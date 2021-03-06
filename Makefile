default:	digestsforthought.zip

## BUILD
#
# This uses a Python virtual environment.
# If you want to test locally, you'll also need a Python virtualenv --
# see README.md.
#
# XXX: Can we pass the Python version in when building the venv?
# That needs to be consistent with the version used in the lambda.
#
digestsforthought.tar:	\
		Pipfile Pipfile.lock build-in-venv \
		digestsforthought config.json
	rm -rfv _venv
	./build-in-venv _venv
	if [ -f $@ ]; then mv -f $@ $@.bak; fi
	tar -c -v -f $@ $^
	tar -r -v -f $@ -C _venv/lib/python*/site-packages .

digestsforthought.zip:	digestsforthought.tar
	if [ -f $@ ]; then mv -f $@ $@.bak; fi
	rm -rf _zipbuild && mkdir _zipbuild
	cd _zipbuild && tar xvf ../$^
	cd _zipbuild && cp digestsforthought digestsforthought.py
	cd _zipbuild && zip -9 -r ../$@ .
	rm -rf _zipbuild

clean:
	rm -f digestsforthought.tar digestsforthought.tar.bak
	rm -f digestsforthought.zip digestsforthought.zip.bak
	rm -rfv _venv
	rm -fv build-in-venv.txt

realclean:	clean
	rm -f stack-uuid

## DEPLOYMENT
#
# This uses Amazon Web Services (AWS) Cloudformation,
# and the AWS command-line client.
#
stack-uuid:
	(echo -n digestsforthought- && uuidgen -r | cut -f 5 -d -) > $@
	chmod a-w $@

# XXX: Can we create the S3 bucket and upload the file via CFN?
deploy-stack:	digestsforthought.zip stack-uuid
	stack=$$(cat stack-uuid); \
		aws s3 mb s3://$$stack ; \
		aws s3 cp digestsforthought.zip s3://$$stack ; \
		aws cloudformation create-stack --stack-name $$stack --template-body file://./cfn/digestsforthought.yaml \
			--parameters ParameterKey=FunctionName,ParameterValue=$$stack ParameterKey=S3Bucket,ParameterValue=$$stack \
			--capabilities CAPABILITY_IAM && \
		aws cloudformation wait stack-create-complete --stack-name $$stack

redeploy-stack:	digestsforthought.zip stack-uuid
	stack=$$(cat stack-uuid); \
		aws s3 cp digestsforthought.zip s3://$$stack ; \
		aws cloudformation update-stack --stack-name $$stack --template-body file://./cfn/digestsforthought.yaml \
			--parameters ParameterKey=FunctionName,ParameterValue=$$stack ParameterKey=S3Bucket,ParameterValue=$$stack \
			--capabilities CAPABILITY_IAM && \
		aws cloudformation wait stack-update-complete --stack-name $$stack

redeploy:	digestsforthought.zip stack-uuid
	stack=$$(cat stack-uuid); \
		aws s3 cp digestsforthought.zip s3://$$stack ; \
		aws lambda update-function-code --function-name $$stack \
			--s3-bucket $$stack --s3-key digestsforthought.zip

invoke:	stack-uuid
	stack=$$(cat stack-uuid); \
	      aws lambda invoke --function-name $$stack $$stack-invoke.log ; \
	      echo; cat $$stack-invoke.log; echo; rm $$stack-invoke.log

destroy:	stack-uuid
	stack=$$(cat stack-uuid); \
		aws cloudformation delete-stack --stack-name $$stack ; \
		aws cloudformation wait stack-delete-complete --stack-name $$stack ; \
		aws s3 rb s3://$$stack



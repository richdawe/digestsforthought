default:	digestsforthought.zip

## BUILD
#
# This requires a Python virtual environment. See README.md.
#
digestsforthought.tar:	digestsforthought requirements.txt config.json
	test -d '$(VIRTUAL_ENV)' || (echo; echo "ERROR: Please set up a virtualenv"; echo; false)
	if [ -f $@ ]; then mv -f $@ $@.bak; fi
	tar -c -v -f $@ $^
	tar -r -v -f $@ -C $(VIRTUAL_ENV)/lib/python*/site-packages .

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

# XXX: Need to create S3 buckets too
deploy:	digestsforthought.zip stack-uuid
	stack=$$(cat stack-uuid); \
		aws cloudformation create-stack --stack-name $$stack --template-body "$$(cat cfn/digestsforthought.yaml)" \
			--parameters ParameterKey=FunctionName,ParameterValue=$$stack --capabilities CAPABILITY_IAM ; \
		aws cloudformation wait stack-create-complete --stack-name $$stack

redeploy:	stack-uuid
	stack=$$(cat stack-uuid); \
		aws cloudformation update-stack --stack-name $$stack --template-body "$$(cat cfn/digestsforthought.yaml)" \
			--parameters ParameterKey=FunctionName,ParameterValue=$$stack --capabilities CAPABILITY_IAM ; \
		aws cloudformation wait stack-update-complete --stack-name $$stack

invoke:	stack-uuid
	stack=$$(cat stack-uuid); \
	      aws lambda invoke --function-name $$stack $$stack-invoke.log; \
	      echo; cat $$stack-invoke.log; echo; rm $$stack-invoke.log

destroy:	stack-uuid
	stack=$$(cat stack-uuid); \
		aws cloudformation delete-stack --stack-name $$stack; \
		aws cloudformation wait stack-delete-complete --stack-name $$stack


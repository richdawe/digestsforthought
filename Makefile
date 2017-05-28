default:	digestsforthought.zip

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


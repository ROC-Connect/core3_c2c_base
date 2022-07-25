PLUGINNAME=$(shell basename $(shell pwd))
#protection against running it in the template folder
ifeq ("$(PLUGINNAME)", "core3_c2c_base")
  $(error you should not run this in core3_c2c_base copy me to the target folder core3_xxxx)
else
  $(info $(PLUGINNAME))
#get out the basename in case we need it later  
  PLUGINBASE=$(shell echo $(PLUGINAME)|cut -d '_' -f2)
endif

#start of actual folder preparation
c2c:	
	$(info --> creating template for $(PLUGINNAME))
#check if the api submodule exists else clone it
	$(info --> cloning api submodule if necessary)
	@if [ ! -d "api" ]; then\
		git submodule add git@github.com:ROC-Connect/api.git;\
	fi
	$(info --> fetching templates (make,build and source file templates))

	$(info done with folder preparation enjoy writing code)
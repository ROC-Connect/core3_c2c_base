#urls this script uses
MF="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/Makefile"
BF="https://github.com/ROC-Connect/core3_c2c_base/blob/main/core3_PLUGINNAME.erl"
EF="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/erlang.mk"



PLUGINNAME=$(shell basename $(shell pwd))
#protection against running it in the template folder
ifeq ("$(PLUGINNAME)", "core3_c2c_base")
  $(error you should not run this in core3_c2c_base copy me to the target folder core3_xxxx)
endif

$(info $(PLUGINNAME))
PLUGINBASE=$(shell echo $(PLUGINNAME)|cut -d '_' -f2)


#start of actual folder preparation
c2c:	
	$(info --> creating template for $(PLUGINNAME))
#check if the api submodule exists else clone it
	$(info --> cloning api submodule if necessary)
	@if [ ! -d "api" ]; then\
		git submodule add git@github.com:ROC-Connect/api.git;\
	fi
	$(info --> fetching templates (make,build and source file templates))
	$(shell curl $(MF) -o Makefile)
	$(shell curl $(BF) -o $(PLUGINNAME).erl)
	$(shell curl $(EF) -o erlang.mk)
	$(info --> patching templates $(PLUGINBASE) (make,build and source file templates))
	$(shell sed -i s/PLUGINAME/$(PLUGINBASE)/g $(PLUGINNAME).erl)
	$(shell sed -i s/PLUGINAME/$(PLUGINBASE)/g Makefile)
	$(info done with folder preparation enjoy writing code)

clean:
	$(info removing Makefile erlang.mk $(PLUGINNAME).erl)
	$(shell rm Makefile erlang.mk $(PLUGINNAME).erl)	
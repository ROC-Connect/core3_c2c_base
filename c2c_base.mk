#urls this script uses
MF="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/Makefile"
BF="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/core3_PLUGINNAME.erl"
EF="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/erlang.mk"
#src files
BASE="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/src/PLUGINNAME.erl"
API="https://raw.githubusercontent.com/ROC-Connect/core3_c2c_base/main/src/PLUGINNAME_api.erl"


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
	$(info --> preparing git submodule and gitignore)
	@if [ ! -d "api" ]; then\
		git submodule add git@github.com:ROC-Connect/api.git;\
	fi
#add gitignore	
	$(shell echo .erlang.mk/ >.gitignore)
	$(shell echo core3_*.d >>.gitignore)
	$(shell echo deps/ >>.gitignore)
	$(shell echo ebin/ >>.gitignore)
	$(shell echo pushebin/ >>.gitignore)
	$(shell echo c2c_base.mk >>.gitignore)
	
#download base build files and patch them
	$(info --> fetching templates (make and build files templates))
	$(shell curl $(MF) -o Makefile)
	$(shell curl $(BF) -o $(PLUGINNAME).erl)
	$(shell curl $(EF) -o erlang.mk)
	$(info --> patching templates $(PLUGINBASE) (make and build  files templates))
	$(shell sed -i s/PLUGINBASE/$(PLUGINBASE)/g $(PLUGINNAME).erl)
	$(shell sed -i s/PLUGINBASE/$(PLUGINBASE)/g Makefile)
#create and populate src folder	
	$(info --> fetching source templates)
	$(shell mkdir -p src)
	$(shell curl $(BASE) -o src/$(PLUGINBASE).erl)
	$(shell sed -i s/PLUGINBASE/$(PLUGINBASE)/g src/$(PLUGINBASE).erl)
	$(shell curl $(API) -o src/$(PLUGINBASE)_api.erl)
	$(shell sed -i s/PLUGINBASE/$(PLUGINBASE)/g src/$(PLUGINBASE)_api.erl)
	$(info done with folder preparation enjoy writing code)
	
	


clean:
	$(info removing Makefile erlang.mk $(PLUGINNAME).erl and src)
	$(shell rm -rf Makefile erlang.mk $(PLUGINNAME).erl src)	
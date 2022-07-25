PROJECT = core3_PLUGINBASE
PROJECT_DESCRIPTION = Core3 PLUGINBASE Adapter
COMMIT_ID   = $(shell git log -n 1 |head -n 1| awk '/commit/ {print $$2;}')
COMMIT_DATE = $(shell git log -n 1 | awk '/Date: / {$$1="";gsub(/^ /, "");print}')
BRANCH      = $(shell git describe --all | awk -F"/" '{gsub(/remotes|origin|heads|\//,"");print}')
TIME = $(shell date)
WHO = $(shell whoami)
PCNAME= $(shell hostname)
PROJECT_VERSION=${BRANCH}-${COMMIT_ID}
RELX_OUTPUT_DIR = _rel/$(TYPE)


CI_OTP = OTP-19.3 OTP-20.2
CI_HIPE = $(lastword $(CI_OTP))
CI_ERLLVM = $(CI_HIPE)


export ERLC_OPTS ?= -W0 +compressed +no_debug_info +bin_opt_info +warn_export_all +warn_export_vars +warn_shadow_vars +warn_obsolete_guard
#DEPS = syn

LOCAL_DEPS = rtrace db http_server


define PROJECT_ENV
[
    {db, [ ]},
    {ecrond, []}
]
endef

#define PROJECT_APP_EXTRA_KEYS
#{start_phases, [{run_public_apps, []}]}
#endef



include erlang.mk
include api/maker/targets.mk

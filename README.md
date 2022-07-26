# core3_c2c_base

this is the base template used for make c2c, which should be used to start a fresh c2c repo

NAME=PARTNERNAME make c2c 

ATTENTION this repo is public do not put sensitive information here

the steps to create a new c2c plugins are

1) create a repo core3_PARTNERNAME
2) create a dns entry PARTNERNAME.dev.DOMAIN.com cname dev.DOMAIN.com 300s
3) add 4 dns metadata
 - SERVER:oauth-partner
 - url-oauth: /api/:CHANNEL:/c2c/:PARTNERNAME:/:UUID:/oauth
 - url-redirect: /api/:CHANNEL:/c2c/:PARTNERNAME:/:UUID:/redirect
 - url-webhook: /api/:CHANNEL:/c2c/:PARTNERNAME:/:UUID:/webhook
4) create the kubernetes oauth-partner PARTNERNAME-dev.yaml with the correct oauth metadata for the partner (you must encrypt the secret for now in the future we will use akv) base64:encode(utils_crypto:publicEnc(<<"secret">>)).
5) generate the ingress yaml using the dns script.
5) on factoryleader add another channel-cloud-oauth config channel-partnername
6) create the partnernamebackup container in the channel storage account

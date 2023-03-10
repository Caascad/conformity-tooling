# vim:set ts=2 sw=2 sts=2 et :
# shellcheck shell=bash

ZONE=$1
DOMAIN=$2

DOMAIN=${DOMAIN:-caascad.com}

Help()
{
   echo "Retrieve, then export RANCHER_URL and RANCHER_TOKEN variables from the requested zone."
   echo
   echo "Syntax: get-rancher-creds [[ZONE]|-h|--help]"
   echo "options:"
   echo "-h         Print the help."
   echo "[ZONE]     Retrieve the credentials from the requested zone."
   echo ""
   echo  "Usage: get-rancher-creds [ZONE]"
}

refresh_caascad_zones() {
  if [ -e "${CAASCAD_ZONES_URL}" ]; then
    CAASCAD_ZONES=$(curl -sL "${CAASCAD_ZONES_URL}")
  elif [ -e "${CAASCAD_ZONES_FILE}" ]; then
    CAASCAD_ZONES=$(cat "${CAASCAD_ZONES_FILE}")
  else
    if ! command -v sd 1>/dev/null; then 
	    echo """[WARNING] sd command missing. Please install it with the toolbox (see below), then retry. 
$ toolbox install sd
      """; 
      exit;
    else
      CAASCAD_ZONES=$(sd get zones 2> /dev/null);
    fi
  fi
}

vault_login() {
  if [ -z "${VAULT_LOGGED}" ]; then
    infra_zone_name=$(echo "${CAASCAD_ZONES}" | jq -r ".[\"${ZONE}\"].infra_zone_name")
    VAULT_ZONE="${infra_zone_name}"
    export VAULT_ADDR=https://vault.${VAULT_ZONE}.${DOMAIN}
    vault token lookup >/dev/null 2>&1 || vault login -method oidc
    local VAULT_LOGGED=1
  fi
}

set_rancher_vars() {
  local zone=$1
  
  vault_login
  vault_json=$(vault read secret/concourse-infra/global/kubernetes-"${zone}" -format=json)
  export RANCHER_TOKEN=$(echo "${vault_json}" | jq -r ".data.token") 
  export RANCHER_URL=$(echo "${vault_json}" | jq -r ".data.url")
}

while getopts ":h" option; do
   case $option in
      "h"|"help")
         Help;
         exit;;
   esac
done

if [[ $1 == "" ]]; then
  Help
  exit
fi

refresh_caascad_zones
set_rancher_vars "${ZONE}"
echo "RANCHER_URL=$RANCHER_URL" 
echo "RANCHER_TOKEN=$RANCHER_TOKEN" 

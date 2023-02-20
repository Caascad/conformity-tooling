#!/bin/bash

TEST=$1
LOGFILE=$2
TEST_DESCRIPTION=$3

# Predefined rancher credentials
TOKEN="concourse-infra-pipelines-ocb-test02-infra:bQNdCSPaXcayrHIhSlFICZdCoYkzDm5sa66hRuZzLayNia7dFEORH7TBAb8uPn9r" 
URL="https://rancher.ocb-test02.caascad.com/k8s/clusters/local"

unsetRancher () {
    unset RANCHER_URL
    unset RANCHER_TOKEN
}

geranchercreds () {
    . get-rancher-creds ocb-test06
}

unsetRancher

CHECKMETRICS_REQUEST="checkmetrics -S prometheus-operated -N monitoring"
CURRENT_DATE=$(date +%d%h%y-%H%M%S)

echo "$CURRENT_DATE - INFO ---- START $TEST" &>> $LOGFILE
echo "$CURRENT_DATE - INFO ---- $TEST_DESCRIPTION" &>> $LOGFILE 
printf '\n' &>> $LOGFILE

if [[ $TEST == "TEST1" ]]; then 
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q thanos_build_info &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST2" ]]; then 
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q thanos_build_info -d &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST3" ]]; then 
$CHECKMETRICS_REQUEST -U $URL -T $TOKEN -Q thanos_build_info -d &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST4" ]]; then
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q @queries_ok.txt &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST5" ]]; then
cat <<EOF | $CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q - &>> $LOGFILE
thanos_build_info
up
EOF
echo $? > res;
fi

if [[ $TEST == "TEST6" ]]; then 
geranchercreds
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q thanos_build_info &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST7" ]]; then 
$CHECKMETRICS_REQUEST -D 120 -Q thanos_build_info &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST8" ]]; then 
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q thanos_unbuild_info &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST9" ]]; then
$CHECKMETRICS_REQUEST -D 120 -U $URL -T $TOKEN -Q @queries_ko.txt &>> $LOGFILE
echo $? > res;
fi

if [[ $TEST == "TEST10" ]]; then
geranchercreds
$CHECKMETRICS_REQUEST -D 120 -U $URL -T "bad_token" -Q @queries_ok.txt &>> $LOGFILE
echo $? > res;
fi

printf '\n' &>> $LOGFILE
echo "$CURRENT_DATE - INFO ---- END $TEST" &>> $LOGFILE
printf '\n\n' &>> $LOGFILE

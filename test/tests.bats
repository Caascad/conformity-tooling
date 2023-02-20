#!/usr/bin/env bats

# VARIABLES 
MONSCRIPT="test.sh"
TEST1="test OK with single query_range - basic auth"
TEST2="test OK with single query_range - basic auth - mode bavard"
TEST3="test OK with single query - basic auth"
TEST4="test OK with multiple query_range using a file as inputs"
TEST5="test OK with multiple query_range using stdin as inputs"
TEST6="test OK with single query_range - no auth, then execute get-rancher-creds and gather environnment variables"
TEST7="test KO with single query_range - cause no auth"
TEST8="test KO with single query_range - cause missing metric"
TEST9="test KO with multiple query_range using a file as inputs - cause missing metric"
TEST10="test KO with multiple query_range using a file as inputs - execute get-rancher-creds but pass bad auth as arguments"

# Commands to be launch before each test
setup() {
  CURRENT_DATE=$(date +%d%h%y-%H%M%S)
  LOG_FILE="archives/check_$CURRENT_DATE.txt"
  sleep 1
}

# Commands to be launch after each test
teardown() {
  cat ${LOG_FILE} >> last_log.txt
}

# TESTS OK
@test "$TEST1" {
  declare TEST_DESCRIPTION="$TEST1"
  /bin/bash $MONSCRIPT TEST1 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

@test "$TEST2" {
  declare TEST_DESCRIPTION="$TEST2"
  /bin/bash $MONSCRIPT TEST2 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

@test "$TEST3" {
  declare TEST_DESCRIPTION="$TEST3"
  /bin/bash $MONSCRIPT TEST3 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

@test "$TEST4" {
  declare TEST_DESCRIPTION="$TEST4"
  /bin/bash $MONSCRIPT TEST4 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

@test "$TEST5" {
  declare TEST_DESCRIPTION="$TEST5"
  /bin/bash $MONSCRIPT TEST5 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

@test "$TEST6" {
  declare TEST_DESCRIPTION="$TEST6"
  /bin/bash $MONSCRIPT TEST6 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 0 ]
}

# TESTS KO
@test "$TEST7" {
  declare TEST_DESCRIPTION="$TEST7"
  /bin/bash $MONSCRIPT TEST7 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 1 ]
}

@test "$TEST8" {
  declare TEST_DESCRIPTION="$TEST8"
  /bin/bash $MONSCRIPT TEST8 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 1 ]
}

@test "$TEST9" {
  declare TEST_DESCRIPTION="$TEST9"
  /bin/bash $MONSCRIPT TEST9 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 1 ]
}

@test "$TEST10" {
  declare TEST_DESCRIPTION="$TEST10"
  /bin/bash $MONSCRIPT TEST10 ${LOG_FILE} "$TEST_DESCRIPTION"
  result="$(cat res)" 
  [ "$result" -eq 1 ]
}

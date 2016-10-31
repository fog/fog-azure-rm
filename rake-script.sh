#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true"]
then
  rake cc_coverage
  rake integration_tests
else
  echo $AZURE_CLIENT_ID
  rake cc_coverage
  rake integration_tests
fi
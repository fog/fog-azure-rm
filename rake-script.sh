#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true"]
then
  echo "In First check"
  rake cc_coverage
  rake integration_tests
else
  echo "In else check"
  rake cc_coverage
fi
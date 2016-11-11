#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true" ]
then
  rake cc_coverage
  codeclimate-test-reporter --directory /home/travis/build/fog/fog-azure-rm/coverage
else
  rake cc_coverage
  codeclimate-test-reporter --directory /home/travis/build/fog/fog-azure-rm/coverage
fi
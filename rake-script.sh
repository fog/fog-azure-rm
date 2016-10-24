#!/bin/bash

if [[ $TRAVIS_BRANCH == 'fog/fog-azure-rm/master' ]]
  rake cc_coverage
  rake integration_tests
else
  rake cc_coverage
fi
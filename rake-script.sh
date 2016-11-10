#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true" ]
then
  rake cc_coverage
  rake integration_tests
else
  rake cc_coverage
fi
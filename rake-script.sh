#!/bin/bash
echo $TRAVIS_BRANCH
if [ $TRAVIS_BRANCH == 'develop' ]
then
  rake cc_coverage
  rake integration_tests
else
  rake cc_coverage
fi
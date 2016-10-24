#!/bin/bash
echo $TRAVIS_BRANCH
if [ $TRAVIS_BRANCH = 'develop' ]
then
  echo "In First check"
  rake cc_coverage
  rake integration_tests
else
  echo "In else check"
  rake cc_coverage
fi
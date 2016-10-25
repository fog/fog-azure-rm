#!/bin/bash
echo $TRAVIS_BRANCH
echo ${ENV['CLIENT_ID']:0:2}
if [ $TRAVIS_BRANCH = 'develop' ]
then
  echo ${ENV['CLIENT_ID']:0:2}
  echo "In First check"
  rake cc_coverage
  rake integration_tests
else
  echo ${ENV['CLIENT_ID']:0:2}
  echo "In else check"
  rake cc_coverage
fi
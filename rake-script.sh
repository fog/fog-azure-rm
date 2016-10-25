#!/bin/bash
echo $TRAVIS_BRANCH
echo ${#ENV['CLIENT_ID']}
if [ $TRAVIS_BRANCH = 'master' ]
then
  echo ${#ENV['CLIENT_ID']}
  echo "In First check"
  rake cc_coverage
  rake integration_tests
else
  echo ${#ENV['CLIENT_ID']}
  echo "In else check"
  rake cc_coverage
fi
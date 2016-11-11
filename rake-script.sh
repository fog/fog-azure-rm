#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true"]
then
  rake cc_coverage
  export CODECLIMATE_REPO_TOKEN="b1401494baa004d90402414cb33a7fc6420fd3693e60c677a120ddefd7d84cfd"
  codeclimate-test-reporter --directory /home/travis/build/fog/fog-azure-rm/coverage
else
  rake cc_coverage
  export CODECLIMATE_REPO_TOKEN="b1401494baa004d90402414cb33a7fc6420fd3693e60c677a120ddefd7d84cfd"
  codeclimate-test-reporter --directory /home/travis/build/fog/fog-azure-rm/coverage
fi
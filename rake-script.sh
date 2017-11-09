#!/bin/bash
rake cc_coverage
R=$?
export CODECLIMATE_REPO_TOKEN="b1401494baa004d90402414cb33a7fc6420fd3693e60c677a120ddefd7d84cfd"
codeclimate-test-reporter
if [ $R == 1 ]; then
  exit 1
else
  exit 0
fi

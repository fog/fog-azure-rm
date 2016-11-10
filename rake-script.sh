#!/bin/bash
if [ $TRAVIS_PULL_REQUEST != "true" ]
then
  rake cc_coverage
else
  rake cc_coverage
fi
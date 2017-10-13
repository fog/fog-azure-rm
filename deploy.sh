#!/bin/sh

yes y | gem uninstall dpl
yes y | gem uninstall gems
gem install gems -v 0.8.3
gem install dpl -v 1.8.27
dpl --provider=rubygems --api-key=6dc03973e10bda1b5d690090f510275d --gemspec=./fog-azure-rm.gemspec

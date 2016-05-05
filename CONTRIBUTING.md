## Getting Involved

New contributors are always welcome, when it doubt please ask questions. We strive to be an open and welcoming community. Please be nice to one another.

### Coding

* Pick a task:
  * Offer feedback on open [pull requests](https://github.com/Confiz/fog-azure-rm/pulls).
  * Review open [issues](https://github.com/Confiz/fog-azure-rm/issues) for things to help on.
  * [Create an issue](https://github.com/Confiz/fog-azure-rm/issues/new) to start a discussion on additions or features.
* Fork the project, add your changes and tests to cover them in a topic branch.
  * [Fork](https://github.com/Confiz/fog-azure-rm/fork)
  * Create your feature branch (`git checkout -b my-new-feature`)
  * Commit your changes (`git commit -am 'Add some feature'`)
  * Push to the branch (`git push origin my-new-feature`)
  * Create a new pull request
* Commit your changes and rebase against `Confiz/fog-azure-rm` to ensure everything is up to date.
* [Submit a pull request](https://github.com/Confiz/fog-azure-rm/compare/).

### Non-Coding

* Offer feedback on open [issues](https://github.com/Confiz/fog-azure-rm/issues).
* Organize or volunteer at events.
* Write and help edit [documentation](https://github.com/Confiz/fog-azure-rm/tree/develop/lib/fog/azurerm/docs).

## Testing 

Two directories for testing are as follows

* The `test` directory contains the `Minitest` tests, which currently covers the real classes for each service.
* The `tests` directory contains the `shindo` tests, which covers the mock classes for each service. `shindo` tests generally pass if mocking is turned on.

#### Minitest
You can run `Minitest` tests by running this command in the root directory.

```shell
$ rake minitest_test
```

#### Shindo 
You can run `Shindo` tests by running this command in the root directory.

```shell
$ rake shindo_test
```

## Code Coverage
We are using Simplecov Gem for code coverage. Simplecov will show the report of code coverage for both testing scenarios.

#### Minitest 
You can see the report of Minitest's Code Coverage by running this command in the root directory.

```shell
$ rake minitest_coverage
```

#### Shindo
You can see the report of Shindo's Code Coverage by running this command in the root directory.

```shell
$ rake shindo_coverage
```


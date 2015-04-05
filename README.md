#apt-check.sh

### A re-implimentation of some of the functionality of `update-notifier-common` in POSIX shell

Debian and Ubuntu have or did have a package called `update-notifier-common` that did some stuff so
you could have this sort of thing in your message of the day etc.

```
28 packages can be updated.
16 updates are security updates.
```

This script aims to impliment some of the functionality of the `/usr/lib/update-notifier/apt-check` without depending on python.

## Usage

`./apt-check.sh [OPTIONS]`

Outputs upgrade information to stderr.

### Options

Flag | Option         | Description
-----|----------------|------------
`-h` | Human Readable | set this option to get MOTD style output.
`-f` | Fussy          | set this option to make the exit status more fussy.  When set a non zero exit status is returned if any packages are avalible for upgrading, if unset a non zero exit status is returned if any packages have security upgades avalible.
`-q` | Quiet          | hides the output if there are no packages to upgrade, respects the fussy option.
`-s` | Skip Update    | Does not run `apt-get update` before testing, saves a few seconds if you are running `apt-get update` periodicly in some other context.
`-c` | Cleanup        | Runs `apt-get clean` and cleanup `/var/lib/apt/lists/*` useful for saving diskspace in the context of building a docker image etc.

### Example Installation

`curl -o /usr/local/bin/apt-check https://raw.githubusercontent.com/assemblyline/apt-check.sh/master/apt-check.sh && chmod +x /usr/local/bin/apt-check`

### Exit Status
The following exit values shall be returned:

`0` No packages need to be upgraded

`>0` `n` packages need to be upgraded


### Dependencies

* A POSIX `/bin/sh`
  * `test`
  * `cut`
  * `grep`
* `apt-get`

### Testing

The automated test suite tests against:

* Ubuntu
  * `14.04 LTS` - Trusty
  * `12.04 LTS` - Precise
* Debian
  * `sid` - unstable
  * `jessie` - testing
  * `wheezy` - stable

To run the test suite you will need ruby and docker.

```
bundle install
bundle exec rspec
```

The os images used in these tests can be found [here](https://quay.io/repository/assemblyline/apt-check.sh-testing). Note that as these need to be downloaded to run the tests that the first run may be quite slow and use up some diskspace.

### Bugs

Please open an issue or a pull request.

### Licence

[MIT](https://github.com/assemblyline/apt-check.sh/blob/master/LICENSE)

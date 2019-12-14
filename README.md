# Vagrant files

Useful vagrant files for playing with various frameworks and languages

## Required ruby packages for this repo

```Gemfile
source "https://rubygems.org"

ruby "2.5.1"

# Linting
gem "rubocop", "~> 0.70.0", require: false
gem "rubocop-github", "~> 0.13.0", require: false
gem "rubocop-performance", "~> 1.3.0", require: false

# code formatting
gem "prettier", require: false

# Intellisense
gem "solargraph", require: false
```

## Useful Vagrant commands

* `vagrant --help`
* `vagrant validate` - validates the Vagrantfile

### VM management commands

```bash
# start a VM (provisions the VM if not already provisioned)
vagrant up

# status of VM
vagrant status

# SSH to VM
vagrant ssh

# stop VM
vagrant halt

# delete VM
vagrant destroy

# force VM delete without prompt
vagrant destroy -f
```

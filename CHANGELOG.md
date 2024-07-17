# CES Changelog
All notable changes to this project will be documented in this file.

⚠️We only track changes that are directly related to the CES image build. 
Other dependencies like apt packages and dogus, that may influence the instance behaviour, change between versions
without specification in the changelog. ⚠️  

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- Upgrade to Ubuntu 24.04; #461
- Upgrade fail2ban to 1.1.0
- Upgrade terraform to 1.9.1
- Convert Packer templates to HCL format
- You need to specify a VirtualBox version below 7 on Packer image build

### Removed
- Removed ctop
- Removed libreadline-gplv2-dev

## [v20.04.6-1] - 2024-07-09
### Changed
- Upgrade to Docker 26.1.4
- Upgrade to Ubuntu 20.04.6

## [v20.04.4-2] - 2022-07-14
### Changed
- Install cesappd separately (#450)

## [v20.04.4-1] - 2022-05-05
### Added
- Make sure scripts in /install are executable in Packer build process

### Changed
- Upgrade to Ubuntu 20.04.4 iso

### Removed
- Firewall rule for port 50051 from installation script (#447)

## [v20.04.3-1] - 2021-12-09
### Removed
- submodules #443

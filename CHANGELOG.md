# CES Changelog
All notable changes to this project will be documented in this file.

⚠️We only track changes that are directly related to the CES image build. 
Other dependencies like apt packages and dogus, that may influence the instance behaviour, change between versions
without specification in the changelog. ⚠️  

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

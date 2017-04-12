# Goss Spec

Since version 0.13.0 the cesapp is able to execute tests to verify [goss](https://github.com/aelsabbahy/goss) specs.

# How to write a goss spec for a container

There are two ways to write goss specs for a dogu. The hard way and the easy way.

## The hard way

* create a file at `spec/goss/goss.yaml`
* add test cases as described in the [goss documentation](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#available-tests)
* test your spec with `cesapp verify dogu-directory`

## The easy way

* create a empty file at `spec/goss/goss.yaml`
* verify the spec, keep the test container with `cesapp verify dogu-directory --keep-container` and ignore the verify error
* jump into the container with `docker exec -ti dogu-name bash`
* change the directory to `/spec/goss`
* now you can add tests to goss spec e.g.: `goss add file /etc/nginx/nginx.conf`, for a complete list have a look at the [goss documentation](https://github.com/aelsabbahy/goss/blob/master/docs/manual.md#available-tests)

# How it works

* The cesapp will build the container image of the dogu
* Dogu container is created with volumes for goss binary and spec directory
* Container is started with goss binary mounted at `/usr/bin/goss` and spec directory at `/spec`
* The cesapp will wait until the dogu is healthy
* Goss will be executed with in the container and `/spec/goss/goss.yaml` as input
* The test container will be stopped and removed

# Build Server Integration

The `verify` command is able to store the results in a build server friendly manner e.g.: `cesapp verify dogu-directory --ci --report-directory reports`.
The command will now format the output in the junit format and write the report to the file `reports/goss_doguname.xml`.
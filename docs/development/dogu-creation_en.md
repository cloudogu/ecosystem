# How to create a dogu#

Below you will find a brief introduction to creating a Dogu. You can find a more detailed guide in our [Dogu Development Docs on Github](https://github.com/cloudogu/dogu-development-docs/).

## 1. Create dogu directory
Create directory /ecosystem/containers/'newDoguName' and place these essential files into it:

 * `Dockerfile` --> Creation of the Docker image of your new dogu
 * `startup.sh` --> Commands executed at every start of the dogu
 * `dogu.json` --> Important dogu configuration information

For additional resources of the new dogu, a `resources` folder can be created.
## 2. Fill files with content
### Dockerfile
 * Fixed commands, which only need to be executed once are included here
 * Guidelines for writing Dockerfiles can be found [here](https://docs.docker.com/engine/reference/builder/) and [here](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/). 
 * For Java-based applications use the cloudogu `java` base image
 * For other applications use the cloudogu `base` base image
 * If your dogu is a web application, add the line `ENV SERVICE_TAGS webapp`. This will lead to the appearance of your dogu in the warp menu.
 * Copy your resources to the dogu, if necessary
 * Please include `MAINTAINER` information

### startup.sh
 * Commands, which need to be executed at every start of the dogu are included here
 * Create or modify files and directories if necessary
 * Run commands necessary at first or every start
 * Add a command to start your application at the end of the file

### dogu.json
 * Name: The name of the new dogu
 * Version: The version of the new dogu
 * DisplayName: Full name of this dogu
 * Description: Short description of the software in this dogu
 * Category: The ecosystem category your dogu fits into. Possible options so far: `Development Apps`, `Administration Apps`, `Documentation` and `Base`
 * Tags (JSON array): One-word tags related with this dogu
 * Logo: Link to logo image for this application
 * Url: Official website of the software in this dogu
 * Image: Path to the image in the cloudogu registry
 * Dependencies (JSON array): List of dogus this dogu depends on
 * ExposedCommands (JSON array):
 * HealthChecks (JSON array): 
 * Volumes (JSON array): Directories in the ecosystem, which are also accessible from inside the dogu
 * Volumes-> Volume-> NeedsBackup (bool): Indicator for the backup. Set to false when volume data is not important for backup
 * ServiceAccounts (JSON array): 

#### dogu.json - Dependencies

There are three ways to define dogu dependencies:

* Other Dogus
* Packages (e.g. backup-watcher)
* Clients (e.g. cesapp, ces-setup)

For the first two cases, make sure that the dependencies are installed. The client dependency specifies which version a client must have in order to use the Dogu properly. However, the client itself is not required to run the Dogus (so it can be uninstalled after the Dogus is started). Example: It is not important which ces-setup is installed, if I install a new Dogu afterwards.

About the types, there is the possibility to specify specific versions (format: (<=,<,>,>=)2.X.X).

Example JSON:
 ```
   "Dependencies": [
     {"type": "dogu", "name": "cas", "version":">=4.1.1-2"},
     {"type": "package", "name": "backup-watcher", "version":"<=1.0.1"},
     {"type": "client", "name": "ces-setup", "version":">=2.0.1"},
   ]
 ```

## 3. Create your dogu
 * Start up ecosystem
 * Go to /vagrant/containers
 * Type `cesapp build 'newDoguName'`
 * If the dogu is successfully built, type `docker start 'newDoguName'`

## 4. Test your dogu
 * Check /var/log/docker/'newDoguName'.log if dogu is started up correctly
 * Restart your dogu via `docker restart 'newDoguName'` and check the log again
 * Make sure all bash scripts comply with the [guideline](bash-guideline.md) 

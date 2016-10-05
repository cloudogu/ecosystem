## How to migrate to Cloudogu Ecosystem
### Jenkins
 * Stop jenkins dogu via `service ces-jenkins stop` and `docker stop jenkins`
 * Copy jobs from source Jenkins instance '/job' folder to '/var/lib/ces/jenkins/volumes/data/jobs' and check for right file system permissions
 * Install all neccessary plugins to Jenkins
 * Start Jenkins via `service ces-jenkins start`
 * Don't forget to change documentation/links to your new instance of Jenkins

### SonarQube
 * 
 * 
 * 
 * 

### Sonatype Nexus
 * Stop Sonatype nexus dogu via 'service ces-nexus stop' and 'docker stop nexus'
 * Copy the contents of the following folders from your old sonatype_work/nexus directory to the corresponding /var/lib/ces/nexus/volumes/data folders: storage, conf, logs & timeline
 * Check for right file system permissions
 * Start Sonatype nexus via 'service ces-nexus start'
 * Update indices

### SCM Manager
 * 
 * 
 * 

### 
 * 
 * 
 *
 * 


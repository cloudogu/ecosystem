## How to migrate to Cloudogu Ecosystem
### Jenkins
 * Stop jenkins dogu via `service ces-jenkins stop` and `docker stop jenkins`
 * Copy jobs from source Jenkins instance '/job' folder to '/var/lib/ces/jenkins/volumes/data/jobs' and check for right file system permissions
 * Install all neccessary plugins to Jenkins
 * Start Jenkins via `service ces-jenkins start`
 * Don't forget to change documentation/links to your new instance of Jenkins

### SonarQube
 * Stop sonar dogu via `service ces-sonar stop` and `docker stop sonar`
 * Get database name from /var/lib/ces/sonar/volumes/data/conf/sonar.properties (same as sonar.jdbc.username)
 * Copy sonar mysql.dump to /var/lib/ces/mysql/volumes/data/
 * Switch to Mysql dogu via `docker exec -it mysql bash`
 * Execute command: `mysql --execute="set global max_allowed_packet=64*1024*1024;"`
 * Drop all tables from database: `mysql --execute="DROP DATABASE <database_name>;"` and `mysql --execute="CREATE DATABASE <database_name>"`
 * Import mysql database dump via `mysql <database_name> < /var/lib/mysql/mysql.dump`
 * Remove SonarQube data/es folder: `rm -rf /var/lib/ces/sonar/volumes/data/data/es`
 * Add cesAdmin group to mysql database: Execute `INSERT INTO <database_name>.groups (name, description) VALUES ('cesAdmin', 'CES-Admin-Group');`
 * Optional: Install required plugins in SonarQube by copying the *.jar files to /var/lib/ces/sonar/volumes/data/extensions/plugins/
 * Start SonarQube via `service ces-sonar start`

### Sonatype Nexus
 * Stop Sonatype nexus dogu via `service ces-nexus stop` and `docker stop nexus`
 * Copy the contents of the following folders from your old sonatype_work/nexus directory to the corresponding /var/lib/ces/nexus/volumes/data folders: storage, conf, logs & timeline
 * Check for right file system permissions
 * Start Sonatype nexus via `service ces-nexus start`
 * Update indices

### SCM Manager
 * Stop SCM dogu via `service ces-scm stop` and `docker stop scm`
 * Copy all data from your backup/old SCM folder to /var/lib/ces/scm/volumes/data/
 * Start SCM via `service ces-scm start`

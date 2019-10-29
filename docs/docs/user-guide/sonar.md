## Using the SonarQube dogu

### Importing quality profiles

To import quality profiles into the SonarQube dogu please follow these steps:

- Move your quality profile files (in xml format) to /var/lib/ces/sonar/volumes/qualityprofiles
- Restart the sonar dogu (e.g. via `docker restart sonar`)

The profiles will be automatically imported into SonarQube and are usable in it as soon as it has started up.
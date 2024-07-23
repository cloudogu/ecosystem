# Releasing the EcoSystem Development Baseboxes

0. Make a release of ecosystem, if not already existent, as described in [Release the ecosystem](release_ecosystem_en.md)
1. Build a basebox as described in [Building Basebox](building_basebox_en.md)
2. Add a version to the basebox
    - Change the basebox name from `images/dev/build/ecosystem-basebox.box` to `images/dev/build/basebox-virtualbox-v24.04.X-Y.box`
3. Create a new folder `v24.04.X-Y` in the `basebox/virtualbox` folder in the [Google Cloud Bucket](https://console.cloud.google.com/storage/browser/cloudogu-ecosystem?project=cloudogu-backend)
4. Upload the box to the corresponding versioned folder
    - e.g. upload the `images/dev/build/basebox-virtualbox-v24.04.X-Y.box` into the `basebox/virtualbox/v24.04.X-Y` folder
5. Edit the file's access permissions
    - Add an entry "Public/allUsers" and grant it "Reader" permissions
6. Adapt the Vagrantfile to match the newly released box
    - Adapt the basebox_version (to `v24.04.X-Y`)
    - Adapt the basebox_checksum (get it via `sha256sum images/dev/build/basebox-virtualbox-v24.04.X-Y.box`)
    - Test it via `vagrant up`
    - Commit and push

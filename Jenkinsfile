#!groovy
@Library(['github.com/cloudogu/dogu-build-lib@v1.0.0']) _

// required plugins
// - http://wiki.jenkins-ci.org/display/JENKINS/HTML+Publisher+Plugin

node('docker') {

    timestamps {

        properties([
            // Keep only the last x builds to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds()
        ])

        stage('Checkout') {
            checkout scm
        }

        stage('Lint') {
            shellCheck("./install/create-network.sh")
            shellCheck("./install/firewall.sh")
            shellCheck("./install/install-ces-packages.sh")
            shellCheck("./install/prepare-environment.sh")
            shellCheck("./install/setup-message.sh")
            shellCheck("./install/sync-files.sh")
            shellCheck("./install.sh")
            shellCheck("./images/scripts/commons/ces_apt.sh")
            shellCheck("./images/scripts/commons/cleanup.sh")
            shellCheck("./images/scripts/commons/dependencies.sh")
            shellCheck("./images/scripts/commons/docker.sh")
            shellCheck("./images/scripts/commons/etcd.sh")
            shellCheck("./images/scripts/commons/fail2ban.sh")
            shellCheck("./images/scripts/commons/grub.sh")
            shellCheck("./images/scripts/commons/guestadditions.sh")
            shellCheck("./images/scripts/commons/minimize.sh")
            shellCheck("./images/scripts/commons/networking.sh")
            shellCheck("./images/scripts/commons/sshd.sh")
            shellCheck("./images/scripts/commons/subvolumes.sh")
            shellCheck("./images/scripts/commons/terraform.sh")
            shellCheck("./images/scripts/commons/update.sh")
            shellCheck("./images/scripts/dev/dependencies.sh")
            shellCheck("./images/scripts/dev/vagrant.sh")
            shellCheck("./images/scripts/prod/sshd_security.sh")
        }

        stage('Packer validate') {
            sh 'cd images/dev && packer init . && packer validate dev.pkr.hcl'
            sh 'cd images/prod && packer init . && packer validate -var "timestamp=$(date +%Y%m%d)" prod.pkr.hcl'
        }
    }
}

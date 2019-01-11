#!groovy

@Library(['github.com/cloudogu/dogu-build-lib@1e5e2a63c858c4c5b377d1fb0a85f4c134735943', 'github.com/cloudogu/zalenium-build-lib@eba8a3b']) _

import com.cloudogu.ces.dogubuildlib.*


// todo
// - setup output

// required plugins
// - http://wiki.jenkins-ci.org/display/JENKINS/HTML+Publisher+Plugin

node('vagrant') {

timestamps{
    properties([
            // Keep only the last x builds to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds()
    ])


        EcoSystem ecoSystem = new EcoSystem(this, "gcloud-ces-operations-internal-packer", "jenkins-gcloud-ces-operations-internal")


    stage('Checkout') {
        checkout scm
    }

    try {

        stage('Provision') {
            timeout(15) {
                //writeVagrantConfiguration()
                //sh 'rm -f setup.staging.json setup.json'
                //sh 'vagrant up'
                ecoSystem.provision("/dogu");
            }
        }

        stage('Setup') {
            timeout(5) {
                /*withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'cesmarvin-setup', usernameVariable: 'TOKEN_ID', passwordVariable: 'TOKEN_SECRET']]) {
                    sh "vagrant ssh -c \"sudo cesapp login ${env.TOKEN_ID} ${env.TOKEN_SECRET}\""
                }
                writeSetupStagingJSON()
                sh 'vagrant ssh -c "sudo mv /vagrant/setup.staging.json /etc/ces/setup.staging.json"'
                sh 'vagrant ssh -c "sudo mv /etc/ces/setup.staging.json /etc/ces/setup.json"'
                sh 'vagrant ssh -c "while sudo pgrep -u root ces-setup > /dev/null; do sleep 1; done"'
                sh 'vagrant ssh -c "sudo journalctl -u ces-setup -n 100"' */
                ecoSystem.loginBackend('cesmarvin-setup')
                ecoSystem.setup([ additionalDependencies: [ 'official/postgresql',
                "official/cas",
                "official/cockpit",
                "official/jenkins",
                "official/nginx",
                "official/ldap",
                "official/postfix",
                "official/postgresql",
                "official/redmine",
                "official/registrator",
                "official/scm",
                "official/smeagol",
                "official/sonar",
                "official/nexus",
                "official/usermgt"
                ] ])
            }
        }

        stage('Start Dogus') {
            timeout(15) {
                echo "Waiting for dogus to become healthy..."
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast cas")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast cockpit")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast jenkins")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast nginx")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast ldap")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast postfix")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast postgresql")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast redmine")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast registrator")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast scm")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast smeagol")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast sonar")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast nexus")
                ecoSystem.vagrant.ssh("sudo cesapp healthy --wait --timeout 600 --fail-fast usermgt")
            }
        }

        stage('Integration Tests') {
            timeout(10) {
                def seleniumChromeImage = docker.image('selenium/standalone-chrome:3.3.0')
                def seleniumChromeContainer = seleniumChromeImage.run('-p 4444')

                // checkout integration-tests into
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'integration-tests']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/cloudogu/integration-tests']]])

                try {

                    def seleniumChromeIP = containerIP(seleniumChromeContainer)
                    def cesIP = getCesIP()

                    docker.image('cloudogu/gauge-java:latest').inside("-v ${HOME}/.m2:/maven -e BROWSER=REMOTE -e SELENIUM_URL=http://${seleniumChromeIP}:4444/wd/hub -e gauge_jvm_args=-Deco.system=https://${cesIP}") {
                        sh '/startup.sh /bin/bash -c "cd integration-tests && mvn test"'
                    }

                } finally {
                    seleniumChromeContainer.stop()
                    // archive test results
                    junit 'integration-tests/reports/xml-report/*.xml'

                    // publish gauge results
                    publishHTML([
                            allowMissing         : false,
                            alwaysLinkToLastBuild: false,
                            keepAll              : true,
                            reportDir            : 'integration-tests/reports/html-report',
                            reportFiles          : 'index.html',
                            reportName           : 'Integration Test Report'
                    ])

                }
            }

        }

    } finally {
        stage('Clean') {
            ecoSystem.destroy()
        }
    }
}

}

String getCesIP() {
    // log into vagrant vm and get the ip from the eth1, which should the configured private network
    sh "vagrant ssh -c \"ip addr show dev eth1\" | grep 'inet ' | awk '{print \$2}' | awk -F'/' '{print \$1}' > vagrant.ip"
    return readFile('vagrant.ip').trim()
}

String containerIP(container) {
    sh "docker inspect -f {{.NetworkSettings.IPAddress}} ${container.id} > container.ip"
    return readFile('container.ip').trim()
}

void writeVagrantConfiguration() {
    //adjust the vagrant config for local-execution as needed for the integration tests

    writeFile file: '.vagrant.rb', text: """
# override public network with a private one
config.vm.networks.each do |n|
  if n[0] == :public_network
    n[0] = :private_network
    n[1][:type] = "dhcp"
  end
end

# increase boot timeout
config.vm.boot_timeout = 600

config.vm.provider "virtualbox" do |v|
	v.memory = 8192
	v.cpus = 2
	# v.linked_clone = true
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
end
"""
}

void writeSetupStagingJSON() {
    //configure setup
    //      - to install all Dogus
    //      - to work in embedded mode
    //      - have an admin as 'admin/adminpw'

    writeFile file: 'setup.staging.json', text: """
{
  "token":{
    "ID":"",
    "Secret":"",
    "Completed":true
  },
  "region":{
    "locale":"en_US.utf8",
    "timeZone":"Europe/Berlin",
    "completed":true
  },
  "naming":{
    "fqdn":"${getCesIP()}",
    "hostname":"ces",
    "domain":"ces.local",
    "certificateType":"selfsigned",
    "certificate":"",
    "certificateKey":"",
    "relayHost":"mail.ces.local",
    "completed":true
  },
  "dogus":{
    "defaultDogu":"cockpit",
    "install":[
      "official/cas",
      "official/cockpit",
      "official/jenkins",
      "official/nginx",
      "official/ldap",
      "official/postfix",
      "official/postgresql",
      "official/redmine",
      "official/registrator",
      "official/scm",
      "official/smeagol",
      "official/sonar",
      "official/nexus",
      "official/usermgt"
    ],
    "completed":true
  },
  "admin":{
    "username":"admin",
    "mail":"admin@cloudogu.com",
    "password":"adminpw",
    "adminGroup":"CesAdministrators",
    "adminMember":true,
    "confirmPassword":"adminpw",
    "completed":true
  },
  "userBackend":{
    "port":"389",
    "useUserConnectionToFetchAttributes":true,
    "dsType":"embedded",
    "attributeID":"uid",
    "attributeFullname":"cn",
    "attributeMail":"mail",
    "attributeGroup":"memberOf",
    "searchFilter":"(objectClass=person)",
    "host":"ldap",
    "completed":true
  },
  "unixUser":{
    "Name":"",
    "Password":""
  },
  "registryConfig": {
  }
}"""
}
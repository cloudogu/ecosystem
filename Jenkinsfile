#!groovy

// todo
// - setup output

// required plugins
// - http://wiki.jenkins-ci.org/display/JENKINS/HTML+Publisher+Plugin

node('vagrant') {

    properties([
            // Keep only the last x builds to preserve space
            buildDiscarder(logRotator(numToKeepStr: '10')),
            // Don't run concurrent builds for a branch, because they use the same workspace directory
            disableConcurrentBuilds()
    ])

    stage('Checkout') {
        checkout scm
    }

    try {

        stage('Provision') {
            timeout(5) {
                writeVagrantConfiguration()
                sh 'rm -f setup.staging.json setup.json'
                sh 'vagrant up'
            }
        }

        stage('Setup') {
            timeout(5) {
                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'cesmarvin-setup', usernameVariable: 'TOKEN_ID', passwordVariable: 'TOKEN_SECRET']]) {
                    sh "vagrant ssh -c \"sudo cesapp login ${env.TOKEN_ID} ${env.TOKEN_SECRET}\""
                }
                writeSetupStagingJSON()
                sh 'vagrant ssh -c "sudo mv /vagrant/setup.staging.json /etc/ces/setup.staging.json"'
                sh 'vagrant ssh -c "sudo mv /etc/ces/setup.staging.json /etc/ces/setup.json"'
                sh 'vagrant ssh -c "while sudo pgrep -u root ces-setup > /dev/null; do sleep 1; done"'
                sh 'vagrant ssh -c "sudo journalctl -u ces-setup -n 100"'
            }
        }

        stage('Start Dogus') {
            timeout(15) {
                // TODO wait for all
                sh 'vagrant ssh -c "sudo cesapp healthy --wait --timeout 600 --fail-fast cas"'
                sh 'vagrant ssh -c "sudo cesapp healthy --wait --timeout 600 --fail-fast jenkins"'
                sh 'vagrant ssh -c "sudo cesapp healthy --wait --timeout 600 --fail-fast scm"'
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
            sh 'vagrant destroy -f'
        }
    }

}

String getCesIP() {
    //log into vm and get its IP

    // note \$5 is escaping a $ sign which is needed in the shell script

    //TODO: does not work: only empty string provided
    sh 'vagrant ssh -c "ip addr | grep \'state UP\' -A2 | tail -n1 | awk \'{print \\$52}\' | cut -f1  -d\'/\'"  > my.ip'
    return readFile('my.ip').trim()
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

config.vm.provider "virtualbox" do |v|
	v.memory = 8192
	v.cpus = 2
	v.linked_clone = true
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
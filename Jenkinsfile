#!groovy

// todo
// - setup output

node('vagrant') {

  ip = "192.168.42.100"

  stage('Checkout') {
    checkout scm
  }

  try {

    stage('Provision') {
        timeout(5) {
            writeVagrantConfiguration()
            sh 'vagrant up'
        }
    }

    stage('Setup') {
        timeout(30) {
            writeSetupJSON()
            sh 'vagrant ssh -c "while pgrep -u root ces-setup > /dev/null; do sleep 1; done"'
        }
    }

  } finally {
    stage('Clean') {
        sh 'vagrant destroy -f'
    }
  }

}

String ip;

void writeVagrantConfiguration() {
  writeFile file: '.vagrant.rb', text: """
# override public network with a private one
config.vm.networks.each do |n|
    if n[0] == :public_network
        n[0] = :private_network
        n[1][:ip] = "${ip}"
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

void writeSetupJSON() {
    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'cesmarvin-setup', usernameVariable: 'TOKEN_ID', passwordVariable: 'TOKEN_SECRET']]) {
    writeFile file: 'setup.json', text: """
{
  "token":{
    "ID":"${env.TOKEN_ID}",
    "Secret":"${env.TOKEN_SECRET}",
    "Completed":true
  },
  "region":{
    "locale":"en_US.utf8",
    "timeZone":"Europe/Berlin",
    "completed":true
  },
  "naming":{
    "fqdn":"${ip}",
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
  }
}"""
    }
}
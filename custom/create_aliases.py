def createAliases(file, namespace, doguName):
    file.write("# {}\n".format(doguName))
    file.write("alias b{}=\"cd /vagrant/containers/{} && cesapp build .\"\n".format(doguName, doguName))
    file.write("alias l{}=\"tail -f /var/log/docker/{}.log\"\n".format(doguName, doguName))
    file.write("alias cl{}=\"cat -n /var/log/docker/{}.log\"\n".format(doguName, doguName))
    file.write("alias tl{}=\"truncate -s 0 /var/log/docker/{}.log\"\n".format(doguName, doguName))
    file.write("alias e{}=\"docker exec -it {} bash\"\n".format(doguName, doguName))
    file.write("alias i{}=\"cesapp install {}/{}\"\n".format(doguName, namespace, doguName))
    file.write("alias c{}=\"cesapp edit-config {}\"\n".format(doguName, doguName))
    file.write("alias sc{}=\"etcdctl -output json ls -r /config/{} | jq\"\n".format(doguName, doguName))
    file.write("alias r{}=\"docker restart {}\"\n".format(doguName, doguName))
    file.write("alias g{}=\"cd /vagrant/containers/{}\"\n".format(doguName, doguName))
    file.write("alias p{}=\"cesapp purge {}\"\n".format(doguName, doguName))
    file.write("\n")

defaultDogus = ["cas", "cockpit", "ldap-mapper", "ldap", "jenkins", "nexus", "nginx", "plantuml", "postfix", "postgresql", "redmine", "registrator", "scm", "smeagol", "sonar", "swaggerui", "usermgt"]
premiumDogus = ["backup", "confluence", "jira", "portainer", "monitoring"]
itz_bund = ["easyredmine", "baseline"]

print "Opening the file..."
target = open(".zsh_aliases", "w")

print "Creating alias for default dogus..."
for x in defaultDogus:
    createAliases(target, "official", x)

print "Creating alias for premium dogus..."
for x in premiumDogus:
    createAliases(target, "premium", x)

print "Creating alias for baseline dogus..."
for x in itz_bund:
    createAliases(target, "itz-bund", x)

print "Write predefined aliases..."
target.write("\n# ----------------------------------------------------------\n\n")
target.write("# Pet\n")
target.write("alias snip=\"pet search | xsel --clipboard\"\n")
target.write("\n# ----------------------------------------------------------\n\n")
target.write("# Etcd\n")
target.write("alias eget=\"etcdctl get\"\n")
target.write("alias els=\"etcdctl ls\"\n")
target.write("alias e=\"etcdctl\"\n")

vagrant ssh -c 'sudo adduser cloudflo2312  --disabled-password --gecos ""'
vagrant ssh -c 'echo mypassword | passwd cloudflo2312 --stdin'

ssh 192.168.56.2@cloudflo2312:
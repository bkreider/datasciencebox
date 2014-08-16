ubuntu:
  user.present:
    - shell: /bin/bash

# If local VM copy the vagrant insecure key to ubuntu user
/home/ubuntu/.ssh:
  file.directory:
    - user: ubuntu
    - makedirs: True

insecure-key:
  cmd.run:
    - name: "wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O authorized_keys -q"
    - cwd: /home/ubuntu/.ssh
    - user: ubuntu
    - onlyif: "test -d /home/vagrant && test ! -e /home/ubuntu/.ssh/authorized_keys"
    - require:
      - user: ubuntu
      - file: /home/ubuntu/.ssh

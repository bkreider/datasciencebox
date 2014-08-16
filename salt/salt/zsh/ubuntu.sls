include:
  - zsh
  - user.ubuntu

extend:
  ubuntu:
    user:
      - shell: /bin/zsh

oh-my-zsh:
  pkg.installed:
    - name: git
  git.latest:
    - name: git://github.com/robbyrussell/oh-my-zsh.git
    - target: /home/ubuntu/.oh-my-zsh
    - user: ubuntu
    - require:
      - pkg: oh-my-zsh

dot_zshrc:
  file.copy:
    - name: /home/ubuntu/.zshrc
    - source: /home/ubuntu/.oh-my-zsh/templates/zshrc.zsh-template
    - user: ubuntu
    - require:
      - git: oh-my-zsh

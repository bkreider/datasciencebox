include:
  - conda
  - zsh.ubuntu
  - user.ubuntu

build-essential:
  pkg.installed

base:
  conda.managed:
    - name: /home/ubuntu/envs/base
    - requirements: salt://python/requirements.txt
    - user: ubuntu
    - require:
      - sls: conda

# TODO: Settings?
append-path:
  file.append:
    - name: /home/ubuntu/.zshrc
    - text: "export PATH=/home/ubuntu/envs/base/bin:$PATH"
    - user: ubuntu
    - require:
      - sls: zsh.ubuntu
      - conda: base

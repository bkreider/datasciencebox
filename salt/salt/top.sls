base:
  'datasciencebox':
    - user.ubuntu
    - zsh.ubuntu
    - s3cmd.ubuntu
    - ipnotebook
    # - salt.master
    # - salt.cloud
  'ipengine-*':
    - ipcluster.engine

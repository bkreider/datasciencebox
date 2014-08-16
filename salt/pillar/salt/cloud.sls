salt-cloud:
  providers:
    us-east-1d:
      provider: ec2
      ssh_interface: private_ips
      id: ""
      key: ""
      keyname: XXXX_keypair
      private_key: /etc/salt/cloud.providers.d/key/aws.pem
      location: us-east-1
      availability_zone: us-east-1d

  profiles:
    ipengine:
      provider: us-east-1d
      size: m3.large
      image: ami-018c9568
      ssh_username: ubuntu
      securitygroupid:
        - ""

  certs:
    aws:
      pem: |
        -----BEGIN RSA PRIVATE KEY-----
        -----END RSA PRIVATE KEY-----

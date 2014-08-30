require 'yaml'

VAGRANT_COMMAND = ARGV[0]

Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
  # config.vm.box = "trusty64"
  # config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.hostname = 'datasciencebox'

  if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'dsb'
  end

  config.vm.network "forwarded_port", guest: 8888, host: 8888    # Notebook
  config.vm.network "forwarded_port", guest: 50070, host: 50070  # NameNode
  config.vm.network "forwarded_port", guest: 18080, host: 18080  # Spark

  config.vm.synced_folder "salt/", "/srv"
  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.memory = 2048
    vb.cpus = 2
  end

  config.vm.provider :aws do |aws, override|
    override.vm.box = "dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

    override.vm.hostname = nil

    if !defined? AWS
      if File.file?(File.join(File.dirname(__FILE__), 'aws.yml'))
        AWS = YAML.load_file(File.join(File.dirname(__FILE__), 'aws.yml'))["aws"]
      else
        AWS = YAML.load_file(File.join(File.dirname(__FILE__), 'aws.yml.template'))["aws"]
      end
    end

    aws.ami = AWS["ami"]

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'dsb'
    else
      override.ssh.username = AWS["username"]
    end

    aws.instance_type = AWS["instance_type"]

    aws.access_key_id = AWS["access_key_id"]
    aws.secret_access_key = AWS["secret_access_key"]

    aws.keypair_name = AWS["keypair_name"]
    override.ssh.private_key_path = AWS["private_key_path"]

    aws.region = "us-east-1"
    aws.availability_zone = "us-east-1d"
    aws.security_groups = AWS["security_groups"]

    if AWS.has_key?("subnet_id")
      aws.subnet_id = AWS["subnet_id"]
    end

    aws.tags = {
      "Name" => AWS["name"],
    }
  end
end

# DataScienceBox

My personal data science box based on [salt](http://www.saltstack.com/) and
[Vagrant](http://vagrantup.com/) to easily create cloud instances or local VMs
ready for doing data science.

- Ubuntu 12.04
- Python 2.7.8 packages based on [Anaconda](http://continuum.io/downloads)
- [IPython notebook](http://ipython.org/notebook.html) running in port 8888

Optional:

- [s3cmd](http://s3tools.org/s3cmd)
- [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/) cluster creation
- [Mesos](http://mesos.apache.org/) + [Spark](https://spark.apache.org/)
cluester creation (beta)

## Main box

### Local VM

`vagrant up`, by default the IPython notebook port (8888) is forwarded
to the host.

### EC2

1. Install vagrant aws plugin: `vagrant plugin install vagrant-aws`
2. Copy the `aws.template.yml` file to `aws.yml` and fill the missing values
3. `vagrant up --provider=aws`

### SSH

`vagrant ssh`

## Settings

Settings are divided into different files all located at: `salt/pillar/`
most of them are optional on that case a `settings.sls.template` file is
provided with the options.

### S3

Copy the `salt/pillar/s3cmd.sls.template` into `salt/pillar/s3cmd.sls`
and fill the missing values. The `.s3cfg` will be filled with those values
on the box.

### Python packages

Change the `salt/salt/python/requirements.txt` file.

### salt-cloud

You need to fill the 3 files in the `salt/pillar/salt` directory, each file has
a template with basic defaults:

1. `certs.sls`: AWS private key used to create the instances
1. `providers.sls`: AWS credentials, key_pair name and cert name (#1)
1. `profiles.sls`: Provider name (#2), image size, base image and security group

On the main dsb instance do:

1. `sudo salt-call state.sls salt.master`
1. `sudo salt-call state.sls salt.cloud`
1. `sudo salt-call state.sls salt.minion`

## Mesos

### Local

Mainly used for development of the states

1. `vagrant up --provider=aws`, `vagrant ssh` and
`sudo salt-call state.sls salt.master`.
2. `vagrant up master` starts a box with the namenode, zookeeper and mesos-master
3. Add a line to the `/etc/hosts` of the host machine containing the ip of the
dsb-master like this: `172.28.128.4        dsb-master`
3. `vagrant up slave` starts a box with the datanode and mesos-slave

Check on the host machine you should be able to see:
[Mesos UI](http://localhost:5050) and the [Namenode UI](http://localhost:50070)

### Cloud

**Requires**: [salt-cloud](#salt-cloud) config

1. Start dsb main instance:
`vagrant up --provider=aws`, `vagrant ssh` and `sudo salt-call state.sls salt.master`
2. Start master instance: mesos-master and namenode:
`sudo salt-cloud -p mesos-master mesos-master`
3. Provison master intance:
`sudo salt 'roles:mesos-master' -G state.highstate`
4. Start worker instances: mesos-slave and datanode:
`sudo salt-cloud -p mesos-slave mesos-slave-1`
5. Provision worker instances:
`sudo salt 'roles:mesos-slave' -G state.highstate`

### Spark

**Requires**: Mesos local or mesos in the cloud

From the main dsb box:

1. Download spark on the master node ad put the spark `tgz` in  hdfs:
`sudo salt 'roles:mesos-master' -G state.sls mesos.spark`
2. Install spark and mesos on the main box (notebook):
`sudo salt-call state.sls mesos.spark.conf`

## IPython.parallel cluster

**Requires**: [salt-cloud](#salt-cloud) config

Fill/change the `salt/pillar/ipcluster.sls` file, launch the datasciencebox on EC2
(`vagrant up --provider=aws`) and ssh into it (`vagrant ssh`), then:

1. `sudo salt-call state.sls ipcluster.instances`: creates instances
2. `sudo salt-call state.sls ipcluster.controller`: start the ipcontroller on the main instance
3. `sudo salt 'ipengine-*' state.highstate`: start ipengine on worker instances

Everyting is ready, see [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/)
for more information on how to use it.

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
cluster creation (beta)

## Main box

### Local VM

`vagrant up`. The default IPython notebook port (8888) is forwarded
to the host

### EC2

1. Install vagrant aws plugin: `vagrant plugin install vagrant-aws`
2. Copy the `aws.template.yml` file to `aws.yml` and fill the missing values
3. `vagrant up --provider=aws`

#### SSH

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

`salt-cloud` allows the creation of instances.
You need to fill the 3 files in the `salt/pillar/salt` directory, each file has
a template with basic defaults:

1. `certs.sls`: AWS private key used to create the instances
2. `providers.sls`: AWS credentials, key_pair name and cert name (#1)
3. `profiles.sls`: Provider name (#2), image size, base image and security group

On the main dsb box do: `sudo salt-call state.sls salt.cloud`

## Mesos

### Cloud

**Requires**: [salt-cloud](#salt-cloud)

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

### Local

Mainly used for development of the states since its only possible to have one
mesos slave.

1. `vagrant up --provider=aws`, `vagrant ssh` and
`sudo salt-call state.sls salt.master`.
2. `vagrant up master` starts a box with the namenode, zookeeper and mesos-master
3. Add a line to the `/etc/hosts` of the host machine containing the ip of the
dsb-master like this: `172.28.128.4        dsb-master`
3. `vagrant up slave` starts a box with the datanode and mesos-slave

Check on the host machine you should be able to see:
[Mesos UI](http://localhost:5050) and the [Namenode UI](http://localhost:50070)

### Spark

**Requires**: Mesos local or mesos in the cloud

From the main dsb box:

1. Download spark on the master node ad put the spark `tgz` in  hdfs:
`sudo salt 'roles:mesos-master' -G state.sls mesos.spark`
2. Install spark and mesos on the main box (notebook):
`sudo salt-call state.sls mesos.spark.conf`

## IPython.parallel cluster

**Requires**: [salt-cloud](#salt-cloud)

1. Change the `cluster` section on the `salt/pillar/ipython.sls` file
2. On the main dsb box: `sudo salt-call state.sls ipython.controller`:
starts the ipcontroller on the main box
3. On the main dsb box: `sudo salt-call state.sls ipython.cluster`:
creates instances in parallel
4. On the main dsb box: `sudo salt 'roles:ipython-engine' -G state.highstate`:
starts ipengine on the new instances

Everyting is ready, see [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/)
for more information on how to use it.

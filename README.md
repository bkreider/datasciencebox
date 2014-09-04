# DataScienceBox

Data science box based on [salt](http://www.saltstack.com/) and
[Vagrant](http://vagrantup.com/) to easily create cloud instances.

There are two types of instances the single and the master

- Single dsb is a python enviroment based on
[Anaconda](http://continuum.io/downloads) packages.
The IPython notebook is available at port 8888.
- Master dsb = single dsb + salt-master + HDFS namenode + mesos-master.
Allows the creation of mesos-slaves that can be used to use spark.

**Requisites**:

1. [Vagrant](https://www.vagrantup.com/downloads.html)
2. Vagrant aws plugin: `vagrant plugin install vagrant-aws`
3. Copy the `aws.template.yml` file to `aws.yml` and fill the missing values

## Single

Create instance: `vagrant up --provider=aws`

SSH: `vagrant ssh`

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

## Master

**Note**: This requires ubuntu 12.04

Create instance: `vagrant up master --provider=aws`

SSH: `vagrant ssh master`

### Slaves

**Requires**: [salt-cloud](#salt-cloud)

2. `vagrant ssh master`
3. `sudo salt-call state.sls mesos.cluster`:
creates slaves in parallel
4. `sudo salt 'roles:mesos-slave' -G state.highstate`:
provision slave instances

### Spark

1. `sudo salt-call state.sls mesos.spark`:
Download spark and put the spark `tgz` in  hdfs:
3. (optional) Install the python enviroment in all the slaves:
`sudo salt 'roles:mesos-slave' -G state.sls python`
4. (optional) To use pyspark on the notebook it needs to be restarted:
`sudo salt-call state.sls ipython.notebook`

## IPython.parallel cluster

**Requires**: [salt-cloud](#salt-cloud)

1. Change the `cluster` section on the `salt/pillar/ipython.sls` file
2. SSH to the dsb box
2. `sudo salt-call state.sls ipython.controller`:
starts the ipcontroller on the main box
3. `sudo salt-call state.sls ipython.cluster`:
creates instances in parallel
4. `sudo salt 'roles:ipython-engine' -G state.highstate`:
starts ipengine on the new instances

Everyting is ready, see [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/)
for more information on how to use it.

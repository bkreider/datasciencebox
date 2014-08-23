# DataScienceBox

My personal data science box based on [salt](http://www.saltstack.com/) and
[Vagrant](http://vagrantup.com/) to easily create cloud instances or local VMs
ready for doing data science.

- Ubuntu 14.04
- Python 2.7.8 based on [Anaconda](http://continuum.io/downloads)
- [IPython notebook](http://ipython.org/notebook.html) running in port 8888

Optional:

- [s3cmd](http://s3tools.org/s3cmd)
- [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/) cluster creation

## Creating the box

### Local VM

Just run `vagrant up`, by default the IPython notebook port (8888) is forwarded
to the host.

### EC2

- Install vagrant aws plugin: `vagrant plugin install vagrant-aws`
- Copy the `aws.template.yml` file to `aws.yml` and fill the missing values
- `vagrant up --provider=aws`

### SSH

1. Local VM `vagrant ssh -- -l ubuntu`
2. EC2 instance: `vagrant ssh`

## Settings

Settings are divided into different files all located at: `salt/pillar/`
most of them are optional on that case a `settings.sls.template` file is
provided with the options.

### S3

Copy the `salt/pillar/s3cmd.sls.template` into `salt/pillar/s3cmd.sls`
and fill the missing values. The `.s3cfg` will be filled with those values
on the box.

### Python packages

Change the `salt/salt/python/requirements.txt` file

## IPython.parallel cluster

**1. Cloud information**

You need to fill the 3 files in the `salt/pillar/salt` directory, each file has
a template.

1. `certs.sls`: AWS private key used to create the instances; careful with indentation
1. `providers.sls`: AWS credentials, key_pair name and cert name (#1)
1. `profiles.sls`: Provider name (#2), image size, base image and security group

**2. Start instances**

Fill the `salt/pillar/ipcluster.sls` file, launch the datasciencebox on EC2
(`vagrant up --provider=aws`) and ssh into it (`vagrant ssh`), then:

1. `sudo salt-call state.sls ipcluster.instances`: creates instances
2. `sudo salt-call state.sls ipcluster.controller`: start the ipcontroller on the main instance
3. `sudo salt 'ipengine*' state.sls state.highstate`: start ipengine on worker instances

Everyting is ready, see [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/)
for more information on how to use it.

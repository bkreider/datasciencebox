# DataScienceBox

My personal data science box based on [salt](http://www.saltstack.com/) and
[Vagrant](http://vagrantup.com/) to easily create cloud instances or local VMs
ready for doing data science.

- Ubuntu 14.04
- Python 2.7.8 based on [Anaconda](http://continuum.io/downloads)
- [IPython notebook](http://ipython.org/notebook.html) running in port 8888
- [s3cmd](http://s3tools.org/s3cmd), including conf file

And optionally:

- [Luigi](https://github.com/spotify/luigi), including conf file for S3
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

Vagrant box and EC2 instance are based on ubuntu 14.04 to be consistent between
them to ssh to a local VM locally you need to use the ubuntu user:
`vagrant ssh -- -l ubuntu`.
If running on the EC2 don't need to worry about that, just `vagrant ssh`

## Configuration

Settings are divided into different files all located at: `salt/pillar/`

### Python packages

Change the `salt/salt/python/requirements.txt` file

### IPython.parallel cluster

Fill the `salt/pillar/ipcluster.sls` file, launch the datasciencebox on EC2
(`vagrant up --provider=aws`) and ssh into it (`vagrant ssh`), then:

1. `sudo salt-call state.sls ipcluster.instances`: creates instances
2. `sudo salt-call state.sls ipcluster.controller`: start the ipcontroller on the main instance
3. `sudo salt 'ipengine*' state.sls state.highstate`: start ipengine on worker instances

Everyting is ready, see [IPython.parallel](http://ipython.org/ipython-doc/dev/parallel/)
for more information on how to use it.

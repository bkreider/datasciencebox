from fabric.api import task, run, local, sudo, put, get, settings, env


def _get_config():
    ret = {}
    output = local('vagrant ssh-config default', capture=True)
    for line in output.split('\n'):
        if 'HostName' in line:
            ret['HostName'] = line.split(' ')[-1]
        if 'Port' in line:
            ret['Port'] = line.split(' ')[-1]
        if 'IdentityFile' in line:
            ret['IdentityFile'] = line.split(' ')[-1]
    return ret


@task
def ssh():
    local('vagrant ssh')


@task
def get_hostname():
    print(_get_config()['HostName'])


@task
def make_master():
    config = _get_config()
    env.hosts = [config['HostName']]
    env.key_filename = config['IdentityFile']
    env.user = 'dsb'
    host_string = config['HostName'] +':' + config['Port']
    with settings(host_string=host_string):
        sudo('sudo salt-call state.sls salt.master')
        sudo('sudo salt-call state.sls salt.minion')
        sudo('sudo salt-call state.highstate')


@task
def sync_put():
    config = _get_config()
    env.hosts = [config['HostName']]
    env.key_filename = config['IdentityFile']
    env.user = 'dsb'
    host_string = config['HostName'] +':' + config['Port']
    with settings(host_string=host_string):
        put('./notebooks', './')


@task
def sync_get():
    config = _get_config()
    env.hosts = [config['HostName']]
    env.key_filename = config['IdentityFile']
    env.user = 'dsb'
    host_string = config['HostName'] +':' + config['Port']
    with settings(host_string=config['HostName']):
        get('./notebooks', './')

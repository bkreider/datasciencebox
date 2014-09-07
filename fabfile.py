from fabric.api import task, run, local, put, get, settings, env


@task
def ssh(id='master'):
    local('vagrant ssh %s' % id)


def _get_config(id='master'):
    ret = {}
    output = local('vagrant ssh-config %s' % id, capture=True)
    for line in output.split('\n'):
        if 'HostName' in line:
            ret['HostName'] = line.split(' ')[-1]
        if 'IdentityFile' in line:
            ret['IdentityFile'] = line.split(' ')[-1]
    return ret


@task
def get_hostname(id='master'):
    print(_get_config(id)['HostName'])


@task
def sync_put(id='master'):
    config = _get_config(id)
    env.hosts = [config['HostName']]
    env.key_filename = config['IdentityFile']
    env.user = 'dsb'
    with settings(host_string=config['HostName']):
        put('./notebooks', './')


@task
def sync_get(id='master'):
    config = _get_config(id)
    env.hosts = [config['HostName']]
    env.key_filename = config['IdentityFile']
    env.user = 'dsb'
    with settings(host_string=config['HostName']):
        get('./notebooks', './')

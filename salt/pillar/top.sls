#!py
import os
import fnmatch

def run():
  '''
  Returns all the pillars in the pillars list if they exists

  Right now it only handles one level of depth
  '''
  pillars = ['users', 's3cmd', 'salt', 'ipcluster']
  pillar_path = '/srv/pillar'

  matches = []
  for pillar in pillars:
    if is_available(pillar_path, pillar):
      matches.append(pillar)
  return {'base': {'*': matches}}

def is_available(pillar_path, pillar_name):
  if os.path.isfile(os.path.join(pillar_path, pillar_name + ".sls")):
    return True
  if os.path.isfile(os.path.join(pillar_path, pillar_name, 'init.sls')):
    return True
  return False

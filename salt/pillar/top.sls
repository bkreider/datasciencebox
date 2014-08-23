#!py
import os
import fnmatch

def run():
  '''
  Returns all the pillars in the pillars list
  that actually exists
  '''
  pillars = ['ipcluster', 's3cmd', 'salt']
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

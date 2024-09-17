#!/usr/bin/env python

import os
import pem
import json
import string
import random
from github import Auth
from github import Github
from github import GithubIntegration

def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

pemf = os.environ["PRIVATE_KEY"]
if os.path.isfile(pemf):
    with open(pemf, 'rb') as f:
        fil = f.read()
else:
    fil = pem
cert = pem.parse(fil)

auth = Auth.AppAuth(os.environ["APP_ID"], str(cert[0]))
gi = GithubIntegration(auth = auth)
installation = gi.get_installations()[0]
print(installation)
repos = [x.full_name for x in installation.get_repos()]
ghoutput = os.environ.get("GITHUB_OUTPUT")
if ghoutput is None:
    throwException("oops")
id = id_generator()
if os.path.isfile(ghoutput):
    with open(ghoutput, 'a') as f:
        f.write(f'repos<<{id}\n{json.dumps(repos)}\n{id}\n')


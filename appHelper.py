#!/usr/bin/env python

import os
import json
import string
import random
# https://pygithub.readthedocs.io/
from github import Auth
from github import Github
from github import GithubIntegration

# generate a random ID to assing the variable
def id_generator(size=6, chars=string.ascii_uppercase + string.digits):
    return ''.join(random.choice(chars) for _ in range(size))

# the private key here is either a .pem file or it's an evvar that contains the
# contents of the .pem file. 
def read_pem():
    pemf = os.environ["PRIVATE_KEY"]
    if os.path.isfile(pemf):
        with open(pemf, 'rb') as f:
            cert = f.read()
    else:
        cert = pemf
    return cert


def get_installation():
    # Auth dance
    cert = read_pem()
    auth = Auth.AppAuth(os.environ["APP_ID"], str(cert))
    gi = GithubIntegration(auth = auth)
    return gi

def get_slug_id():
    ghapp = get_installation()
    app = ghapp.get_app()
    email = f'{app.id}+{app.slug}@users.noreply.github.com'
    # assign them to the GitHub output (which is a file whose path is assigned
    # to the GITHUB_OUTPUT variable) 
    ghoutput = os.environ.get("GITHUB_OUTPUT")
    if ghoutput is None:
        throwException("oops")
    rid = id_generator()
    if os.path.isfile(ghoutput):
        with open(ghoutput, 'a') as f:
            f.write(f'slug={app.slug}\n')
            f.write(f'id={app.id}\n')
            f.write(f'email={email}\n')
            f.close()


def list_repositories():
    ghapp = get_installation()
    installation = ghapp.get_installations()[0]
    # get the full names for the repositories
    repos = [x.full_name for x in installation.get_repos()]

    # assign them to the GitHub output (which is a file whose path is assigned
    # to the GITHUB_OUTPUT variable) 
    ghoutput = os.environ.get("GITHUB_OUTPUT")
    if ghoutput is None:
        throwException("oops")
    rid = id_generator()
    if os.path.isfile(ghoutput):
        with open(ghoutput, 'a') as f:
            f.write(f'repos<<{rid}\n{json.dumps(repos)}\n{rid}\n')
            f.close()

def get_token():
    ghapp = get_installation()
    installation = ghapp.get_installations()[0]
    token = ghapp.get_access_token(installation.id)
    # assign them to the GitHub output (which is a file whose path is assigned
    # to the GITHUB_OUTPUT variable) 
    ghoutput = os.environ.get("GITHUB_OUTPUT")
    if ghoutput is None:
        throwException("oops")
    rid = id_generator()
    if os.path.isfile(ghoutput):
        with open(ghoutput, 'a') as f:
            f.write(f'token={token.token}\n')
            f.close()


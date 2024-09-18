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

def write_string(key, value):
    # assign them to the GitHub output (which is a file whose path is assigned
    # to the GITHUB_OUTPUT variable) 
    ghoutput = os.environ.get("GITHUB_OUTPUT")
    if ghoutput is None:
        throwException("oops")
    if os.path.isfile(ghoutput):
        with open(ghoutput, 'a') as f:
            f.write(f'{key}={value}\n')
            f.close()

def write_json(key, value):
    # assign them to the GitHub output (which is a file whose path is assigned
    # to the GITHUB_OUTPUT variable) 
    ghoutput = os.environ.get("GITHUB_OUTPUT")
    if ghoutput is None:
        throwException("oops")
    rid = id_generator()
    if os.path.isfile(ghoutput):
        with open(ghoutput, 'a') as f:
            f.write(f'{key}<<{rid}\n{json.dumps(value)}\n{rid}\n')
            f.close()

def get_installation():
    # Auth dance
    cert = read_pem()
    auth = Auth.AppAuth(os.environ["APP_ID"], str(cert))
    gi = GithubIntegration(auth = auth)
    return gi

def get_slug_id():
    ghapp = get_installation()
    installation = ghapp.get_installations()[0]
    gh = installation.get_github_for_installation()
    app = ghapp.get_app()
    app_usr = gh.get_user(app.slug+"[bot]")
    email = f'{app_usr.id}+{app_usr.login}@users.noreply.github.com'
    write_string("slug", app.slug)
    write_string("email", email)
    write_string("id", app_usr.id)


def list_repositories():
    ghapp = get_installation()
    installation = ghapp.get_installations()[0]
    # get the full names for the repositories
    repos = [x.full_name for x in installation.get_repos()]
    write_json("repos", repos)

def get_token():
    ghapp = get_installation()
    installation = ghapp.get_installations()[0]
    token = ghapp.get_access_token(installation.id)
    write_string("token", token.token)


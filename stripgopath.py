import os

pwd = os.getcwd()

gopath = os.environ.get('GOPATH', None)

if gopath is not None:
    if pwd.startswith(gopath):
        pwd = pwd[len(gopath) + 1:]

print "GOPATH/" + pwd

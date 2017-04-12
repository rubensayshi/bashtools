import os
import re


pwd = os.getcwd()

gopath = os.environ.get('GOPATH', "")
gofml = os.environ.get('GOFML', "")

if gofml != "" and gopath != "":
	goproject=os.path.basename(gofml)
	r = re.compile("(%s/src/%s).*" % (gopath, gofml))
	m = r.match(pwd)

	if m:
		pwd = pwd.replace(m.group(1), "GOFML(%s)" % goproject)

print pwd

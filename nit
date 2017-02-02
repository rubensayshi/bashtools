#!/usr/bin/python3

import json
import os
import re
import shutil
import argparse
import subprocess
import sys


KNOWN_TOOLS = ['jshint', 'jscs', 'phpcs']
REGEX = re.compile('^.*`(.+?)`.*$')


def analyze_readme(readme):
    run = []

    with open(readme, 'r') as f:
        iscodeblock = False
        for line in f.readlines():
            if not iscodeblock and line.startswith('```'):
                iscodeblock = True
            elif iscodeblock and (line.startswith('```') or line.endswith('```')):
                iscodeblock = False
            else:
                if iscodeblock:
                    for tool in KNOWN_TOOLS:
                        if tool in line:
                            run.append(line)
                else:
                    m = re.match(REGEX, line)
                    if m:
                        for tool in KNOWN_TOOLS:
                            if tool in m.group(1):
                                run.append(m.group(1))
   
    return run


def main():
    cwd = os.getcwd()
    
    run = []
    
    if os.path.isfile(cwd + "/README.md"):
        run = run + analyze_readme(cwd + "/README.md")
    
    for cmd in run:
        cmd = re.sub(r'\n$', '', cmd);
        print(cmd)
        if str(input("run?") or "").lower() not in ['n', 'no']:
            os.system(cmd)
        

if __name__ == "__main__":
    main()


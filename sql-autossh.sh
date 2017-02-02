#!/bin/bash

autossh -N -L 3307:live-blocktrail01.cns6zrdnrjve.eu-west-1.rds.amazonaws.com:3306 -f ubuntu@ec2-52-208-236-215.eu-west-1.compute.amazonaws.com
autossh -N -L 3308:dev-blocktrail01.cns6zrdnrjve.eu-west-1.rds.amazonaws.com:3306 -f ubuntu@ec2-52-208-236-215.eu-west-1.compute.amazonaws.com

# autossh -N -L 3309:localhost:3306 -f root@vps3.rubensayshi.com


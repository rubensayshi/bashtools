#!/bin/bash

CMD="pagekite.py --frontend=rubensayshi.com:5000 --service_on=http:rjaws.pagekite.rubensayshi.com:localhost:5000:RAWR --clean --insecure"

echo $CMD
$CMD

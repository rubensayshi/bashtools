ps -ef | grep pycharm | grep java | awk '{print $2}' |  xargs kill -9 

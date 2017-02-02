ps -ef | grep phpstorm | grep java | awk '{print $2}' |  xargs kill -9 

ps -ef | grep autossh | awk '{print $2}' |  xargs kill -9 

#!/bin/bash
# -------------------------------------------------
#  Get monitors configuration from monitor.xml and apply it for current user session.
#  In case of multiple definitions in monitor.xml only first one is used.
#
#  See http://bernaerts.dyndns.org/linux/74-ubuntu/309-ubuntu-dual-display-monitor-position-lost
#  for instructions
#
#  Parameters :
#    $1 : waiting time in sec. before forcing configuration (optional)
#
#  Revision history :
#    19/04/2014, V1.0 - Creation by N. Bernaerts
#    10/07/2014, V1.1 - Wait 5 seconds for X to fully initialize
#    01/09/2014, V1.2 - Correct NULL file bug (thanks to Ivan Harmady) and handle rotation
#    07/10/2014, V1.3 - Add monitors size and rate handling (idea from jescalante)
#    08/10/2014, V1.4 - Handle primary display parameter
#    08/12/2014, V1.5 - Waiting time in seconds becomes a parameter
# -------------------------------------------------

CONFIG="$1"

[ "${CONFIG}" = "" ] && echo "\$1 required" && exit 1

# monitor.xml path
MONITOR_XML="$HOME/.config/monitors.xml"

# get number of declared monitors
NUM=$(xmllint --xpath 'count(//monitors/configuration['$CONFIG']/output)' $MONITOR_XML)

# loop thru declared monitors to create the command line parameters
for (( i=1; i<=$NUM; i++)); do
  # get attributes of current monitor (name and x & y positions)
  NAME=$(xmllint --xpath 'string(//monitors/configuration['$CONFIG']/output['$i']/@name)' $MONITOR_XML 2>/dev/null)
  POS_X=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/x/text()' $MONITOR_XML 2>/dev/null)
  POS_Y=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/y/text()' $MONITOR_XML 2>/dev/null)
  ROTATE=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/rotation/text()' $MONITOR_XML 2>/dev/null)
  WIDTH=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/width/text()' $MONITOR_XML 2>/dev/null)
  HEIGHT=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/height/text()' $MONITOR_XML 2>/dev/null)
  RATE=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/rate/text()' $MONITOR_XML 2>/dev/null)
  PRIMARY=$(xmllint --xpath '//monitors/configuration['$CONFIG']/output['$i']/primary/text()' $MONITOR_XML 2>/dev/null)

  # if position is defined for current monitor, add its position and orientation to command line parameters
  [ -n "$POS_X" ] && PARAM_ARR=("${PARAM_ARR[@]}" "--output" "$NAME" "--pos" "${POS_X}x${POS_Y}" "--fbmm" "${WIDTH}x${HEIGHT}" "--rate" "$RATE" "--rotate" "$ROTATE")
 
  # if monitor is defined as primary, adds it to command line parameters
  [ "$PRIMARY" = "yes" ] && PARAM_ARR=("${PARAM_ARR[@]}" "--primary")
done

# if needed, wait for some seconds (for X to finish initialisation)
[ -n "$1" ] && sleep $1

# position all monitors
xrandr "${PARAM_ARR[@]}"



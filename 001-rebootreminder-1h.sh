#!/bin/bash

# <xbar.title>reboot reminder</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Michael Kwun</xbar.author>
# <xbar.author.github>lawtalker</xbar.author.github>
# <xbar.desc>Days of uptime, in red after specified number of days.</xbar.desc>
# <xbar.var>number(VAR_RED_DAY=7): Red starting on this day</xbar.var>
# <xbar.var>number(VAR_GRAY_ZERO=190): Day 0 gray level</xbar.var>

# based on Matteo Ferrando's uptime plugin 
# which is at https://xbarapp.com/docs/plugins/System/uptime.1m.sh.html

# the rewritten plugin
# a. just show days
# b. in gray until "red day," getting darker each day
# c. in red starting on a specified day

INFO=$(uptime | sed 's/^ *//g')

echo "$INFO" | awk -F'[ ,:\t\n]+' -v RED=$VAR_RED_DAY -v GRAY=$VAR_GRAY_ZERO '
    {
        if (GRAY > 255) {
            GRAY=255
        }

        if (substr($5,0,1) == "d") {
        # up for a day or more
            D = $4
        }
        else {
            D = 0
        }
        
        if (D == 1) {
            UNIT = "day"
        }
        else {
            UNIT = "days"
        }
        
        if (D < RED) {
            R = int( GRAY - GRAY/(RED-1) * D )
            GB = R
        }
        else {
            R = 255
            GB = 0
        }

        printf "[ ↑ %d %s ] ", D, UNIT
        printf " | color=#%02x%02x%02x | size=12\n", R, GB, GB
    }'


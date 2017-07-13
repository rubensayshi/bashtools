#!/bin/bash

DEVDBCONNECTION=live SUPPORT_API_URL="https://support-api.blocktrail.com" php5.6 /work/blocktrail-webapp/index.php tools support unban $*

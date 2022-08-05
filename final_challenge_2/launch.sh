#!/bin/bash
HOSTIP=`hostname -I | awk '{print $3}'`
#SHOREIP="10.116.0.2"
SHOREIP=$HOSTIP
TIME_WARP=1

TEAM_VEHICLES=("MANATEE-1" "MANATEE-2" "MANATEE-3" "MANATEE-4" "MANATEE-5" "MANATEE-6")
TEAM_TYPES=("kayak" "uuv" "kayak" "uuv" "kayak" "uuv")
TEAM_AUV_PORTS=("9005" "9006" "9007" "9008" "9009" "9010")
TEAM_AUV_PSHARE=("9205" "9206" "9207" "9208" "9209" "9201") 
TEAM_ALL_POINTS=("1500,1400:-1500,1400:-1500,200:1500,200:1500,-1000:-1500,-1000" "1500,1200:-1500,1200:-1500,0:1500,0:1500,-1200:-1500,-1200" "1500,1000:-1500,1000:-1500,-200:1500,-200:1500,-1400:-1500,-1400" "1500,800:-1500,800:-1500,-400:1500,-400" "1500,600:-1500,600:-1500,-600:1500,-600" "1500,400:-1500,400:-1500,-800:1500,-800")
TEAM_START_POS=( "x=1500,y=1400,speed=0,heading=0,depth=0" "x=1500,y=1200,speed=0,heading=0,depth=0" "x=1500,y=1000,speed=0,heading=0,depth=0" "x=1500,y=800,speed=0,heading=0,depth=0" "x=1500,y=600,speed=0,heading=0,depth=0" "x=1500,y=400,speed=0,heading=0,depth=0") 
TEAM_MAX_SPEED=("15" "6" "15" "6" "15" "6")

for i in ${!TEAM_VEHICLES[@]}; do
	echo "Launching ${TEAM_VEHICLES[$i]} MOOS Community. WARP is" $TIME_WARP
	nsplug ${TEAM_TYPES[$i]}_base.bhv targ_${TEAM_VEHICLES[$i]}.bhv AUV_NAME="${TEAM_VEHICLES[$i]}" \
		AUV_PORT=${TEAM_AUV_PORTS[$i]} \
		AUV_PSHARE=${TEAM_AUV_PSHARE[$i]} \
		AUV_TYPE=${TEAM_TYPES[$i]} \
		START_POS=${TEAM_START_POS[$i]} \
		ALL_POINTS=${TEAM_ALL_POINTS[$i]} \
		WARP=${TIME_WARP} \
		SHORESIDE_PORT=9000
	nsplug vehicle_base.moos targ_${TEAM_VEHICLES[$i]}.moos \
		AUV_NAME="${TEAM_VEHICLES[$i]}" \
		HOSTIP="${HOSTIP}" \
		AUV_PORT=${TEAM_AUV_PORTS[$i]} \
		AUV_PSHARE=${TEAM_AUV_PSHARE[$i]} \
		AUV_TYPE=${TEAM_TYPES[$i]} \
		WARP=${TIME_WARP} \
		START_POS=${TEAM_START_POS[$i]} \
		SHOREIP="${SHOREIP}" \
        	MAX_SPEED=${TEAM_MAX_SPEED[$i]} \
		GROUP="manatee" \
		MAX_DEPTH="500" \
		SHORESIDE_PORT=9000 \
		SHORESIDE_PSHARE=9200
	pAntler targ_${TEAM_VEHICLES[$i]}.moos --MOOSTimeWarp=$TIME_WARP >& /dev/null &
done

./shark_launch.sh "$@" && ./fish_launch.sh "$@" && ./treasure_launch.sh "$@" && ./whale_launch.sh "$@"


echo "Launching shoreside MOOS Community, WARP is" $TIME_WARP
nsplug shoreside_base.moos targ_shoreside.moos WARP=$TIME_WARP SHOREIP=$SHOREIP SHORESIDE_PORT=9000 SHORESIDE_PSHARE=9200
pAntler targ_shoreside.moos --MOOSTimeWarp=$TIME_WARP >& /dev/null &

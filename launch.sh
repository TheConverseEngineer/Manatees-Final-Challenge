#!/bin/bash
HOSTIP=`hostname -I | awk '{print $3}'`
SHOREIP=$HOSTIP
TIME_WARP=1

TEAM_VEHICLES=("MANATEE-1" "MANATEE-2" "MANATEE-3" "MANATEE-4" "MANATEE-5" "MANATEE-6")
TEAM_TYPES=("kayal" "kayak" "kayak" "kayak" "kayak" "kayak")
TEAM_AUV_PORTS=("9005" "9006" "9007" "9008" "9009" "9010")
TEAM_AUV_PSHARE=("9205" "9206" "9207" "9208" "9209" "9201") 
TEAM_START_Y=("-2950" "-2850" "-2750" "-2650" "-2550" "-2450")
TEAM_START_POS=("x=-3000,y=-2950,speed=0,heading=0,depth=0" "x=-3000,y=-2850,speed=0,heading=0,depth=0" "x=-3000,y=-2750,speed=0,heading=0,depth=0" "x=-3000,y=-2650,speed=0,heading=0,depth=0" "x=-3000,y=-2550,speed=0,heading=0,depth=0" "x=-3000,y=-2450,speed=0,heading=0,depth=0")


for i in ${!TEAM_VEHICLES[@]}; do
	echo "Launching ${TEAM_VEHICLES[$i]} MOOS Community. WARP is" $TIME_WARP
	nsplug vehicle_base.bhv targ_${TEAM_VEHICLES[$i]}.bhv AUV_NAME="${TEAM_VEHICLES[$i]}" \
		AUV_PORT=${TEAM_AUV_PORTS[$i]} \
		AUV_PSHARE=${TEAM_AUV_PSHARE[$i]} \
		AUV_TYPE=${TEAM_TYPES[$i]} \
		START_POS=${TEAM_START_POS[$i]} \
		START_Y=${TEAM_START_Y[$i]} \
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
        MAX_SPEED="15" \
		MAX_DEPTH="100" \
		SHORESIDE_PORT=9000 \
		SHORESIDE_PSHARE=9200
	pAntler targ_${TEAM_VEHICLES[$i]}.moos --MOOSTimeWarp=$TIME_WARP >& /dev/null &
done

./shark_launch.sh "$@" && ./whale_launch.sh "$@"


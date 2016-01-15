#!/bin/bash
HOME=/data

if [ $UPGRADE = true ]; then
	echo "[[ No Version Found : Downloading ]]";
	curl -S $ZIP_URL -o /tmp/infinity.zip
	unzip /tmp/infinity.zip -d $HOME && rm /tmp/infinity.zip
	if [[ ! -d $HOME/libraries ]]; then
		rm $HOME/libraries
		mkdir -p $HOME/libraries && curl -S https://libraries.minecraft.net/$LAUNCHWRAPPER -o $HOME/libraries/$LAUNCHWRAPPER
	fi
	curl -S https://s3.amazonaws.com/Minecraft.Download/versions/${MCVER}/minecraft_server.${MCVER}.jar -o $HOME/minecraft_server.${MCVER}.jar
	chmod +x $HOME/FTBInstall.sh $HOME/ServerStart.sh $HOME/settings.sh
	echo $MCVER > $HOME/ftbinfinity.ver
fi

if [ "$EULA" != "" ]; then
	echo "# Generated via Docker on $(date)" > eula.txt
	echo "eula=$EULA" >> eula.txt
else
	echo ""
	echo "Please accept the Minecraft EULA at"
	echo "  https://account.mojang.com/documents/minecraft_eula"
	echo "by adding the following immediately after 'docker run':"
	echo "  -e EULA=TRUE"
	echo ""
	exit 1
fi

if [ -n "$MOTD" ]; then
	sed -i "/motd\s*=/ c motd=$MOTD" $HOME/server.properties
fi
if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" $HOME/server.properties
fi
if [ -n "$SEED" ]; then
	sed -i "/level-seed\s*=/ c level-seed=$SEED" $HOME/server.properties
fi
if [ -n "$PVP" ]; then
	sed -i "/pvp\s*=/ c pvp=$PVP" /data/server.properties
fi
if [ -n "$WHITELIST" ]; then
	sed -i "/whitelist\s*=/ c whitelist=true" $HOME/server.properties
	sed -i "/white-list\s*=/ c white-list=true" $HOME/server.properties
fi
if [ -n "$DIFFICULTY" ]; then
	case $DIFFICULTY in
		peaceful|0)	DIFFICULTY=0 ;;
		easy|1)		DIFFICULTY=1 ;;
		normal|2)	DIFFICULTY=2 ;;
		hard|3)		DIFFICULTY=3 ;;
		*) echo "DIFFICULTY must be peaceful, easy, normal, or hard."; exit 1 ;;
	esac
	sed -i "/difficulty\s*=/ c difficulty=$DIFFICULTY" /data/server.properties
fi
if [ -n "$OPS" -a ! -e ops.txt.converted ]; then
	echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [[ -n "$UID" ]]; then
	usermod -u $UID minecraft
	chown minecraft:minecraft -R $HOME
fi
cd $HOME
$HOME/FTBInstall.sh && $HOME/ServerStart.sh

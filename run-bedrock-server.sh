function eula {
    echo "*********************************************************************************"
    echo "Please read the Minecraft Bedrock server EULA and agree to the license agreement."
    echo " "
    echo "    https://www.minecraft.net/en-us/download/server/bedrock/"
    echo " "
    echo "By running this container, you are accepting that you agree to their EULA."
    echo "If you do not agree, you should not use this docker image."
    echo ""
    echo "You must supply a link to a linux binary of their bedrock server to download and"
    echo "run inside this container."
    echo ""
    echo " -e MINECRAFT_URL=...SERVER_URL_HERE..."
    echo "*********************************************************************************"
}

function section {
    echo "*********************************************************************************"
    echo "$1"
    echo ""
}

# Due to the EULA, I cannot distribute minecraft bedrock server as part of this docker
# image, thus make the docker image download it on startup if it has not already been
# downloaded.
if [ "$EULA" == "true" ] && [ "$MINECRAFT_URL" != "" ]; then

    section "Downloading minecraft bedrock server"
    if [ ! -f /app/minecraft/bedrock_server ]; then
        echo "Downloading from $MINECRAFT_URL"
        wget --quiet $MINECRAFT_URL -O /app/bedrock-server.zip
        unzip /app/bedrock-server.zip -d /app/minecraft
    else
        echo "Minecraft bedrock server already downloaded.  Will not download again."
    fi

    # Try again, if it fails to be found this time, a bad URL was used.
    if [ ! -f "/app/minecraft/bedrock_server" ]; then
        echo "Could not find the Minecraft Bedrock Server executable after downloading and extracting the provided URL."
        echo "Make sure the URL you provided is a ZIP file that points to Minecraft Bedrock Server version."
        exit 2
    fi
else
    eula
    exit 1
fi

# Allow customization of the server properties on initial run
section "Setting server.properties"
declare -a options
options=("server-name" "gamemode" "difficulty" "allow-cheats" "max-players" "online-mode" "white-list" "view-distance" "tick-distance" "player-idle-timeout" "max-threads" "level-name" "level-seed" "default-player-permission-level" "texturepack-required" "content-log-file-enabled" "compression-threshold" "server-authoritative-movement" "player-movement-score-threshold" "player-movement-distance-threshold" "player-movement-duration-threshold-in-ms" "correct-player-movement")
for opt in ${options[@]}
do
    env="${opt^^}"
    env="MC_${env//\-/_}"

    if [ "${!env}" != "" ];
    then
        echo "SETTING minecraft option $opt with $env=\"${!env}\""
        sed -i "s/^$opt=.*$/$opt=${!env}/" /app/minecraft/server.properties
    else
        echo "Not set $opt with $env"
    fi
done

echo ""
echo ""
echo "Here are the applied server.properties"
echo ""
echo ""

cat /app/minecraft/server.properties
echo ""
echo ""

section "EULA"
echo ""
echo ""
eula
echo ""
echo ""

exec "/app/minecraft/bedrock_server"
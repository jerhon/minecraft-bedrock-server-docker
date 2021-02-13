FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl unzip wget && \
    apt-get clean

ENV LD_LIBRARY_PATH /app/minecraft

COPY run-bedrock-server.sh /app/
RUN chmod +x /app/run-bedrock-server.sh

WORKDIR /app/minecraft

# IPv4 Port
EXPOSE 19132
# IPv6 Port
EXPOSE 19133

ENV MINECRAFT_URL https://minecraft.azureedge.net/bin-linux/bedrock-server-1.16.201.03.zip

# Default to just a LAN game
ENV MC_ONLINE_MODE false

ENTRYPOINT [ "/bin/bash", "/app/run-bedrock-server.sh" ]
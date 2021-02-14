# Readme

This is an UNOFFICIAL way to run Minecraft Bedrock Server in Docker.  Read the terms here prior to using it!

https://www.minecraft.net/en-us/download/server/bedrock/

This is a wrapper around a shell script which automates downloading the bedrock server image from a URL, extracts it, can set server properties via environment variables, and runs it.

This is really the same as downloading and running the server yourself, it just automates a few steps and runs the application in a Docker container.

Check out the corresponding ```docker-compose.yaml``` to run this easier on [the GitHub repository](https://github.com/jerhon/minecraft-bedrock-server-docker).

# Usage

## Run

You'll need to get a URL for the Minecraft Bedrock Server download from https://www.minecraft.net/en-us/download/server/bedrock/

Choose the linux version, right click on the download link, and copy the URL for the application.

I suggest using ```docker-compose.yaml``` with the YAML defined in the GitHub repository.

Create a new ```docker-compose.override.yaml``` file that sits by the ```docker-compose.yaml``` file with the following contents.  Paste the link for the minecraft download in the

```
version: "3.8"
services:
  minecraft:
    environment:
      EULA: "true"
      MINECRAFT_URL: "MINECRAFT_URL_GOES_HERE!!!"
```

Once that has been completed, you can run the server via docker-compose.

```
docker-compose up
```

By setting EULA to true, you acknowledge you have read and agree with the Minecraft Bedrock Server EULA.

## Setting Server Options

Most server options from the server.properties file can be specified as an environment variable with the name of

MC_OPTION_NAME

For example, max-players would be set with the environment variable MC_MAX_PLAYERS.
See the server.properties file for the options and specific values that are accepted.

When the docker container starts up, it will display the applied server property values.

# Notes

I intentionally don't include the Minecraft server as part of the docker file.
This is due to the EULA agreement prohibiting redistribution of files.

The goal of this was to set up a simple Minecraft server locally at my house.
We've got a few XBOXes in different rooms, and the kids have tablets that can connect to servers as well.
This way the world is stored and run by my server so anyone could connect at any time from any device in my household.


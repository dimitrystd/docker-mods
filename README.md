# Home Assistant - Docker mod for code-server

This mod adds Home Assistant related add-ons to code-server, to be installed/updated during container start.

In code-server docker arguments, set an environment variable `DOCKER_MODS=linuxserver/mods:code-server-python3|ghcr.io/stecky/mods:code-server-home-assistant`

# How to update and build
I built docker and pushed it manually
```
docker login
docker build --no-cache -t dmitriy/mods:code-server-home-assistant .
docker push dmitriy/mods:code-server-home-assistant
```
Now `compose.yml` looks like
```yaml
...
  vscode:
    image: linuxserver/code-server:3.12.0
    environment:
      - DOCKER_MODS=dmitriy/mods:code-server-home-assistant
      - HOMEASSISTANT_URL=http://server1-us:8123
...
```

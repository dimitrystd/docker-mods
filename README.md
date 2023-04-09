# Home Assistant - Docker mod for code-server

This mod adds Home Assistant related add-ons to code-server, to be installed/updated during container start.

In code-server docker arguments, set an environment variable `DOCKER_MODS=linuxserver/mods:code-server-python3|ghcr.io/stecky/mods:code-server-home-assistant`

# How to update and build
Update versions in `requirements.txt` and `vscode.extensions` files. You can also check for versions in the official hassio addon.
- https://github.com/hassio-addons/addon-vscode/blob/main/vscode/requirements.txt
- https://github.com/hassio-addons/addon-vscode/blob/main/vscode/vscode.extensions

I built docker and pushed it manually
```
cd <repository path>/docker-mods/docker-mods
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

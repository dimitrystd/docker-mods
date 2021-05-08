#!/usr/bin/with-contenv bash
# ==============================================================================
# Code Server with Home Assistant Add-ons
# Sets up code-server.
# ==============================================================================

# List of previous config hashes, to allow upgrade "default" configs.
readonly -a PREVIOUS_DEFAULT_CONFIG_HASHES=(
    86776df88391c3d94f79f62b430f9ff8538960628d5e04fb660165a5a46640d2e74f89cd68b3e6985dc59101ae2dda00a1e25aa48381acfd4736858c5f23878b
    2be4c50575c05711d30121c3a1320698d3dbb034523c481be3aad3b638af3e0a46113d8c3f8cfc1b0f01e4cc10f32da3a30feca161c31b5b27177aeb7231bf70
    d4745002643a0168f65bc5b465a9baff59af0fb4783b50553e1a4e8b3f1a569fc4905df19b7743f7f313a5809a5128d997fc4b5e0a0e5db0a01f47b3b7bec39d
    6ed36f832778926fa614fc12eec97b8f813bbb1a04f709769c9e5f54bc8e3cfc05a110155921a3b2ae47fc8389d24fa2bd385e4ce5a6c94850813791a6ac1c82
    944d9ba57968666353df7e9dc78ec5d94b9b052e1abf863b51bc1f372d9f35cb2d93259f153e9ab3b3dd1b520bfcd7bddb54803bcfd9eb65975ae8fb5553663c
    4ef960e3d6e795adda51d5cbeb18d309fee87ba5cd177292a21b5a70a71a4726ae7053c3793cddc6d63d3b4dacc180ad3ea12d005fc8d63a1bc4cb29f9a17f18
    c5b8acf06ef6d9a2435e9ddb92cb9fce7cfbfe4a2206b0e0c3c4ed514cc926f8d3c662e694a995d102b5ba939056f93201c220558e06e1cd0872bfb1995ba148
    08d86c84a0d80720b22712e878963e90cbb34b659330dad8a823f3c5c7f0ae043d197a5e3020dd7ab4fda3625e17f794675ec074984951e7107db2488898a8d0
    5243d7664d30b5aa0c45fbe1089cccdf85c5ade17cddd97e21b3a29ccb37b20d20bdfecc141ad6e1a7aa5ea8ee61695a79a43140a2d53f9f91687bc61f7e496c
)

# Clean up copies of extensions we deliver from the persistent storage
while read -r ext; do
    extension="${ext%%#*}"
    # shellcheck disable=SC2086
    rm -f -r /config/extensions/${extension,,}*
done < /root/vscode.extensions

# Ensure user extensions folder exists
mkdir -p /config/extensions

# Sets up default user settings on first start.
SETTINGS_FILE=/config/User/settings.json
if [ ! -f "$SETTINGS_FILE" ]; then
    mkdir -p /config/User
    cp /root/.code-server/settings.json ${SETTINGS_FILE}
fi

# Upgrade settings.json is still default from previous version.
current=$(sha512sum ${SETTINGS_FILE}|cut -d " " -f 1)
if [[ " ${PREVIOUS_DEFAULT_CONFIG_HASHES[*]} " == *" ${current} "* ]]; then
    cp /root/.code-server/settings.json ${SETTINGS_FILE}
fi

# Workaround workspace bug for code-server.
# https://github.com/codercom/code-server/issues/121
WORKSPACES_FILE=/config/Backups/workspaces.json
if [ ! -f "$WORKSPACES_FILE" ]; then
    mkdir -p /config/Backups
    cp /root/.code-server/workspaces.json ${WORKSPACES_FILE}
fi

# Workaround workspace bug for code-server (same as above, part 2).
# https://github.com/codercom/code-server/issues/121
WORKSPACE_STORAGE=/config/User/workspaceStorage
if [ ! -d "$WORKSPACE_STORAGE" ]; then
    mkdir -p ${WORKSPACE_STORAGE}
fi
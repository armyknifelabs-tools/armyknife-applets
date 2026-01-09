rootdir := ''
prefix := '/usr'
clean := '0'
debug := '0'
vendor := '0'
target := if debug == '1' { 'debug' } else { 'release' }
vendor_args := if vendor == '1' { '--frozen --offline' } else { '' }
debug_args := if debug == '1' { '' } else { '--release' }
cargo_args := vendor_args + ' ' + debug_args

targetdir := env('CARGO_TARGET_DIR', 'target')
sharedir := rootdir + prefix + '/share'
iconsdir := sharedir + '/icons/hicolor'
prefixdir := prefix + '/bin'
bindir := rootdir + prefixdir
default-schema-target := sharedir / 'cosmic'

armyknife-applets-bin := prefixdir / 'armyknife-applets'

metainfo := 'com.system76.CosmicApplets.metainfo.xml'
metainfo-src := 'data' / metainfo
metainfo-dst := clean(rootdir / prefix) / 'share' / 'metainfo' / metainfo

default: build-release

# Compiles with debug profile
build-debug *args:
    cargo build {{args}}

# Compiles with release profile
build-release *args: (build-debug '--release' args)

# Compile with a vendored tarball
build-vendored *args: vendor-extract (build-release '--frozen --offline' args)

_link_applet name:
    ln -sf {{armyknife-applets-bin}} {{bindir}}/{{name}}

_install_icons name:
    find {{name}}/'data'/'icons' -type f -exec echo {} \; | rev | cut -d'/' -f-3 | rev | xargs -d '\n' -I {} install -Dm0644 {{name}}/'data'/'icons'/{} {{iconsdir}}/{}

_install_default_schema name:
    find {{name}}/'data'/'default_schema' -type f -exec echo {} \; | rev | cut -d'/' -f-3 | rev | xargs -d '\n' -I {} install -Dm0644 {{name}}/'data'/'default_schema'/{} {{default-schema-target}}/{}

_install_desktop path:
    install -Dm0644 {{path}} {{sharedir}}/applications/{{file_name(path)}}

_install_bin name:
    install -Dm0755 {{targetdir}}/{{target}}/{{name}} {{bindir}}/{{name}}

_install_applet id name: (_install_icons name) \
    (_install_desktop name + '/data/' + id + '.desktop') \
    (_link_applet name)

_install_button id name: (_install_icons name) (_install_desktop name + '/data/' + id + '.desktop')

_install_metainfo:
    install -Dm0644 {{metainfo-src}} {{metainfo-dst}}

# Installs files into the system
install: (_install_bin 'armyknife-applets') (_link_applet 'armyknife-panel-button') (_install_applet 'com.system76.CosmicAppList' 'armyknife-app-list') (_install_default_schema 'armyknife-app-list') (_install_applet 'com.system76.CosmicAppletA11y' 'armyknife-applet-a11y') (_install_applet 'com.system76.CosmicAppletAudio' 'armyknife-applet-audio') (_install_applet 'com.system76.CosmicAppletInputSources' 'armyknife-applet-input-sources') (_install_applet 'com.system76.CosmicAppletBattery' 'armyknife-applet-battery') (_install_applet 'com.system76.CosmicAppletBluetooth' 'armyknife-applet-bluetooth') (_install_applet 'com.system76.CosmicAppletMinimize' 'armyknife-applet-minimize') (_install_applet 'com.system76.CosmicAppletNetwork' 'armyknife-applet-network') (_install_applet 'com.system76.CosmicAppletNotifications' 'armyknife-applet-notifications') (_install_applet 'com.system76.CosmicAppletPower' 'armyknife-applet-power') (_install_applet 'com.system76.CosmicAppletStatusArea' 'armyknife-applet-status-area') (_install_applet 'com.system76.CosmicAppletTiling' 'armyknife-applet-tiling') (_install_applet 'com.system76.CosmicAppletTime' 'armyknife-applet-time') (_install_applet 'com.system76.CosmicAppletWorkspaces' 'armyknife-applet-workspaces') (_install_button 'com.system76.CosmicPanelAppButton' 'armyknife-panel-app-button') (_install_button 'com.system76.CosmicPanelLauncherButton' 'armyknife-panel-launcher-button') (_install_button 'com.system76.CosmicPanelWorkspacesButton' 'armyknife-panel-workspaces-button') (_install_metainfo)

# Vendor Cargo dependencies locally
vendor:
    mkdir -p .cargo
    cargo vendor | head -n -1 > .cargo/config
    echo 'directory = "vendor"' >> .cargo/config
    tar pcf vendor.tar vendor
    rm -rf vendor

# Extracts vendored dependencies
[private]
vendor-extract:
    rm -rf vendor
    tar pxf vendor.tar
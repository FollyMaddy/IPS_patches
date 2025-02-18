#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="gsplus-rp-share"
rp_module_desc="Apple II/GS emulator v"
rp_module_help="ROM Extensions: .gsp .txt .GSP .TXT\n\nCopy your Apple II/GS games to $romdir/apple2gs\n\nCopy the required BIOS file ROM.03 or ROM.01 to $biosdir\n\n"
rp_module_section="exp"
rp_module_flags=""

function depends_gsplus-rp-share() {
     getDepends libsdl2-dev libsdl2-image-dev re2c libreadline-dev
}

function sources_gsplus-rp-share() {
    gitPullOrClone "$md_build" https://github.com/digarok/gsplus
}

function build_gsplus-rp-share() {
    cmake .
    make
    md_ret_require="$md_build/bin/GSplus"
}

function install_gsplus-rp-share() {
    md_ret_files=(
    'bin/GSplus'
	'bin/partls'
	'bin/to_pro'
    )
}

function configure_gsplus-rp-share() {
    mkRomDir "apple2gs"
    
    addEmulator 1 "$md_id" "apple2gs" "$md_inst/gsplus.sh %ROM%"
    addSystem "apple2gs" "Apple II/GS" ".gsp .txt .GSP .TXT"

    [[ "$md_mode" == "remove" ]] && return

    ln -sf "$biosdir/apple2gs/ROM.01" "$md_inst/ROM"
    rm "$md_inst/gsplus.sh"
    {
    	echo '#!/usr/bin/env sh'
    	echo '_PWD=$(pwd)'
    	echo 'cd /opt/retropie/emulators/gsplus-rp-share'
    	echo './GSplus -config "$1"'
    	echo 'cd "$_PWD"'
    } >> "$md_inst/gsplus.sh"
    chmod 755 "$md_inst/gsplus.sh"
}
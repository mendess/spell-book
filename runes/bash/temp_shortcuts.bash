#!/bin/bash
l1csf() {
    [ $# -lt 1 ] && {
        echo "provide the report number"
        exit 1
    }
    mkdir -vp ~/projects/csf/lab1/mendess_work_dir/
    cd ~/projects/csf/lab1/mendess_work_dir/ || exit

    mkdir -vp "$1"
    cd "$1" || exit

    firefox "http://localhost:8080/advisory?id=$1"

    pkg_link=$(curl -s http://localhost:8080/advisory?id="$1" |
        grep -Po 'https://registry.npmjs.org/[^"]+')

    [ -e "$1.json" ] || jq ".advisory.id = $1" ~/projects/csf/lab1/1020.json |
        jq ".correct_package_link = \"$pkg_link\"" >"$1".json
    [ -d package ] || {
        wget -nv "$pkg_link"
        tar xzfv ./*tgz
        rm -vf ./*tgz
    }

    mkdir -vp tools
    cd tools || exit
    : >tool_list
    curl -s "http://localhost:8080/advisory?id=$1" |
        grep -oP '/tool_report\?id=[0-9]+&tool=[^"]+' |
        cut -d= -f3 |
        while read -r t; do
            curl -s "http://localhost:8080/tool_report?id=$1&tool=$t" |
                grep -oP '/report\?path=packages/CWE[^"]+' |
                while read -r l; do
                    [ -e "$(basename "$l")" ] && continue
                    wget -nv "http://localhost:8080$l" -O "$(basename "$l")"
                done
            echo "$t" >>tool_list
        done
    cd ..
}

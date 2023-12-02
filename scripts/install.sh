#!/usr/bin/env bash

set -e
source $(dirname $(realpath $0))/../CUSTOM_INFO

# a docker image tag with the format 'name:tag'.
# generated by CUSTOM_INFO above.
# eg: alexlee/test-u:latest
IMGTAG=${USERNAME:-$(id -un)}/${IMGNAME}:${VERSION}

install_prefix=$HOME/.local
[[ ! -d $1 ]] || install_prefix=$(realpath $1)

install_path=${install_prefix}/docker_env

[[ -d $install_path ]] || mkdir -p $install_path

FUNC_NAME=${FUNC_ALIAS:-${ENTRY:-bash}}

install_name=${FUNC_NAME##*/}_${IMGNAME:-"test-u"}_env

install_path=${install_path}/${install_name}

cat <<EOF > ${install_path}
docker_${FUNC_NAME##*/}() {
    docker run \\
        -it \\
        --rm \\
        -u $(id -u) \\
        --entrypoint \${ENTRY:-"${ENTRY}"} \\
        -v /home/\${USERNAME}:/home/\${USERNAME} \\
        -v /media:/media \\
        --hostname ${IMGNAME:-"test-u"} \\
        -w \$(realpath \$(pwd)) \\
        ${IMGTAG} \\
        \$@
    }

PASS=$RANDOM
if [[ "\${BASH_ARGV0##*/}" != "${install_name}" ]]; then
    bash \${BASH_ARGV} \${PASS};
elif [[ "\${BASH_ARGV}" == "\${PASS}" ]]; then
    echo \$(tput bold)\$(tput smul)"command available:"\$(tput sgr0)
    typeset -F | cut -d' ' -f 3 | xargs -i echo \$(tput setaf 2)\$(tput sitm) {}\$(tput sgr0)
else
    echo \$(tput bold)"USAGE:"\$(tput sgr0)
    echo  "\$ "\$(tput sgr0)"source \${BASH_ARGV0}"\$(tput sgr0)
fi
EOF

echo -e "First, exec: \n\
    source $install_path"
echo -e "Then, use: \n\
    [ENTRY=<entry>] docker_${FUNC_NAME##*/} [arg1]..."

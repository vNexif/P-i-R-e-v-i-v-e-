#!/bin/bash


check_if_root(){
if [ "$EUID" -ne 0 ]
    then echo "Please run as sudo"
    exit
 fi
}


usage(){
    echo "Reinstall Your dying system remotely"
    echo "Usage: $0 [-v] $1 [-s] $2 [-u]"
    echo "For detailed herrpo use -h"
    1>&2; exit 1;
}

Help(){
    # Display Help
    echo "Well, It does the thing you could do but why bother."
    echo
    echo "Syntax: [-h|s]"
    echo "Options:"
    echo "h     Print this Help."
    echo "s     Just use it if your internet is unstable."
    echo "u     Go all in."
    #echo "v     Verbose mode."
}

get_sys_req(){
    sysrq=$("cat /proc/sys/kernel/sysrq")
}

set_sys_req(){
    echo 1 > /proc/sys/kernel/sysrq
}

#write_to_memory(){
#
#}

get_rpi_image(){
            dir=./re_pi
            mkdir $dir && cd $dir;
            curl -L http://downloads.raspberrypi.org/raspbian_lite_latest;
}

search_rpi_image(){

    :'
    search_dir=./re_pi

    find ./ -name "*-raspbian-*.zip" -mtime 0
    for entry in "find ./ -name "*-raspbian-*.zip" -mtime 0"

  echo "$entry"
done
'

:'unset -v latest
for file in "$dir"/*; do
  [[ $file -nt $latest ]] && latest=$file
done
'

    image=$(ls -t *-raspbian*.zip | head -1)
    return $image
}

safe_reinstall(){
    check_if_root;
    #Download the latest.
    get_rpi_image;
    #search for it bcs I'm lazy.
    image=$(ls -t *-raspbian*.zip | head -1);
    #dd that boi.
    dd if=$image bs=4M | pv | funzip | dd bs=4M of=/dev/mmcblk0
    #reboot
    echo b > /proc/sysrq-trigger;
}




unsafe_reinstall()){
    check_if_root
    echo "If you lose internet connection, you're screwed :)"
    curl -L http://downloads.raspberrypi.org/raspbian_lite_latest | funzip | dd bs=4M of=/dev/mmcblk0;
    echo b > /proc/sysrq-trigger;
        
}



while getopts "h?su" opt; do
    case "${opt}" in
    h)
        #echo "Invalid Option: -$OPTARG" 1>&2
        Help
        exit 1;
        ;;
    v)  set -v
       ;;
    s) safe_reinstall;
        exit 1;
        ;;
    u) unsafe_reinstall;
        exit 1;
        ;;
    *) 
        usage
        ;;
    \?)
        usage
        ;;
    esac
done

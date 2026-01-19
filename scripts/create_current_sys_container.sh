#!/bin/bash


LOGFILE="/tmp/create_docker.log"
PASSWORD_DOCKER=""
USER_DOCKER=""
NEED_SETTING_DOCKER=false
REPO=""
NAME_CONTAINER=""

CHECK_MARK="\033[0;32m\xE2\x9c\x94\033[0m"
CROSS_MARK="\033[0;31m\xE2\x9c\x97\033[0m"


function usage {
	cat <<EOF
	Usage: $0 [options]
	-r=%repo%			repo settings ( REQUIRED ) Example: -r='deb [trusted=yes] ftp://10.1.6.196/Debian stretch main'
	-n=%name%			name container ( REQUIRED ) Example: -n=linux
	-p=%password docker%		password docker ( OPTIONAL, write without % ) Example: -p=1234
	-u=%user docker%		user docker ( OPTIONAL, write without % ) Example: -u=Vodichenkov.A.D
	-s=%settings%			install docker setting ( OPTIONAL ) Example: -s
	-h=%help%			show help menu ( OPTIONAL ) Example: -h
EOF
}

function check_parameters {
	echo -n "[...] checking parameters script"

	if [[ -z $PASSWORD_DOCKER ]]; then
    	echo -e "\\r[ $CROSS_MARK ] checking parameters script. This script need password docker as parameter"
    	usage
    	exit 1
	fi

	if [[ -z $USER_DOCKER ]]; then
    	echo -e "\\r[ $CROSS_MARK ] checking parameters script. This script need password docker as parameter"
    	usage
    	exit 1
	fi
	
	echo -e "\\r[ $CHECK_MARK ] checking parameters script"
}

function check_root_privilege {
	echo -n "[...] checking root privilege"

  	local USER
  	USER=$( whoami )
  	if [ "$USER" != "root" ]; then
    	echo -e "\\r[ $CROSS_MARK ] checking root privilege. Run this script with root privilege!"
    	exit 1
  	fi
  	
  	echo -e "\\r[ $CHECK_MARK ] checking root privilege"
}

function install_packages {
	echo -n "[...] install dependences"

	apt-get update >> "$LOGFILE" 2>&1
	apt-get install -y debootstrap docker.io >> "$LOGFILE" 2>&1
	
	echo -e "\\r[ $CHECK_MARK ] install dependences"
}

function settings_docker_hub {
	echo -n "[...] install settings docker"

	USER=$(users | awk '{print $1}')
	usermod -a -G docker $USER
	openssl s_client -connect 10.1.2.97:5005 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM | sudo tee /usr/local/share/ca-certificates/97.crt
	update-ca-certificates 
	service docker restart
	
	echo -e "\\r[ $CHECK_MARK ] install settings docker"
}

function docker_login {
	echo -n "[...] install login docker"

	docker login 10.1.2.97:5005 -u="${USER_DOCKER}" -p="${PASSWORD_DOCKER}" >> "$LOGFILE" 2>&1
	
	echo -e "\\r[ $CHECK_MARK ] install login docker"
}

function docker_create {
	echo -n "[...] create docker container"

	target=/tmp/new_container
	cut_repo=$(echo $REPO | sed 's/\[[^]]*\]//g')
	repo=$(echo $cut_repo | awk '{print $2}')
	release=$(echo $cut_repo | awk '{print $3}')
	components=$(echo $cut_repo | awk '{for (i=4;i<=NF;i++) printf (i==4?$i:","$i); print ""}')
	
	if [ -d "$target" ]; then
    		mkdir $target >> "$LOGFILE" 2>&1
    else 
    	rm -rf $target
    	mkdir $target
  	fi

	debootstrap --no-check-gpg --components=$components --arch=amd64 $release "$target" "$repo" >> "$LOGFILE" 2>&1
	
	mount --bind /dev     "$target"/dev
	mount --bind /dev/pts "$target"/dev/pts
	mount --bind /proc    "$target"/proc
	mount --bind /sys     "$target"/sys

	chroot "$target" /bin/bash << EOF
	apt-get remove -y --allow-remove-essential e2fsprogs e2fslibs whiptail kmod iptables iproute2 dmidecode >> "$LOGFILE" 2>&1
	apt-get clean -y >> "$LOGFILE" 2>&1
	find /var/lib/apt/lists/ -maxdepth 2 -type f -delete >> "$LOGFILE" 2>&1
	exit
EOF

	umount "$target"/dev/pts
	umount "$target"/dev
	umount "$target"/proc
	umount "$target"/sys

	rm -rf "$target"/usr/{{lib,share}/locale,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
	rm -rf "$target"/usr/share/{man,doc,info,gnome/help}
	rm -rf "$target"/usr/share/cracklib
	rm -rf "$target"/usr/share/i18n
	rm -rf "$target"/etc/ld.so.cache
	rm -rf "$target"/var/cache/ldconfig/*

	SOURCES_LIST=$(cat /etc/apt/sources.list)
	cat << EOF | tee "$target"/etc/apt/sources.list >> "$LOGFILE" 2>&1
	# local repo
	$SOURCES_LIST
EOF

	pushd "$target" >> "$LOGFILE" 2>&1
	tar -cf ../container.tar *
	pushd /tmp >> "$LOGFILE" 2>&1

	cat container.tar | docker import - $NAME_CONTAINER >> "$LOGFILE" 2>&1

	rm -rf container.tar >> "$LOGFILE" 2>&1
	rm -rf $target >> "$LOGFILE" 2>&1
	
	echo -e "\\r[ $CHECK_MARK ] create docker container"
}


function main {
	check_root_privilege
	
	if [[ -z "$REPO" ]]; then
	  echo "#ERROR: No repository to set!"
	  exit 1
	fi

	if [[ -z "$NAME_CONTAINER" ]]; then
	  echo "#ERROR: No name container!"
	  exit 1
	fi
	
	if [[ $NEED_SETTING_DOCKER == true ]]; then
		check_parameters
	fi
	
	install_packages
	
	if [[ $NEED_SETTING_DOCKER == true ]]; then
		settings_docker_hub
		docker_login
	fi
	
	docker_create
}


for i in "$@"
do
	case $i in
		-h|--help)
    	usage
    	exit 0
    	;;
    		-r=*|--repo=*)
    	REPO="${i#*=}"
			;;
			-n=*|--name=*)
    	NAME_CONTAINER="${i#*=}"
			;;
			-p=*|--password=*)
    	PASSWORD_DOCKER="${i#*=}"
			;;
			-u=*|--user=*)
    	USER_DOCKER="${i#*=}"
			;;
			-s|--settings)
    	NEED_SETTING_DOCKER=true
			;;
    	*)
    	usage
    	exit 1
    	;;
	esac
done


main

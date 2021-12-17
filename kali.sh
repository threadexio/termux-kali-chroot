#!/data/data/com.termux/files/usr/bin/bash

#
# $1 - command
# $2 - location of the rootfs
#

rootfs="${2:-rootfs}"

declare -A rmount
declare -A mount

info() {
	printf '\e[1;36m[*]\e[0m %s\n' "$@"
}

fatal() {
	printf '\e[0;31m[x]\e[0m %s\n' "$@"
	exit
}

if [ "$(id -u)" -ne 0 ]; then
	fatal "Run me as root!"
fi

if [ -r "./settings.sh" ]; then
	. "./settings.sh"
else
	fatal "Cannot read ./settings.sh"
fi

if [ ! -d "$rootfs" ]; then
	fatal "Cannot find rootfs in $rootfs"
fi

_rmount_() {
	info "rmounting ${rmount[$1]} to $rootfs/$1"
	mount --rbind "${rmount[$1]}" "$rootfs/$1"
}

_mount_() {
	local src
	local fstype

	src="$(echo "${mount[$1]}" | cut -d: -f1)"
	fstype="$(echo "${mount[$1]}" | cut -d: -f2)"

	info "mounting ${src} of type ${fstype} to $rootfs/$1"

	if [ -z "$fstype" ]; then
		mount "$src" "$rootfs/$1"
	else
		mount -t "$fstype" "$src" "$rootfs/$1"
	fi
}

check_if_mounted() {
	if mount | grep "$1 " >/dev/null; then
		return 0
	else
		return 1
	fi
}

mount_all() {
	for m in "${!rmount[@]}"; do
		check_if_mounted "$rootfs/$m" || _rmount_ "$m"
	done

	for m in "${!mount[@]}"; do
		check_if_mounted "$rootfs/$m" || _mount_ "$m"
	done
}

unmount_all() {
	for m in "${!rmount[@]}"; do
		check_if_mounted "$rootfs/$m" && (
			info "unmounting $rootfs/$m"
			umount "$rootfs/$m"
		)
	done

	for m in "${!mount[@]}"; do
		check_if_mounted "$rootfs/$m" && (
			info "unmounting $rootfs/$m"
			umount "$rootfs/$m"
		)
	done
}

enter_kali() {

	# Ensure everything is mounted correctly
	mount_all

	env -i chroot "$rootfs" bin/bash -l
}

case "$1" in
start)
	mount_all
	;;

stop)
	unmount_all
	;;
*)
	enter_kali
	;;
esac

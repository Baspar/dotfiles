#!/usr/bin/env bash

cfg_tmpdir="/run/user/$UID/i3lock-extra"
cfg_lockfile="$cfg_tmpdir/locked"
cfg_pixelize_scale='10'

err() { echo "$*" >&2; }

usage() {
	while read; do printf '%s\n' "$REPLY"; done <<- EOF
		Usage: i3lock-extra <-m mode> [args]
		Flags:
		       --mode|-m <mode>    # Lock mode.
		       --tmpdir|-d <path>  # Directory to store temporary files in. This should not be accessible by other users!
		       --pixelize-scape|-p # For the pixelize mode only. Sets the number by which the image is resized down and
		                             back up to achieve the pixelize effect. For example, 4 means that it will be resized
		                             to 1/4 of the original and blown back up.
		Modes:
		       rnd <dir>           # Use a random image from a dir.
		       blur [img]          # Take a screenshot, blur it out. If provided, add an image on top.
		       pixelize [img]      # Same as the abobe, but pixelize the image instead.
		       img <img>           # Use the provided image.
	EOF
}

random() {
	images_dir=$1

	images=( "$images_dir"/* )
	images_c="${#images[*]}"
	image_r=$(( RANDOM % images_c ))
	image="${images[$image_r]}"

	printf '%s' "$image"
}

deskshot() {
	declare scale_down scale_up
	declare dist_mode=$1; shift

	case "$dist_mode" in
		blur) scrot -e "convert -gaussian-blur 4x8 \$f ${cfg_tmpdir}/lockbg.png" "${cfg_tmpdir}/lockbg.png";;
		pixelize)
			scale_down=$(( 100/cfg_pixelize_scale ))
			scale_up=$(( ( 100/cfg_pixelize_scale ) * cfg_pixelize_scale * cfg_pixelize_scale ))

			scrot -e "convert \$f -scale "$scale_down"% -scale "$scale_up"% ${cfg_tmpdir}/lockbg.png" "${cfg_tmpdir}/lockbg.png"
		;;
	esac

	if [[ "$1" ]]; then
		convert -gravity center -composite -matte "${cfg_tmpdir}/lockbg.png" "$1" "${cfg_tmpdir}/lockbg.png"
	fi
	
	image="${cfg_tmpdir}/lockbg.png"
	printf '%s' "$image"
}

lock() {
	>"$cfg_lockfile"
	i3lock -n -t -i "$image"
}

cleanup() {
	rm -f "$cfg_lockfile";
}

main() {
	umask 0077 # All files and dirs created should only be accessible by the user.

	while (( $# )); do
		case "$1" in
			--help|-h) usage; return 0;;
			--mode|-m) mode=$2; shift;;
			--tmpdir|-d) cfg_tmpdir=$2; shift;;
			--umask|-u) umask $2; shift;;
			--pixelize-scale|-p) cfg_pixelize_scale=$2; shift;;

			--) shift; break;;
			-*)
				err "Unknown key: $1"
				usage
				return 1
			;;

			*) break;;
		esac
		shift
	done

	if ! [[ -d "$cfg_tmpdir" ]]; then
		mkdir -p "$cfg_tmpdir" || {
			return 1
		}
	fi

	case "${mode:-img}" in
		blur|pixelize) image=$( deskshot "$mode" "$1" );;

		rnd)
			(( $# )) || { usage; return 1; }
			image=$( random "$1" )
		;;

		img)
			(( $# )) || { usage; return 1; }
			image="$1"
		;;

		*) usage; return 1;;
	esac

	trap cleanup INT TERM EXIT
	
	until lock; do
		true
	done
}

main "$@"

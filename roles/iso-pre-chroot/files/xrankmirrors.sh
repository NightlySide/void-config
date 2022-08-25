#!/usr/bin/env -S bash
## credits to https://paste.sh/1QS8Tgf6#aHTfRy1dOG4rcA5x_6kauwq3

pkg=current/xbps-0.59.1_6.x86_64.xbps
file="${XDG_CACHE_HOME:-$HOME/.cache}/${0##*/}-results"

mirrormsg() { printf '%s\n' "getting mirrors from void-docs..." ; }

get() {
	rm "$file"
	while read -r syntax mirror _ loc; do
		case $syntax in
			\|)
				case $mirror in
					Repository) ;;
					*)
						mirror="${mirror#<}"
						mirror="${mirror%>}"
						loc="${loc% |}"
						loc="${loc%%,*}" 
						[ -n "${REGION}" ] && {
							[ "${REGION}" = get ] && printf '%s\n' "$loc" && continue 
							[ ! "${loc%%:*}" = "${REGION}" ] && continue
						} 
						printf '%s\n' "$mirror"
						dlspeed="$(curl -Y 1048576 -# -w "%{speed_download}" "$mirror/$pkg" -o/dev/null)"
						connect=$(printf "%.2fs" "$(curl --connect-timeout 2 -sw "%{time_appconnect}" "$mirror" -o/dev/null)")
						echo "${mirror},${loc},${dlspeed},${connect}" >> "$file"
					;;
				esac
			;;
		esac
	done <<< "$(curl -# https://raw.githubusercontent.com/void-linux/void-docs/master/src/xbps/repositories/mirrors/index.md)"
	#echo "finished writing results of mirrors to $file"
}

format() {
	sort -t, -nrk3 < "$file" | numfmt -d , --field 3 --to=iec-i --suffix=B/s | sed '1s/^/mirror,location,dlspeed,connect\n/' | column -s, -t
}

case "$1" in
	-g) mirrormsg && get ;;
	-f) format ;;
	-r) REGION="$2"; mirrormsg && get ;;
	-p) REGION="get"; mirrormsg && get | sed '1s/^/region: location\n/' | column -s: -t ;;
	*) cat <<EOF 
usage: ${0##*/} [-g] [-f]
  -g   get results and write to file
  -f   format results file 
  -r   get results from specific region if available
  -p   print available regions and locations

file: $file
EOF
esac
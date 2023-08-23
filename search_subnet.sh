#!/bin/bash
PREFIX="${1:-NOT_SET}"
INTERFACE="$2"
SUBNET_1="${3:-NOT_SET}"
HOST_1="${4:-NOT_SET}"

trap 'echo "Ping exit, (Ctrl+C) pressed!"; exit 1' 2

username=$(id -nu)
if [[ "$username" != "root" ]]; then
	echo "Permission dennied! Use sudo... exit."
	exit 1
fi

[[ "$PREFIX" = "NOT_SET" ]] && { echo "\$PREFIX must be passed as first positional argument"; exit 1; }
if [[ -z "$INTERFACE" ]]; then
	echo "\$INTERFACE must be passed as second positional argument"
	exit 1
fi
if ! [[ $PREFIX =~ ^([0-9]{1,3}\.)([0-9]{1,3})$ ]]; then
	echo "Prefix: $PREFIX is not valid! Exit..."
	exit 1
fi

if [[ "$SUBNET_1" = "NOT_SET" ]] && [[ "$HOST_1" = "NOT_SET" ]]; then
	for SUBNET in {1..255}
	do
		for HOST in {1..255}
		do
			echo "[*] IP : ${PREFIX}.${SUBNET}.${HOST}"
			arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET}.${HOST}"
		done
	done
elif [[ "$SUBNET_1" != "NOT_SET" ]] && [[ "$HOST_1" = "NOT_SET" ]]; then
	if ! [[ $SUBNET_1 =~ ^[0-9]{1,3}$ ]]; then
		echo "Subnet: $SUBNET_1 is not valid! Exit..."
		exit 1
	fi
	for HOST in {1..255}
	do
		echo "[*] IP : ${PREFIX}.${SUBNET_1}.${HOST}"
		arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET_1}.${HOST}"
	done
else
	if ! [[ $SUBNET_1 =~ ^[0-9]{1,3}$ ]]; then
		echo "Subnet: $SUBNET_1 is not valid! Exit..."; exit 1;
	fi
	if ! [[ $HOST_1 =~ ^[0-9]{1,3}$ ]]; then
		echo "Host: $HOST_1 is not valid! Exit..."; exit 1;
	fi
	echo "[*] IP : ${PREFIX}.${SUBNET_1}.${HOST_1}"
	arping -c 3 -i "$INTERFACE" "${PREFIX}.${SUBNET_1}.${HOST_1}"
fi

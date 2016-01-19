#!/usr/bin/env bash

if [ -z "$HOME" ]; then
	HOME="~"
fi

PER_USER_SSH_CONFIG_DIR="$HOME/.ssh"
SESSION_KEYS_DIR="$PER_USER_SSH_CONFIG_DIR/host_keys"

echo "================================================================================"
echo "=== SSH Key Generation and Configuration ======================================="
echo "================================================================================"

# TODO: Check does session name or host name exist in SSH config file
# Read Session Name
ERROR_COUNTER=0
until [ ! -z "$host" ]; do
	if [ $ERROR_COUNTER -eq 1 ]; then
		echo "ERROR: Hostname patterns cannot be empty. Please re-enter."
		echo "--------------------------------------------------------------------------------"
	fi;
	echo "HOST pattern matcher. It can be wildcard IP or Hostname (See more: man ssh_config.)."
	echo "Enter HOST pattern, followed by [ENTER]:"
	read host 
	ERROR_COUNTER=1
done
echo "--------------------------------------------------------------------------------"

# Read Host Name
ERROR_COUNTER=0
until [ ! -z "$host_name" ]; do
	if [ $ERROR_COUNTER -eq 1 ]; then
		echo "ERROR: Host Name cannot be empty. Please re-enter."
		echo "--------------------------------------------------------------------------------"
	fi;
	echo "Enter Host name, followed by [ENTER]:"
	read host_name
	ERROR_COUNTER=1
done
echo "--------------------------------------------------------------------------------"

# Read Port number for Host

ALL_CONDITION_PASS=0
until [ $ALL_CONDITION_PASS -eq 1 ]; do

	echo "Enter Port number for $host_name(empty for default: 22), followed by [ENTER]:"
	read host_port 

	if [ -z "$host_port" ]; then
		host_port=22
		ALL_CONDITION_PASS=1
	else
		# Check does host port is integer value
		if [ $host_port -eq $host_port 2>/dev/null ]; then
			if [ "$host_port" -gt 0 ] && [ "$host_port" -lt 65536 ]; then
				ALL_CONDITION_PASS=1
			else
				echo "ERROR: Port number should be in range 0 and 65536. Please re-enter."
				echo "--------------------------------------------------------------------------------"
			fi
		else
			echo "ERROR: Port number for host should be integer value. Please re-enter."
			echo "--------------------------------------------------------------------------------"
		fi
	fi;
done
echo "--------------------------------------------------------------------------------"

# Read User name
ERROR_COUNTER=0
until [ ! -z "$user_name" ]; do
	if [ $ERROR_COUNTER -eq 1 ]; then
		echo "ERROR: User Name cannot be empty. Please re-enter."
		echo "--------------------------------------------------------------------------------"
	fi;
	echo "Enter User name, followed by [ENTER]:"
	read user_name
	ERROR_COUNTER=1
done
echo "--------------------------------------------------------------------------------"

# Reading User password for host
# ERROR_COUNTER=0
# until [ ! -z "$user_password_try_01" ] && [ ! -z "$user_password_try_02" ] && [ "$user_password_try_01" == "$user_password_try_02" ]; do
# 	if [ $ERROR_COUNTER -eq 1 ]; then
# 		echo "ERROR: Incorrect or empty value in password. Please re-enter."
# 		echo "--------------------------------------------------------------------------------"
# 	fi;
# 	echo "Enter User Password, followed by [ENTER]:"
# 	read -s user_password_try_01
# 	echo "Re-enter User Password, followed by [ENTER]:"
# 	read -s user_password_try_02
# 	ERROR_COUNTER=1
# done
# user_password=$user_password_try_01
# echo "--------------------------------------------------------------------------------"

# Read User e-mail 
ERROR_COUNTER=0
until [ ! -z "$user_email" ]; do
	if [ $ERROR_COUNTER -eq 1 ]; then
		echo "ERROR: User E-mail cannot be empty. Please re-enter."
		echo "--------------------------------------------------------------------------------"
	fi;
	echo "Enter User e-mail, followed by [ENTER]:"
	read user_email
	ERROR_COUNTER=1
done

CURRENT_SESSION_KEY_DIR="$SESSION_KEYS_DIR/$host_name"

mkdir -p $CURRENT_SESSION_KEY_DIR
cd $CURRENT_SESSION_KEY_DIR


KEY_FILE_NAME="id_rsa_$host_name"
KEY_FILE_PATH="$CURRENT_SESSION_KEY_DIR/$KEY_FILE_NAME"

echo "--------------------------------------------------------------------------------"
echo "--- SSH KEY GENERATION. KEY LENGTH 4096 ----------------------------------------"
echo "--------------------------------------------------------------------------------"
ssh-keygen -b 4096 -f $KEY_FILE_PATH -C user_email -o -a 500

cd $PER_USER_SSH_CONFIG_DIR
cat << EOF >> ./config
# SSH keys for session: $host_name
HOST $host
	HostName $host_name
	Port $host_port
	User $user_name
	IdentityFile $KEY_FILE_PATH

EOF

# if xclip installed copy public key contents to system clipboard
! command -v $1 >/dev/null 2>&1 || { 
	echo "--------------------------------------------------------------------------------"
	echo "--- COPY SSH PUBLIC KEY TO SYSTEM CLIPBOARD ------------------------------------"
	echo "--------------------------------------------------------------------------------"
	PUBLIC_KEY_FILE_PATH="$KEY_FILE_PATH.pub"
	xclip -sel clip < $PUBLIC_KEY_FILE_PATH 
}


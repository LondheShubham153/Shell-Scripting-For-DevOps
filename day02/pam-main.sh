#/bin/bash
# Date: 10/09/2025
# This is script for user & group management in linux.
# Usage: pam-main.sh
# Author: Bhikesh Khute
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m' 
CYAN='\033[0;36m'
NC='\033[0m'
echo "------------------------------------------------------"
echo -e "=======\033[45m Welcome to Login Management System \033[0m======="
echo "------------------------------------------------------"
while true; do
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root (sudo)."; exit 1
fi
while true; do
echo -e "${RED}1. Add user${NC}"
echo -e "${GREEN}2. Delete user${NC}"
echo -e "${PURPLE}3. Modify user - Add user to multiple groups${NC}"
echo -e "${CYAN}4. Modify user - Changing Login Shell${NC}"
echo -e "${YELLOW}5. Modify user - Disable Login${NC}"
echo -e "${GREEN}6. Modify user - Enable Login${NC}"
echo -e "${CYAN}7. Modify user - Add user to sudo group${NC}"
echo -e "${RED}8. Add group${NC}"
echo -e "${GREEN}9. Backup directories${NC}"
echo -e "${PURPLE}10. Exit${NC}"
read -p "Select the option: " choice
case $choice in 
	1) 
	read -rp "Enter first and last name of the user(Example - Ramesh Sippy): " fullname #Example - Ramesh Sippy
	username="$(awk '{print tolower($1 $2)}' <<<"$fullname")"
	if id -u "$username" >/dev/null 2>&1; then
	  echo "User '$username' already exists."; echo "-----------------------------------------------"; unset username; break
	fi
	if useradd -c "$fullname" -m -s /bin/bash "$username" >/dev/null 2>&1; then
	  randpass="$(openssl rand -base64 14 2>/dev/null || tr -dc 'A-Za-z0-9!@#%+=' </dev/urandom | head -c16)"
	  printf '%s:%s\n' "$username" "$randpass" | chpasswd
	  passwd --expire "$username" >/dev/null
	  echo "$username created. Temporary password: $randpass (will be forced to change on first login)"
	else
	  echo "Failed to create user '$username'."
	fi
	echo "-----------------------------------------------"
	unset username
	unset randpass
	;;
        2)
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". "
	read -r -p "Select user NUMBER to be deleted: " choice
	username="$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")"
	if [[ -z "${username:-}" ]]; then echo "Invalid selection."; else
	  if [[ "$username" == "$USER" ]]; then echo "Refusing to delete the current user '$USER'."; else
	    read -r -p "Type the username '$username' to confirm deletion: " confirm
	    if [[ "$confirm" == "$username" ]]; then
	      if userdel -r "$username" >/dev/null 2>&1; then
	        echo "$username deleted."
	      else
	        echo "Failed to delete '$username'."
	      fi
	    else
	      echo "Confirmation mismatch. Aborting."
	    fi
	  fi
	fi
	echo "-------------------------------------------------"
	unset username
	unset choice
	;;
	3)
	echo "------------------Normal Users List------------------"
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	echo "------------------Group List-------------------------"
        getent group | awk -F: '{print $1}' | nl -w1 -s". "
	read -p "Select the existing user NUMBER: " choice
	read -p "Select the group NUMBER to be added: " gchoice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	grpname=$(awk -F: '$3 >= 1000 {print $1}' /etc/group | sed -n "${gchoice}p")
        if [[ -n "${username:-}" && -n "${grpname:-}" ]]; then
	  usermod -aG "$grpname" "$username" && echo "$username added to group $grpname"
	else
	  echo "Invalid selection."
	fi
	echo "-------------------------------------------------"
	unset grpname
	unset username
	unset choice
	unset gchoice
	;;
        4)
	echo "------------------Normal Users List------------------"
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	read -p "Select the existing username: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	curr_shell=$(getent passwd "$username" | cut -d: -f7)
	if [ "$curr_shell" = "/bin/sh" ]; then
		    chsh -s /bin/bash "$username"
		    echo "$username's shell is successfully changed to bash"
		    echo "-------------------------------------------------"
	elif [ "$curr_shell" = "/bin/bash" ]; then
		    chsh -s /bin/sh "$username"
		    echo "$username's shell is successfully changed to sh"
		    echo "-----------------------------------------------"
	fi
	unset username
	unset curr_shell
	unset choice
	;;
        5)
	echo "------------------Normal Users List------------------"
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	read -p "Select the existing username: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	if getent passwd "$username" > /dev/null; then
		nologin_path="$(command -v nologin || echo /sbin/nologin)"
		echo "Changing $username shell to $nologin_path"
		usermod -s "$nologin_path" "$username"
		echo "$username's login disabled."
		echo "-------------------------------"
	else
		echo "User $username not found!"
	fi
	unset username
	unset choice
	unset nologin_path
	;;
        6)
        echo "------------------Normal Users List------------------"
        awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
        read -p "Select the existing user: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
        if getent passwd "$username" > /dev/null; then
                echo "Changing $username shell to /bin/bash"
                chsh -s /bin/bash "$username"
		echo "$username's shell is successfully activated to bash"
		echo "---------------------------------------------------"
        else
                echo "User $username not found!"
	fi
	unset username
	unset choice
        ;;
        7)
	echo "------------------Normal Users List------------------"
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	read -p "Enter the existing username: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	admin_group="$(getent group sudo >/dev/null 2>&1 && echo sudo || echo wheel)"
	usermod -aG "$admin_group" "$username"
	echo "$username added to $admin_group group."
	echo "----------------------------------------------------------------------"
	unset username
	unset choice
	unset admin_group
	;;
        8)
	read -r -p "Enter the group name to be added: " grpname
	if getent group "$grpname" >/dev/null 2>&1; then
	  echo "Group '$grpname' already exists."
	elif groupadd "$grpname" >/dev/null 2>&1; then
	  echo "--------------------$grpname added.------------------"
	else
	  echo "Failed to add group '$grpname'."
	fi
	;;
        9)
	mkdir -p /opt/dir_backups
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". "
	read -r -p "Select the user NUMBER to associate with the backup: " choice
	username="$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")"
	read -r -p "Specify the absolute path of the directory to be backed up: " dirback
	if [[ -d "$dirback" ]]; then
	  ts="$(date +%F_%H-%M-%S)"
	  tar -czf "/opt/dir_backups/${username}_$ts.tar.gz" -C "$dirback" . >/dev/null 2>&1 && \
	    echo "Backup completed successfully" || echo "Backup failed"
	else
	  echo "Directory '$dirback' not found."
	fi
	echo "-----------------------------"
	unset username
	unset dirback
	unset choice
	unset ts
	;;	
        10)
	break;
	;;
        *)
	echo "Invalid option. Try again."
	;;
esac
done

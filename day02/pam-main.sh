#/bin/bash
#!/usr/bin/bash
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
	read -p "Enter first and last name of the user(Example - Ramesh Sippy): " fullname #Example - Ramesh Sippy
	username=`echo $fullname | awk '{print tolower($1 $2)}'` #Output - rameshsippy
	useradd -c "$fullname" -m -s /bin/bash $username > /dev/null #Redirects output to blackhole instead of screen
	echo $username:R@nd0mDig!t | chpasswd #Adding Default Password; To be changed after login for security reasons.
	passwd --expire $username > /dev/null #Password is expired so that on first login itself it can be changed.
	echo "$username is successfully created in the system"
	echo "-----------------------------------------------"
	unset username
	;;
        2)
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	read -p "Select user to be deleted: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	deluser --remove-home -q $username
	echo "$username is successfully deleted from the system"
	echo "-------------------------------------------------"
	unset username
	unset choice
	;;
	3)
	echo "------------------Normal Users List------------------"
	awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
	echo "------------------Group List-------------------------"
        awk -F: '$3 >= 1000 {print $1}' /etc/group | nl -w1 -s". "
	read -p "Select the existing user: " choice
	read -p "Select the group name to be added: " gchoice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	grpname=$(awk -F: '$3 >= 1000 {print $1}' /etc/group | sed -n "${gchoice}p")
        usermod -aG $grpname $username
	echo "$username is successfully added to group $grpname"
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
		echo "Changing $username shell to /usr/sbin/nologin"
		chsh -s /usr/sbin/nologin "$username"
		echo "$username's disabled to nologin"
		echo "-------------------------------"
	else
		echo "User $username not found!"
	fi
	unset username
	unset choice
	;;
        6)
        echo "------------------Normal Users List------------------"
        awk -F: '$3 >= 1000 {print $1}' /etc/passwd | nl -w1 -s". " #Filtering only normal users
        read -p "Select the existing username: " choice
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
	usermod -aG sudo $username
	echo "$username is successfully added to sudo group. Enjoy super-privileges!"
	echo "----------------------------------------------------------------------"
	unset username
	unset choice
	;;
        8)
        read -p "Enter the group name to be added: " grpname
        addgroup $grpname > /dev/null
	echo "--------------------$grpname is added in the system.------------------"
	echo " "
	;;
        9)
        mkdir -p /opt/dir_backups
	read -p "Select the username to intiate the backup: " choice
	username=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd | sed -n "${choice}p")
	read -p "Specify the path of the directory to be backuped up: " dirback
	tar -cvzf /opt/dir_backups/$username.tar.gz $dirback > /dev/null
	echo "Backup completed successfully"
	echo "-----------------------------"
	unset username
	unset dirback
	unset choice
	;;	
        10)
	break;
	;;
        *)
	echo "Invalid option! Exiting the program"
esac
done

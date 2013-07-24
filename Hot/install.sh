#!/bin/bash

function acpi_call {
	pacman -Q acpi_call-git > /dev/null 2>&1
	if [ $? -eq 0  ]
	then
		sudo modprobe acpi_call
	else		
		sudo yaourt -S acpi_call-git
		sudo modprobe acpi_call
	fi
	echo "acpi_call kernel module addes ;)"
	echo "------------------"
	run_acpi
}

function AddStart {
	echo 'Add this script to startup? (y/n)'
        read answer
 
        while [[ x$answer != xy && x$answer != xn ]]
        do
                echo you have entered an invalid response. Please type y or n: 
                read answer
        done
	if [ x$answer == xy ]
	then
		echo -e "$STARTUP \nif [ \$? -eq 0 ] \nthen  \n\techo Off on \`date\` |sudo tee -a /var/log/vgaoff.log  > /dev/null 2>&1 \nelse \n\techo Error on \`date\`| sudo tee -a /var/log/vgaoff.err  > /dev/null 2>&1\nfi"  | sudo tee /etc/profile.d/hot.sh > /dev/null 2>&1
	fi 
}

function run_acpi {
	echo on or off?
	read answer

	while [[ x$answer != xon && x$answer != xoff ]]
	do
		echo you have entered an invalid response. Please type on or off: 
		read answer
	done
	PS3='Please enter your choice: '
	options=("Dell" "Asus" "Other" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Dell")
            sudo /usr/share/acpi_call/dellL702X.sh $answer
	    STARTUP="sudo /usr/share/acpi_call/dellL702X.sh $answer"
	    AddStart $STARTUP
	    exit
            ;;
        "Asus")
            sudo /usr/share/acpi_call/asus1215n.sh $answer
	    STARTUP="sudo /usr/share/acpi_call/asus1215n.sh $answer"
	    AddStart $STARTUP
	    exit
            ;;
        "Other")
            sudo /usr/share/acpi_call/turn_off_gpu.sh
	    echo "READ : http://forum.ubuntu.ir/index.php/topic,28512.msg195027.html#msg195027"
	    exit
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
}

# View Your VGA
echo "Your VGA's : "
lspci | grep VGA --color
echo "------------------"

# Check for yaourt is installed? :D
pacman -Q yaourt > /dev/null 2>&1

if [ $? -eq 0  ]
then
	acpi_call
else
	echo "Pleas install yaourt!"
	echo "See : https://wiki.archlinux.org/index.php/Yaourt"
	exit
fi

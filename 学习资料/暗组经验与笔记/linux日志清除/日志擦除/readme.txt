Linux日志橡皮擦
================

Linux日志橡皮擦是一个bash脚本，删除几乎所有的日志，从日志文件在Linux机器上。
这可能是有用的攻击消灭了注销前的Linux机器受损的痕迹。


用法
=====
$ 0选项

选项??：
-H	显示此消息
-i [IP地址] 	搜索前20个IP记录在日志文件中的所有日志文件和搜索一个特定的ip地址
-d [IP地址]	从日志文件中删除的ip地址
-s [spoof_ip_address]	Spoof the IP following -d with the one following -s wherever deletion is not possible
-u [USER_NAME]		其日志的用户名要擦除或者欺骗
-w [web_shell_path]	网页后门（如C99）外壳绝对路径，你想抹去日志
-F	他妈的日志文件，要完全清除所有的日志文件，虽然不推荐
-E	“文件扩展名”要找到其他种植系统的后门
-R [web_root_directory]	网站根目录开始搜索的后门

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



Customizing the script while executing for the first time on target:
====================================================================

	1. Upload both, the linux_log_eraser.sh and log_files.sh on target server
	2. Fire the linux_log_eraser script. Take care that you must be root (either UID=0 or EUID=0) to execute the script
	3. Use parameter -i, and pass the IP address you are worried about in log files:
	  ./linux_log_eraser -i 192.168.1.1
	4. The above command will scan all the log files for that particular IP and will let you know all the log files having trace of that IP
	5. Open up log_files.sh file. Cross check which log file, reported in step 4, is not in the list. Do add the log file/files
	6. Running the step 3 command would also let you know the top 20 IP's in the log files having most occurrences
	7. Choose any suitable IP from the top 20 IP's as a spoof IP.....and you are ready to  proceed with other options of script



Logic:
======

Some log files are Ascii types, hence can be read and edited easily. Rest log files are binary types and are hard to read and edit directly.

For ascii files, all the lines in various log files containing either of the following would be deleted:
	1. The IP following -d parameter
	2. User name following -u parameter (if it is other than root). Since the user 'root' has many entries, so to remain stealty it's
	   better not to delete such lines.
	3. Web shell path of your backdoor following -w parameter.

For binary files, all the entries for your IP and user name (if it is other than root) would be spoofed (not deleted)
IP would be spoofed to the Spoof IP provided and user name would be spoofed to "root"

Pass the following to script:
	1. The IP which you wish to delete/spoof in log files
	2. The spoof IP. This would be the IP to replace the IP in binary log files
	3. The user name you wish to delete/spoof in log files
	4. Absolute web shell path to erase it's entries from log files (e.g. the web back doors)

For spoofing in binary files, better analyze the files manually first and choose a good IP and user name

You can do the following for binary file analysis:
For wtmp:
	#last				(shows: username, terminal, IP)
	#strings /var/log/wtmp		(shows: username, terminal, IP)

For utmp:
	#who				(shows: username, terminal, IP)
	#strings /var/run/utmp		(shows: username, terminal, IP)

For lastlog:
	#lastlog			(shows: username, terminal, IP)
	#strings /var/log/lastlog	(shows: terminal, IP)

For btmp (if exists):
	#lastb				(shows: username)
	#strings /var/log/btmp		(shows: username)

Correct me if the logic is wrong at any place except for "/var/log/lastlog"

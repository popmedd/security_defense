# All log files are commented for safety. 
# Since they are the most genic ones, do uncomment all of them

#######################
# Declaration of two arrays containing the absolute path of log files. Add in more path per your requirements
# Since declared outside any function, they are global
# declare -r makes our array read-only and could not be altered anywhere in the code following the declaration
#######################

# Those logs files which keep entries for IP address, web path accessed etc. Basically the ASCII log files.
declare -r ascii_log_files=(
			#'/var/log/syslog'
			#'/var/log/messages'
			#'/var/log/httpd/access_log'
			#'/var/log/httpd/error_log'
			#'/var/log/xferlog'
			#'/var/log/secure'
			#'/var/log/auth.log'
			#'/var/log/user.log'
			
			# Check syslog.conf for more log files
			# Enter more log files here
			)

# Those logs files which keep user activity logs. Basically the non-ASCII log files.
declare -r binary_log_files=(
			#'/var/log/wtmp'
			#'/var/log/lastlog'
			#'/var/log/btmp'
			#'/var/run/utmp'
			# Enter more log files here
			)

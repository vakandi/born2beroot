#!/bin/bash

# Set the number of allowed authentication attempts
sudo_attempt_limit=3

# Set the custom error message to display on incorrect password
sudo_error_message="Incorrect password. Please try again."

# Set the path to the log file
sudo_log_file="/var/log/sudo/sudo.log"

# Enable TTY mode
Defaults requiretty

# Restrict paths that can be used by sudo
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Configure sudo to log commands and output to the log file
Defaults logfile="$sudo_log_file"
Defaults log_input
Defaults log_output

# Configure sudo to limit authentication attempts and display a custom error message
Defaults passwd_tries=$sudo_attempt_limit
Defaults badpass_message="$sudo_error_message"


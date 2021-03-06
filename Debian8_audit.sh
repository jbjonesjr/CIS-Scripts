#!/bin/bash
#Debian 8 Audit Script
#Developed and Modified By jbjonesjr for use against Debian 8 benchmark v 1.0
#Last Update Data : 27 January, 2017
# Use following command to run this scipt
# chmod +x Debian8_audit.sh
# ./Debian8_audit.sh



echo "Debian8 Audit Started"
echo "=================================================================================="

echo "    *************** 1 Patching & Software Updates *****************"



echo "=================================================================================="
echo "    *************** 2 Filesystem Configuration *****************"

echo "2.1 Create Separate Partition for /tmp"
grep "[[:space:]]/tmp[[:space:]]" /etc/fstab

echo "=================================================================================="
echo "2.2 Set nodev option for /tmp Partition"
grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nodev
echo "--"
mount | grep "[[:space:]]/tmp[[:space:]]" | grep nodev


echo "=================================================================================="
echo "2.3 Set nosuid option for /tmp Partition"
grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep nosuid
echo "--"
mount | grep "[[:space:]]/tmp[[:space:]]" | grep nosuid


echo "=================================================================================="
echo "2.4 Set noexec option for /tmp Partition"
grep "[[:space:]]/tmp[[:space:]]" /etc/fstab | grep noexec
echo "--"
mount | grep "[[:space:]]/tmp[[:space:]]" | grep noexec


echo "=================================================================================="
echo "2.5 Create Separate Partition for /var"
grep "[[:space:]]/var[[:space:]]" /etc/fstab


echo "=================================================================================="
echo "2.6 Bind Mount the /var/tmp directory to /tmp"
grep -e "^/tmp[[:space:]]" /etc/fstab | grep /var/tmp
mount | grep -e "^/tmp[[:space:]]" | grep /var/tmp


echo "=================================================================================="
echo "2.7 Create Separate Partition for /var/log"
grep "[[:space:]]/var/log[[:space:]]" /etc/fstab

echo "=================================================================================="
echo "2.8 Create Separate Partition for /var/log/audit"
grep "[[:space:]]/var/log/audit[[:space:]]" /etc/fstab


echo "=================================================================================="
echo "2.9 Create Separate Partition for /home"
grep "[[:space:]]/home[[:space:]]" /etc/fstab

echo "=================================================================================="
echo "2.10 Add nodev Option to /home"
grep "[[:space:]]/home[[:space:]]" /etc/fstab
mount | grep /home

echo "=================================================================================="
echo "2.11 Add nodev Option to Removable Media Partitions"
echo "grep <each removable media mountpoint> /etc/fstab"
echo "work on it "

echo "=================================================================================="
echo "2.12 Add noexec Option to Removable Media Partitions"
echo "grep <each removable media mountpoint> /etc/fstab"
echo "work on it "

echo "=================================================================================="
echo "2.13 Add nosuid Option to Removable Media Partitions"
echo "grep <each removable media mountpoint> /etc/fstab"
echo "work on it "


echo "=================================================================================="
echo "2.14 Add nodev Option to /run/shm Partition"
grep /run/shm /etc/fstab | grep nodev
echo '--'
mount | grep /run/shm | grep nodev

echo "=================================================================================="
echo "2.15 Add nosuid Option to /run/shm Partition"
grep /run/shm /etc/fstab | grep nosuid
mount | grep /run/shm | grep nosuid

echo "=================================================================================="
echo "2.16 Add noexec Option to /run/shm Partition"
grep /run/shm /etc/fstab | grep noexec
mount | grep /run/shm | grep noexec

echo "=================================================================================="
echo "2.17 Set Sticky Bit on All World-Writable Directories"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null

echo "=================================================================================="
echo "2.18 Disable Mounting of cramfs Filesystems"
/sbin/modprobe -n -v cramfs
echo "--"
/sbin/lsmod | grep cramfs


echo "=================================================================================="
echo "2.19 Disable Mounting of freevxfs Filesystems"
/sbin/modprobe -n -v freevxfs
echo "--"
/sbin/lsmod | grep freevxfs


echo "=================================================================================="
echo "2.20 Disable Mounting of jffs2 Filesystems"
/sbin/modprobe -n -v jffs2
echo "--"
/sbin/lsmod | grep jffs2


echo "=================================================================================="
echo "2.21 Disable Mounting of hfs Filesystems"
/sbin/modprobe -n -v hfs
echo "--"

/sbin/lsmod | grep hfs

echo "=================================================================================="
echo "2.22 Disable Mounting of hfsplus Filesystems"
/sbin/modprobe -n -v hfsplus
echo "--"
/sbin/lsmod | grep hfsplus

echo "=================================================================================="
echo "2.23 Disable Mounting of squashfs Filesystems"
/sbin/modprobe -n -v squashfs
echo "--"
/sbin/lsmod | grep squashfs

echo "=================================================================================="
echo "2.24 Disable Mounting of udf Filesystems"
/sbin/modprobe -n -v udf
echo "--"
/sbin/lsmod | grep udf

echo "=================================================================================="
echo "2.25 Disable Automounting"
ls /etc/rc*.d | grep autofs

echo "=================================================================================="
echo "    *************** 3 Secure Boot Settings *****************"

echo "3.1 Set User/Group Owner on bootloader config"
stat -c "%u %g" /boot/grub/grub.cfg | egrep "^0 0"

echo "=================================================================================="
echo "3.2 Set Permissions on bootloader config"
stat -L -c "%a" /boot/grub/grub.cfg | egrep ".00"


echo "=================================================================================="
echo "3.3 Set Boot Loader Password"
grep "^set superusers" /boot/grub/grub.cfg
echo "--"
grep "^password" /boot/grub/grub.cfg

echo "=================================================================================="
echo "3.4 Require Authentication for Single-User Mode"
grep ^root:[*\!]: /etc/shadow


echo "=================================================================================="
echo "    *************** 4 Additional Process Hardening *****************"

echo "4.1 Restrict Core Dumps"
grep "hard core" /etc/security/limits.conf
echo "--"
/sbin/sysctl fs.suid dumpable



echo "=================================================================================="
echo "4.2 Enable XD/NX Support on 32-bit x86 Systems"
dmesg | grep NX

echo "=================================================================================="
echo "4.3 Enable Randomized Virtual Memory Region"
/sbin/sysctl kernel.randomize_va_space

echo "=================================================================================="
echo "4.4 Disable Prelink"
dpkg -s prelink

echo "=================================================================================="
echo "4.5 Activate AppArmor"
apparmor_status

echo "=================================================================================="
echo "    *************** 5 OS Services *****************"
echo "    *************** 5.1 Ensure Legacy Services are Not Enabled *****************"

echo "5.1.1 Ensure NIS is not installed"
dpkg -s nis

echo "=================================================================================="
echo "5.1.2 Ensure rsh server is not enabled"
grep ^shell /etc/inetd.conf
grep ^login /etc/inetd.conf
grep ^exec /etc/inetd.conf

echo "=================================================================================="
echo "5.1.3 Ensure rsh client is not installed"
dpkg -s rsh-client
dpkg -s rsh-redone-client

echo "=================================================================================="
echo "5.1.4 Ensure talk server is not enabled"
grep ^talk /etc/inetd.conf
grep ^ntalk /etc/inetd.conf

echo "=================================================================================="
echo "5.1.5 Ensure talk client is not installed"
dpkg -s talk

echo "=================================================================================="
echo "5.1.6 Ensure telnet server is not enabled"
grep ^telnet /etc/inetd.conf

echo "=================================================================================="
echo "5.1.7 Ensure tftp-server is not enabled"
grep ^tftp /etc/inetd.conf

echo "=================================================================================="
echo "5.1.8 Ensure xinetd is not enabled"
ls /etc/rc*.d | grep xinetd

echo "=================================================================================="
echo "5.2 Ensure chargen is not enabled"
grep ^chargen /etc/inetd.conf

echo "=================================================================================="
echo "5.3 Ensure daytime is not enabled"
grep ^daytime /etc/inetd.conf

echo "=================================================================================="
echo "5.4 Ensure echo is not enabled"
grep ^echo /etc/inetd.conf

echo "=================================================================================="
echo "5.5 Ensure discard is not enabled"
grep ^discard /etc/inetd.conf

echo "=================================================================================="
echo "5.6 Ensure time is not enabled"
grep ^time /etc/inetd.conf


echo "=================================================================================="
echo "    *************** 6 Special Purpose Services *****************"

echo "=================================================================================="
echo "6.1 Ensure the X Window System is not installed"
dpkg -l xserver-xorg-core*

echo "=================================================================================="
echo "6.2 Ensure Avahi Server is not enabled"
systemctl is-enabled avahi-daemon

echo "=================================================================================="
echo "6.3 Ensure Print Server is not enabled"
systemctl is-enabled cups

echo "=================================================================================="
echo "6.4 Ensure DHCP Server is not enabled"
ls /etc/rc*.d | grep isc-dhcp-server

echo "=================================================================================="
echo "6.5 Configure Network Time Protocol (NTP)"
dpkg -s ntp
grep "restrict .* default" /etc/ntp.conf
grep "^server" /etc/ntp.conf
grep "RUNASUSER=ntp" /etc/init.d/ntp

echo "=================================================================================="
echo "6.6 Ensure LDAP is not enabled"
dkpg -s slapd

echo "=================================================================================="
echo "6.7 Ensure NFS and RPC are not enabled"
ls /etc/rc*.d | grep rpcbind
ls /etc/rc*.d | grep nfs-kernel-server

echo "=================================================================================="
echo "6.8 Ensure DNS Server is not enabled"
/sbin/sysctl is-enabled bind9

echo "=================================================================================="
echo "6.9 Ensure FTP Server is not enabled"
/sbin/sysctl is-enabled vsftpd

echo "=================================================================================="
echo "6.10 Ensure HTTP Server is not enabled"
/sbin/sysctl is-enabled apache2

echo "=================================================================================="
echo "6.11 Ensure IMAP and POP server is not enabled"
/sbin/sysctl is-enabled dovecot


echo "=================================================================================="
echo "6.12 Ensure Samba is not enabled"
ls /etc/rc*.d | grep smbd

echo "=================================================================================="
echo "6.13 Ensure HTTP Proxy Server is not enabled"
ls /etc/rc*.d | grep squid3

echo "=================================================================================="
echo "6.14 Ensure SNMP Proxy Server is not enabled"
ls /etc/rc*.d | grep snmpd


echo "=================================================================================="
echo "6.15 Configure Mail Transer Agent for Loacl-Only Mode"
netstan -an | grep LIST | grep ":24[[:space:]]"

echo "=================================================================================="
echo "6.16 Ensure rsync service is not enabled"
dkpg -s rsync
echo "--"
grep ^RSYNC_ENABLE /etc/default/rsync


echo "=================================================================================="
echo "    *************** 7 Network Configuration and Firewalls *****************"
echo "    *************** 7.1 Modify Network Parameters (Host) *****************"

 "=================================================================================="
echo "7.1.1 Disable IP Forwarding"
/sbin/sysctl net.ipv4.ip_forward

echo "=================================================================================="
echo "7.1.2 Disable Send Packet Redirects"
/sbin/sysctl net.ipv4.conf.all.send_redirects
echo "--"
/sbin/sysctl net.ipv4.conf.default.send_redirects

echo "=================================================================================="

echo "    *************** 7.2 Modify Network Parameters (Host and Router) *****************"

echo "7.2.1 Disable Source Routed Packet Acceptance"
/sbin/sysctl net.ipv4.conf.all.accept_source_route
echo "--"
/sbin/sysctl net.ipv4.conf.default.accept_source_route

echo "=================================================================================="

echo "7.2.2 Disable ICMP Redirect Acceptance"
/sbin/sysctl net.ipv4.conf.all.accept_redirects
echo "--"
/sbin/sysctl net.ipv4.conf.default.accept_redirects

echo "=================================================================================="
echo "7.2.3 Disable Secure ICMP Redirect Acceptance"
/sbin/sysctl net.ipv4.conf.all.secure_redirects
echo "--"
/sbin/sysctl net.ipv4.conf.default.secure_redirects

echo "=================================================================================="
echo "7.2.4 Log Suspicious Packets"
/sbin/sysctl net.ipv4.conf.all.log_martians
echo "--"
/sbin/sysctl net.ipv4.conf.default.log_martians

echo "=================================================================================="

echo "7.2.5 Enable Ignore Broadcast Requests"
/sbin/sysctl net.ipv4.icmp_echo_ignore_broadcasts

echo "=================================================================================="
echo "7.2.6 Enable Bad Error Message Protection"
/sbin/sysctl net.ipv4.icmp_ignore_bogus_error_responses

echo "=================================================================================="
echo "7.2.7 Enable RFC-recommended Source Route Validation"
/sbin/sysctl net.ipv4.conf.all.rp_filter
echo "--"
/sbin/sysctl net.ipv4.conf.default.rp_filter

echo "=================================================================================="
echo "7.2.8 Enable TCP SYN Cookies"
/sbin/sysctl net.ipv4.tcp_syncookies

echo "=================================================================================="

echo "    *************** 7.3 Configure IPv6 *****************"
echo "7.3.1 Disable IPv6 Router Advertisements"
/sbin/sysctl net.ipv6.conf.all.accept_ra
echo "--"
/sbin/sysctl net.ipv6.conf.default.accept_ra

echo "=================================================================================="
echo "7.3.2 Disable IPv6 Redirect Acceptance"
/sbin/sysctl net.ipv6.conf.all.accept_redirects
echo "--"
/sbin/sysctl net.ipv6.conf.default.accept_redirects

echo "=================================================================================="
echo "7.3.3 Disable IPv6"
ip addr | grep inet6

echo "=================================================================================="
echo "    *************** 7.4 Install TCP Wrappers *****************"

echo "7.4.1 Install TCP Wrappers"
dpkg -a tcpd

echo "=================================================================================="
echo "7.4.2 Create /etc/hosts.allow"
cat /etc/hosts.allow

echo "=================================================================================="
echo "7.4.3 Verify Permissions on /etc/hosts.allow"
/bin/ls -l /etc/hosts.allow

echo "=================================================================================="
echo "7.4.4 Create /etc/hosts.deny"
grep "ALL: ALL" /etc/hosts.deny

echo "=================================================================================="
echo "7.4.5 Verify Permissions on /etc/hosts.deny"
/bin/ls -l /etc/hosts.deny

echo "=================================================================================="

echo "    *************** 7.5 Uncommon Network Protocols *****************"

echo "7.5.1 Disable DCCP"
grep "install dccp /bin/true" /etc/modprobe.d/CIS.conf

echo "=================================================================================="
echo "7.5.2 Disable SCTP"
grep "install sctp /bin/true" /etc/modprobe.d/CIS.conf

echo "=================================================================================="
echo "7.5.3 Disable RDS"
grep "install rds /bin/true" /etc/modprobe.d/CIS.conf

echo "=================================================================================="
echo "7.5.4 Disable TIPC"
grep "install tipc /bin/true" /etc/modprobe.d/CIS.conf

echo "=================================================================================="
echo "7.6 Deactivate Wireless Interfaces"
ifconfig -a

echo "=================================================================================="
echo "7.7 Ensure Firewall is Active"
dpkg -a iptables
echo "--"
dpkg -a iptables-persistent

echo "=================================================================================="
echo "    *************** 8 Logging and Auditing *****************"
echo "    *************** 8.1 Configuring System Accounting *****************"
echo "    *************** 8.1.1 Configure Data Retention *****************"
echo "8.1.1.1 Configure Audit Log Storage Size"
grep max_log_file /etc/audit/auditd.conf

echo "=================================================================================="
echo "8.1.1.2 Disable System on Audit Log Full"
grep space_left_action /etc/audit/auditd.conf
echo "--"
grep mail_action_acct /etc/audit/auditd.conf
echo "--"
grep admin_space_left_action /etc/audit/auditd.conf

echo "=================================================================================="
echo "8.1.1.3 Keep All Auditing Information"
grep max_log_file_action /etc/audit/auditd.conf

echo "=================================================================================="
echo "8.1.2 Install and Enable auditd Service"
dpkg -a auditd
echo "--"
systemctl is-enabled auditd

echo "=================================================================================="
echo "8.1.3 Enable Auditing for Processes That Start Prior to auditd"
grep "linux" /boot/grub/grub.cfg

echo "=================================================================================="
echo "8.1.4 Record Events That Modify Date and Time Information"
grep time-change /etc/audit/audit.rules

echo "=================================================================================="
echo "8.1.5 Record Events That Modify User/Group Information"
grep identity /etc/audit/audit.rules


echo "=================================================================================="
echo "8.1.6 Record Events That Modify the System's Network Environment"
grep system-locale /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.7 Record Events That Modify the System's Mandatory Access Controls"
grep MAC-policy /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.8 Collect Login and Logout Events "
grep logins /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.9 Collect Session Initiation Information"
grep session /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.10 Collect Discretionary Access Control Permission Modification Events"
grep perm_mod /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.11 Collect Unsuccessful Unauthorized Access Attempts to Files"
grep access /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.12 Collect Use of Priviledged Commands"
echo "This needs to be manual. Use find to identify setuid/setguid programs, confirm they appear in the audit file"

echo "=================================================================================="

echo "8.1.13 Collect Successful File System Mounts "
grep mounts /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.14 Collect File Deletion Events by User"
grep delete /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.15 Collect Changes to System Administration Scope"
grep scope /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.16 Collect System Administrator Actions (sudolog)"
grep actions /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.17 Collect Kernel Module Loading and Unloading"
grep modules /etc/audit/audit.rules

echo "=================================================================================="

echo "8.1.18 Make the Audit Configuration Immutable"
tail -n 1 /etc/audit/audit.rules
echo "=================================================================================="
echo "    *************** 8.2 Configuring rsyslog *****************"
echo "8.2.1 Install the rsyslog package"
dpkg -s rsyslog

echo "=================================================================================="
echo "8.2.2 Ensure the rsyslog Service is activated"
/sbin/systemctl is-enabled rsyslog

echo "=================================================================================="
echo "8.2.3 Configure /etc/rsyslog.conf"
ls -l /var/log/

echo "=================================================================================="
echo "8.2.4 Create and Set Permissions on rsyslog Log Files"
echo "For each <logfile> listed in the /etc/rsyslog.conf file, perform the following command and verify that the <owner>:<group> is root:root and the permissions are 0600 (for sites that have not implemented a secure group) and root:securegrp with permissions of 0640 \nls -l <logfile>"
echo "Work on it"

echo "=================================================================================="

echo "8.2.5 Configure rsyslog to Send Logs to a Remote Log Host"
grep "^*.*[^I][^I]*@" /etc/rsyslog.conf

echo "=================================================================================="
echo "8.2.6 Accept Remote rsyslog Messages Only on Designated Log Hosts"
grep '$ModLoad imtcp.so' /etc/rsyslog.conf
echo "--"
grep '$InputTCPServerRun' /etc/rsyslog.conf

echo "=================================================================================="

echo "    *************** 8.3 Advanced Intrusion Detection Envionrment (AIDE) *****************"
echo "8.3.1 Install AIDE"
dpkg -s aide

echo "=================================================================================="

echo "8.3.2 Implement Periodic Execution of File Integrity"
contrab -u root -l | grep aide

echo "=================================================================================="

echo "8.4 Configure logrotate"
dpkg -s aide

echo "=================================================================================="
echo "*************** 5.3 Configure logrotate *****************"
grep '{' /etc/logrotate.d/rsyslog

echo "=================================================================================="

echo ">>>>> 9 System Access, Authentication and Authorization <<<<< "
echo "*************** 9.1 Configure cron *****************"

echo "=================================================================================="
echo "9.1.1 Enable cron Daemon"
systemctl is-enabled crond
echo "--"
systemctl is-enabled anacron

echo "=================================================================================="
echo "9.1.2 Set User/Group Owner and Permission on /etc/crontab"
stat -c "%a %u %g" /etc/crontab | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.3 Set User/Group Owner and Permission on /etc/cron.hourly"
stat -c "%a %u %g" /etc/cron.hourly | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.4 Set User/Group Owner and Permission on /etc/cron.daily"
stat -c "%a %u %g" /etc/cron.daily | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.5 Set User/Group Owner and Permission on /etc/cron.weekly"
stat -c "%a %u %g" /etc/cron.weekly | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.6 Set User/Group Owner and Permission on /etc/cron.monthly"
stat -c "%a %u %g" /etc/cron.monthly | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.7 Set User/Group Owner and Permission on /etc/cron.d"
stat -c "%a %u %g" /etc/cron.d | egrep ".00 0 0"

echo "=================================================================================="
echo "9.1.8 Restrict at/cron to Authorized Users"
ls -l /etc/cron.deny
echo "--"
ls -l /etc/at.deny
echo "--"
ls -l /etc/cron.allow
echo "--"
ls -l /etc/at.allow

echo "=================================================================================="
echo "*************** 9.2 Configure PAM *****************"

echo "9.2.1 Set Password Creation Requirement Parameters Using pam_cracklib"
dpkg -s libpam-cracklib
echo "--"
grep pam_cracklib.so /etc/pam.d/common-password

echo "=================================================================================="
echo "9.2.2 Set Lockout for Failed Password Attempts"
grep "pam_tally2" /etc/pam.d/login

echo "=================================================================================="
echo "9.2.3 Limit Password Reuse"
grep "remember" /etc/pam.d/common-password

echo "=================================================================================="

echo "*************** 9.3 Configure SSH *****************"
echo "9.3.1 Set SSH Protocol to 2"
grep "^Protocol" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.2 Set LogLevel to INFO"
grep "^LogLevel" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.3 Set Permissions on /etc/ssh/sshd_config"
/bin/ls -l /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.4 Disable SSH X11 Forwarding"
grep "^X11Forwarding" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.5 Set SSH MaxAuthTries to 4 or Less"
grep "^MaxAuthTries" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.6 Set SSH IgnoreRhosts to Yes"
grep "^HostbasedAuthentication" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.7 Set SSH HostbasedAuthentication to No"
grep "^HostbasedAuthentication" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.8 Disable SSH Root Login"
grep "^PermitRootLogin" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.9 Set SSH PermitEmptyPasswords to No"
grep "^PermitEmptyPasswords" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.10 Do Not Allow Users to Set Environment Options"
grep PermitUserEnvironment /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.11 Use Only Approved Cipher in Counter Mode"
grep "Ciphers" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.12 Set Idle Timeout Interval for User Login"
grep "^ClientAliveInterval" /etc/ssh/sshd_config
echo "--"
grep "^ClientAliveCountMax" /etc/ssh/sshd_config

echo "=================================================================================="
echo "6.2.13 Limit Access via SSH"
grep "^AllowUsers" /etc/ssh/sshd_config
echo "--"
grep "^AllowGroups" /etc/ssh/sshd_config
echo "--"
grep "^DenyUsers" /etc/ssh/sshd_config
echo "--"
grep "^DenyGroups" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.3.14 Set SSH Banner"
grep -i "^Banner" /etc/ssh/sshd_config

echo "=================================================================================="
echo "9.4 Restrict root Login to System Console"
cat /etc/securetty

echo "=================================================================================="
echo "9.4 Restrict Access to the su Command"
grep pam_wheel.so /etc/pam.d/su
echo "--"
grep wheel /etc/group

echo "=================================================================================="

echo "*************** 10 User Accounts and Environment *****************"
echo "*************** 10.1 Set Shadow Password Suite Parameters (/etc/login.defs) *****************"

echo "10.1.1 Set Password Expiration Days"
grep PASS_MAX_DAYS /etc/login.defs
echo "work on it chage --list <user>"

echo "=================================================================================="
echo "10.1.2 Set Password Change Minimum Number of Days"
grep PASS_MIN_DAYS /etc/login.defs
echo "work on it chage --list <user> "

echo "=================================================================================="
echo "10.1.3 Set Password Expiring Warning Days"
grep PASS_WARN_AGE /etc/login.defs
echo "work on it chage --list <user>"

echo "=================================================================================="
echo "10.2  Disable System Accounts"
egrep -v "^\+" /etc/passwd | awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/sbin/nologin" && $7!="/sbin/false") {print}'

echo "=================================================================================="
echo "10.3 Set Default Group for root Account"
grep "^root:" /etc/passwd | cut -f4 -d:

echo "=================================================================================="
echo "10.4 Set Default umask for Users"
grep "^umask 077" /etc/bash.bashrc
echo "--"
grep "^umask 077" /etc/profile.d/*

echo "=================================================================================="
echo "10.5 Lock Inactive User Accounts"
useradd -D | grep INACTIVE

echo "=================================================================================="
echo "*************** 11 Warning Banners *****************"

echo "11.1 Set Warning Banner for Standard Login Services"
/bin/ls -l /etc/motd
echo "--"
ls /etc/issue
echo "--"
ls /etc/issue.net

echo "=================================================================================="
echo "11.2 Remove OS Information from Login Warning Banners"
egrep '(\\v|\\r|\\m|\\s)' /etc/issue
echo "--"
egrep '(\\v|\\r|\\m|\\s)' /etc/motd
echo "--"
egrep '(\\v|\\r|\\m|\\s)' /etc/issue.net

echo "=================================================================================="
echo "11.3 Set Graphical Warning Banner"
grep banner-message /etc/gdm3/greeter.dconf-defaults

echo "=================================================================================="
echo "*************** 12 Verify System File Permissions *****************"

echo "12.1 Verify Permissions on /et/passwd"
/bin/ls -l /etc/passwd

echo "=================================================================================="
echo "12.2 Verify Permissions on /etc/shadow"
/bin/ls -l /etc/shadow

echo "=================================================================================="
echo "12.3 Verify Permissions on /etc/group"
/bin/ls -l /etc/group

echo "=================================================================================="
echo "12.4 Verify User/Group Ownership on /etc/passwd"
/bin/ls -l /etc/passwd

echo "=================================================================================="
echo "12.5 Verify User/Group Ownership on /etc/shadow"
/bin/ls -l /etc/shadow

echo "=================================================================================="
echo "12.6 Verify User/Group Ownership on /etc/group"
/bin/ls -l /etc/group

echo "=================================================================================="
echo "12.7 Find World Writable Files"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -0002 -print

echo "=================================================================================="
echo "12.8 Find Un-owned Files and Directories"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nouser -ls

echo "=================================================================================="
echo "12.9 Find Un-grouped Files and Directories"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -nogroup -ls

echo "=================================================================================="
echo "12.10 Find SUID System Executables"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -4000 -print

echo "=================================================================================="
echo "12.11 Find SGID System Executables"
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' -xdev -type f -perm -2000 -print

echo "=================================================================================="
echo "*************** 13 Review User and Group Settings *****************"

echo "13.1 Ensure Password Fields are Not Empty"
/bin/cat /etc/shadow | /usr/bin/awk -F: '($2 == "" ) { print $1 " does not have a password "}'

echo "=================================================================================="
echo "13.2 Verify No Legacy "+" Entries Exist in /etc/passwd File"
/bin/grep '^+:' /etc/passwd

echo "=================================================================================="
echo "13.3 Verify No Legacy "+" Entries Exist in /etc/shadow File"
/bin/grep '^+:' /etc/shadow

echo "=================================================================================="
echo "13.4 Verify No Legacy "+" Entries Exist in /etc/group File"
/bin/grep '^+:' /etc/group

echo "=================================================================================="
echo "13.5 Verify No UID 0 Accounts Exist Other Than root"
/bin/cat /etc/passwd | /usr/bin/awk -F: '($3 == 0) { print $1 }'

echo "=================================================================================="
echo "13.6 Ensure root PATH Integrity"
if [ "`echo $PATH | /bin/grep :: `" != "" ]; then
echo "Empty Directory in PATH (::)"
fi
if [ "`echo $PATH | /bin/grep :$`" != "" ]; then
echo "Trailing : in PATH"
fi

p=`echo $PATH | /bin/sed -e 's/::/:/' -e 's/:$//' -e 's/:/ /g'`
set -- $p
while [ "$1" != "" ]; do
if [ "$1" = "." ]; then
echo "PATH contains ."
shift
continue
fi
if [ -d $1 ]; then
dirperm=`/bin/ls -ldH $1 | /usr/bin/cut -f1 -d" "`
if [ `echo $dirperm | /usr/bin/cut -c6 ` != "-" ]; then
echo "Group Write permission set on directory $1"
fi
if [ `echo $dirperm | /usr/bin/cut -c9 ` != "-" ]; then
echo "Other Write permission set on directory $1"
fi
dirown=`ls -ldH $1 | awk '{print $3}'`
if [ "$dirown" != "root" ] ; then
echo "$1 is not owned by root"
fi
else
echo "$1 is not a directory"
fi
shift
done

echo "=================================================================================="

echo "13.7 Check Permissions on User Home Directories"
for dir in `/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' |/usr/bin/awk -F: '($8 == "PS" && $7 != "/sbin/nologin") { print $6 }'`; do
dirperm=`/bin/ls -ld $dir | /usr/bin/cut -f1 -d" "`
if [ `echo $dirperm | /usr/bin/cut -c6 ` != "-" ]; then
echo "Group Write permission set on directory $dir"
fi
if [ `echo $dirperm | /usr/bin/cut -c8 ` != "-" ]; then
echo "Other Read permission set on directory $dir"
fi
if [ `echo $dirperm | /usr/bin/cut -c9 ` != "-" ]; then
echo "Other Write permission set on directory $dir"
fi
if [ `echo $dirperm | /usr/bin/cut -c10 ` != "-" ]; then
echo "Other Execute permission set on directory $dir"
fi
done

echo "=================================================================================="
echo "13.8 Check User Dot File Permissions"
for dir in `/bin/cat /etc/passwd | /bin/egrep -v '(root|sync|halt|shutdown)' | /usr/bin/awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
for file in $dir/.[A-Za-z0-9]*; do
if [ ! -h "$file" -a -f "$file" ]; then
fileperm=`/bin/ls -ld $file | /usr/bin/cut -f1 -d" "`
if [ `echo $fileperm | /usr/bin/cut -c6 ` != "-" ]; then
echo "Group Write permission set on file $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c9 ` != "-" ]; then
echo "Other Write permission set on file $file"
fi
fi
done
done

echo "=================================================================================="
echo "13.9 Check Permissions on User .netrc Files"

for dir in `/bin/cat /etc/passwd | /bin/egrep -v '(root|sync|halt|shutdown)' |/usr/bin/awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
for file in $dir/.netrc; do
if [ ! -h "$file" -a -f "$file" ]; then
fileperm=`/bin/ls -ld $file | /usr/bin/cut -f1 -d" "`
if [ `echo $fileperm | /usr/bin/cut -c5 ` != "-" ]
then
echo "Group Read set on $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c6 ` != "-" ]
then
echo "Group Write set on $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c7 ` != "-" ]
then
echo "Group Execute set on $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c8 ` != "-" ]
then
echo "Other Read set on $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c9 ` != "-" ]
then
echo "Other Write set on $file"
fi
if [ `echo $fileperm | /usr/bin/cut -c10 ` != "-" ]
then
echo "Other Execute set on $file"
fi
fi
done
done

echo "=================================================================================="
echo "13.10 Check for Presence of User .rhosts Files"

for dir in `/bin/cat /etc/passwd | /bin/egrep -v '(root|halt|sync|shutdown)' |/usr/bin/awk -F: '($7 != "/sbin/nologin") { print $6 }'`; do
for file in $dir/.rhosts; do
if [ ! -h "$file" -a -f "$file" ]; then
echo ".rhosts file in $dir"
fi
done
done

echo "=================================================================================="
echo "13.11 Check Groups in /etc/passwd"

for i in $(cut -s -d: -f4 /etc/passwd | sort -u ); do
grep -q -P "^.*?:x:$i:" /etc/group
if [ $? -ne 0 ]; then
echo "Group $i is referenced by /etc/passwd but does not exist in /etc/group"
fi
done

echo "=================================================================================="
echo "13.12 Check That Users Are Assigned Valid Home Directories"
cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
if [ $uid -ge 1000 -a ! -d "$dir" -a $user != "nfsnobody" ]; then
echo "The home directory ($dir) of user $user does not exist."
fi
done

echo "=================================================================================="
echo "13.13 Check User Home Directory Ownership"

cat /etc/passwd | awk -F: '{ print $1 " " $3 " " $6 }' | while read user uid dir; do
if [ $uid -ge 1000 -a -d "$dir" -a $user != "nfsnobody" ]; then
owner=$(stat -L -c "%U" "$dir")
if [ "$owner" != "$user" ]; then
echo "The home directory ($dir) of user $user is owned by $owner."
fi
fi
done

echo "=================================================================================="
echo "13.14 Check for Duplicate UIDs"

echo "The Output for the Audit of Control 13.14- Check for Duplicate UIDs is"
/bin/cat /etc/passwd | /usr/bin/cut -f3 -d":" | /usr/bin/sort -n | /usr/bin/uniq -c |while read x ; do [ -z "${x}" ] && break
set - $x
if [ $1 -gt 1 ]; then
users=`/usr/bin/awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | /usr/bin/xargs`
echo "Duplicate UID ($2): ${users}"
fi
done

echo "=================================================================================="
echo "13.15 Check for Duplicate GIDs"

echo "The Output for the Audit of Control 9.2.15 - Check for Duplicate GIDs is"
/bin/cat /etc/group | /usr/bin/cut -f3 -d":" | /usr/bin/sort -n | /usr/bin/uniq -c |while read x ; do [ -z "${x}" ] && break
set - $x
if [ $1 -gt 1 ]; then
grps=`/usr/bin/awk -F: '($3 == n) { print $1 }' n=$2 /etc/group | xargs`
echo "Duplicate GID ($2): ${grps}"
fi
done

echo "=================================================================================="

echo "13.16 Check for Duplicate User Names"
echo "The Output for the Audit of Control 9.2.18 - Check for Duplicate User Names is"
cat /etc/passwd | /usr/bin/cut -f1 -d":" | /usr/bin/sort -n | /usr/bin/uniq -c | while read x ; do
  [ -z "${x}" ] && break
  set - $x
  if [ $1 -gt 1 ]; then
    uids=`/usr/bin/awk -F: '($1 == n) { print $3 }' n=$2 /etc/passwd | xargs`
    echo "Duplicate User Name ($2): ${uids}"
  fi
done

echo "=================================================================================="
echo "13.17 Check for Duplicate Group Names"
echo "The Output for the Audit of Control 9.2.19 - Check for Duplicate Group Names is"
cat /etc/group | cut -f1 -d":" | /usr/bin/sort -n | /usr/bin/uniq -c | while read x ; do [ -z "${x}" ] && break
set - $x
if [ $1 -gt 1 ]; then
gids=`/usr/bin/awk -F: '($1 == n) { print $3 }' n=$2 /etc/group | xargs`
echo "Duplicate Group Name ($2): ${gids}"
fi
done

echo "=================================================================================="
echo "13.18 Check for Presence of User .netrc Files"
echo "----"
for dir in `/bin/cat /etc/passwd |/usr/bin/awk -F: '{ print $6 }'`; do
if [ ! -h "$dir/.netrc" -a -f "$dir/.netrc" ]; then
echo ".netrc file $dir/.netrc exists"
fi
done

echo "=================================================================================="
echo "13.19 Check for Presence of User .forward Files"
for dir in `/bin/cat /etc/passwd |/usr/bin/awk -F: '{ print $6 }'`; do
if [ ! -h "$dir/.forward" -a -f "$dir/.forward" ]; then
echo ".forward file $dir/.forward exists"
fi
done
echo "=================================================================================="
echo "13.20 Ensure shadow group is empty"s
grep ^shadow /etc/group
echo "Auditing is Completed"

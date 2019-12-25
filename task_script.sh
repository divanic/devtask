#! /bin/bash

# checking if apt is available
while [[ $(ps aux | grep -i apt | wc -l) != 1 ]] ; do 
	echo 'apt locked.'
	sleep 3 
	ps aux | grep -i apt | wc -l 
done
echo -e 'start script.\n'

timezone=Europe
city=Moscow
res=$(timedatectl | grep " Time zone" | awk '{print $3}')
#checking current time zone
echo 'changing tzone.'
if [[ "$res" == $timezone/$city ]]; then
	echo -e 'already set.\n'
else
#first remove softling, then create new
	unlink /etc/localtime
	ln -s /usr/share/zoneinfo/$timezone/$city /etc/localtime
	echo -e 'set.\n'
fi

echo -e 'show ssh port.\n'
#checking sshd listening port
res=$(netstat -nltp4 | grep sshd | awk '{print $4}' | cut -d : -f 2)
echo $res

user=xxx
#may conflict if already exist user with username that starts with $user
#should use awk with delimeter prolly

res=$(cat /etc/passwd | grep "$user")
if [[ -z $res ]]; then
	echo -e 'creating.\n'
#using openssl to encrypt password (xxx123) with default crypt
	useradd -m -p $(openssl passwd xxx123) -s /bin/bash $user
	usermod -aG sudo $user  
#allowing new user execute /bin/systemctl witout password on all host only as himself
	echo "$user	ALL=NOPASSWD:/bin/systemctl" >> /etc/sudoers
else 
	echo -e 'user exist.\n'
fi

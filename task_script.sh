#! /bin/bash
while [[ $(ps aux | grep -i apt | wc -l) != 1 ]] ; do 
	echo 'apt locked.'
	sleep 3 
	ps aux | grep -i apt | wc -l 
done


echo -e 'start script.\n'

timezone=Europe
city=Moscow
res=$(timedatectl | grep " Time zone" | awk '{print $3}')
echo 'changing tzone.'
if [[ "$res" == $timezone/$city ]]; then
	echo -e 'already set.\n'
else
	unlink /etc/localtime
	ln -s /usr/share/zoneinfo/$timezone/$city /etc/localtime
	echo -e 'set.\n'
fi

echo 'show ssh port'
res=$(netstat -nltp4 | grep ssh | awk '{print $4}' | cut -d : -f 2)
echo $res

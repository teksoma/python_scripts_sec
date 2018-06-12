#!/bin/bash

kali=$(ps -ef | grep 00:aa:00:60:00:03)
meta=$(ps -ef | grep 00:aa:00:60:00:02)
ubuDes18=$(ps -ef | grep 00:aa:00:60:00:05)
ubuSer18=$(ps -ef | grep 00:aa:00:60:00:04)
win7=$(ps -ef | grep 00:aa:00:60:00:06)

kaliSrc="kali.qcow2"
metaSrc="Metasploitable.qcow2"
ubuDes18Src="Ubuntu-Desktop-18.04.qcow2"
ubuSer18Src="Ubuntu-Server-18.04.qcow2"
win7Src="Windows-7.qcow2"

kaliRun=false
metaRun=false
ubuDes18Run=false
ubuSer18Run=false
win7Run=false

setRunning()
{
	if echo "$kali" | grep -q "$kaliSrc"; then
		kaliRun=true
	else
		kaliRun=false
	fi

	if echo "$meta" | grep -q "$metaSrc"; then
		metaRun=true
	else
		metaRun=false
	fi

	if echo "$ubuDes18" | grep -q "$ubuDes18Src"; then
		ubuDes18Run=true;
	else
		ubuDes18Run=false;
	fi

	if echo "$ubuSer18" | grep -q "$ubuSer18Src"; then
		ubuSer18Run=true
	else
		ubuSer18Run=false
	fi

	if echo "$win7" | grep -q "$win7Src"; then
		win7Run=true
	else
		win7Run=false
	fi
}

printState()
{
	if [ $kaliRun = true ]; then
		echo "1.) Kali                 [+]"
	else
		echo "1.) Kali                 [-]"
	fi

	if [ $metaRun = true ]; then
		echo "2.) Metasploitable       [+]"
	else
		echo "2.) Metasploitable       [-]"
	fi

	if [ $ubuDes18Run = true ]; then
		echo "3.) Ubuntu Desktop 18.04 [+]"
	else
		echo "3.) Ubuntu Desktop 18.04 [-]"
	fi

	if [ $ubuSer18Run = true ]; then
		echo "4.) Ubuntu Server 18.04  [+]"
	else
		echo "4.) Ubuntu Server 18.04  [-]"
	fi

	if [ $win7Run = true ]; then
		echo "5.) Windows 7            [+]"
	else
		echo "5.) Windows 7            [-]"
	fi
}

turnOnVM()
{
	if [ $1 = "kali" ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 4096 -enable-kvm -drive if=virtio,file=kali.qcow2,cache=none -netdev tap, id=tap2,ifname=tap2,script=no,downscript=no -device e1000,netdev=tap2,mac=00:aa:00:06:00:03 -daemonize
	elif [ $1 = "meta" ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=Metasploitable.qcow2,cache=none -netdev tap, id=tap1,ifname=tap1,script=no,downscript=no -device e1000,netdev=tap1,mac=00:aa:00:06:00:02 -daemonize
	elif [ $1 = "ubuDes18" ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=Ubuntu-Desktop-18.04.qcow2,cache=none -netdev tap, id=tap4,ifname=tap4,script=no,downscript=no -device e1000,netdev=tap4,mac=00:aa:00:06:00:05 -daemonize
	elif [ $1 = "ubuSer18" ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 256 -enable-kvm -drive if=virtio,file=Ubuntu-Server-18.04.qcow2,cache=none -netdev tap, id=tap3,ifname=tap3,script=no,downscript=no -device e1000,netdev=tap3,mac=00:aa:00:06:00:04 -daemonize
	elif [ $1 = "win7" ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 2048 -enable-kvm -drive if=virtio,file=kali.qcow2,cache=none -netdev tap, id=tap5,ifname=tap5,script=no,downscript=no -device e1000,netdev=tap5,mac=00:aa:00:06:00:06 -daemonize
	fi
}

turnOffVM()
{
	if [ $1 = "kali" ]; then
		pid="$((ps -ef | awk '$3 == 1') | grep "03 -daemonize")"
		killId="($pid | cut -d ' ' -f 2)"
		kill $killId
	elif [ $1 = "meta" ]; then
		pid="$((ps -ef | awk '$3 == 1') | grep "02 -daemonize")"
		killId="($pid | cut -d ' ' -f 2)"
		kill $killId
	elif [ $1 = "ubuDes18" ]; then
		pid="$((ps -ef | awk '$3 == 1') | grep "05 -daemonize")"
		killId="($pid | cut -d ' ' -f 2)"
		kill $killId
	elif [ $1 = "ubuSer18" ]; then
		pid="$((ps -ef | awk '$3 == 1') | grep "04 -daemonize")"
		killId="($pid | cut -d ' ' -f 2)"
		kill $killId
	elif [ $1 = "win7" ]; then
		pid="$((ps -ef | awk '$3 == 1') | grep "06 -daemonize")"
		killId="($pid | cut -d ' ' -f 2)"
		kill $killId
	fi	
}

launchAll()
{
	if [ "$kaliRun" = false ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 4096 -enable-kvm -drive if=virtio,file=kali.qcow2,cache=none -netdev tap, id=tap2,ifname=tap2,script=no,downscript=no -device e1000,netdev=tap2,mac=00:aa:00:06:00:03 -daemonize
	elif [ "$metaRun" = false ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=Metasploitable.qcow2,cache=none -netdev tap, id=tap1,ifname=tap1,script=no,downscript=no -device e1000,netdev=tap1,mac=00:aa:00:06:00:02 -daemonize
	elif [ "$ubuDes18Run" = false ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 1024 -enable-kvm -drive if=virtio,file=Ubuntu-Desktop-18.04.qcow2,cache=none -netdev tap, id=tap4,ifname=tap4,script=no,downscript=no -device e1000,netdev=tap4,mac=00:aa:00:06:00:05 -daemonize
	elif [ "$ubuSer18Run" = false ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 256 -enable-kvm -drive if=virtio,file=Ubuntu-Server-18.04.qcow2,cache=none -netdev tap, id=tap3,ifname=tap3,script=no,downscript=no -device e1000,netdev=tap3,mac=00:aa:00:06:00:04 -daemonize
	elif [ "$win7Run" = false ]; then
		./x86_64_softmmu/qemu-system-x86_64 -m 2048 -enable-kvm -drive if=virtio,file=kali.qcow2,cache=none -netdev tap, id=tap5,ifname=tap5,script=no,downscript=no -device e1000,netdev=tap5,mac=00:aa:00:06:00:06 -daemonize
	fi	
}

turnOffAll()
{
	killall qemu-system-x86
}

vmChoose()
{
	if [ $1 = "kali" ]; then
		if [ $kaliRun = false ]; then
			echo -n "Turn on Kali? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
				turnOnVM "kali"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		else
			echo -n "Turn off Kali? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y']; then
				turnOffVM "kali"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		fi

	elif [ $1 = "meta" ]; then
		if [ $kaliRun = false ]; then
			echo -n "Turn on Metasploitable? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
				turnOnVM "meta"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		else
			echo -n "Turn off Metasploitable? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y']; then
				turnOffVM "meta"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		fi
	elif [ $1 = "ubuDes18" ]; then
		if [ $kaliRun = false ]; then
			echo -n "Turn on Ubuntu Desktop 18.04? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
				turnOnVM "ubuDes18"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		else
			echo -n "Turn off Ubuntu Desktop 18.04? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y']; then
				turnOffVM "18.04"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		fi
	elif [ $1 = "ubuSer18" ]; then
		if [ $kaliRun = false ]; then
			echo -n "Turn on Ubuntu Server 18.04? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
				turnOnVM "ubuSer18"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		else
			echo -n "Turn off Ubuntu Server 18.04? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y']; then
				turnOffVM "ubuSer18"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		fi
	elif [ $1 = "win7" ]; then
		if [ $kaliRun = false ]; then
			echo -n "Turn on Windows 7? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
				turnOnVM "win7"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		else
			echo -n "Turn off Windows 7? (Y/n):"
			read choice
			if [ $choice = 'Y' ] || [ $choice = 'y']; then
				turnOffVM "win7"
			elif [ $choice = 'n' ]; then
				clear
				main
			else
				echo "Not a valid choice"
			fi
		fi
	fi
}

main()
{

	if ! [ $(id -u) = 0 ]; then
		echo "Run this script as sudo"
		exit 1
	fi 

	turnoff=0

		clear

		echo " ----------------------------"
		echo "|          Qemu-Menu         |"
		echo " ----------------------------"

		setRunning
		printState
	while [ 1 = 1 ]
	do

		echo -n "> "
		read input

		if [ "$input" = 1 ]; then
			vmChoose "kali"
		elif [ "$input" = 2 ]; then
			vmChoose "meta"
		elif [ "$input" = 3 ]; then
			vmChoose "ubuDes18"
		elif [ "$input" = 4 ]; then
			vmChoose "ubuSer18"
		elif [ "$input" = 5 ]; then
			vmChoose "win7"
		elif [ "$input" = 'a' ] || [ "$input" = 'all' ]; then
			launchAll
		elif [ "$input" = 'quit' ] || [ "$input" = 'q' ]; then
			echo -n "Turn off all VMs? (Y/n)"
			read choice

			while [ "$turnoff" -eq 0 ]
			do
				if [ $choice = 'Y' ] || [ $choice = 'y' ]; then
					turnOffAll
					turnoff=1
				elif [ $choice = 'n' ]; then
					echo "Closing Qemu-Menu ... "
					sleep 1 
					clear
					exit 1
				else
					echo "Not a valid choice"
				fi
			done

			echo "Closing Qemu-Menu ... "
			sleep 1 
			clear
			exit 1
			
		else
			echo "invalid option"
		fi
	done
}

main

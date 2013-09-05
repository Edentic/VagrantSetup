#!bin/bash

function installWP {
	echo "::: INSTALLING WORDPRESS :::"
	wget -O ./wp.tgz http://wordpress.org/latest.tar.gz
	if [[ "$?" != "0" ]]
	then
  		echo "an error happened downloading WordPress!"
  		exit 1
	fi
	
	tar xf ./wp.tgz
	mv ./wordpress/* .
	rmdir ./wordpress
	rm ./wp.tgz
	cat ./templates/wp-config.php | sed -e "s/\${db_name}/$1/" -e "s/\${project_name}/$1/" > ./wp-config.php
}

function setDBSettings {
		echo "::: SETTING UP DATABSE :::"
		cat ./templates/settings.pp | sed -e "s/\${db_name}/$1/" > ./manifests/settings.pp
}

function startVagrant {
	echo "::: STARTING VIRTUAL ENVOROMENT :::"
	vagrant up
	if [[ "$?" != "0" ]]
	then
    	echo "Vagrant could not start! Have you installed vagrant?"
  		exit 1
  	fi
}

case $1 in
	"init")
            if [ "$2" = "" ]; 
            then
                echo No project name given!;
            else
                setDBSettings $2;
                startVagrant;
            fi
	;;

	"WPinit")
            if [ "$2" = "" ]; then
                echo No project name given!
            else
				installWP $2;
				if [[ "$?" != "0" ]]
				then
  					echo "WordPress could not be installed!"
  					exit 1
				fi
				setDBSettings $2;
				startVagrant;
			fi
	;;

	*)
		echo "Please do init for setting up vagrant or WPinit for installing wp and setting up vgrant"
	;;
esac





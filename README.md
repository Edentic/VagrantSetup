VagrantSetup
============

Make it easy to setup a new vagrant instance with LAMP stack and optional WP install

Requirements
============

* [Vagrant](http://www.vagrantup.com/)
* WGET

Usage
=====

Download the files and place it in your project root folder.
Open up your terminal and `cd` into your project directory.

LAMP stack only
---------------

Run the following command if you only want to setup a LAMP server without installing WordPress:
`sh vagrantsetup init <dbname>` where <dbname> is the name of the database the server creates.

WordPress install
-----------------
Run the following command for installing the latest version of WordPress and setting it up on Vagrant:
`sh vagrantsetup WPinit <projectname>` where <projectname> is the name of the WordPress installation.

Access your server
==================

When the server is up and running, you can access your server on the IP `192.168.57.10` or on your local network using `<your_machine_ip>:8080`.

MySQL & PHPMyAdmin
-------------------------
You can access your database using the following credentials:
`Usernmae: 'root'`
`Password: 'dbadmin'`
`Database: '<dbname | projectname>'`

You can access PHPMyAdmin on the ip `192.168.57.10/phpmyadmin`. Log in with the same credentials as MySQL.

**Notice this server is a development server and is not intended for production use!**
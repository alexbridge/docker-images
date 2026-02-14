### Installation

1) $ curl -sSL https://raw.githubusercontent.com/aam-git/dockerfiles/master/opencart/docker-compose.yml > docker-compose.yml
2) use your text editor to edit docker-compose.yml (eg nano docker-compose.yml) and enter a more secure MYSQL_ROOT_PASSWORD
3) $ docker-compose up -d
4) go to your web url (eg. http://127.0.0.1)
5) go through the opencart standard install procedure
 - DB Driver is "MySQLi"
 - Hostname is "database"
 - Username is "root"
 - Password is "secure_password_here" (though you should have changed this in step 2)
 - Database is "opencart"
 - Enter your own details for step 2
6) Opencart Install should now be complete, you can now delete the install folder.
7) Log into admin, in the popup for Storage location, change it to anywhere under "/var/www/" for example "/var/www/storage"
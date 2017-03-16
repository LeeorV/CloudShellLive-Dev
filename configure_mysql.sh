touch /script_output.txt
echo "Setup settings for config">>/script_output.txt
echo "mysql-server mysql-server/root_password password admin" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password admin" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive 

echo "Update Package Repo"
apt-get -y update >>/script_output.txt

echo "Install MySQL"
apt-get -y install mysql-server >>/script_output.txt

echo "Create DB"
mysql --batch --silent -e CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

echo "Grant permissions to Wordpress DB to new wordpress user account"
mysql --batch --silent -e GRANT ALL ON wordpress.* TO 'wordpressuser'@'%' IDENTIFIED BY '$CS_SQL_PASSWD';
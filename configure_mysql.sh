# Setup settings for configecho "mysql-server mysql-server/root_password password admin" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password admin" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive 

# Update Package Repo
apt-get -y update >/script_output.txt

# Install MySQL
apt-get -y install mysql-server >>/script_output.txt

# Create DB
mysql --batch --silent -e CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

# Grant permissions to Wordpress DB to new wordpress user account
mysql --batch --silent -e GRANT ALL ON wordpress.* TO 'wordpressuser'@'%' IDENTIFIED BY '{Passowrd}';
mysql --batch --silent -e FLUSH PRIVILEGES;
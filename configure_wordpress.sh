touch /script_output.txt
# Update Package Repo
apt-get -y update >>/script_output.txt

# Install Apache Web Server
apt-get -y install apache2 >>/script_output.txt


PUBLIC_IP = "$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

# Set server name in apache config
echo "ServerName $PUBLIC_IP" >>/etc/apache2/apache2.conf

# Install PHP and additional packages
apt-get -y install php libapache2-mod-php php-mcrypt php-mysql>>/script_output.txt
apt-get -y install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc>>/script_output.txt

# Enable apache2 rewrite module
a2enmod rewrite>>/script_output.txt

# Download and extract latest wordpress
wget -O /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz>>/script_output.txt
tar -xvzf /tmp/latest.tar.gz -C /tmp>>/script_output.txt

# Set premissions for .htaccess file
touch /tmp/wordpress/.htaccess>>/script_output.txt
chmod 660 /tmp/wordpress/.htaccess>>/script_output.txt

# Copy sample configuration file
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php>>/script_output.txt

# Create upgrade directory
mkdir /tmp/wordpress/wp-content/upgrade>>/script_output.txt

# Copy wordpress folder to root
cp -a /tmp/wordpress/. /var/www/html>>/script_output.txt
mv /var/www/html/index.html /var/www/html/index.html.old>>/script_output.txt

# Allow group write on content directory
chmod g+w /var/www/html/wp-content>>/script_output.txt
chmod -R g+w /var/www/html/wp-content/themes>>/script_output.txt
chmod -R g+w /var/www/html/wp-content/plugins>>/script_output.txt

# Get secret key from server
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >>/script_output.txt

# Restart Apache
apache2ctl restart
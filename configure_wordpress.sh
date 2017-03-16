touch /script_output.txt

echo "Update Package Repo">>/script_output.txt
apt-get -y update >>/script_output.txt

echo "Install Apache Web Server">>/script_output.txt
apt-get -y install apache2 >>/script_output.txt


PUBLIC_IP = "$(curl http://169.254.169.254/latest/meta-data/public-ipv4)"

echo "Set server name in apache config">>/script_output.txt
echo "ServerName $PUBLIC_IP" >>/etc/apache2/apache2.conf

echo "Install PHP and additional packages">>/script_output.txt
apt-get -y install php libapache2-mod-php php-mcrypt php-mysql>>/script_output.txt
apt-get -y install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc>>/script_output.txt

echo "Enable apache2 rewrite module">>/script_output.txt
a2enmod rewrite>>/script_output.txt

echo "Download and extract latest wordpress">>/script_output.txt
wget -O /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz>>/script_output.txt
tar -xvzf /tmp/latest.tar.gz -C /tmp>>/script_output.txt

echo "Set premissions for .htaccess file">>/script_output.txt
touch /tmp/wordpress/.htaccess>>/script_output.txt
chmod 660 /tmp/wordpress/.htaccess>>/script_output.txt

echo "Copy sample configuration file">>/script_output.txt
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php>>/script_output.txt

echo "Create upgrade directory">>/script_output.txt
mkdir /tmp/wordpress/wp-content/upgrade>>/script_output.txt

echo "Copy wordpress folder to root">>/script_output.txt
cp -a /tmp/wordpress/. /var/www/html>>/script_output.txt
mv /var/www/html/index.html /var/www/html/index.html.old>>/script_output.txt

echo "Allow group write on content directory">>/script_output.txt
chmod g+w /var/www/html/wp-content>>/script_output.txt
chmod -R g+w /var/www/html/wp-content/themes>>/script_output.txt
chmod -R g+w /var/www/html/wp-content/plugins>>/script_output.txt

echo "Get secret key from server">>/script_output.txt
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >>/script_output.txt

echo "Restart Apache">>/script_output.txt
apache2ctl restart

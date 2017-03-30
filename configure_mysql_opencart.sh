touch /script_output.txt
echo "####	Setup settings for config">>/script_output.txt
echo "mysql-server mysql-server/root_password password admin" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password admin" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive 

echo "####	Update Package Repo">>/script_output.txt
apt-get -y update >>/script_output.txt

echo "####	Install MySQL">>/script_output.txt
apt-get -y install mysql-server >>/script_output.txt
#!/bin/sh
#
# This is a basic bash script to install Mod-Sec WAF
# and to add Proxxypass & Proxypass-reverse (Virtual-host) to the Mod Security WAF.
#
# Written by - SHAW (shawsuraj)
#
#
# ModSecurity, sometimes called Modsec, is an open-source web application firewall (WAF).
# Originally designed as a module for the Apache HTTP Server, it has evolved to provide an
# array of Hypertext Transfer Protocol request and response filtering capabilities along with
# other security features across a number of different platforms including Apache HTTP Server,
# Microsoft IIS and NGINX.[3] It is a free software released under the Apache license 2.0.



echo "Do you want to install/update apache2: y/n [y]"; read ans;
if [ $ans = n ]
then
echo " "
else
  echo "Installing apache2 ..."
  sudo apt-get install apache2 -y
fi

# Installing git
sudo apt-get install git -y

# Install ModSecurity
echo "Installing ModSecurity ..."
sudo apt-get install libapache2-mod-security2 -y

echo "Restarting Apache ..."
sudo service apache2 restart

echo "Now Configuring ModSecurity ..."
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

# Changing the value of SecRuleEngine from DetectionOnly to On
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/modsecurity/modsecurity.conf

# Restarting Apache for the changes to take effect
sudo systemctl restart apache2

# ModSecurity has default rules set located
# at /usr/share/modsecurity-crs directory.
# However, it is always recommended to download the rules set from GitHub:

# Before, we do this, renaming the default rules directory
sudo mv /usr/share/modsecurity-crs /usr/share/modsecurity-crs.bk

# Then, downloading new rule set from GitHub using the command below:
echo "Downloading new rule sets ..."
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/share/modsecurity-crs

# Setting the configuration file from the downloaded crs
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf


# To get these rules working on Apache, adding the following two lines
echo 'IncludeOptional /usr/share/modsecurity-crs/*.conf' | sudo tee -a /etc/apache2/mods-enabled/security2.conf
echo 'IncludeOptional "/usr/share/modsecurity-crs/rules/*.conf' | sudo tee -a /etc/apache2/mods-enabled/security2.conf


# Restaring Apache
echo "Almost Done, Now Restarting Apache ..."
sudo systemctl restart apache2

#Activating the modules
echo "Enabling the modules ..."
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
sudo a2enmod proxy_html


# Modifying the Deafult COnfing
sudo mv /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.bk
sudo cp conf_file/000-default.conf /etc/apache2/sites-enabled/000-default.conf
#Restart the apache server
sudo systemctl restart apache2


echo "Setup is complete"
echo "Set Proxypass -(server-ip)  and Proxypass-reverse -(WAF-ip)"
echo "HERE -> /etc/apache2/sites-enabled/000-default.conf"
echo "And then restart the apache server to apply the changes."

# This is a basic bash script to install Mod-Sec WAF
# And to add Proxxypass & Proxypass-reverse to the
# Mod Security WAF.

# Written by - SHAW (shawsuraj)


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
  echo "Installing apache2"
  sudo apt-get install apache2
fi

# Installing git
sudo apt-get install git

# Install ModSecurity
echo "Installing ModSecurity"
sudo apt-get install libapache2-mod-security2

echo "Restarting Apache"
sudo service apache2 restart

echo "Now Configuring ModSecurity"
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

# Changing the value of SecRuleEngine from DetectionOnly to On
sed -i -e 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' nano /etc/modsecurity/modsecurity.conf

# Restarting Apache for the changes to take effect
sudo systenctk restart apache2

# ModSecurity has default rules set located
# at /usr/share/modsecurity-crs directory.
# However, it is always recommended to download the rules set from GitHub:

# Before, we do this, renaming the default rules directory
sudo mv /usr/share/modsecurity-crs /usr/share/modsecurity-crs.bk

# Then, downloading new rule set from GitHub using the command below:
echo "Downloading new rule sets"
sudo git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /usr/share/modsecurity-crs

# Copying the sample configuration file from the downloaded rules
sudo cp /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf


# To get these rules working on Apache, adding the following two lines
echo "IncludeOptional /usr/share/modsecurity-crs/*.conf" >> /etc/apache2/mods-enabled/security2.conf
echo 'IncludeOptional "/usr/share/modsecurity-crs/rules/*.conf' >> /etc/apache2/mods-enabled/security2.conf


# Restaring Apache
echo "Almost Done, Now Restarting Apache"
sudo systemctl restart apache2

#Activating the modules
ehco "Enabling the modules"
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
echo " Modifying the default Apache virtual host"
match='</VirtualHost>'
file='/etc/apache2/sites-enabled/000-default.conf'
l1='\n\nProxyPreserveHost On\n\n'
l2='# Servers to proxy the connection, or;\n'
l3='# List of application servers\n'
l4='# ProxyPass / http://[IP Addr.]:[port]/\n'
l5='# ProxyPassReverse / http://[IP Addr.]:[port]/\n'
l5='# Example:\n'
l6='ProxyPass / http://0.0.0.0:8080/\n'
l7='ProxyPassReverse / http://0.0.0.0:8080/\n\n'
l8='ServerName localhost'


sed -i "s/$match/$l1$l2$l3$l4$l5$l6$l7$l8\n\n$match/" $file


#Restart the apache server
sudo systemctl restart apache2


echo "Setup is complete"
echo "Set Proxypass -(server-ip)  and Proxypass-reverse -(WAF-ip)"
echo "here -> /etc/apache2/sites-enabled/000-default.conf"
echo "And then restart the apache server"
echo "Then it will be ready to use"

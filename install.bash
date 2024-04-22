echo "Host IP: "
read ip
echo "$ip  $HOSTNAME" >> /etc/hosts

echo "This should output the above IP:"
echo $(hostname --ip-address)

echo "If not, use ^C to cancel the install..."
sleep 3

touch install.log

echo "> Installing packages..."
apt update -y >> install.log
apt install curl wget sudo htop wget -y >> install.log

echo "> Adding repo..."
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
echo "> Adding repo key..."
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 

echo "> Installing packages..."
apt update -y >> install.log
apt full-upgrade >> install.log

echo "> Installing proxmox kernel..."
apt install proxmox-default-kernel -y >> install.log
apt install proxmox-ve postfix open-iscsi chrony -y >> install.log

echo "> Remove debian kernel"
apt remove linux-image-amd64 'linux-image-6.1*' -y >> install.log

echo "> Remove os probe"
apt remove os-prober -y >> install.log

echo "> Install done!"
sleep 3

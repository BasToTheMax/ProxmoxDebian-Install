FILE=./.installed
if [ -f "$FILE" ]; then
    echo "$FILE exists."

    
    echo "> Remove debian kernel"
    apt remove linux-image-amd64 'linux-image-6.1*' -y
    
    echo "> Remove os probe"
    apt remove os-prober -y
    
    echo "> Install done! You can access your server by https://$(hostname --ip):8006"
    echo "> Rebooting server in 10 seconds"
    sleep 10
    echo "> Rebooting..."
    reboot
else 
    echo "$FILE does not exist."

    echo "Host IP: "
    read ip
    echo "$ip  $HOSTNAME" >> /etc/hosts
    
    echo "This should output the above IP:"
    echo $(hostname --ip-address)
    
    echo "If not, use ^C to cancel the install..."
    echo "> Proceeding in 5 seconds..."
    sleep 2
    echo "> in 3 seconds"
    sleep 1
    echo "> in 2 seconds"
    sleep 1
    echo "> in 1 second"
    sleep 1
    
    touch install.log
    
    echo "> Installing packages..."
    apt update -y
    apt install curl wget sudo htop wget -y
    
    echo "> Adding repo..."
    echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list
    echo "> Adding repo key..."
    wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg 
    
    echo "> Installing packages..."
    apt update -y
    apt full-upgrade -y
    
    echo "> Installing proxmox kernel..."
    apt install proxmox-default-kernel -y
    apt install proxmox-ve postfix open-iscsi chrony -y

    echo "> Now reboot the server and execute this script again"
    touch $FILE
fi

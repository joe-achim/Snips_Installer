# Dependances
sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y raspberrypi-kernel-headers
sudo apt-get install -y dirmngr apt-transport-https
sudo apt-get install -y duplicity #https://blog.rom1v.com/2013/08/duplicity-des-backups-incrementaux-chiffres/
sudo apt-get install -y sshfs # https://codeandunicorns.com/duplicity-scpssh-backup-raspberry-pi/
#sudo apt-cache policy lsb-release
sudo apt-get install lsb-release

# Mount Freebox & Backup order
	  sudo mkdir /media/freebox && sudo chown pi -R /media/freebox
	  sudo mount.cifs //freebox-server.local/SAMSUNG/ /media/freebox -o ip=192.168.0.254,user=freebox,password=[ChangeMe],vers=1.0 && crontab -l | { cat; echo "@reboot sudo mount.cifs //freebox-server.local/SAMSUNG/ /media/freebox -o ip=192.168.0.254,user=freebox,password=[ChangeMe],vers=1.0"; } | crontab - && mkdir /media/freebox/_BACKUPS_RASPYS/$HOSTNAME
          sudo mkdir /_backup && sudo chown pi -R /_backup
	  sudo mount -o bind /media/freebox/_BACKUPS_RASPYS/$HOSTNAME/ /_backup && crontab -l | { cat; echo "@reboot sudo mount -o bind /media/freebox/_BACKUPS_RASPYS/$HOSTNAME/ /_backup"; } | crontab -
	  

# Install Snips Plateform 
sudo bash -c  'echo "deb   https://raspbian.snips.ai/$(lsb_release -cs) stable main" > /etc/apt/sources.list.d/snips.list'
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys D4F50CDCA10A2849
sudo apt-key adv --keyserver pgp.surfnet.nl --recv-keys D4F50CDCA10A2849
sudo apt-get update
sudo apt-get install -y snips-platform-voice
sudo apt-get install -y snips-injection
sudo apt-get install -y snips-watch

# Python pip & virtualenv install
sudo apt-get install -y python-pip
sudo apt-get install -y python-virtualenv
sudo pip install --upgrade virtualenv
virtualenv --python=/usr/bin/python2.7 snips

#Install NodeJS + NPM : https://michaelborn.me/entry/installing-node-js-on-raspberry-pi-a
if $(uname -m | grep -Eq ^armv6); then
	  #NODE="$(curl -sL https://nodejs.org/dist/latest | grep 'armv6l.tar.xz' | cut -d'"' -f2)"
	  #wget https://nodejs.org/dist/latest/$NODE
	  NODE="$(curl -sL https://nodejs.org/dist/latest-v8.x | grep 'armv6l.tar.xz' | cut -d'"' -f2)"
	  wget https://nodejs.org/dist/latest-v8.x/$NODE
	  tar -xvf $NODE
	  cd ${NODE%%.tar*}/
	  ls -l
	  sudo ln -s /usr/src/${NODE%%.tar*}/bin/node /usr/local/bin/nodejs
	  sudo ln -s /usr/local/bin/nodejs /usr/local/bin/node
  else
  	  # Install Node.js 8.x LTS Carbon and npm
	  sudo apt-get install -y gcc g++ make
	  sudo apt-get install curl
	  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
	  sudo apt-get install -y nodejs
fi

# Install the Yarn package manager
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

# Snips MyChef
pip install spidev
pip install paho-mqtt
# git clone https://github.com/Psychokiller1888/MyChef.git
# sudo rm -rf /usr/share/snips/assistant
# sudo mv MyChef/mychef.service /etc/systemd/system
# sudo mv MyChef/assistants/assistant_fr /usr/share/snips/assistant
sudo systemctl restart "snips-*"
sudo systemctl start mychef
sudo systemctl enable mychef

#Install SAM
sudo apt-get update
sudo bash -c  'echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list'
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys F727C778CCB0A455
sudo apt-key adv --keyserver pgp.surfnet.nl --recv-keys F727C778CCB0A455
sudo npm install -g snips-sam
sam connect localhost
sam init
sam login
#sam install assistant -i proj_985YN8Ndgr
sam install assistant -i proj_b3gZ5602NK2
sam sound-feedback on

# Install NPM
# wget -O - https://raw.githubusercontent.com/audstanley/NodeJs-Raspberry-Pi/master/Install-Node.sh | sudo bash;
# sudo apt update && sudo apt dist-upgrade -y
# bash <(curl -sL https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/update-nodejs-and-nodered) y y
# curl -L https://npmjs.com/install.sh | sudo sh
# sudo npm install -g snips-sam

# Install Sound-Card & Drivers from : https://github.com/Psychokiller1888/snipsLedControl/
cd ~/
wget https://raw.githubusercontent.com/joe-achim/Snips_Installer/master/.asoundrc
wget https://gist.githubusercontent.com/Psychokiller1888/a9826f92c5a3c5d03f34d182fda1ce4c/raw/e24882e8997730dcf7a308e303b3b88001dbbfa1/slc_download.sh
sudo chmod +x slc_download.sh
sudo ./slc_download.sh 1 3 1
#sudo ./snipsLedControl_v1.7/installers/respeakers.sh
ls -I* ~/seeed-voicecard && sudo mv /etc/asound.conf /etc/asound.conf.sav
ls -I* ~/seeed-voicecard && sudo mv -f ~/.asoundrc /etc/asound.conf
ls -I* ~/seeed-voicecard && sudo apt-get install -y i2c-tools
ls -I* ~/seeed-voicecard && sudo systemctl restart seeed-voicecard
cd ~/


# Prepare for add satellites https://github.com/Psychokiller1888/satConnect
cd ~/
git clone https://github.com/Psychokiller1888/satConnect.git
cd satConnect
sudo pip install -r requirements.txt
sudo python server.py --remove-backup
cd ~/

# Point d'accès Wifi dédié au réseau Domotique
# https://raspbian-france.fr/creer-un-hotspot-wi-fi-en-moins-de-10-minutes-avec-la-raspberry-pi/
# https://www.framboise314.fr/raspap-creez-votre-hotspot-wifi-avec-un-raspberry-pi-de-facon-express/

# Création d'une sauvegarde du fichier de configuration WiFi
#sudo cp /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.sav

# Suppression du fichier de configuration WiFi pour retourner à une configuration vierge
#sudo cp /dev/null /etc/wpa_supplicant/wpa_supplicant.conf

# ranformer son Raspberry Pi en routeur Wifi avec Hostapd
# URL:> https://dadarevue.com/raspberry-pi-routeur-wifi-hotspot-hostapd/
# URL:> https://doc.ubuntu-fr.org/hostapd#filtrage_mac
# URL:> http://lea-linux.org/documentations/Point_d'acc%C3%A8s_s%C3%A9curis%C3%A9_par_hostAPd

# Téléchargement et installation de RaspAP
#wget -q https://git.io/voEUQ -O /tmp/raspap && bash /tmp/raspap

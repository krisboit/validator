# install some basic stuff
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common python git

# checkout repo
cd ~/
rm -rf validator
git clone https://github.com/krisboit/validator.git

# add in path
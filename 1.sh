sudo apt update && sudo apt upgrade -y
sudo ufw allow 8448
sudo ufw allow http
sudo ufw allow https
sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/matrix-org.list
sudo apt update
sudo apt install matrix-synapse-py3 -y
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /usr/share/keyrings/postgresql-key.gpg >/dev/null
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/postgresql-key.gpg arch=amd64] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt update
sudo apt install postgresql postgresql-contrib -y
sudo apt install postgresql-14 postgresql-contrib-14 -y
sudo -su postgres

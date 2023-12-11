curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
| sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list
sudo apt update
sudo apt install nginx -y
sudo nginx -v
sudo systemctl start nginx
sudo apt install snapd -y
sudo snap install core
sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
certbot --version
sudo certbot certonly --nginx --agree-tos --no-eff-email --staple-ocsp --preferred-challenges http
sudo openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 4096
sudo systemctl list-timers
sudo certbot renew --dry-run
ls /etc/matrix-synapse/conf.d
rm /etc/matrix-synapse/conf.d/database.yaml
sudo cp database.yaml /etc/matrix-synapse/conf.d/database.yaml
echo "registration_shared_secret: '$(cat /dev/urandom | tr -cd '[:alnum:]' | fold -w 256 | head -n 1)'" | sudo tee /etc/matrix-synapse/conf.d/registration_shared_secret.yaml
registration_shared_secret: 'vgd73p26ZDaFExpX4OPv45DsA2ZMAxiVZR7um9fBoBoFESmg5MSs68xAMUhwQ8Zn3NqcZMRSqxLeIFatppfne7xD2RHL16YfuIKmNeJ1FClQszO1SZknUVwOPyDiPe5gCCWgD9cHfa3dLTdZND5Y0SdH7GBkwYqKjibAe0JoQc8mKty3HWd6uIga3QewhtXr3b3Hpk8sr6zYpXvaBtWRHwaSWcLooqbWF8LPbSyrC0BVAKzXObUwqRGyDpkrnMiY'
rm /etc/matrix-synapse/conf.d/presence.yaml
sudo cp presence.yaml /etc/matrix-synapse/conf.d/presence.yaml
sudo systemctl restart matrix-synapse
register_new_matrix_user -c /etc/matrix-synapse/conf.d/registration_shared_secret.yaml http://localhost:8008
rm /etc/matrix-synapse/conf.d/registration.yaml
sudo cp registration.yaml /etc/matrix-synapse/conf.d/registration.yaml
sudo systemctl restart matrix-synapse
rm /etc/nginx/conf.d/synapse.conf
sudo cp synapse.conf /etc/nginx/conf.d/synapse.conf
sudo nginx -t
sudo systemctl restart nginx
sudo apt install coturn
sudo ufw allow 3478
sudo ufw allow 5349
sudo ufw allow 49152:65535/udp
sudo certbot certonly --nginx --agree-tos --no-eff-email --staple-ocsp --preferred-challenges http
echo "static-auth-secret=$(cat /dev/urandom | tr -cd '[:alnum:]' | fold -w 256 | head -n 1)" | sudo tee /etc/turnserver.conf
static-auth-secret=OcKBLuwpE6IyMoi9mPccjVFaL7PwJRFUuKh5EvGBVcvB7tunevQ3cpP74we8cF4XSN8lFNrgqxJeyItKOcoOABwjdTNChmJeB4WMrsLV2JNsPs3U61s9rRijj3OxBpZux0CGft8CiyNDweVLqqxNaYphNesoAT4y51RxLVdAP2ros9S3jRR7IYRccJVRMpqTa8USBuBqAkzRRPLbFOHsC6QHur2oiySuW6sqs4YkH65N8kReSzgi7Fq2Zll3RO5e
rm /etc/turnserver.conf
sudo cp turnserver.conf /etc/turnserver.conf
sudo systemctl restart coturn
rm /etc/matrix-synapse/conf.d/turn.yaml
sudo cp turn.yaml /etc/matrix-synapse/conf.d/turn.yaml
sudo systemctl restart matrix-synapse
reboot

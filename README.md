El OS Ubuntu Mate 18.04 está en només en Beta i dona molts problemes d'instal·lació. A més, no venen instal·lats paquets bàsics que fan que s'arrosseguin encara més problemes. També és més fàcil el tema SSH, ja ve instal·lat per defecte i és molt fàcil activar-lo. Es recomana la versió Ubuntu Server 18.04 LTS, certificat per al seu ús en Raspberry Pi. Es pot trobar en el següent enllaç:

https://cdimage.ubuntu.com/releases/18.04.5/release/ubuntu-18.04.5-preinstalled-server-arm64+raspi3.img.xz

**IMPORTANT:** The script must be run using a username `pi`.

Run the next command to setup your Raspberry Pi for GoPiGo3.

```bash
wget -O - https://raw.githubusercontent.com/Albert-Alvarez/rUBot/master/setup.sh | sudo bash
```

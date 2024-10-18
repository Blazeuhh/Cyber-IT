## TP FINAL MODULE 1

### On fait des LVMs pour la partition sda 5 en ligne de commandes :

![image](https://github.com/user-attachments/assets/ffdb10c4-fb66-4fdb-8596-9254b447062a)


#### Installer les packages nécessaires pour crypté en ligne de commandes puis faire les LVM correctement :

`apt install cryptsetup && apt install lvm2
apt update`

1. Chiffrer la partition :
   Utiliser LUKS (Linux Unified Key Setup) pour chiffrer la partition. 
   `cryptsetup luksFormat /dev/sda5`

2. Ouvrir la partition chiffrée :
   `cryptsetup luksOpen /dev/sda5 crypt`

3. Créer un volume physique LVM sur la partition chiffrée :
   `pvcreate /dev/mapper/crypt`

4. Créer un groupe de volumes :
   `vgcreate LVMGroup /dev/mapper/crypt`

5. Créer les volumes logiques ( avec les Go des LVM que vous voulez ici 100 M est un exemple ) :

    ```
   lvcreate -L 100M -n root LVMGroup
   lvcreate -L 100M -n swap LVMGroup
   lvcreate -L 100M -n srv LVMGroup
   lvcreate -L 100M -n home LVMGroup
   lvcreate -L 100M -n var LVMGroup
   lvcreate -L 100M -n tmp LVMGroup
   lvcreate -L 100M -n var--log LVMGroup
   ```

7. Formater les volumes logiques .

8. Monter les volumes logiques aux points de montage corrects.

#### Normalement cela devrait ressemble à ceci avec la commande lsblk :

 ![image](https://github.com/user-attachments/assets/d586204c-56d3-40e2-af0b-b9098903bf25)

#### Avec la commande blkid pour voir les UUID :

![image](https://github.com/user-attachments/assets/60aa0cf4-f282-47fe-b7cc-af83e2b45244)

#### Correspondance UUID (cat /etc/fstab)

![image](https://github.com/user-attachments/assets/46de52e1-c30b-425b-b523-0e90b1159592)


### Problèmes :

#### Si jamais vous avez envie de supprimer une LVM vérifier d'abord si elle est pas monté

`lsblk`

#### Si elle est monté faites la commande suivante :

`umount /dev/LVMGroup/xxxx`

#### Désactivez le swap (si c'est une partition swap )  :

`swapoff /dev/LVMGroup/swap`

#### Ensuite retirez la LVM souhaité

`lvremove /dev/LVMGroup/xxxx`

#### Installer et Voir les paquets installés :

`apt install ssh git ufw vim sudo`
`dpkg -l apprmor ssh git ufw vim sudo`

![image](https://github.com/user-attachments/assets/e7407b4c-0933-4865-ab58-d0e163733bab)

### Créer les utilisateurs user1, user2, adminuser puis mettre adminuser dans le group cyber

#### Ajouter des utilisateurs

`sudo useradd user1
sudo useradd user2
sudo useradd adminuser`

#### Définir un mot de passe pour chaque utilisateur
`sudo passwd user1
sudo passwd user2
sudo passwd adminuser`

#### Créer le groupe cyber
`sudo groupadd cyber`

#### Ajouter adminuser au groupe cyber
`sudo usermod -aG cyber adminuser`

#### Vérifier les groupes d'adminuser
`groups adminuser`

#### Voici normalement ce que vous devez avoir comme résultat après les commandes  `getent passwd` et `getent groups`

![image](https://github.com/user-attachments/assets/256bfa75-f571-448c-8289-90141c9889e8)

![image](https://github.com/user-attachments/assets/9148f72b-1dad-4bd3-968e-d0769a34c487)

### Créer le groupe cyber et les utilisateurs

#### Créer le groupe admins
sudo groupadd admins

#### Ajouter adminuser au groupe admins
sudo usermod -aG admins adminuser

#### Créer le répertoire /data
sudo mkdir /data

#### Changer le groupe propriétaire de /data pour admins
sudo chown :admins /data

#### Configurer les permissions pour permettre l'accès uniquement au groupe admins
sudo chmod 770 /data

### Voici normalement ce que vous devez avoir comme résultat après les commandes  `ls -ld /data` et `getfacl /data`
![image](https://github.com/user-attachments/assets/85b700d4-7a93-46c7-b68d-5279166757c0)

![image](https://github.com/user-attachments/assets/cdd16a0f-a5d1-4353-8a67-92f959807670)

Pour configurer le service SSH de sorte qu'il fonctionne sur le port **4242** et empêche la connexion SSH avec l'utilisateur **root**, voici les étapes à suivre :

### SSH port 4242 , PermitRootLogin no et vérification

#### 1. Modifier la configuration de SSH

Le fichier de configuration principal de SSH (le serveur et le client) est **`/etc/ssh/sshd_config`**. Tu dois modifier ce fichier pour :
- Changer le port par défaut (22) pour 4242.
- Désactiver la connexion SSH pour l'utilisateur root.

Pour éditer ce fichier, utilise un éditeur de texte comme `nano` ou `vim` :

```bash
sudo nano /etc/ssh/sshd_config
```

### 2. Configurer le port SSH sur 4242

Dans le fichier **`sshd_config`**, trouve la ligne qui spécifie le port (souvent `Port 22`) et modifie-la comme suit :

```bash
Port 4242
```

Si la ligne est commentée (avec un `#` devant), retire le `#` pour activer la ligne.

### 3. Désactiver la connexion SSH pour l'utilisateur root

Ensuite, trouve la ligne suivante dans le même fichier **`sshd_config`** :

```bash
PermitRootLogin yes
```

Modifie-la pour interdire la connexion SSH avec l'utilisateur root :

```bash
PermitRootLogin no
```

Cela interdira explicitement les connexions SSH pour l'utilisateur `root`.

### 4. Enregistrer et quitter l'éditeur

- Si tu utilises `nano`, enregistre les modifications avec `CTRL + O`, puis appuie sur `ENTER` pour confirmer. Ensuite, quitte l'éditeur avec `CTRL + X`.
- Si tu utilises `vim`, enregistre et quitte avec `:wq`.

### 5. Redémarrer le service SSH

Après avoir modifié la configuration, il faut redémarrer le service SSH pour que les changements prennent effet :

```bash
sudo systemctl restart ssh
```

#### Voici normalement ce que vous devez avoir comme résultat après avoir modifier le fichier /etc/ssh/sshd_config et après la commande ss -tuln | grep 4242

![image](https://github.com/user-attachments/assets/8ba7bbc1-f1c4-4d46-935b-3adb6bdb090b)

![image](https://github.com/user-attachments/assets/739a2c79-dfe9-46fe-8cf4-8d3188f116df)

### Ouverture du port 4242 sur ufw avec sudo ufw allow 4242/tcp et ufw status pour voir les règles (ufw enable si le firewall n'est pas actif)

![image](https://github.com/user-attachments/assets/9f9932aa-f987-4035-8221-76557def3e47)


### Changement de Hostname par nanalinux ( commande utilisé nano /etc/hostname , nano /etc/hosts )

![image](https://github.com/user-attachments/assets/5516d60a-3272-4592-bb44-bec754f84bb0)

![image](https://github.com/user-attachments/assets/05eeb741-6195-4602-91fa-a7712b338e15)

### Mettre un mot de passe fort /etc/pam.d/common-password et chage -l <utilisateur> (ronan)

![image](https://github.com/user-attachments/assets/59c70a30-5f6b-4c99-9502-79cc6b3f5942) minclass=3

![image](https://github.com/user-attachments/assets/85e6d8f9-c6b0-4201-aaa5-4aec63217097)

### Configurer sudo selon une pratique stricte/etc/sudoers et /var/log/sudo/

![image](https://github.com/user-attachments/assets/622a703b-0564-44ee-9b91-5b7bafde8289)

![image](https://github.com/user-attachments/assets/7daf481f-7a85-45a0-8688-c026e7b5c435)


### Script monitoring.sh
#!/bin/bash

# Architecture du système et version du kernel
echo "Architecture et version du kernel :"
uname -a

# Nombre de processeurs physiques
echo "Nombre de processeurs physiques :"
grep "physical id" /proc/cpuinfo | sort | uniq | wc -l

# Nombre de processeurs virtuels (threads)
echo "Nombre de processeurs virtuels :"
grep -c ^processor /proc/cpuinfo

# Mémoire vive disponible et son taux d'utilisation
echo "Mémoire vive disponible et taux d'utilisation :"
free -m | awk '/Mem:/ { printf "Mémoire disponible : %dMB / %dMB (%.2f%% utilisé)\n", $3, $2, $3/$2 * 100 }'

# Mémoire disponible actuelle (swap) et son taux d'utilisation
echo "Mémoire swap disponible et taux d'utilisation :"
free -m | awk '/Swap:/ { printf "Mémoire swap disponible : %dMB / %dMB (%.2f%% utilisé)\n", $3, $2, $3/$2 * 100 }'

# Taux d'utilisation des processeurs
echo "Taux d'utilisation des processeurs :"
mpstat | awk '$3 ~ /all/ { printf "Utilisation CPU : %.2f%%\n", 100 - $12 }'

# Date et heure du dernier redémarrage
echo "Dernier redémarrage :"
who -b | awk '{print $3, $4}'

# Vérification si LVM est actif
echo "LVM actif ou non :"
if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then
    echo "LVM est actif."
else
    echo "LVM n'est pas actif."
fi

# Nombre de connexions actives
echo "Nombre de connexions actives :"
ss -s | grep 'estab' | awk '{print $3 " connexions établies"}'

# Nombre d'utilisateurs actuellement connectés
echo "Nombre d'utilisateurs connectés :"
who | wc -l

# Adresse IPv4 et MAC
echo "Adresse IP et MAC :"
ip -o -4 addr show | awk '{print "Interface : " $2 "\nIP : " $4}'
ip link show | awk '/ether/ {print "MAC : " $2}'

# Nombre de commandes exécutées avec sudo
echo "Nombre de commandes exécutées avec sudo :"
grep -c 'COMMAND=' /var/log/sudo/sudo.log 2>/dev/null || echo "Le fichier sudo.log est introuvable."




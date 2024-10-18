
# TP Final - Module 1

## Création de LVMs pour la partition sda5 via la ligne de commande

![image](https://github.com/user-attachments/assets/ffdb10c4-fb66-4fdb-8596-9254b447062a)

### Installation des paquets nécessaires et création des LVMs

Installez les paquets nécessaires pour le chiffrement et la gestion des LVMs :

```bash
apt install cryptsetup lvm2
apt update
```

1. **Chiffrez la partition** : Utilisez LUKS pour chiffrer `/dev/sda5`.

    ```bash
    cryptsetup luksFormat /dev/sda5
    ```

2. **Ouvrez la partition chiffrée** :

    ```bash
    cryptsetup luksOpen /dev/sda5 crypt
    ```

3. **Créez un volume physique LVM sur la partition chiffrée** :

    ```bash
    pvcreate /dev/mapper/crypt
    ```

4. **Créez un groupe de volumes** :

    ```bash
    vgcreate LVMGroup /dev/mapper/crypt
    ```

5. **Créez les volumes logiques** : (Les tailles des volumes sont données à titre d'exemple, ici 100M).

    ```bash
    lvcreate -L 100M -n root LVMGroup
    lvcreate -L 100M -n swap LVMGroup
    lvcreate -L 100M -n srv LVMGroup
    lvcreate -L 100M -n home LVMGroup
    lvcreate -L 100M -n var LVMGroup
    lvcreate -L 100M -n tmp LVMGroup
    lvcreate -L 100M -n var-log LVMGroup
    ```

6. **Formatez les volumes logiques**.

7. **Montez les volumes logiques**

### Vérification des LVMs créés

- **Avec la commande `lsblk`** :

    ![image](https://github.com/user-attachments/assets/d586204c-56d3-40e2-af0b-b9098903bf25)

- **Avec la commande `blkid` pour voir les UUIDs** :

    ![image](https://github.com/user-attachments/assets/60aa0cf4-f282-47fe-b7cc-af83e2b45244)

- **Correspondance des UUIDs dans `/etc/fstab`** :

    ![image](https://github.com/user-attachments/assets/46de52e1-c30b-425b-b523-0e90b1159592)

### [Problème]

### Suppression d'une LVM

1. **Vérifiez si elle est montée** :

    ```bash
    lsblk
    ```

2. **Si montée, démontez-la** :

    ```bash
    umount /dev/LVMGroup/xxxx
    ```

3. **Désactivez le swap (si c'est une partition swap)** :

    ```bash
    swapoff /dev/LVMGroup/swap
    ```

4. **Supprimez la LVM** :

    ```bash
    lvremove /dev/LVMGroup/xxxx
    ```

## Installation de paquets essentiels

Installez les paquets SSH, Git, UFW, Vim et Sudo :

```bash
apt install ssh git ufw vim sudo
dpkg -l apparmor ssh git ufw vim sudo
```

![image](https://github.com/user-attachments/assets/e7407b4c-0933-4865-ab58-d0e163733bab)

## Création d'utilisateurs et groupes

1. **Ajouter des utilisateurs** :

    ```bash
    sudo useradd user1
    sudo useradd user2
    sudo useradd adminuser
    ```

2. **Définir un mot de passe pour chaque utilisateur** :

    ```bash
    sudo passwd user1
    sudo passwd user2
    sudo passwd adminuser
    ```

3. **Créer un groupe `cyber`** :

    ```bash
    sudo groupadd cyber
    ```

4. **Ajouter `adminuser` au groupe `cyber`** :

    ```bash
    sudo usermod -aG cyber adminuser
    ```

5. **Vérifier les groupes de `adminuser`** :

    ```bash
    groups adminuser
    ```

### Résultats attendus après les commandes `getent passwd` et `getent group`

![image](https://github.com/user-attachments/assets/256bfa75-f571-448c-8289-90141c9889e8)
![image](https://github.com/user-attachments/assets/9148f72b-1dad-4bd3-968e-d0769a34c487)

### Configuration du groupe `admins` et du répertoire `/data`

1. **Créer le groupe `admins`** :

    ```bash
    sudo groupadd admins
    ```

2. **Ajouter `adminuser` au groupe `admins`** :

    ```bash
    sudo usermod -aG admins adminuser
    ```

3. **Créer le répertoire `/data`** :

    ```bash
    sudo mkdir /data
    ```

4. **Changer le groupe propriétaire de `/data` pour `admins`** :

    ```bash
    sudo chown :admins /data
    ```

5. **Configurer les permissions d'accès à `/data`** :

    ```bash
    sudo chmod 770 /data
    ```

#### Résultats attendus après les commandes `ls -ld /data` et `getfacl /data`

![image](https://github.com/user-attachments/assets/85b700d4-7a93-46c7-b68d-5279166757c0)
![image](https://github.com/user-attachments/assets/cdd16a0f-a5d1-4353-8a67-92f959807670)

### Configuration du service SSH

1. **Modifier la configuration de SSH** pour le faire fonctionner sur le port **4242** et désactiver la connexion root.

    - Ouvrez le fichier de configuration avec `nano` ou `vim` :

      ```bash
      sudo nano /etc/ssh/sshd_config
      ```

2. **Configurer le port SSH sur 4242** :

    - Trouvez et modifiez la ligne suivante :

      ```bash
      Port 4242
      ```

3. **Désactiver la connexion SSH pour l'utilisateur `root`** :

    - Trouvez la ligne `PermitRootLogin` et modifiez-la ainsi :

      ```bash
      PermitRootLogin no
      ```

4. **Redémarrer le service SSH** :

    ```bash
    sudo systemctl restart ssh
    ```

### Résultats attendus après la modification de `sshd_config` et la commande `ss -tuln | grep 4242`

![image](https://github.com/user-attachments/assets/8ba7bbc1-f1c4-4d46-935b-3adb6bdb090b)
![image](https://github.com/user-attachments/assets/739a2c79-dfe9-46fe-8cf4-8d3188f116df)

### Ouverture du port 4242 dans UFW

1. **Autorisez le port 4242** :

    ```bash
    sudo ufw allow 4242/tcp
    ```

2. **Vérifiez l'état d'UFW** :

    ```bash
    sudo ufw status
    ```

    - Si UFW n'est pas activé, activez-le avec :

      ```bash
      sudo ufw enable
      ```

![image](https://github.com/user-attachments/assets/9f9932aa-f987-4035-8221-76557def3e47)

## Changement du hostname

1. **Changer le hostname avec `nano`** :

    - Modifiez les fichiers `/etc/hostname` et `/etc/hosts` pour définir le nouveau hostname, par exemple **nanalinux**.

    ```bash
    sudo nano /etc/hostname
    sudo nano /etc/hosts
    ```

![image](https://github.com/user-attachments/assets/5516d60a-3272-4592-bb44-bec754f84bb0)
![image](https://github.com/user-attachments/assets/05eeb741-6195-4602-91fa-a7712b338e15)


## Configuration des paramètres de gestion des mots de passe

### Définir la durée maximale de validité des mots de passe

Pour forcer les utilisateurs à changer leur mot de passe tous les 90 jours, utilisez la commande suivante :

```bash
sudo chage --maxdays 90 <utilisateur>
```

Remplacez `<utilisateur>` par le nom du compte utilisateur que vous souhaitez configurer.

### Définir la durée minimale avant le changement de mot de passe

Pour empêcher un utilisateur de changer son mot de passe plus d'une fois tous les 7 jours, configurez ce paramètre :

```bash
sudo chage --mindays 7 <utilisateur>
```

### Définir le délai d'avertissement avant l'expiration du mot de passe

Pour avertir les utilisateurs 7 jours avant l'expiration de leur mot de passe, utilisez la commande suivante :

```bash
sudo chage --warndays 7 <utilisateur>
```

### Conseils de sécurité supplémentaires

Il est recommandé de définir un umask de **077** dans le fichier `/etc/login.defs` pour améliorer la sécurité des fichiers créés par les utilisateurs.

Pour cela, éditez le fichier `/etc/login.defs` avec un éditeur de texte :

```bash
sudo nano /etc/login.defs
```

Ajoutez ou modifiez la ligne suivante :

```bash
UMASK 077
```
### Changement du fichier `/etc/pam.d/common-password` et résultat de la commande `chage -l <utilisateur>`

![image](https://github.com/user-attachments/assets/59c70a30-5f6b-4c99-9502-79cc6b3f5942)
![image](https://github.com/user-attachments/assets/85e6d8f9-c6b0-4201-aaa5-4aec63217097)

## Configuration stricte de sudo

### Configurer sudo selon une pratique stricte

1. **Modifier le fichier `/etc/sudoers`** : Ce fichier permet de configurer les permissions `sudo` de manière stricte. Pour l'éditer, utilisez l'éditeur sécurisé `visudo` :

    ```bash
    sudo visudo
    ```

2. **Vérifiez que les logs des commandes `sudo` sont enregistrés dans `/var/log/sudo`**. Cela permet d'auditer les actions exécutées avec `sudo`.

    - Si ce n'est pas déjà configuré, assurez-vous que la ligne suivante est présente dans le fichier `/etc/sudoers` pour consigner l'utilisation de `sudo` :

      ```bash
      Defaults        logfile="/var/log/sudo/sudo.log"
      ```

3. **Vérifiez le fichier `/var/log/sudo/`** pour auditer les commandes exécutées avec `sudo`.

### Résultats attendus

- **Fichier `/etc/sudoers` strictement configuré** :

    ![image](https://github.com/user-attachments/assets/622a703b-0564-44ee-9b91-5b7bafde8289)

- **Logs des commandes `sudo` dans `/var/log/sudo/`** :

## Résultat scripts et configuration

### Résultat script monitoring.sh

![image](https://github.com/user-attachments/assets/dd9f2557-8610-46f9-8957-db3d9bfbec5f)


### Script Save

![Capture d'écran 2024-10-18 152120](https://github.com/user-attachments/assets/0298bc39-b80c-4767-8884-1247e62148ef)


### Ligne de commande cron automatisation

![Capture d'écran 2024-10-18 151523](https://github.com/user-attachments/assets/f3eeedcc-7209-497f-afbb-45ad28d680d7)


### Fichiers config services

#### Nettoyage

![Capture d'écran 2024-10-18 152316](https://github.com/user-attachments/assets/929017a4-fa20-4cdb-8719-54f93937cfc2)

#### Service

![Capture d'écran 2024-10-18 151945](https://github.com/user-attachments/assets/3c7aad88-34bc-4fd0-a3b7-836257cf9b9d)


#### Timer

![Capture d'écran 2024-10-18 152746](https://github.com/user-attachments/assets/414705ad-bfb2-4b15-8582-ec1f49f9d9de)

## ! Le SCRIPT est dans le fichier monitoring.sh dans le même dossier !

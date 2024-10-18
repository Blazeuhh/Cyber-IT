## TP FINAL MODULE 1

#### On fait des LVMs pour la partition sda 5 en ligne de commandes :

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

### Normalement cela devrait ressemble à ceci avec la commande lsblk :

 ![image](https://github.com/user-attachments/assets/d586204c-56d3-40e2-af0b-b9098903bf25)

### Avec la commande blkid pour voir les UID :

![image](https://github.com/user-attachments/assets/60aa0cf4-f282-47fe-b7cc-af83e2b45244)

### Problèmes :

#### Si jamais vous avez envie de supprimer une LVM vérifier d'abord si elle est pas monté

`lsblk`

#### Si elle est monté faites la commande suivante :

`umount /dev/LVMGroup/xxxx`

#### Désactivez le swap (si c'est une partition swap )  :

`swapoff /dev/LVMGroup/swap`

#### Ensuite retirez la LVM souhaité

`lvremove /dev/LVMGroup/xxxx`





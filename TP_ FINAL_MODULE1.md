## TP FINAL MODULE 1

On fait des LVMs 

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

5. Créer les volumes logiques :
   ```
   lvcreate -L 100M -n root LVMGroup
   lvcreate -L 100M -n swap LVMGroup
   lvcreate -L 100M -n srv LVMGroup
   lvcreate -L 100M -n home LVMGroup
   lvcreate -L 100M -n var LVMGroup
   lvcreate -L 100M -n tmp LVMGroup
   lvcreate -L 100M -n var--log LVMGroup
   ```

7. Formater les volumes logiques avec le système de fichiers approprié.

8. Monter les volumes logiques aux points de montage corrects.


![image](https://github.com/user-attachments/assets/d586204c-56d3-40e2-af0b-b9098903bf25)


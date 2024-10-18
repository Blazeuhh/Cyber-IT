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

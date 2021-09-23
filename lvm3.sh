#!/bin/bash
for x in "${@}"
do
sudo pvcreate $x
echo "physical volumes created"
done
echo "crosscheck the disk striping"
sudo lvs -o+lv_layout,stripes
echo " "
sudo vgs 
read -p 'enter the volume group that needs to be extended' vg
sudo vgextend $vg $@
sudo vgs
echo "volume group has been extended"
read -p 'Enter the number of file systems whose size needs to be increased' Number
for ((i=1; i<=${Number}; i++)) 
do 
df -h
echo " "
read -p 'enter the file system name' LVM
echo " "
read -p 'enter the size in gb that has to be added' Size
sudo lvextend -L +${Size}G $LVM
sudo xfs_growfs $LVM
echo " "
done
df -h
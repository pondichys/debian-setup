# Arch-like Debian installation

This procedure describes how to install Debian Linux using an archlinux like experience.

Additional info

[Tune LUKS Parameters for Unlock Speed in GRUB - Gentoo Configuration Guide: Full Disk LUKS2 with GRUB and systemd](https://leo3418.github.io/collections/gentoo-config-luks2-grub-systemd/tune-parameters.html)

Download the a Debian live ISO image. Downloading a live image enables to boot and work in a desktop environment to ease copy/paste during the installation process. I use the XFCE live image but any live image is ok.

## Boot on the iso

```bash
# Open a terminal and switch to root
sudo -i

# Install some tools
apt update && apt install debootstrap cryptsetup arch-install-scripts gdisk -y
```

# Create partitions
Partition layout for EFI system
- partition 1 for EFI
- partition 2 for encrypted btrfs root

```bash
# List the existing devices
# Allows you to select the correct device to setup the partitions
lsblk

# In this example we'll use /dev/vda for a VM or /dev/nvme0n1 for bare metal
# export DISK_DEVICE="/dev/vda"
export DISK_DEVICE="/dev/nvme0n1"
# Create a first partition for EFI
sgdisk -n1::+1G -t1:EF00 -c1:'EFI' ${DISK_DEVICE}
# Create a second partition for root file system
# As we use BTRFS subvolumes, no need to create multiple separate partitions
sgdisk -n2:: -t2:8300 -c2:'DEBIAN' ${DISK_DEVICE}
# Check the results
sgdisk -p ${DISK_DEVICE}
```

# Encrypt the partition (no LVM)

```bash
# Get device names from lsblk output
lsblk
# Store device names into variable
# export EFI_PART='/dev/vda1'
# export LINUX_PART='/dev/vda2'
export EFI_PART='/dev/nvme0n1p1'
export LINUX_PART='/dev/nvme0n1p2'
export DM="cryptroot"

cryptsetup luksFormat ${LINUX_PART} \
--type luks2 \
--label ROOT \
--pbkdf pbkdf2 \
--pbkdf-force-iterations 500000
# Enter the passphrase twice and confirm by typing YES

# Open the LUKS partition to create the file systems
cryptsetup luksOpen ${LINUX_PART} ${DM}
```

# Create the file systems

```bash
# Create EFI file system
mkfs.fat -F 32 -n EFI ${EFI_PART}

# Create the BTRFS file system
mkfs.btrfs -L DEBIAN /dev/mapper/${DM}
```

# Create directories and subvolumes

```bash
# Set BTRFS mount options
export BTRFS_OPTS="noatime,compress=zstd,discard=async"

# Mount BTRFS root on /mnt
mount -o ${BTRFS_OPTS} /dev/mapper/${DM} /mnt

# Create BTRFS subvolumes
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@opt
btrfs su cr /mnt/@root
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@varcache
btrfs su cr /mnt/@varlog
# Containers
# btrfs su cr /mnt/@containers
# libvirt
# btrfs su cr /mnt/@images #/mnt/var/lib/libvirt

umount /mnt

# Mount /mnt using @ BTRFS subvolume
mount -o ${BTRFS_OPTS},subvol=@ /dev/mapper/${DM} /mnt

mkdir -pv /mnt/boot/efi
mkdir -v /mnt/{home,.snapshots,opt,root,tmp}
mkdir -pv /mnt/var/{cache,log}
# mkdir -pv /mnt/var/lib/containers

mount -o ${BTRFS_OPTS},subvol=@home /dev/mapper/${DM} /mnt/home
mount -o ${BTRFS_OPTS},subvol=@snapshots /dev/mapper/${DM} /mnt/.snapshots
mount -o ${BTRFS_OPTS},subvol=@varcache /dev/mapper/${DM} /mnt/var/cache
mount -o ${BTRFS_OPTS},subvol=@varlog /dev/mapper/${DM} /mnt/var/log
mount -o ${BTRFS_OPTS},subvol=@tmp /dev/mapper/${DM} /mnt/tmp
mount -o ${BTRFS_OPTS},subvol=@opt /dev/mapper/${DM} /mnt/opt
mount -o ${BTRFS_OPTS},subvol=@root /dev/mapper/${DM} /mnt/root
# mount -o ${BTRFS_OPTS},subvol=@containers /dev/mapper/${DM} /mnt/var/lib/containers
# mount -o ${BTRFS_OPTS},subvol=@images /dev/mapper/${DM} /mnt/var/lib/libvirt/images

# Mount /boot/efi
mount -o noatime ${EFI_PART} /mnt/boot/efi

# Check that everything looks ok
df -h
```

# Install the system

```bash
debootstrap --arch amd64 --include=vim bookworm /mnt http://deb.debian.org/debian

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Set up APT repositories
export CODENAME="bookworm"
#stable, non-free, backports
cat > /mnt/etc/apt/sources.list << EOF
deb http://deb.debian.org/debian ${CODENAME} main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian ${CODENAME} main contrib non-free non-free-firmware

deb http://deb.debian.org/debian-security/ ${CODENAME}-security main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian-security/ ${CODENAME}-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian ${CODENAME}-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian ${CODENAME}-updates main contrib non-free non-free-firmware

deb http://deb.debian.org/debian ${CODENAME}-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian ${CODENAME}-backports main contrib non-free non-free-firmware
EOF

# Enter chroot
LANG=C.UTF-8 arch-chroot /mnt /bin/bash

# Update
apt update
# Install kernel from backports
apt install -y linux-image-amd64/${CODENAME}-backports \
 linux-headers-amd64/${CODENAME}-backports
 
# Install base system
apt install -y firmware-iwlwifi firmware-linux firmware-linux-nonfree \
micro bash-completion command-not-found plocate usbutils hwinfo \
btrfs-progs cryptsetup-initramfs fonts-terminus

# Set your timezone
dpkg-reconfigure tzdata

# Install networking - network-manager-gnome is needed to get nm-applet tray icon
apt install -y network-manager \
network-manager-gnome 

# Setup host name
HOSTNAME="debian-yoga"
echo "${HOSTNAME}" > /etc/hostname

TAB="$(printf '\t')"
cat > /etc/hosts << EOF
127.0.0.1${TAB}localhost ${HOSTNAME}
::1${TAB}${TAB}localhost ip6-localhost ip6-loopback
fe00::0${TAB}${TAB}ip6-localnet
ff00::0${TAB}${TAB}ip6-mcastprefix
ff02::1${TAB}${TAB}ip6-allnodes
ff02::2${TAB}${TAB}ip6-allrouters
EOF

# Set locales
apt install locales
dpkg-reconfigure locales

# Configure keyboard if using non US layout
apt install console-setup
dpkg-reconfigure keyboard-configuration

# Setup root password
# root user can be locked later on using passwd -l root
passwd root

# Optional - create additional user
useradd -m seb
usermod -aG cdrom,floppy,audio,dip,video,plugdev,netdev seb
passwd seb

# Install doas or sudo
# doas
# apt install -y opendoas
# echo "permit seb" > /etc/doas.conf

# sudo
apt install -y sudo
usermod -aG sudo seb
```

## Encryption settings

```bash
export LUKS_UUID=$(blkid -s UUID -o value $LINUX_PART)
export cryptkey=/etc/keys/root.key
```

Create key file to avoid entering the passphrase 2 times at boot

```bash
mkdir -m0700 /etc/keys
umask 0077 && dd if=/dev/urandom bs=1 count=64 of=${cryptkey} conv=excl,fsync
cryptsetup luksAddKey $LINUX_PART ${cryptkey}

# Create /etc/crypttab
cat <<EOF >> /etc/crypttab
${DM} UUID=${LUKS_UUID} ${cryptkey} luks,discard,keyslot=1
EOF

# In /etc/cryptsetup-initramfs/conf-hook, set KEYFILE_PATTERN to a glob(7) expanding to the key path names to include to the initramfs image.
echo "KEYFILE_PATTERN=\"/etc/keys/*.key\"" >>/etc/cryptsetup-initramfs/conf-hook
# In /etc/initramfs-tools/initramfs.conf, set UMASK to a restrictive value to avoid leaking key material. See initramfs.conf(5) for details.
echo UMASK=0077 >> /etc/initramfs-tools/initramfs.conf
# Finally re-generate the initramfs image, and double-check that it 1/ has restrictive permissions; and 2/ includes the key.
update-initramfs -u 

# Check that the key file is part of initramfs
stat -L -c "%A  %n" /initrd.img
-rw-------  /initrd.img

lsinitramfs /initrd.img | grep "^cryptroot/keyfiles/"
cryptroot/keyfiles/${DM}.key
```

# Setup bootloader

```bash
apt install -y grub-efi-amd64
# Configure /etc/default/grub for encryption support
echo "GRUB_ENABLE_CRYPTODISK=y" >> /etc/default/grub
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 cryptdevice=UUID=${LUKS_UUID}:${DM} root=\/dev\/mapper\/${DM}\"/" /etc/default/grub

echo 'GRUB_PRELOAD_MODULES="part_gpt part_msdos cryptodisk luks btrfs"' >> /etc/default/grub
# Optional graphics-related grub settings
echo 'GRUB_GFXPAYLOAD=keep' >> /etc/default/grub
echo 'GRUB_TERMINAL=gfxterm' >> /etc/default/grub
echo 'GRUB_GFXMODE=1920x1080x32' >> /etc/default/grub

update-grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi
```

# Finish the installation

```bash
apt clean
# Exit CHROOT
exit

# Reboot
reboot
```

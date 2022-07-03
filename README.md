# Arch Linux Installation Considerations

Following steps are already on [arch wiki](https://wiki.archlinux.org/title/Installation_guide)
page, but they are simplified for my personal use.  

Feel free to use them for your own but beware of differences between my system and yours.  
For example, if you have NVME storage drives on your laptop, you system might name your drives
`nvme0n1` as well, but they also might be named like `sda`, etc. So you need to customize 
these steps too.

I don't regularly reinstall Arch Linux, I do it once in two or three years, not because
it fails to be as operative as it was back in its first day, but because I make my systems a mess
time to time. That is, I make mistakes which Windows users might not be able to do so.
And yes, Linux users might have this habbit of cleaning their system by reinstalling
Linux time to time, it's because they usually learn to use it more appropriately and
more expertly in time which is rare between Windows users. And of course the reason to
all of this is due to the complexity of Linux systems and how long it takes to know them
very well, which for me it seems to take forever.

## Installation

Based on my experience, wireless devices seem to be blocked by `rfkill` after live boot
of Arch Linux for installation.

```sh
rfkill list
rfkill unblock <n>
ip link set wlan0 up
```

Connect to a wireless using `iwctl` by following these commands:

```sh
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect <BSSID>
dhclient
ping archlinux.org
```

After you're connected to the network, update your system's time:

```sh
timedatectl set-ntp true
```

Now partition your system:

```sh
fdisk /dev/nvme0n1
```

Make sure fdisk is set on **gpt partition table**. If it's not, just hit **g**.  
Assuming you have 1TB of NVME storage drive, partition as follows:

* uefi:  /dev/nvme0n1p1 (300M)
* swap:  /dev/nvme0n1p2 (4G)
* linux: /dev/nvme0n1p3 (300G)
* home:  /dev/nvme0n1p4 (rest)

Now make file systems:

```sh
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mkfs.ext4 /dev/nvme0n1p4
```

And mount them accordingly:

```sh
mount /dev/nvme0n1p3 /mnt
mount --mkdir /dev/nvme0n1p2 /mnt/boot
mount --mkdir /dev/nvme0n1p4 /mnt/home
swapon /dev/nvme0n1p2
```

Now that partitions are ready to be used, Linux can be installed on them:

```sh
pacstrap /mnt base linux linux-hardened linux-firmware sof-firmware amd-ucode amd-headers grub efibootmgr
```

You might also need these packages:  
**NOTE:** there will be Gnome Desktop installed on your system afterwards.

```sh
pacstrap /mnt vim amvlk base-devel fakeroot cargo fprintd ntfs-3g sudo make cmake git vlc tor firefox net-tools openssh man man-db man-pages gnome networkmanager eog rsync evince acpi mutt telegram-desktop virtualbox virtualbox-guest-iso virtualbox-guest-utils virtualbox-host-modules-arch linux-headers 
```

Then generate file system table for next reboot:

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

Now chroot into the Linux installed partition:

```sh
arch-chroot /mnt
```

Setup your time zone and verify your system time by `date` command:

```sh
ln -s /usr/share/zoneinfo/<Region>/<City> /etc/localtime
hwclock --systohc
date
```

Uncomment `en_US.UTF-8` in '/etc/locale.gen' and then execute:

```sh
locale-gen
```

Setup system language:

```sh
echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
```

And your host name which will be seen on your prompt `user@hostname`:

```sh
echo '<hostname>' > /etc/hostname
```

Now this is not necessary, but it would be when you make LVM, RAID, or LUKS
configuration:

```sh
mkinitcpio -P
```

This is where micro code, grub and efibootmgr is needed so that system can boot on newly
installed Linux:

```sh
grub-install --target x86_64-efi --efi-directory /boot --bootloader-id GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

Create users and set passwords:

```sh
passwd
useradd -m <username>
passwd <username>
```

Now unmount all partitions:

```sh
exit
umout -R /mnt
reboot
```

After reboot, enable services:

```sh
systemctl enable --now sshd
systemctl enable --now tor
systemctl enable --now gdm
```

## PC Speaker

You might realize that Arch Linux makes a lot of loud beeps because of PC speaker module. To disable it, driver should be blocked:

```sh
rmmod pcspkr
echo 'blacklist pcspkr' > /etc/modprobe.d/pcspkr.conf
```

## VirtualBox Kernel Module

You might face problems when running a virtual machine instance, VirtualBox complaining that module is not loaded. This is simple to fix by loading its module:

```sh
modprobe vboxdrv
```


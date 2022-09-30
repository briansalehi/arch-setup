# Arch Linux Installation Considerations

Following steps are already on
[arch wiki](https://wiki.archlinux.org/title/Installation_guide)
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

First you need to make sure that **Secure Boot** is disabled on your system.

Then, check if Arch Linux live booted in UEFI mode. If not, reboot and change boot mode on your system:

```sh
ls /sys/firmware/efi/efivars
```

Based on my experience, wireless devices seem to be blocked by `rfkill` on Arch Linux live boot, so you need to check if they are blocked and unblock them if necessary:

```sh
rfkill list             # check if wlan0 is blocked
rfkill unblock all      # specify wlan0 or all to unblock
ip link set wlan0 up    # also set the interface up for use
```

When interface is prepared, connect to a wireless using `iwctl` by following these commands:

```sh
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl station wlan0 connect <BSSID>     # replace BSSID with access point name
dhclient                                # just to make sure you got an ip
ping archlinux.org                      # check if you're connected to network
```

After you're connected to the network, update your system's time:

```sh
timedatectl set-ntp true
```

Now partition your system:

```sh
fdisk /dev/nvme0n1
```

Make sure `fdisk` is set on **gpt partition table**. If it's not, just hit **g**.  
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

Now that partitions are ready to be used, but before installing the Linux itself, there's a small chance that `pacman` has outdated keyrings.
To make sure no errors will occur during installation, just update keyring:

```sh
pacman -Sy archlinux-keyring
```

Now Linux packages can be installed on the mounted partition:

```sh
pacstrap /mnt base linux linux-headers linux-firmware linux-hardened sof-firmware amd-ucode amd-headers grub efibootmgr
```

You might also need these packages:  
**NOTE:** there will be Gnome Desktop installed on your system afterwards.

```sh
pacstrap /mnt wget curl vim nftables amvlk base-devel fakeroot cargo fprintd ntfs-3g sudo make cmake git vlc tor firefox net-tools openssh man man-db man-pages gnome networkmanager eog rsync evince acpi mutt telegram-desktop virtualbox virtualbox-guest-iso virtualbox-guest-utils virtualbox-host-modules-arch linux-headers xclip
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

Uncomment `en_US.UTF-8` in `/etc/locale.gen` and then execute:

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

Now this is not necessary, but it would be if you have made LVM, RAID, or LUKS configurations, see `mkinitcpio.conf(5)`:

```sh
mkinitcpio -P
```

This is where `amd-ucode`, `grub` and `efibootmgr` is needed so that the system can boot:

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

And give users privileges using `visudo` command, so that you won't have to log into the `root` user anymore.

Also if this is a remote server, configure SSH so that service is on different port and `root` login cannot be made.

Now go back to live boot shell and unmount all partitions:

```sh
exit
umout -R /mnt
reboot
```

After reboot, enable desired services:

```sh
systemctl enable --now sshd
systemctl enable --now tor
systemctl enable --now gdm
```

## PC Speaker

You might realize that Arch Linux makes a lot of loud beeps because of PC speaker module. To disable it, `pcspkr` driver should be blocked:

```sh
rmmod pcspkr
echo 'blacklist pcspkr' > /etc/modprobe.d/pcspkr.conf
```

## VirtualBox Kernel Module

You might face problems when running a virtual machine instance, VirtualBox complaining that module is not loaded. This is simple to fix by loading its module:

```sh
modprobe vboxdrv
```


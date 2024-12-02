# LattePanda OpenCore Hackintosh
> Little board, big Mac energy

# Installation

This is a typical Hackintosh setup using OpenCore. If you're not familiar with Hackintoshing, please read [Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/).

## Hardware setup

1. Ensure you have a M.2 SSD installed. macOS will not install on the LattePanda's eMMC.

2. For WiFi, it's highly recommend that you use a M.2 WiFi card with the BCM94360CS chipset [such as this one](https://amzn.to/4dszrgu) which work natively without kexts/hacks/drivers. That said, you can install the [itlwm](https://github.com/OpenIntelWireless/itlwm) project to enable the onboard Intel WiFi, however this will not have AirDrop and will not use the native WiFi network menu. 

## Create install media

1. Download the sonoma installer Sonoma

```sh
softwareupdate --fetch-full-installer --full-installer-version 14.6.1
```

2. Insert a 32GB or larger thumb drive (16GB will be a 200-300MB too small), using Disk Utility, select Erase and format it with Scheme: **GUID Partition map**, and name it `Sonoma`

3. Create a bootable USB drive

```sh
sudo /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/createinstallmedia --volume /Volumes/Sonoma
```

## Setup your `config.plist`


## Install bootloader

1. Find the disk identifier for the USB stick with `diskutil`

```sh
diskutil list
```

Examine the output. For instance, if your output looks like this, the identifier of the EFI partition is `disk4s1`, remember that.

```
/dev/disk4 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *31.9 GB    disk4
   1:                        EFI EFI                     209.7 MB   disk4s1
   2:                  Apple_HFS Install macOS Sonoma    31.6 GB    disk4s2
```

2. Mount the EFI partition of the USB stick (replace the disk identifier in the command below before running it)

```sh
sudo mkdir -p /Volumes/EFI
sudo mount -t msdos /dev/disk4s1 /Volumes/EFI
```

3. Copy in the contents of the repo into the disk:

```sh
cp -r ~/Downloads/LattePandaOpenCoreHackintosh-main/EFI /Volumes/EFI/
```

## Setup BIOS

1. Press the power switch
2. Press Escape to enter setup
3. Under "Save & Exit", select "Restore Defaults"
4. Under "Advanced" -> "CSM Configuration", set "CSM Support" to Disabled
5. Under "Boot" -> "Boot Option #1", select your thumb drive
6. Under "Save & Exit", select "Save Changes and Reset"

## Boot the installer

1. Plug your USB thumb drive into the LattePands
2. Press the power switch (it should boot from your USB)
3. Use the arrow keys to move the cursor to `Install macOS Sonoma`, then press Enter

## Install

Once the installer boots, you're ready to install macOS.

1. Select Disk Utility
2. Find your SSD
3. Click Erase, format it with Scheme: **GUID Partition map**, Format: **Max OS Extended (Journaled)** and name it `Macintosh HD`
4. Quit Disk Utility
5. Click Install macOS Sonoma
6. Click Install
7. Click Agree (right most button)
8. Click `Macintosh HD`
9. Click Install (right most button)
10. Wait. Your machine will restart several times

## Post-install

Once booted, complete installation by going through the macOS Setup Assistant. It's OK if you can't connect to WiFi at this time, just hit continue.

After your isntall is complete and you're booted to the desktop:

1. Install the EFI and bootloader from your USB thumb drive's EFI partition to internal SSD's EFI partition

```sh
sudo mkdir -p /Volumes/EFI
sudo mount -t msdos /dev/disk0s1 /Volumes/EFI
sudo mkdir -p /Volumes/EFIUSB
sudo mount -t msdos /dev/disk2s1 /Volumes/EFIUSB
cp -r /Volumes/EFIUSB/* /Volumes/EFI/
```

If this command fails, your EFI may be at a different disk identifier, use `diskutil list` to find it.

4. Reboot your LattePanda
3. Unplug your USB thumb drive
4. Press Delete to enter setup
5. Select your SSD as the first boot device
6. Save changes and reboot
7. You're done!

## Status

## ✅ Working
* Connectivity
   * WiFi with BCM94360CS card
   * Bluetooth
   * Ethernet
   * USB port mapping
* Services
   * iMessage
   * AirDrop
   * Handoff
* Display
   * eDP out
   * Touchscreen
   * HDMI out
   * HDMI/DP Audio (`OS-X-Fake-PCI-ID`)
   * USB-C to DP
   * Headphone port (`layout-id: 1`)
* Power management
   * Sleep with breathing LED
   * Shutdown without reboot (USB mapping)
   * Battery percentage (CHUWI Minibook battery on 10-pin connector)
      * Says “service recommended”
      * Battery control panel not present
      * Takes 30-60 seconds to recognize power adapter is unplugged
* Bootloader
   * Mouse support
   * Startup chime

## ❌ Not working
* HDMI no longer works, KP (when it did, it was limited to 1920x1080)
* Doesn't wake on keyboard

# LattePanda OpenCore Hackintosh
> Little board, big Mac energy

# Installation

This is a typical Hackintosh setup using OpenCore. If you're not familiar with Hackintoshing, please read [Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/).

## Hardware setup

1. Ensure you have a M.2 SSD installed. macOS will not install on the LattePanda's eMMC.

2. For WiFi, it's highly recommend that you use a M.2 WiFi card with the BCM94360CS chipset [such as this one](https://amzn.to/4dszrgu) which work natively without kexts/hacks/drivers. That said, you can install the [itlwm](https://github.com/OpenIntelWireless/itlwm) project to enable the onboard Intel WiFi, however AirDrop will not work.

## Create install media

You'll need another maching running macOS to create the installation media. If you don't have a machine running macOS, look up a guide for creating install media and copying the EFI folder for your OS.

1. Open the Terminal app and download the Sonoma installer with the following command:

```sh
softwareupdate --fetch-full-installer --full-installer-version 14.6.1
```

2. Insert a 32GB or larger thumb drive (16GB will be a 200-300MB too small), using Disk Utility, select Erase and format it with Scheme: **GUID Partition map**, and name it `Sonoma`

3. Create a bootable USB drive

```sh
sudo /Applications/Install\ macOS\ Sonoma.app/Contents/Resources/createinstallmedia --volume /Volumes/Sonoma
```

## Install bootloader

1. Again in the Terminal app, find the disk identifier for the USB stick with `diskutil`

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

## Setup your `config.plist`

You'll need to generate a new serial number and board ID and edit the `config.plist` provided in this repository. This step assumes your `EFI` drive is still mounted from the previous steps.

1. Open `/Volumes/EFI/EFI/config.plist` in a text editor
2. Search for `PlatformInfo`
3. Under `Generic`, paste the generated values for the following
  * `MLB`
  * `SystemSerialNumber`
  * `SystemUUID`
4. Save changes and shut down

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

## Making the intenral drive bootable

Once booted, complete installation by going through the macOS Setup Assistant. It's OK if you can't connect to WiFi at this time, just hit continue.

After your install is complete and you're booted to the desktop:

1. Install the EFI and bootloader from your USB thumb drive's EFI partition to internal SSD's EFI partition.

```sh
sudo mkdir -p /Volumes/EFI
sudo mount -t msdos /dev/disk0s1 /Volumes/EFI
sudo mkdir -p /Volumes/EFIUSB
sudo mount -t msdos /dev/disk2s1 /Volumes/EFIUSB
cp -r /Volumes/EFIUSB/* /Volumes/EFI/
```

If this command fails, your EFI may be at a different disk identifier, use `diskutil list` to find it.

2. Reboot your LattePanda
3. Unplug your USB thumb drive
4. Press Escape to enter setup
5. Under "Boot" -> "Boot Option #1", select "UEFI OS (your SSD make/model here)"
6. Under "Save & Exit", select "Save Changes and Reset"
7. When the OpenCore picker appears, use the arrow keys to highlight `Macintosh HD`
8. Press `Ctrl + Enter` to boot and set it as the default option. You can change this in the future by pressing `Ctrl + Enter` on a different device.

## Post-installation

This step is necessary to get WiFi working with the BCM94360CS card, enabling full AirDrop and handoff support. If you want to use built-in WiFi, you can [use the OpenIntelWireless itlwm project](https://github.com/OpenIntelWireless/itlwm), but you will not have Airdrop and may have issues with iMessage if using

1. Launch OpenCore-patcher -- macOS will say it can't be opened, click `OK`
2. Open System Settings, search for "Security settings" and select it
3. Under "Security" -> "OpenCore-Patcher, click `Open Anyway` and enter your password
4. macOS will warn you again that it can't be checked for malicious software, click `Open`
5. Enter your password again and OpenCore Legacy Patcher will install additional components
6. Click `Post-Install Root Patch`
7. In the next dialog, you should see "Networking: Modern Wireless" under "Available patches," click `Start Root Patching` to begin the patching process
8. When complete, the "Reboot to apply" dialog will pop up, click `Reboot`

## Power management

You'll likely want to change a few power management settings if you're using the LattePanda with a battery.

1. Open System Preferences
2. Under "Energy Saver," uncheck "Enable Power Nap" and "Wake for network access"
3. Open Terminal, and run `sudo pmset -a tcpkeepalive 0` to prevent the machine from waking up randomly, but also disables "Find My Mac" (which probably won't work right anyway)

## Touchscreen support

Touchscreen support is provided by [VoodooI2CGoodix](https://github.com/lazd/VoodooI2CGoodix/). This EFI uses a custom build that supports one finger scrolling. To drag things, you need to press and hold. Right click must be performed by holding control and tapping. You will want to uncheck "Natural" scroll direction in the "Mouse" system settings preference pane so scrolling goes the correct direction.

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
      * Says “Service recommended”
      * Battery control panel not present
      * Takes 30-60 seconds to recognize power adapter is plugged/unplugged
      * Doesn't show up if booting from battery, must plug in power adapter for it to appear
* Bootloader
   * Mouse support
   * Startup chime

## ❌ Not working
* HDMI no longer works, KP (when it did, it was limited to 1920x1080)
* Doesn't wake on keyboard, must press power switch to wake up

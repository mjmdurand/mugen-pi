# Mugen Pi V2
Install Karaoke Mugen on your Raspberry Pi.

# Tested KM versions
**2023-10-24**
- Raspberry Pi OS with desktop and recommended software (October 10th 2023, 64-bit, Kernel 6.1, Debian 12)
- Nodejs 18
- KM version : 7.1.31
  
# Requirements
- 1x Raspberry Pi 4 model B (4 or 8 go)
- 1x micro SD card*
- 1x USB 3.0 key or disk*

*you can directly install Raspbian OS on USB key but you need to update & set boot with an SD card first

# Install OS
- Download the lastest version of **Raspberry pi OS** on official website : https://www.raspberrypi.org/software/operating-systems/
- Flash your SD Card with Raspberry pi Imager (https://www.raspberrypi.org/software/) or BalenaEtcher (https://www.balena.io/etcher/) as you prefer.
- Finish the basic configuration (set language, network and update OS).

#### WARNING ⚠️ 
You need **Raspberry pi OS [2021-10-30] (bulleyes)** or above to run the latest versions of Karaoke Mugen.

**Raspberry pi OS [2021-05-07] (buster)** can't run KM after 5.0.37 version due to MPV version.
- 5.1.* requires v0.32 of mpv
- v0.29 is currently available on raspi

#### Alternatives OS (not tested)
- Ubuntu : https://ubuntu.com/download/raspberry-pi

# Disable Screen Blanking (optional)
- Raspberry Pi OS will blank the graphical desktop after 10 minutes without user input. You can disable this by changing the 'Screen Blanking' option in the Raspberry Pi Configuration tool, which is available on the Preferences menu.

# Update Boot (optional, on raspi v4 only)
- If you plan to use USB 3.0 (key or disk), you can directly boot on it.
- Open LXTerminal and type command `sudo raspi-config`.
- Go to `8 Update` to update the configuration tool first.
- Go to `6 Advanced Options` then `A7 Bootloader Version` and select `E1 Use the lastest version boot ROM software`.
- Do NOT reset boot ROM and confirm.
- Go to `6 Advanced Options` then `A6 Boot Order` and select `B2 USB Boot (Boot from USB if available, otherwise boot from SD card)`.
- Finish and reboot your raspberry pi (don't worry boot will be a little longer than previously because it's looking for a USB media to boot before switch on SD card).

Congrats, now you can either boot from SD card or USB drive. 
If you wanna use USB 3.0 to boot, just flash your drive (key or disk) with lastest image and use any USB 3.0 port. Of course remove your SD card.

# Build Karaoke Mugen
**You can do all this by SSH if you prefer**

- Open LXTerminal and clone this git with command `git clone https://github.com/mjmdurand/mugen-pi.git`.
- Go into the new folder `cd mugen-pi`
- Launch the install script : `./build-on-rpi.sh`
- Drink a coffee and everything should be fine

# Launch Karaoke Mugen
**You must launch it with the Raspberry pi terminal/Desktop, SSH won't work as Karaoke Mugen manipulate ffmpeg and mpv**
- Just click on the desktop shortcut.

**If shortcut don't work**
- Karaoke Mugen has been installed on your user directory, you just can go into it by using command `cd ~` in LXTerminal.
- Use the command `yarn start` to launch Karaoke Mugen

# Useful things
- You can access to Karaoke Mugen from any peripherical on the same network, just check the raspi IP adress.
-  If port forwarding don't work, use **port 1337** to connect (for example : http://192.168.0.10:1337)
- Welcome Panel is located at `/welcome` : **you can access to anywhere from here**
- Public Panel is located at `/` or `/public`
- Operator Panel is located at `/admin`
- System panel is located at `/system`

- If you wanna customize karaoke options, go on Operator Panel, click on top right karaoke mugen logo and select Options

# To-do list
- Make update script similar to install script to improve User experience
- add ubuntu support for desktop & shortcuts (AKA Gnome)


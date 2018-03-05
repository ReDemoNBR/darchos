# **DArchOS (ARM) Linux Distribution for RPi 2/3**

## Table of Contents
* [Introduction](#introduction)
* [Features](#features)
* [Purpose](#purpose)
* [Drivers and Interfaces](#drivers-and-interfaces)
* [Requirements](#requirements)
* [How to Install](#how-to-install)
* [Credits](#credits)

---

## Introduction
DArchOS is a Linux distribution made on top of [ArchLinux-ARM][ArchLinux ARM],
focusing [Raspberry Pi 2/3 single-board computers][Raspberry Pi].

Developed to have simple installation and configuration with minimal user interaction
for installation, it packs lots of applications to make the system ready for usage
right after the installation.

---

## Features
* **Xfce** Desktop Environment
* **LightDM** GTK+ Greeter Display Manager
* **Pamac** and **Yaourt** package managers, along with the standard **Pacman**
* Hardware specific and generic drivers installation for audio, video and connectivity
* Pre-configurations for:
    * Swapfile
    * tmpfs (temporary file system) resizing
    * Timezone
    * Keyboard layout
    * Locales
* Initial applications for usability, including
    * Web browsers: **Chromium** and **Firefox**
    * Generic Applications: **X-Apps** pack (Pix, Xed, Xplayer, Xreader and Xviewer)
    * Office applications: **LibreOffice** with language packs
    * Media players: **VLC** and **Audacity**
    * Image editors: **GIMP** and **KolourPaint**
    * Email client: **Thunderbird**
    * BitTorrent client: **qBittorrent**
    * Development tools: **Bluefish**, **DbVisualizer**, **openJDK 9** (JDK/JRE), **NodeJS**
* Themes, icons and styles already pre-configured matching **Adapta-Nokto-Eta**
* Raspberry Pi board customization (GPU memory split, overscan and others)
* Custom repositories, such like **ArchStrike** and **archlinuxcn**, with binary packages
* And more... :)

---

## Purpose
After the shutdown of some ArchLinux-based distributions for ARM devices
(such like Manjaro-ARM) due to its difficulty to mantain repositories and packages,
this distribution was created to show it is possible to mantain a simpler distribution
when you use packages from AUR, taking away the weight of the developers that should
mantain binary packages, automated builds, repositories and mirrors.

This system is completely based on ArchLinux-ARM that uses AUR packages and packages
from other distros and repositories with the help of customizepkg package that
automates changes to PKGBUILD files.

It is installed by first installing ArchLinux-ARM with DArchOS script and configuration
files, and then running the script that will convert it to DArchOS by installing
packages and configurations.

---

## Drivers and Interfaces
* Video
    * X.org
    * Mesa
    * Vesa
    * Framebuffer
* Audio
    * Alsa
    * PulseAudio
* Connectivity
    * Blueman
    * Bluez
    * NetworkManager

---

## Requirements
* Raspberry Pi 2 or Raspberry Pi 3 single-board computer
* MicroSD with at least 16GB of storage (32GB or better recommended)
* MicroSD card reader/writer
* Stable network connection or good Wifi connection with WPA/WPA2 security (cabled
connection recommended)
* A working GNU/Linux-based system to format and prepare the MicroSD with DArchOS resources

---

## How to Install
1. Prepare the MicroSD using [DArchOS Prepare][DArchOS Prepare] following its steps
2. Insert the MicroSD in your Raspberry Pi 2/3
3. Apply 5V power to boot the Raspberry Pi
4. Wait for it to install and prepare the system for you (it will reboot when it is done)
— usually take some hours
5. Login with your user and that's it

---

## Credits
This project uses configurations, resources and methods created by its own developers
and contributors and by [Antergos][Antergos], [Arch Linux][ArchLinux],
[ArchLinux-ARM][ArchLinux ARM], [ArchStrike][ArchStrike], [Manjaro][Manjaro] and
[Manjaro ARM][Manjaro ARM] Linux distributions (plus their respective variants) as well.


[Antergos]: https://antergos.com/ "Antergos (Official Site)"
[ArchLinux]: https://www.archlinux.org/ "ArchLinux (Official Site)"
[ArchLinux ARM]: https://archlinuxarm.org/ "ArchLinux-ARM (Official Site)"
[ArchStrike]: https://archstrike.org/ "ArchStrike (Official Site)"
[Manjaro]: https://manjaro.org/ "Manjaro Linux (Official Site)"
[Manjaro ARM]: http://manjaro-arm.org/ "Manjaro-ARM Linux (Official Site)"
[Raspberry Pi]: https://www.raspberrypi.org/ "Raspberry Pi (Official Site)"
[DArchOS Prepare]: https://github.com/ReDemoNBR/darchos-prepare "DArchOS Prepare (on GitHub)"

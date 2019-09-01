GOTO CONFIG

Running RetroPie from SD drive on QEMU
======================================

# Preconditions

* Assumed 64bit Windows 10 as environment in your Host PC
* Micro SD card of 4GB or larger.
* Raspberry PI 3A+

Direct links to versions I have used are given for minimizing possible incompatibility issues.

1. Download and install [QEMU for Windows](https://qemu.weilnetz.de/w64/qemu-w64-setup-20190815.exe)
2. Download Linux [Kernel suitable for QEMU](https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/kernel-qemu-4.4.34-jessie) 
3. Download [Etcher](https://github.com/balena-io/etcher/releases/download/v1.5.56/balenaEtcher-Portable-1.5.56.exe) for installing the RetroPie image to SD card.

# Steps

1. Download latest RetroPie [weekly image](http://files.retropie.org.uk/images/weekly/). I got http://files.retropie.org.uk/images/weekly/retropie-4.5.1-rpi2_rpi3.img.gz
2. Install the image to SD with Etcher.
3. Check with DiskPart what is the number of the SD card drive. In the example below the number is 3.

    ```
    DISKPART> list disk
    
      Disk ###  Status         Size     Free     Dyn  Gpt
      --------  -------------  -------  -------  ---  ---
      Disk 0    Online          465 GB  1024 KB
      Disk 1    Online         7647 MB      0 B
      Disk 2    No Media           0 B      0 B
      Disk 3    Online           28 GB  3072 KB
      Disk 4    No Media           0 B      0 B
    ```
4. Configure the QEMU script accordingly.
```
:CONFIG

set QEMU="c:\program files\qemu\qemu-system-arm.exe"
set KERNEL=kernel-qemu-4.4.34-jessie
set RPI_SD=\\.\PhysicalDrive3

GOTO RUN

5. Now launch the QEMU to boot up from your RetroPie SD card.

:RUN
%QEMU% -kernel %KERNEL% -cpu arm1176 -hda %RPI_SD% -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -nic user,hostfwd=tcp::2222-:22

GOTO EOF

5. Run the following commands:
    ```
    sudo apt update
    sudo apt upgrade
    sudo raspi-config
    ```
5. In `raspi-config`, select Advanced -> Memory split and set value to *348*. 
6. If previous step fails in QEMU (for me it did), you can edit `/boot/config.txt` directly. Comment all lines with `#` that start with `gpu_mem_` and add line `gpu_mem=348` instead.
7. Shut down the QEMU. Insert SD card to RasPi 3A+ and it should boot up to EmulationStation nicely!

:EOF
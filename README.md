# README #

This project enables a D-Link DWM-221 LTE modem to work with the Toradex Colibri iMX6 module running Toradex's Angstrom distribution (but will work for any Linux, afaik)

## Setting up

### OpenEmbedded image

Follow the instructions in https://developer.toradex.com/knowledge-base/board-support-package/openembedded-(core) to generate an image for your module and flash it.
- In your local.conf file, make sure to add the lines:
	- IMAGE_INSTALL_append = "ppp usb-modeswitch usb-modeswitch-data"

### Kernel

It is necessary to enable some drivers in the kernel for the modem to work.

Follow the instructions in https://developer.toradex.com/knowledge-base/build-u-boot-and-linux-kernel-from-source-code to:

Clone the Toradex Linux Kernel repository for your module.

Build the Linux Kernel from source. Enable the following options within _menuconfig_:

    Device Drivers  ---> 
    [*] Network device support  --->
        <*>   PPP (point-to-point protocol) support
        <*>     PPP BSD-Compress compression
        <*>     PPP Deflate compression 
        [*]     PPP filtering
        <*>     PPP MPPE compression (encryption)
        [*]     PPP multilink support 
        <*>     PPP over Ethernet  
        <*>     PPP support for async serial ports
        <*>     PPP support for sync tty ports

    Device Drivers  --->
    [*] USB support  --->
        <*>     USB Modem (CDC ACM) support 
        
    Device Drivers  --->
    [*] USB support  --->
            [*] USB Serial Converter support  --->
                <*>     USB driver for GSM and CDMA modems


Build the kernel and flash it to the module.

### Setting up the device

Plug the modem to a USB port on your board. Make sure a SIM card is inserted into the modem.
Check if the device is detected by the system:

    

    # lsusb
    ...
    Bus 002 Device 019: ID 2001:a401 D-Link Corp. 
    ...
    

Initially, the device is in Mass Storage mode, with vendor id 2001 and product id a401.
We shall switch to modem mode by running:

    # usb_modeswitch -v 2001 -p a401 -W -n -K
    # usb_modeswitch -v 2001 -p a401 -W -n -M 555342435b000000000000000001061e000000000000000000000000000000 -2 555342435c000000000000000001061b000000010000000000000000000000 -3 555342435d000000000000000001061b000000020000000000000000000000


The first line ejects the Mass Storage driver. The second line switches to modem mode.
After running the commands above, check if the product id for the modem changed from a401 to 7e19:


    # lsusb
    ...
    Bus 002 Device 020: ID 2001:7e19 D-Link Corp. 
    ...


It's also possible to add a udev rule to /etc/udev/rules.d/40-usb_modeswitch.rules so that the commands above automatically run when the modem is plugged in.

### Setting up the PPP connection

From the repository directory, run **install.sh**:
'''
chmod +x install.sh
./install.sh
'''

This will:

- Put the file **_options_** into **/etc/ppp/**. This is the PPP configuration file.
- Put **_pap-secrets_** into **/etc/ppp/**. This is the login data for your carrier (Claro, in this example).
- Put **_claro-provider.3g_** into **/etc/ppp/peers/**. These are the carrier configurations.
- Put **_claro-3g.chat_** into **/etc/ppp/chat/**. This will send AT commands to the module in order to establish a connection to the internet.

### Connecting to the internet

Run _pon_ to connect:

    # pon claro-3g.provider


You can check the log file to see connection information. The log file is /home/root/ppp:

    # tail -f /home/root/ppp


If the connection is succesfully established, you can run _ifconfig_ and there'll be a new network interface _ppp0_.

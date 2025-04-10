# WD My Passport Drive Hardware Encryption Utility for Linux

This tool was originally written by [0-duke](https://github.com/0-duke/wdpassport-utils) in 2015 based on reverse engineering research by [DanLukes](https://github.com/DanLukes) and an implementation by DanLukes and [KenMacD](https://github.com/KenMacD/wdpassport-utils). [crypto-universe](https://github.com/crypto-universe/wdpassport-utils) converted this project and the underlying SCSI interface library py_sg to Python 3. [JoshData](https://github.com/JoshData/wdpassport-utils) updated the library to work with the latest WD My Passport device.

The changes made on this fork, include a unlock_wd.sh script, this auto detects the location of the drive and prompts for a password to unlock.

## Installing

You'll need the Python 3 development headers to install this tool. On Ubuntu 22.04 LTS run:

```
sudo apt install python3 python3-dev python3-pip git
```

The unlock_wd.sh script handles creating a virtual environment to execute the code.  It should handle all dependency installs...
```

## Using the unlock_wd.sh Script

For convenience, this repository includes the `unlock_wd.sh` shell script that simplifies the process of unlocking and mounting your WD My Passport drive.

### Basic Usage

```
sudo ./unlock_wd.sh
```

This will:
1. Detect your WD My Passport drive
2. Prompt you for the password
3. Unlock the drive
4. Mount it automatically

### With Device Specification

If you have multiple drives or if auto-detection fails:

```
sudo ./unlock_wd.sh /dev/sdX
```

Replace `/dev/sdX` with the correct device path (e.g., `/dev/sdb`).

### Permissions

Make sure the script is executable:

```
chmod +x unlock_wd.sh
```

You may need to run the script with sudo privileges to access the device.

<h1>Disclaimer</h1>

Use the tool and any of the information contained in this repository at your own risk. The tool was developed without any official documenation from Western Digital on how to manage the drive using its raw SCSI interface. We accept no responsibility.

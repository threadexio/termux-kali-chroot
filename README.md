# Kali Linux full chroot in termux

This is **NOT** [PRoot](https://wiki.termux.com/wiki/PRoot). This uses the native `chroot` feature, which means it requires root permissions.

## Installation

**Important:** Commands shown here that start with `#` must be run as root

### Preparing the rootfs

If you already have a copy of the root filesystem, you can safely skip this section.

-   First you need to find your device's CPU architecture, that can be done with:

    ```
    uname -m
    ```

    Note down the output of the command, you will need this later.

-   On another machine, clone the latest Kali docker image from the [Kali Linux docker hub](https://hub.docker.com/u/kalilinux)

    **NOTE:** You can choose any branch of kali you want by cloning the appropriate docker image and following the same steps.

    ```
    $ sudo docker pull kalilinux/kali-rolling:[your cpu architecture]
    ```

-   After the clone is finished, export the image into an archive with:

    ```
    $ sudo docker image save kalilinux/kali-rolling:[your cpu architecture] -o image.tar
    ```

-   Extract `image.tar` somewhere and there should be a file called `layer.tar`, extract that archive too.

    ```
    $ tar -xvpf image.tar
    $ find . -type f -name layer.tar
    ```

-   That file called `layer.tar` is the root filesystem, you can now transfer this to somewhere on the phone.

### Setting up

-   On termux make a directory somewhere everything will be stored

    ```
    $ mkdir ~/kali
    $ cd ~/kali
    ```

-   Copy the `layer.tar` from the previous section to that directory.

-   Extract `layer.tar` to another directory

    ```
    # mkdir rootfs && cd rootfs
    # tar -xvpf ../layer.tar
    ```

-   Copy all of the scripts inside this repo to that directory

-   Copy `env.sh` to `/etc/profile.d` in the root filesystem

### Thats it

You are ready to test your new Kali installation. Just do:

```
$ sudo ./kali.sh
```

And it should drop you into a bash shell in Kali.

### kali.sh​

This script can be used to:

-   Start and stop kali (`sudo ./kali.sh start` / `sudo ./kali.sh stop`)
-   Start a bash shell inside kali (`sudo ./kali.sh`)

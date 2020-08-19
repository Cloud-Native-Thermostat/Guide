# Install cluster

In this part we will setup Kubernetes cluster using [K3os](https://github.com/rancher/k3os) which is operating system containing [K3s](https://github.com/rancher/k3s) which is minimalised and bit simplified Kubernetes flavour. This meas that after finishing this part you will get fully functional cluster with minimum resource consumption.

## Notes

I have spend quite some time on this part for several reasons. I wanted Raspberry Pi to run 64-bit operating system which is tricky, because offical Raspberry OS was not available at the time I started and even now is not stable release and even then you have to setup all. K3os was obvious choice but it doesn't have straightforward installation for Raspberry Pi. Thanks to [sgielen](https://github.com/sgielen) who created [Raspberry Pi image generator](https://github.com/sgielen/picl-k3os-image-generator). I have used this generator and update it to latest version of [Raspeberry Pi](https://github.com/raspberrypi/firmware/releases) and [K3os](https://github.com/rancher/k3os).

## Prerequisites

1. 3x Raspberry Pi
2. 3x MicroSDHC ( I'm using 'SanDisk MicroSDHC 32GB Extreme A1 UHS-I (V30)' )
3. 3x Cooling case for Raspberry Pi ( I'm using 'Armor Aluminum Alloy Case Protective Shell Metal Enclosure with Dual Fan for Raspberry Pi 4 Model B Only' but I will try 'Argon One Raspberry Pi 4 Case' for next nodes )
4. 1x Ethernet switch
5. 4x Ethernet cabels
6. Docker installed on your system
7. [Raspberry Pi Imager](https://www.raspberrypi.org/downloads/)

## 1. Get Raspberry Pi MAC addresses and assign static IP adresses

You need to burn Raspberry OS to one of your MicroSDHC and insert it into each of your Raspberry Pi and get MAC address of your eth0 interfaces. I would suggest to write numbers using pernament marker on each Raspberry Pi and then note each MAC address from `ifconfig eth0`.

### 🧶 Headless mode

You can do it without attaching monitor by addind empty file named `ssh` to boot partition on your MicroSDHC and then ssh into booted os. You will need access your router to get assigned IP address.

### Assing static IP addresses on your home router

In order to prevent situation when Raspberry Pi will get different IP on each boot you have to make their IP static in DHCP server setting in your home router. Please note this IPs and for sake of simplicity replace all strings in this guide as follows MASTER_1_IP, WORKER_2_IP, WORKER_3_IP with their respective IP addresses.

## 2. Build master image

1. Under this guide find [./config](./config) folder and apply following changes:
   - [ ] Change file names to your MAC addresses you have noted in previous step. Keep order, each config file contain comment to note which Rasperry Pi node number is it.
   - [ ] Set your own ssh public key under `ssh_authorized_keys` ( NOTE: github shortcut notation didn't work for me )
   - [ ] Update `ntp_servers` might be some public ntp server or if your router provide own use that one
2. Run master image build, please note that it take some time to fetch dependencies so go take coffee or stare at something ⏳.

     docker run -e TARGET=raspberrypi -v $PWD/config:/app/config -v $PWD/deps:/app/deps -v $PWD/out:/app/out -v /dev:/dev --privileged docker.io/elmariofredo/picl-k3os-image-generator:v0.2

3. Burn resulting image generated to [out](./out) folder to MicroSDHC using Raspberry Pi Imager and put it into your Rapberry Pi marked as 1.

4. Get kubeconfig file and verify that master is up and running

     ssh rancher@MASTER_1_IP sudo cat /etc/rancher/k3s/k3s.yaml | sed 's/127.0.0.1/MASTER_1_IP/g' >! ~/.kube/config
     export KUBECONFIG=~/.kube/config
     kubectl get nodes
     #> n1     Ready    master   20s   v1.18.6+k3s1

5. Get join token from master node

     ssh rancher@MASTER_1_IP sudo cat /var/lib/rancher/k3s/server/node-token

## 2. Build worker image

1. Update `server_url` under [config](./config) folder for each worker
2. Update `token` under [config](./config) folder for each worker
3. Build image using same command
    
    docker run -e TARGET=raspberrypi -v $PWD/config:/app/config -v $PWD/deps:/app/deps -v $PWD/out:/app/out -v /dev:/dev --privileged docker.io/elmariofredo/picl-k3os-image-generator:v0.2

4. Burn image to rest MicroSDHC using Raspberry Pi Imager and put it into rest of Raspberry Pi.
5. Verify that workers have joined master properly by running `kubectl get nodes` again

## 3. Done 🎩

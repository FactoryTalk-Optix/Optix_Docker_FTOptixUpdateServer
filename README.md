# Deploying FactoryTalk® Optix™ Applications on Docker containers

## Disclaimer

Rockwell Automation maintains these repositories as a convenience to you and other users. Although Rockwell Automation reserves the right at any time and for any reason to refuse access to edit or remove content from this Repository, you acknowledge and agree to accept sole responsibility and liability for any Repository content posted, transmitted, downloaded, or used by you. Rockwell Automation has no obligation to monitor or update Repository content

The examples provided are to be used as a reference for building your application and should not be used in production as-is. It is recommended to adapt the example for the purpose, of observing the highest safety standards.

## Introduction

This repository contains the required files to build and run a Docker Container with the Factory Talk Optix Update Service.
 
> [!NOTE]
> The default user is `admin` and the password is `FactoryTalkOptix`

> [!WARNING]
> Upgrade of the `UpdateServer` via FactoryTalk® Optix™ IDE is not supported, a new container should be built and deployed if upgrading either the Runtime or the IDE

> [!WARNING]
> This procedure involves some good knowledge of Linux systems and Docker containers and it is intended for advanced users

> [!TIP]
> The final container should be set to restart automatically on fail

## Runtime licensing

If no license is activated, the FactoryTalk® Optix™ application will stop after 120 minutes and must be redeployed from FactoryTalk® Optix™ Studio.

Licenses can be offline activated and rehosted using the FactoryTalk® Optix™ Entitlement CLI via offline activation and offline rehosting. This way the entitlement file is stored in the specific place on the platform. While, if the container has internet access, the license can be activated online by passing the license serial number as an environment variable when starting the container.

### Licensing of offline Docker Containers

For offline containers without internet access, licenses can be activated using the FactoryTalk® Optix™ Entitlement CLI through a two-step process: generate activation/rehost request files inside the container, then process them on an online machine to obtain entitlement files. The workflow supports both persistent volume mounting (recommended) and `docker cp` methods for file transfer between container and host. This enables license activation and rehosting without requiring internet connectivity in the production environment.

### Licensing of online Docker Containers

To activate a license and run the container for more than 120 minutes, internet connectivity to the Rockwell Automation cloud must be available at all times.
- If no internet connectivity is available, the FactoryTalk® Optix™ Application will be stopped after 120 minutes and must be deployed again from FactoryTalk® Optix™ Studio
- The license is passed to the container as an environment variable, this variable is then periodically checked to a Rockwell Automation server to check its validity

## Requirements

- FactoryTalk® Optix™ studio installed on  the development machine
  - FactoryTalk® Optix™ version 1.7.0.0 or later for both online and offline licensing support
  - FactoryTalk® Optix™ version 1.4.0.450 or later for online licensing support
- The latest Runtime Tools for Ubuntu x86-64 compatible to the FactoryTalk® Optix™ Studio version you are using to develop the application
- Docker engine must be installed and running

> [!TIP]
> Usage of Ubuntu or Ubuntu Server as host machine is recommended

> [!TIP]
> Refer to the [official documentation](https://docs.docker.com/get-docker/) on how to get Docker running on the host machine

> [!TIP]
> Set users' right to access the Docker socket with either one of these steps if you want to run the container in rootless mode, either by:
> - Changing the socket permissions with: `sudo chmod 666 /var/run/docker.sock` (valid up to next reboot)
> - Configuring the Docker group ([official documentation](https://docs.docker.com/engine/install/linux-postinstall/))
>   - Add the new group: `sudo groupadd docker`
>   - Add the current user to the Docker group: `sudo usermod -aG docker $USER`
>   - Reboot the machine to apply changes


## Container setup

The [container setup](./Docs/container-setup.md) document contains the steps required to build the Docker image with the FactoryTalk® Optix™ Update Server.

## Starting the container

Now that the container is ready, we can run it and deploy the FactoryTalk® Optix™ Application

> [!WARNING]
> FactoryTalk Optix Studio does not allow specifying a custom deployment port. The TCP port `49100` of the update server cannot be mapped to a different port

> [!TIP]
> To run multiple containers, first deploy and start the FactoryTalk Optix Runtime application. Once it's running, unbind port `49100` before starting the next container.

### Starting the container with no license

In this example we will assume that the base image is called `optix-runtime-image`, if you tagged the container with a different name, you may need to adapt the commands

> [!TIP]
> The port mapping argument follows the pattern `-p [host_port]:[container_port]`, in this example we are mapping the host port `49100` to the container port `49100` and the host port `50080` (accessible by pointing to the host machine) to the container port `80` (the internal port where the FactoryTalk Optix application will be exposing the WebPresentationEngine)

- Run in shell: `docker run -itd -p 49100:49100 -p 50080:80 optix-runtime-image`
    - Without a proper license, the runtime will automatically stop after 120 minutes

> [!NOTE]
> The first time the container is started you may see an error message in the logs with something like `spawner: can't find command '/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/FTOptixRuntime'`, this is expected as the FactoryTalk Optix application is not deployed yet to the container.

### Starting the container with an online-validated license

If network connectivity is available, the license can be passed to the container as an environment variable while starting it, this way the license is periodically validated online.

Please refer to the [online licensing](./Docs/online-licensing.md) document for more details about online licensing validation.

### Starting the container with an offline-validated license

If the container does not have internet connectivity, the license can be offline validated by using an offline activation procedure on the container.

Please refer to the [offline licensing](./Docs/offline-licensing.md) document for more details about offline licensing validation.

## Deploy the FactoryTalk® Optix™ Application

Please refer to the [deploy the FactoryTalk® Optix™ Application](./Docs/deploy-optix-application.md) document for the steps required to deploy the application to the running container.

## Check the container status

- Run the following command: `docker ps -a`

```bash
root@ubuntu-VirtualBox:# docker ps -a
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS          PORTS                                             NAMES
************   optix-runtime-image   "/opt/Rockwell_Autom…"   10 minutes ago   Up 10 minutes   0.0.0.0:49100->49100/tcp, 0.0.0.0:50080->80/tcp,  reverent_wilson
```

## Troubleshooting

Please refer to the [troubleshooting](./troubleshooting.md) document for common issues and their solutions.
# Troubleshooting - FactoryTalk® Optix™ Docker Container

<details>
  <summary>I passed a valid license to the online container but the Runtime log says "No license tokens found, FactoryTalk® Optix™ Runtime will be closed in: 120 minutes"</summary>

1. Make sure that the license is valid
    - Verify through FT Hub that the license is available to be used
    - Verify that the size of the license is big enough to run the application (license tokens count >= application tokens count)
2. Investigate the license SDK
    - Open a shell prompt on the host machine
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
    - Browse to `/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/Log/FTOptixLicenseSDK/`
    - Inspect the `FTOptixLicenseSDK.log`
        - Here you should see the error (timeout,  invalid license key, etc.)
        - If there are issues that cannot be solved locally please get in touch with Rockwell Automation Software Tech Support

```bash
root@ubuntu-VirtualBox:# docker ps -a
ONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS                     PORTS                                                                                               NAMES
dfaa01569c9c   ftoptix-container   "/opt/Rockwell_Autom�"   37 seconds ago   Up 36 seconds              0.0.0.0:49100->49100/tcp, :::49100->49100/tcp, 50080/tcp, 0.0.0.0:50080->80/tcp, :::50080->80/tcp   jolly_hofstadter

root@ubuntu-VirtualBox:# docker exec -it jolly_hofstadter bash
root@dfaa01569c9c:~# cd /home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/Log/FTOptixLicenseSDK/
root@dfaa01569c9c:~# cat FTOptixLicenseSDK.log 
[2024-01-31 10:59:17.474] [LicenseSDK] [trace] [LicenseRepository] Called GetValidLicenses(product: Optix, component: Runtime)
[2024-01-31 10:59:17.475] [LicenseSDK] [trace] [GetValidLicenses] License storage contains 0 entitlement(s)
root@dfaa01569c9c:~# 
```
</details>

<details>
  <summary>I activated a valid license on offline container but the Runtime log says "No license tokens found, FactoryTalk® Optix™ Runtime will be closed in: 120 minutes"</summary>

1. Make sure that you have activated the license properly with FTOptix Entitlement CLI
2. Verify the license activation/path etc
    - Open a shell prompt on the host machine
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
    - Run for example `FTOptixEntitlementCli --showInstalledEntitlement --enableVerboseLog` option to list installed entitlements
    - Run for example `FTOptixEntitlementCli --showDetails <entitlementKey> --enableVerboseLog` and verify that specific license is properly activated
3. Investigate the license SDK
    - Open a shell prompt on the host machine
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
    - Browse to `/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/Log/FTOptixLicenseSDK/`
    - Inspect the `FTOptixLicenseSDK.log`
        - Here you should see the error (invalid license key, etc.)
</details>

<details>
  <summary>I want to activate my license in offline container setup</summary>

1. Open shell in the docker container
    - Open a shell prompt on the host platform
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
2. Do the activation steps:
    - Run in the offline container: `FTOptixEntitlementCli --offlineActivate  --entitlementKey AAAAA-BBBBB-CCCCC-DDDDD-EEEEE --outputActivationRequestFile /containers/path/to/directory/in/which/activation/request/file/will/be/created --enableVerboseLog`
    - Copy the generated `/containers/path/to/directory/in/which/activation/request/file/will/be/created/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req` file from the container to an online platform to for example `/platform/path/to/directory/in/which/activation/request/file/resides/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req`
    - Run on the online platform: `FTOptixEntitlementCli --onlineActivate --activationRequestFile /platform/path/to/directory/in/which/activation/request/file/resides/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req --outputEntitlementFile /platform/path/to/directory/in/which/entitlement/file/will/be/created --enableVerboseLog`
    - On success - copy the generated `/platform/path/to/directory/in/which/entitlement/file/will/be/created/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.ent` file from the online platform to the container (remember that entitlement are read from special location - Ubuntu: `/opt/Rockwell_Automation/entitlement/`)
    - On failure - inspect the logs on the online platform and contact Rockwell Automation Software Tech Support if needed
</details>

<details>
  <summary>I want to rehost my license in offline container setup</summary>

1. Open shell in the docker container
    - Open a shell prompt on the host platform
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
2. Do the rehost steps:
    - Run in the offline container: `FTOptixEntitlementCli --rehost  --entitlementKey AAAAA-BBBBB-CCCCC-DDDDD-EEEEE --outputRehostRequestFile /containers/path/to/directory/in/which/rehost/request/file/will/be/created --enableVerboseLog` (remember that  entitlement files are stored in special location and should be located there for rehost to work - Ubuntu: `/opt/Rockwell_Automation/entitlement/`)
    - Copy the generated `/containers/path/to/directory/in/which/rehost/request/file/will/be/created/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req` file from the container to an online to for example: `/platform/path/to/directory/in/which/rehost/request/file/resides/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req`
    - Run on the online platform: `FTOptixEntitlementCli --rehost --rehostRequestFile /platform/path/to/directory/in/which/rehost/request/file/resides/AAAAA-BBBBB-CCCCC-DDDDD-EEEEE.req --enableVerboseLog`
    - On success - you should see confirmation that the entitlement was rehosted
    - On failure - inspect the logs on the online platform and contact Rockwell Automation Software Tech Support if needed
</details>

<details>
  <summary>My application crashed, how can I investigate the issue?</summary>

- Access the FactoryTalk® Optix™ Application logs
    - Open a shell prompt on the host machine
    - Identify the container name with `docker ps -a`
    - Connect to the running container with `docker exec -it [container name] bash`
    - Browse to `/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication/Log/`
    - Inspect the `FTOptixRuntime.0.log`
- Contact Rockwell Automation Software Tech Support if needed
</details>

<details>
  <summary>How can I set the container to restart automatically if the UpdateServer fails?</summary>

- Execute the container with: `docker run -itd -p 49100:49100 -p 50080:80 -e ADMIN_PASSWORD=YourSecurePassword -e FTOPTIX_ENTITLEMENT_SERIAL_NUMBER=AAAAA-BBBBB-CCCCC-DDDDD-EEEEE --restart unless-stopped optix-runtime-image`
</details>

<details>
  <summary>How can I make the application folder persistent to avoid deploying my application every time the container starts?</summary>

- Run the container by binding the runtime app path (`/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication`) to a folder on the host machine, for example:

```bash
root@ubuntu-VirtualBox:~# docker run -itd -p 49100:49100 -p 50080:80 -e ADMIN_PASSWORD=YourSecurePassword -e FTOPTIX_ENTITLEMENT_SERIAL_NUMBER=AAAAA-BBBBB-CCCCC-DDDDD-EEEEE -v /home/ubuntu/Documents/FTOptix:/home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication optix-runtime-image

d0bd53d3ef******************************************

root@ubuntu-VirtualBox:~# 
```
</details>

<details>
  <summary>How do I change the deployment password of the UpdateServer?</summary>

The UpdateServer will use the local machine's account to authenticate itself against the FactoryTalk® Optix™ Studio. To change the deployment password you can simply change the password being passed to the container with the `-e ADMIN_PASSWORD=YourSecurePassword` option when running the container.
</details>

<details>
  <summary>I can't download the application, all I see is "wrong username or password"</summary>

- Make sure the container is up and running
- Make sure the port 49100/TCP was exposed
- Make sure the container is reachable
- Make sure the proper user and password were used
</details>

<details>
  <summary>The license is not recognized by the FactoryTalk® Optix™ Application</summary>

- Make sure the license is marked as "Available" in FactoryTalk® Hub®
- Make sure FactoryTalk® Optix™ version 1.7.0.804 or later was used
    - Every FactoryTalk® Optix™ version comes with a specific UpdateServer version
    - Make sure the right UpdateServer version was used
</details>

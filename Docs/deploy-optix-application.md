# Deploy the FactoryTalk® Optix™ Application

This document describes the steps required to deploy a FactoryTalk® Optix™ Application to the Docker container running the FactoryTalk® Optix™ Update Server.

- Prepare your FactoryTalk® Optix™ Application by:
    - Removing the NativePresentationEngine
    - Configure the WebPresentationEngine
        - Set the IP address to `0.0.0.0` (all addresses)
        - Set the Port to `80` (or any value you configured as an internal port of the container run command in the [starting the container](../README.md#starting-the-container) section)
        - Set the Protocol to `http` (or `https` if SSL was configured in the project)

![FT Optix Application preparation](../Images/ftoptix-app-setup.png "FT Optix Application setup")

- Once the application is ready, configure the target with the proper IP Address and username and proceed with the deployment

> [!NOTE]
> The default user is `admin` and the password is `FactoryTalkOptix`

> [!TIP]
> The target IP Address should be the IP of the host machine where the container is running (the container was started in bridge mode)

![Deployment options](../Images/deployment-options.png "Deployment options")

- Proceed with the deployment

![Deploy project](../Images/deploy-project.png "Deploy the project to the target")

- Open the web browser and enter the URL: `http://<container_ip>:50080` (change the port if a different mapping was set in the run command)

![FT Optix Application running](../Images/ftoptix-app.png "FT Optix Application running")


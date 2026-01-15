# Online Licensing for FactoryTalk® Optix™ (Containers)

This guide shows how to run a container that **validates** a license online using an environment variable.

> [!TIP]
> To know more about containers licensing, please refer to the tech note at: [IN41091](https://support.rockwellautomation.com/app/answers/answer_view/a_id/1156588)

## Run with set **FTOPTIX_ENTITLEMENT_SERIAL_NUMBER** environment variable

### Pass the entitlement serial number to the container:

The following command runs the container with the environment variable `FTOPTIX_ENTITLEMENT_SERIAL_NUMBER` set to your license serial number.

```bash
docker run -itd   -p 49100:49100   -p 50080:80   -e FTOPTIX_ENTITLEMENT_SERIAL_NUMBER=AAAAA-BBBBB-CCCCC-DDDDD-EEEEE   --name optix-runtime-container   optix-runtime-image
```

> [!NOTE]
> Replace `AAAAA-BBBBB-CCCCC-DDDDD-EEEEE` with your **valid serial number**.

## Additional Information

- The container **requires Internet access** to validate the license online.
- License is verified with Rockwell Automation cloud **every 30 minutes**.
- If the application stops, the license is automatically **released** back to FactoryTalk® Hub™.
- If the container/app crashes and the license is not released, contact **Rockwell Automation Software Tech Support**.

> [!WARNING]
> If the container has **no Internet** connection or runs without a valid license, the Runtime will work for **120 minutes** and then stop; A fresh deployment will be required to restart it.

## Tips

- Use `--restart unless-stopped` to auto-restart the container.
- To run multiple containers, start the first, unbind **49100**, then start the next.

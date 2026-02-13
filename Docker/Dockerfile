# Base image Ubuntu_22_x64
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

# Install dependencies first and clean up in same layer
RUN apt-get update \
    && apt-get install -y ca-certificates libxcb-cursor0 libglib2.0-bin libltdl7 supervisor -qq \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

# Copy and install RA certificates
COPY Certificates/RockwellAutomation_CA.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Provide fake systemctl because it cannot work on Docker
RUN echo "echo 'systemctl is not supported, please use supervisorctl'" > /usr/bin/systemctl && chmod +x /usr/bin/systemctl

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY Services/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy entrypoint script and make it executable
COPY Scripts/entrypoint.sh /entrypoint.sh
# Fix potential Windows line endings
RUN sed -i 's/\r$//' /entrypoint.sh
# Ensure the entrypoint script is executable
RUN chmod +x /entrypoint.sh

# Copy installer files to temporary folder
WORKDIR /root/app
COPY FactoryTalkOptixRuntimeToolsSetup/FTOptixApplicationUpdateService.Ubuntu*x64*.sh \
     FactoryTalkOptixRuntimeToolsSetup/FTOptixEntitlementCli.Ubuntu*x64*.sh \
     ./

# Install FTOptix services and clean up installers in same layer to reduce image size
RUN chmod +x ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh) \
    && ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh) -s \
    && chmod +x ./$(find FTOptixEntitlementCli.Ubuntu*x64*.sh) \
    && ./$(find FTOptixEntitlementCli.Ubuntu*x64*.sh) --silent \
    && rm -f /root/app/*.sh

# Create admin user (required by Linux Update Service)
RUN addgroup --gid 2000 admin \
    && adduser \
    --uid 1234 \
    --ingroup admin \
    --gecos ""\
    --disabled-password \
    admin \
    && usermod -aG shadow admin

# Set environment variables for headless operation
ENV QT_QPA_PLATFORM=offscreen \
    DBUS_SESSION_BUS_ADDRESS=/dev/null

# Prepare folders and set ownership in single layer
RUN mkdir -p /home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication \
    /var/log/ftoptix \
    && chown -R admin:admin /home/admin/Rockwell_Automation/ \
    /opt/Rockwell_Automation/ \
    /var/log/ftoptix \
    && chmod -R 755 /home/admin/Rockwell_Automation/

# Expose the UpdateServer port (mandatory!)
EXPOSE 49100/tcp
# Expose the WebPresentationEngine port (optional)
EXPOSE 50080/tcp

# Default entry is the UpdateServer
ENTRYPOINT ["/entrypoint.sh"]
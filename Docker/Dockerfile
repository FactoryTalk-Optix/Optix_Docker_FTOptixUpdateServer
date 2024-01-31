# Base image Ubuntu_22_x64
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
# Where we are going to place the files we need
WORKDIR /app
# Setting the entitlement number (optional)
#ENV FTOPTIX_ENTITLEMENT_SERIAL_NUMBER=AAAAA-BBBBB-CCCCC-DDDDD-EEEEE
# Install dependencies
RUN apt-get update && apt-get upgrade -y -qq
RUN apt-get install -y systemctl iputils-ping dmidecode ca-certificates libxcb-cursor0 -qq
RUN apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y
# Import certificates
RUN mkdir -p /usr/local/share/ca-certificates
COPY ../Certificates/RockwellAutomation_CA.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
# Copy the Update Server file
COPY ../UpdateServer/FTOptixApplicationUpdateService.Ubuntu_22_x64.*.sh /app/
# Execute the setup
COPY ../Scripts/container-setup.sh /app/
RUN ls -a
RUN chmod +x /app/container-setup.sh
RUN ./container-setup.sh
WORKDIR /root
RUN rm -rf /app
# Set the default password
RUN echo "root:FactoryTalkOptix" | chpasswd
# Set QT flag to run WebApp
ENV QT_QPA_PLATFORM=offscreen
# Expose the UpdateServer port (mandatory!)
EXPOSE 49100/tcp
# Expose the WebPresentationEngine port (optional)
EXPOSE 50080/tcp
# Set the UpdateServer as entrypoint
ENTRYPOINT ["/opt/Rockwell_Automation/FactoryTalk_Optix/ApplicationUpdateService/bin/FTOptixApplicationUpdateService"]

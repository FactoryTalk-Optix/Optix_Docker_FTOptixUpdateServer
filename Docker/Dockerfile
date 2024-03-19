# Base image Ubuntu_22_x64
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
# Install dependencies and clean output image
RUN apt-get update && apt-get install -y dmidecode ca-certificates libxcb-cursor0 libglib2.0-bin libltdl7 -qq
RUN apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y
# Provide fake systemctl because it cannot work on Docker
RUN echo "echo ''" > /usr/bin/systemctl && chmod +x /usr/bin/systemctl
# Import RA certificate
RUN mkdir -p /usr/local/share/ca-certificates
COPY ../Certificates/RockwellAutomation_CA.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates
# Copy the Update Server file to temporary folder
COPY ../UpdateServer/FTOptixApplicationUpdateService.Ubuntu*x64*.sh /root/app/
# Copy the startup script
COPY ../Scripts/init.sh /root/app/
# Where we are going to place the files we need
WORKDIR /root/app
# Execute the setup
RUN ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh) -s
RUN rm -rf ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh)
# Set the default password
RUN echo "root:FactoryTalkOptix" | chpasswd
# Set QT flag to run WebApp
ENV QT_QPA_PLATFORM=offscreen
# Prepare folder for FactoryTalk® Optix™ Application
RUN mkdir -p ~/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication
# Expose the UpdateServer port (mandatory!)
EXPOSE 49100/tcp
# Expose the WebPresentationEngine port (optional)
EXPOSE 50080/tcp
# Set the UpdateServer as entrypoint
RUN chmod +x /root/app/init.sh
ENTRYPOINT ["/root/app/init.sh"]

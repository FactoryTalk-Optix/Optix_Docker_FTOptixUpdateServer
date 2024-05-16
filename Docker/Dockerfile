# Base image Ubuntu_22_x64
FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]

# Install dependencies and clean output image
RUN apt-get update && apt-get install -y ca-certificates libxcb-cursor0 libglib2.0-bin libltdl7 supervisor -qq
RUN apt-get autoremove -y && apt-get clean -y && apt-get autoclean -y

# Provide fake systemctl because it cannot work on Docker
RUN echo "echo ''" > /usr/bin/systemctl && chmod +x /usr/bin/systemctl

# Import RA certificate
RUN mkdir -p /usr/local/share/ca-certificates
COPY Certificates/RockwellAutomation_CA.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY Services/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the Update Server file to temporary folder
COPY UpdateServer/FTOptixApplicationUpdateService.Ubuntu*x64*.sh /root/app/

# Where we are going to place the files we need
WORKDIR /root/app

# Execute the setup
RUN chmod +x ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh)
RUN ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh) -s
RUN rm -rf ./$(find FTOptixApplicationUpdateService.Ubuntu*x64*.sh)

# Linux Update Service Requires "admin" user
RUN addgroup --gid 2000 admin \
    && adduser \
       --uid 1234 \
       --ingroup admin \
       --gecos ""\
       admin

# Set the default password
RUN echo "admin:FactoryTalkOptix" | chpasswd

# Set QT flag to run WebApp
ENV QT_QPA_PLATFORM=offscreen

# Prepare folder for FactoryTalk® Optix™ Application
RUN mkdir -p /home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication \
    && chown admin:admin /home/admin/Rockwell_Automation/FactoryTalk_Optix/FTOptixApplication

# Expose the UpdateServer port (mandatory!)
EXPOSE 49100/tcp
# Expose the WebPresentationEngine port (optional)
EXPOSE 50080/tcp

# Default entry is the UpdateServer
ENTRYPOINT ["/usr/bin/supervisord"]

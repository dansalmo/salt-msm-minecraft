screen:
  pkg:    
    - installed                               

rsync:
  pkg:
    - installed

zip:
  pkg:
    - installed

# Place MSM config file in /etc
/etc/msm.conf:
  file:
    - managed
    - source: salt://minecraft-server/msm.conf

minecraft:
  user:
    - present
    - shell: /bin/bash
    - home: /home/minecraft
    - password: $6$SALTsalt$i/3wU2MphFCKmL6tvEbmi1Ia04YvAanccd0/Focas.UySlvRIRef4ygLniRnY42IS.9rFtaHczSzZlQddJ2cA.
    - enforce_password: True
    - groups:
      - sudo

# Create options directory
#/dev/shm/msm               #for RAM disk in Ubunut
/opt/msm:
  file.directory:
    - user: minecraft
    - group: users
    - mode: 775
    - makedirs: True
    - recurse:
      - user
      - group

/etc/init.d/msm:
  file.managed:
    - source: salt://minecraft-server/etc/init.d/msm
    - mode: 755

/usr/local/bin/msm:
  file.symlink:
    - target: /etc/init.d/msm

/etc/cron.d/msm:
  file.managed:
    - source: salt://minecraft-server/etc/cron.d/msm
    - mode: 755

sudo msm update --noinput:
  cmd.run

# Start msm as service
msm:
  service:
    - running

# Force cron to reload to include MSM's cron  script
cron:
  service:
    - running
    - reload: True

# Create a jar group to manage current and future Minecraft versions:
sudo msm jargroup create minecraft https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar:
  cmd.run

# Create a new server ...
sudo msm server create Max_server:
  cmd.run

# ... tell it to use the latest of those Minecraft jars:
sudo msm Max_server jar minecraft:
  cmd.run

# Modify server version in servers.properties
sudo sed -i 's/msm-version=.*/msm-version=minecraft\/1.7.5/' /opt/msm/servers/Max_server/server.properties:
  cmd.run

#/opt/msm/servers/Max_server/server.properties:
#  file.managed:
#    - source: salt://minecraft-server/server.properties

# Start the server
sudo msm Max_server start:
  cmd.run

# Move generated worlds to the world storage folder
sudo mv /opt/msm/servers/Max_server/world /opt/msm/servers/Max_server/worldstorage:
  cmd.run

# Create symbolic links to new world
sudo msm Max_server worlds load:
  cmd.run


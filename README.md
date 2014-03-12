This project provides Salt State files of installing MSM and a Minecraft server on a Ubuntu machine.

The contents of this repository must be placed in the /srv/salt directory on the salt-master.  The target machine must be running the salt-minion service.  After the salt.highstate command is executed from the salt-master, the minecraft server will be running and can be managed on the machine using MSM.  

An apache2 web server is also installed and started which will serve a simple web page.


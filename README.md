# CloudRemoteControl
A combination of projects that allow for communication and coordination of freely floating computers that just came into existence

## What?
With VulturePS (https://github.com/naseif/VultrPS) naseif and I created an interface to the vultr api to create virtual computers and provision them with a few things. 
Using this we can easily create a few machines in the cloud and install a few things here and there, but something remains missing:

We need a way so that when a scenario is created the virtual machines can be coordinated and informed about each other.

For example in one scenario we have a developer, a mysql machine and a mail-server. Now wouldn't it be nice if they knew each other?

Another, smaller, problem is, that since we use the startup scripts functionality vultr provides, we lose the ability so see the provisioning progress from outside in the world. This is unfortunate, since we want to be able to start provisioning processes and then get informed when everything is ready for us. 

The solution to both of these problems is actually the same.

## How?
The CloudRemoteControl is mainly a backend which serves an api for messaging between machines and several different clients.

- A client to control the scenario from the machine, where your control script / scenario creation script has been started. That is your "home address" which is probably not part of your scenario. We can call that our "master". Since there can be several different users on the same CloudRemoteControl, they can also have separate masters. So do not think a "master" is the same as the installation of a CloudRemoteControl server.
- A client for windows which will be installed as a system service during the main provisioning on our virtual machines. Running in "admin" mode. Which will give the messages the needed rights to do whatever seems neccessary.
- A client for linux which will be installed as a system service during the main provisioning on our virtual machines. Running in "root" mode. For the same purpose as the windows client has admin rights.

## Scenario startup process

When we start a "scenario", with which we mean a combination of virtual machines that will do something for us, those things will happen:
- The scenario script prepares vultr startup scripts that contain the url and a key for communication with the CloudRemoteControl on each server. The Keys are generated randomly. The script is running on the "master" and will call into the CloudRemoteControl-Server api to register those keys as a new group.
- The new virtual machines are created and execute their startup scripts.
- The startup scripts install the daemons / windows services and place the url and keys somewhere, where those programs can find them.
- The windows services/daemons start up and send a "SystemReady" message to the CloudRemoteControl-Server. 

## Scenario running example

- the master tells the "mysql" instance to actually install mysql 
- after receiving the "success" message from the mysql instance the master tells the mysql instance to download a git repository and provision the database with the sql files that are 
- the master sends to all instances their respective public ip addresses so they can modify their host files 
- the master now tells the web-server to download another git repository and to set up an apache to host the php parts of the contained solution
- the master sends a file to the web-server which will work as a configuration file.
- the master sends commands to the development machine that mount the web-servers www-root (or a level higher with the git repository) to the machine.
- the master sends commands to the development machine to install vscode ...

## Scenario shutdown process

- shutdown all virtual instances
- clear all keys from the master on the CloudRemoteControl-Server
- Done


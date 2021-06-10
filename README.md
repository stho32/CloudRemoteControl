# CloudRemoteControl
A combination of projects that allow for communication and coordination of freely floating computers that just came into existence

## What?
With VulturePS (https://github.com/naseif/VultrPS) naseif and I created an interface to the vultr api in order to create virtual computers and provide them with a few things. 
By using this interface, we can easily create a few machines in the cloud and install a few things here and there, but one obstacle has yet to be overcome:

As soon as a scenario is created the virtual machines have to be coordinated and informed about each other. 

We still have to figure out a way how to make that happen. 

In one scenario, for example, there is a developer, a mysql machine and a mail-server and it would be nice to get them in touch with each other. 

There is yet another small problem to be solved: Using the startup scripts functionality provided by vultr regrettably leads to losing the ability to see the provisioning progress from outside in the world. This is unfortunate, since we want to start provisioning processes and then get informed when everything is ready for us.

However, the solution to both of these problems is actually the same.

## How?
The CloudRemoteControl is mainly a backend which serves an api for messaging between machines and several different clients.
- A client to control the scenario from the machine, where your control script / scenario creation script has been started. That is your "home address" which is probably not part of your scenario. We could call it our "master". Since there can be several different users on the same CloudRemoteControl, they can also have separate masters. That means a "master" is not the same as the installation of a CloudRemoteControl server.
- A client for windows which will be installed as a system service during the main provisioning on our virtual machines. Running in "admin" mode. Which will give the messages the required rights to execute all the necessary steps.
- A client for linux which will be installed as a system service during the main provisioning on our virtual machines. Running in "root" mode. For the same purpose as the windows client has admin rights.

## Scenario startup process

When we start a "scenario", meaning a combination of virtual machines that will do something for us, following things will happen:
- The scenario script prepares vultr startup scripts that contain the url and a key for communication with the CloudRemoteControl on each server. The keys are generated randomly. The script is running on the "master" and will call into the CloudRemoteControl-Server api to register those keys as a new group.
- The new virtual machines are created and execute their startup scripts.
- The startup scripts install the daemons / windows services and place the url and keys in a place, where the named programs can find them.
- The windows services/daemons start up and send a "SystemReady" message to the CloudRemoteControl-Server.

## Scenario running example
- the master tells the "mysql" instance to actually install mysql
- after receiving the "success" message from the mysql instance, the master tells the mysql instance to download a git repository and provide the database with the sql files that are needed to create some tables and insert a bunch of test data
- the master sends the respective public ip addresses to all instances in order to enable them to modify their host files
- he master now tells the web-server to download another git repository and to set up an apache to host the php parts of the contained solution
- the master sends a file to the web-server which will work as a configuration file.
- the master sends commands to the development machine that mount the web-servers www-root (or a level higher with the git repository) to the machine.
- the master sends commands to the development machine to install vscode ...

## Scenario shutdown process
- shutdown all virtual instances
- clear all keys from the master on the CloudRemoteControl-Server
- Done


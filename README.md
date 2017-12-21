# dockerfile-jenkins-master-windowsservercore
A Opinionated Jenkins Master in a  Windows Server Core Container

## Running Detatched
  *  docker run -d --name jenkins_master --rm -p 8080:8080 -p 50000:50000 -v c:/jenkins:c:/jenkins ppouliot/jenkins-master-windowsservercore:latest

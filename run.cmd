REM Runs the jenkins master
docker run -d --name jenkins_master --rm -p 8080:8080 -p 50000:50000 -v c:/jenkins:c:/jenkins ppouliot/jenkins-master-windowsservercore

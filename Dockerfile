FROM openjdk:windowsservercore
MAINTAINER peter@pouliot.net

# $ProgressPreference will disable download progress info and speed-up download
SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue'; "]

# Note: Install Jenkins slave
RUN \
    # jenkins version being bundled in this docker image
    if (-not($env:JENKINS_VERSION)) { $env:JENKINS_VERSION = '2.89.2'; \
        [Environment]::SetEnvironmentVariable('JENKINS_VERSION', $env:JENKINS_VERSION, 'Machine') }; \
    if (-not($env:JENKINS_HOME)) { $env:JENKINS_HOME = 'c:/jenkins'; \
        [Environment]::SetEnvironmentVariable('JENKINS_HOME', $env:JENKINS_HOME, 'Machine') }; \
    if (-not($env:JENKINS_UC)) { $env:JENKINS_UC = 'https://updates.jenkins.io'; \
        [Environment]::SetEnvironmentVariable('JENKINS_UC', $env:JENKINS_UC, 'Machine') }; \

    New-Item -ItemType Directory -Force -Path 'c:/jenkins'; \
    Invoke-WebRequest "https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/$env:JENKINS_VERSION/jenkins-war-$env:JENKINS_VERSION.war" -OutFile "c:/jenkins.war" -UseBasicParsing

# Note: Install Chocolatey
RUN \
    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN \
    # Install Choco Package
    choco install openssh git wget curl docker docker-compose docker-machine rsync unzip winrar dotnet4.6.2 python3 ruby nodejs cygwin cyg-get sysinternals -Y ; \
    refreshenv ;\
    cmd.exe /c "c:\programdata\chocolatey\bin\cyg-get.bat expect mail bind-utils xinit xorg-docs" ;\
    refreshenv ;\
    cmd.exe /c "c:\tools\ruby24\bin\gem install octokit r10k hiera-eyaml" ;\
    cmd.exe /c "c:\ProgramData\chocolatey\bin\wget.exe --no-check-certificate https://bootstrap.pypa.io/get-pip.py" ;\
    cmd.exe /c "c:\Python36\python.exe get-pip.py" ; \
    refreshenv ;\
    cmd.exe /c "c:\Python36\Scripts\pip.exe install PyGithub" ; \
    

COPY scripts /scripts

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

CMD [ "powershell", "c:/scripts/startup.ps1" ]

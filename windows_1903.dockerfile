FROM mcr.microsoft.com/windows:1903

RUN @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

RUN choco install git.install -y
RUN choco install cmake -y --installargs '"ADD_CMAKE_TO_PATH=System"'

RUN choco install visualstudio2019buildtools --package-parameters "--includeRecommended --includeOptional" -y
RUN choco install visualstudio2019-workload-vctools -y

RUN choco install cuda -y
RUN copy "C:\Program Files (x86)\MSBuild\Microsoft.Cpp\v4.0\BuildCustomizations\*.*" "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Microsoft\VC\v160\BuildCustomizations"

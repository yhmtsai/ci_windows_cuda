# FROM mcr.microsoft.com/windows/servercore:ltsc2019
# Reference https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

RUN Set-ExecutionPolicy AllSigned
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#Allow installing without asking
RUN choco feature enable -n allowGlobalConfirmation;

RUN choco install git.install
RUN choco install cmake --installargs '"ADD_CMAKE_TO_PATH=System"'
RUN choco install 7zip.install
RUN choco install curl

RUN choco install visualstudio2019buildtools --package-parameters "--includeRecommended --includeOptional"
RUN choco install visualstudio2019-workload-vctools


# For some reason, servercore can not install cuda by choco
RUN curl.exe -L https://developer.download.nvidia.com/compute/cuda/11.2.1/local_installers/cuda_11.2.1_461.09_win10.exe --output cuda.exe
RUN 7z x cuda.exe -o"cuda"
RUN Start-Process -FilePath '.\cuda\setup.exe' -ArgumentList '-s nvcc_11.2 visual_studio_integration_11.2 cublas_11.2 cublas_dev_11.2 cudart_11.2 curand_11.2 curand_dev_11.2 cusolver_11.2 cusolver_dev_11.2 cusparse_11.2 cusparse_dev_11.22' -Wait -NoNewWindow
RUN Remove-Item –path cuda –recurse 
RUN Remove-Item cuda.exe

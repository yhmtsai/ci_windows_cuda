# FROM mcr.microsoft.com/windows/servercore:ltsc2019
# Reference https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

RUN Set-ExecutionPolicy AllSigned
RUN Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install git.install -y
RUN choco install cmake -y --installargs '"ADD_CMAKE_TO_PATH=System"'
RUN choco install 7zip.install -y
RUN choco install curl -y

RUN choco install visualstudio2019buildtools --package-parameters "--includeRecommended --includeOptional" -y
RUN choco install visualstudio2019-workload-vctools -y


# For some reason, servercore can not install cuda by choco
RUN curl.exe -L http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda_10.2.89_441.22_win10.exe --output cuda.exe
RUN 7z x cuda.exe -o"cuda"
RUN Start-Process -FilePath '.\cuda\setup.exe' -ArgumentList '-s nvcc_10.2 cublas_10.2 cublas_dev_10.2 cudart_10.2 curand_10.2 curand_dev_10.2 cusolver_10.2 cusolver_dev_10.2 cusparse_10.2 cusparse_dev_10.2' -Wait -NoNewWindow
RUN copy 'cuda\CUDAVisualStudioIntegration\extras\visual_studio_integration\MSBuildExtensions\*.*' 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Microsoft\VC\v160\BuildCustomizations'
RUN Remove-Item –path cuda –recurse 
RUN Remove-Item cuda.exe

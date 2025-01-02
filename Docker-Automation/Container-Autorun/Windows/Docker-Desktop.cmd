@echo off
echo Checking if Docker Desktop is running...
tasklist /FI "IMAGENAME eq Docker Desktop.exe" | find /I "Docker Desktop.exe" >nul
IF ERRORLEVEL 1 (
    echo Docker Desktop not running. Starting Docker Desktop...
    start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
) ELSE (
    echo Docker Desktop is already running.
)
echo Waiting for Docker to initialize...
:waitloop
docker info >nul 2>&1
IF ERRORLEVEL 1 (
    timeout /t 5 /nobreak >nul
    goto waitloop
)
echo Docker is up and running.
echo Starting Docker container...
docker start d56bc54ba1ebb3285dd8a279a681386e9b52c505a2c0a37761506f27744b8174
echo Docker is container up and running.

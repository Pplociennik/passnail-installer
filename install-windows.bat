@echo off

set PASSNAIL_VERSION=1.0.0
set DEFAULT_INSTALLATION_PATH=%appdata%\.passnail
set INSTALLATION_DATA=%CD%\.installation-data
set DESKTOP_PATH=%systemdrive%\Documents and Settings\%USERNAME%\Desktop

set SET_OWN_PATH=
set CUSTOM_INSTALLATION_PATH=
set CREATE_DESKTOP_LAUNCHER=

rem ====================================================================================

:show_information
call :log You are going to install Passnail Credentials Manager v.%PASSNAIL_VERSION%.
call :log The dafault installation path is:
call :log %DEFAULT_INSTALLATION_PATH%
goto ask_about_path


:ask_about_path
set /P SET_OWN_PATH=Do you want to set your own installation path? (y/n): %=%
If /I "%SET_OWN_PATH%"=="y" goto ask_about_custom_path
If /I "%SET_OWN_PATH%"=="n" goto install_with_default_path
echo Only 'y' and 'n' allowed!
goto ask_about_path

:ask_about_custom_path
set /P CUSTOM_INSTALLATION_PATH=Path: %=%
goto install_with_custom_path

:install_with_default_path
call :prepare_installation "%DEFAULT_INSTALLATION_PATH%"

:install_with_custom_path
call :prepare_installation "%CUSTOM_INSTALLATION_PATH%"

:prepare_installation
call :log Installing at %1
mkdir %1\tools\java\Coretto_11\jdk11.0.9_12
mkdir %1\app\conf
call :install %1

:install
XCOPY /E /H /Y /C "%INSTALLATION_DATA%\tools\java\Coretto_11\jdk11.0.9_12\*.*" "%1\tools\java\Coretto_11\jdk11.0.9_12"
call :log Installed necessary tools
copy "%INSTALLATION_DATA%\passnail.DAT" "%1\app\passnail-client.jar"
copy "%INSTALLATION_DATA%\passnail-data.DAT" "%1\app\conf\generator.properties"
call :log Installed application data
copy "%INSTALLATION_DATA%\passnail-launcher.bin" "%1\launch.cmd"
call :log Installed launcher
call :log Passnail installed succesfully!
call :ask_about_desktop_launcher %1

:ask_about_desktop_launcher
set /P CREATE_DESKTOP_LAUNCHER=Do you want to create a launch script on desktop? (y/n) : %=%
If "%CREATE_DESKTOP_LAUNCHER%"=="y" call :create_launch_on_desktop %1
If "%CREATE_DESKTOP_LAUNCHER%"=="n" goto finished
echo Only 'y' and 'n' allowed!
goto ask_about_desktop_launcher

:create_launch_on_desktop
set SCRIPT_FILE_NAME=launch.cmd
echo cd %1 > Passnail.bat
echo %SCRIPT_FILE_NAME% >> Passnail.bat
move Passnail.bat "%DESKTOP_PATH%\Passnail.bat"
goto finished

:finished
call :log Installation finished succesfully!
pause
exit

:log
echo [INSTALLER] %*
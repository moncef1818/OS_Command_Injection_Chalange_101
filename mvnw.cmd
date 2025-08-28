@echo off
set MAVEN_PROJECTBASEDIR=%MAVEN_BASEDIR%
if not "%MAVEN_PROJECTBASEDIR%"=="" goto endDetectBaseDir

set EXEC_DIR=%CD%
set WDIR=%EXEC_DIR%
:findBaseDir
IF EXIST "%WDIR%"\.mvn goto baseDirFound
cd ..
IF "%WDIR%"=="%CD%" goto baseDirNotFound
set WDIR=%CD%
goto findBaseDir

:baseDirFound
set MAVEN_PROJECTBASEDIR=%WDIR%
cd "%EXEC_DIR%"
goto endDetectBaseDir

:baseDirNotFound
set MAVEN_PROJECTBASEDIR=%EXEC_DIR%
cd "%EXEC_DIR%"

:endDetectBaseDir
if not exist "%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar" goto download

set MAVEN_WRAPPER_JAR="%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar"
set MAVEN_WRAPPER_LAUNCHER=org.apache.maven.wrapper.MavenWrapperMain

java -jar %MAVEN_WRAPPER_JAR% %*
goto end

:download
echo Downloading Maven Wrapper...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar', '%MAVEN_PROJECTBASEDIR%\.mvn\wrapper\maven-wrapper.jar')"

:end
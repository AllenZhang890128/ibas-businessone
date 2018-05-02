@echo off
setlocal EnableDelayedExpansion
echo ***************************************************************************
echo            compile_packages.bat
echo                     by niuren.zhu
echo                           2016.06.19
echo  说明：
echo     1. 安装apache-maven，下载地址http://maven.apache.org/download.cgi。
echo     2. 解压apache-maven，并设置系统变量MAVEN_HOME为解压的程序目录。
echo     3. 添加PATH变量到%%MAVEN_HOME%%\bin，并检查JAVA_HOME配置是否正确。
echo     4. 运行提示符运行mvn -v 检查安装是否成功。
echo     5. 此脚本会遍历当前目录的子目录，查找pom.xml并编译jar包到release目录。
echo     6. 可在compile_order.txt文件中调整编译顺序。
echo ****************************************************************************
REM 设置参数变量
SET WORK_FOLDER=%~dp0
SET h=%time:~0,2%
SET hh=%h: =0%
SET OPNAME=%date:~0,4%%date:~5,2%%date:~8,2%_%hh%%time:~3,2%%time:~6,2%
SET LOGFILE=%WORK_FOLDER%compile_packages_log_%OPNAME%.txt

echo --当前工作的目录是[%WORK_FOLDER%]
echo --检查编译顺序文件[compile_order.txt]
if not exist %WORK_FOLDER%compile_order.txt dir /a:d /b %WORK_FOLDER% >%WORK_FOLDER%compile_order.txt

echo --清除项目缓存
if exist %WORK_FOLDER%release\ rd /s /q %WORK_FOLDER%release\
if not exist %WORK_FOLDER%release md %WORK_FOLDER%release
if exist %WORK_FOLDER%pom.xml (
  call "%MAVEN_HOME%\bin\mvn" clean install -f %WORK_FOLDER%pom.xml >>%LOGFILE%
)

echo --开始编译[compile_order.txt]内容
for /f %%m in (%WORK_FOLDER%compile_order.txt) do (
  if exist %WORK_FOLDER%%%m\pom.xml (
    SET MY_PACKAGES_FOLDER=%%m
    if !MY_PACKAGES_FOLDER:~-8!==.service (
      REM 网站，编译war包
      echo --开始编译[%%m]
      call "%MAVEN_HOME%\bin\mvn" clean package -Dmaven.test.skip=true -f %WORK_FOLDER%%%m\pom.xml >>%LOGFILE%
      if exist %WORK_FOLDER%%%m\target\%%m*.war copy /y %WORK_FOLDER%%%m\target\%%m*.war %WORK_FOLDER%release >>%LOGFILE%
    ) else (
      REM 非网站，编译jar包并安装到本地
      echo --开始编译[%%m]+安装
      call "%MAVEN_HOME%\bin\mvn" clean package install -Dmaven.test.skip=true -f %WORK_FOLDER%%%m\pom.xml >>%LOGFILE%
      if exist %WORK_FOLDER%%%m\target\%%m*.jar copy /y %WORK_FOLDER%%%m\target\%%m*.jar %WORK_FOLDER%release >>%LOGFILE%
      if exist %WORK_FOLDER%%%m\target\lib\*.* copy /y %WORK_FOLDER%%%m\target\lib\*.* %WORK_FOLDER%release\ >>%LOGFILE%
    )
    REM 检查并复制编译结果
    if exist %WORK_FOLDER%release\%%m*.* (
      echo --编译[%%m]成功
    ) else (
      echo --编译[%%m]失败
    )
  )
)
echo --输出直接调用shell脚本
copy /y %WORK_FOLDER%btulz.transforms.b1\src\main\commands\btulz.shell.bat.txt %WORK_FOLDER%release\btulz.shell.bat
copy /y %WORK_FOLDER%btulz.transforms.b1\src\main\commands\btulz.shell.sh.txt %WORK_FOLDER%release\btulz.shell.sh

echo --编译完成，更多信息请查看[compile_packages_log_%OPNAME%.txt]

@echo off
set titl=�Ǹ���MCһ�������ű�-��Ԩ����
title %titl% ��ʼ����
cd /d "%~dp0"
set INFO=[Client thread��INFO]��
set WARN=[Client thread��WARN]��
set INPUT=[Client thread��INPUT]��
set DEBUG=[Client thread��DEBUG]��
echo %INFO%��ʼ����
set GUIControl=nogui
set Times=0
set DividingLine=-----------------------------------------------------
if not exist version.properties exit
SETLOCAL EnableDelayedExpansion
if exist .extensionpack call :ExtensionPackManager
if exist ConfigProgress.txt ren ConfigProgress.txt progress.properties
if exist config.txt ren config.txt config.properties
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "DEL=%%a"
if not exist progress.properties set LunchMode=First && goto FirstLunch
for /f "tokens=1,* delims==" %%a in ('findstr "ConfigSet=" "progress.properties"') do set ConfigSet=%%b
if %ConfigSet% == false set LunchMode=Incomplete && goto FirstLunch
if %ConfigSet% == auto set LunchMode=Auto && goto FirstLunch
goto ConfigReader


:Main
echo %INFO%%DividingLine%
title %titl% %name%
if %AutoRestart% == true title %titl% %name% ��������:0
echo %INFO%�ǽ������������ֱ�ӹرտ���̨
echo %INFO%�ڿ���̨����stopȻ��س����ɹط�
echo %INFO%%DividingLine%
echo %INFO%����˽ű����� �Ǹ���һ�������ű� ħ��
echo %INFO%ԭ����: ����Сվ
echo %INFO%ħ����: RENaa_FD
if %AutoMemSet% == false goto EarlyMemCheck
set CheckStatus=EarlyMemCheck && goto MemCheck
:EarlyMemCheck
if %ServerGUI% == true set GUIControl= 
echo %INFO%%DividingLine%
echo %INFO%����˰汾��:%version% [git-%git%]
if %EarlyLunchWait% equ 0 goto EulaTask
echo %INFO%����˽���%EarlyLunchWait%�������
for /l %%a in (1,1,%EarlyLunchWait%) do (ping -n 2 -w 500 0.0.0.1>nul)

:EulaTask
if not exist eula.txt goto Eula
for /f "tokens=1,* delims==" %%a in ('findstr "eula=" "eula.txt"') do set eula=%%b
if %eula% == true goto Loop
:Eula
echo %INFO%%DividingLine%
call :ColorText 0E "%WARN%�ȵȣ�" && echo.
call :ColorText 0E "%WARN%�ڷ������ʽ����ǰ,�㻹Ҫͬ��Minecraft EULA " && echo.
echo %INFO%�鿴EULA��ǰ�� https://account.mojang.com/documents/minecraft_eula
echo %INFO%�ڴ˴����������ʾͬ��Minecraft EULA�����������
pause>nul
echo eula=true>eula.txt
echo %INFO%��ͬ����Minecraft EULA,����˼�������

:Loop
echo %DividingLine%
echo Java �汾: && .\Java\bin\java.exe -version
echo %DividingLine%
echo loading %name%, please wait...
.\Java\bin\java.exe -Xms%MinMem%M -Xmx%UserRam%M -XX:+UseCompressedOops --add-modules=jdk.incubator.vector -jar %core% %GUIControl%
echo #
echo %DividingLine%
echo %INFO%������Ѿ��ر�
if %AutoRestart% == false goto CmdExit
if %RestartWait% equ 0 goto Restart
for /l %%b in (%RestartWait%,-1,1) do (echo %INFO%����˽���%%b�������
ping -n 2 -w 500 0.0.0.1>nul)
:Restart
echo %INFO%�����������
set /a Times+=1
title %titl% %name% ��������:%Times%
if %AutoMemSet% == false goto MainMemCheck
set CheckStatus=MainMemCheck && goto MemCheck
:MainMemCheck
goto Loop



:MemCheck
echo %INFO%%DividingLine%
for /f "delims=" %%a in ('wmic os get TotalVisibleMemorySize /value^|find "="') do set %%a
set /a t1=%TotalVisibleMemorySize%,t2=1024
set /a ram=%t1%/%t2%
for /f "delims=" %%b in ('wmic os get FreePhysicalMemory /value^|find "="') do set %%b
set /a t3=%FreePhysicalMemory%
set /a freeram=%t3%/%t2%
echo %INFO%ϵͳ����ڴ�Ϊ��%ram% MB��ʣ������ڴ�Ϊ��%freeram% MB
set /a UserRam=%freeram%-%SysMem%
if %UserRam% LSS 1024 (call :ColorText 0E "%WARN%ʣ������ڴ���ܲ����Կ�������˻��߿����󿨶�" && echo.
set /a UserRam=1024)
echo %INFO%���ο������������ %UserRam% MB
goto %CheckStatus%

:CmdExit
echo %INFO%��������˳� && pause>nul 
exit




:FirstLunch
title %titl% ������
if %LunchMode% == Auto echo %INFO%�Զ�����������,�����ֶ�������ɾ��progress.properties && goto Default
if %LunchMode% == First echo %INFO%��⵽��һ������
if %LunchMode% == Incomplete echo %INFO%��⵽δ�������
echo %INFO%�����������ļ�

:ModeSelect
echo %INFO%%DividingLine%
echo #�����ļ�,��������ɾ��>config.properties
echo #������������������������ɾ��progress.properties>>config.properties
echo #�����ļ�,��������ɾ��>progress.properties
echo #������������������������ɾ�����ļ�>>progress.properties
echo ConfigSet=false>>progress.properties
echo %INFO%��������ɺ�����ɾ��progress.properties,����ᵼ�����ö�ʧ
echo %INFO%������������������������ɾ��progress.properties
echo %INFO%%DividingLine%
echo %INFO%��ѡ������ģʽ(���·��������)
echo %INFO%1.Ĭ��ģʽ(ȫ��ʹ��Ĭ������,�ʺϵ�һ�ο����ĸ���)
echo %INFO%2.�߼�ģʽ(ȫ�������Զ���,�ʺ����������ĸ���)
set /p ConfigMode=%INPUT%
if %ConfigMode% equ 1 goto Default
if %ConfigMode% equ 2 goto AutoMemset
echo %INFO%��������ȷ��ģʽ
goto ModeSelect


:Default
title %titl% ������-Ĭ��ģʽ
echo AutoMemSet=true >>config.properties
echo SysMem=768 >>config.properties
echo MinMem=128 >>config.properties
echo AutoRestart=true >>config.properties
echo RestartWait=10 >>config.properties
echo EarlyLunchWait=5 >>config.properties
echo LogAutoRemove=false >>config.properties
echo ServerGUI=false >>config.properties
goto ConfigProgress

:AutoMemSet
title %titl% ������-�߼�ģʽ
echo %INFO%%DividingLine%
echo %INFO%�Ƿ��Զ������ڴ�(������:AutoMemSet)(Ĭ��:1)
echo %INFO%1.��			2.��
set /p InputSub=%INPUT%
if %InputSub% equ 1 echo AutoMemSet=true >>config.properties && goto SysMem
if %InputSub% equ 2 echo AutoMemSet=false >>config.properties && goto UserRam
echo %INFO%��������ȷ��ѡ��
goto AutoMemSet

:SysMem
echo %INFO%%DividingLine%
echo %INFO%Ԥ���ڴ��С(������:SysMem)(Ĭ��:768)
echo %INFO%�������ִ�С(��λ:MB),����0����Ԥ��
set /p InputSub=%INPUT%
if %InputSub% geq 0 echo SysMem=%InputSub% >>config.properties && goto MinMem
echo %INFO%��������ȷ������
goto SysMem

:UserRam
echo %INFO%%DividingLine%
echo %INFO%��������ڴ��С(������:UserRam)(Ĭ��:2048)
echo %INFO%�������ִ�С(��λ:MB),�������1024
set /p InputSub=%INPUT%
if %InputSub% geq 1 echo UserRam=%InputSub% >>config.properties && goto MinMem
echo %INFO%��������ȷ������
goto UserRam

:MinMem
echo %INFO%%DividingLine%
echo %INFO%������С�ڴ��С(������:MinMem)(Ĭ��:128)
echo %INFO%�������ִ�С(��λ:MB),����0������������ڴ���ͬ
set /p InputSub=%INPUT%
if %InputSub% geq 0 echo MinMem=%InputSub% >>config.properties && goto AutoRestart
echo %INFO%��������ȷ������
goto MinMem

:AutoRestart
echo %INFO%%DividingLine%
echo %INFO%�Ƿ����Զ�����(������:AutoRestart)(Ĭ��:1)
echo %INFO%1.��			2.��
set /p InputSub=%INPUT%
if %InputSub% equ 1 echo AutoRestart=true >>config.properties && goto RestartWait
if %InputSub% equ 2 echo AutoRestart=false >>config.properties && goto EarlyLunchWait
echo %INFO%��������ȷ��ѡ��
goto AutoRestart

:RestartWait
echo %INFO%%DividingLine%
echo %INFO%�Զ������ȴ�ʱ��(������:RestartWait)(Ĭ��:10)
echo %INFO%�������ִ�С(��λ:��)����0�������ȴ�,���300
set /p InputSub=%INPUT%
if %InputSub% geq 0 if %InputSub% leq 300 echo RestartWait=%InputSub% >>config.properties && goto EarlyLunchWait
echo %INFO%��������ȷ������
goto RestartWait

:EarlyLunchWait
echo %INFO%%DividingLine%
echo %INFO%�����ȴ�ʱ��(������:EarlyLunchWait)(Ĭ��:5)
echo %INFO%�������ִ�С(��λ:��)����0�������ȴ�,���300
set /p InputSub=%INPUT%
if %InputSub% geq 0 if %InputSub% leq 300 echo EarlyLunchWait=%InputSub% >>config.properties && goto LogAutoRemove
echo %INFO%��������ȷ������
goto EarlyLunchWait

:LogAutoRemove
echo %INFO%%DividingLine%
echo %INFO%�Զ������־(������:LogAutoRemove)(Ĭ��:2)
echo %INFO%1.��			2.��
set /p InputSub=%INPUT%
if %InputSub% equ 1 echo LogAutoRemove=true >>config.properties && goto ServerGUI
if %InputSub% equ 2 echo LogAutoRemove=false >>config.properties && goto ServerGUI
echo %INFO%��������ȷ��ѡ��
goto LogAutoRemove

:ServerGUI
echo %INFO%%DividingLine%
echo %INFO%�Ƿ�������������GUI(������:ServerGUI)(Ĭ��:2)
echo %INFO%1.��			2.��
set /p InputSub=%INPUT%
if %InputSub% equ 1 echo ServerGUI=true >>config.properties && goto ConfigProgress
if %InputSub% equ 2 echo ServerGUI=false >>config.properties && goto ConfigProgress
echo %INFO%��������ȷ��ѡ��
goto ServerGUI

:ConfigProgress
echo #�����ļ�,����ɾ��>progress.properties
echo #��������������ɾ�����ļ�>>progress.properties
echo ConfigSet=true>>progress.properties
echo %INFO%%DividingLine%
echo %INFO%�������



:ConfigReader
echo %INFO%��ʼ��ȡ�����ļ�
echo %INFO%%DividingLine%

for /f "tokens=1,* delims==" %%a in ('findstr "AutoMemSet=" "config.properties"') do (set AutoMemSet=%%b)
set AutoMemSet=%AutoMemSet: =%
set AutoMemSetOut=%AutoMemSet:true=����%
set AutoMemSetOut=%AutoMemSetOut:false=�ر�%
echo %INFO%�Զ������ڴ�:%AutoMemSetOut%
if %AutoMemSet% == false goto ConfigReaderMem

for /f "tokens=1,* delims==" %%a in ('findstr "SysMem=" "config.properties"') do (set SysMem=%%b)
set SysMem=%SysMem: =%
echo %INFO%�����ڴ�Ԥ��:%SysMem%MB
goto ConfigReader2

:ConfigReaderMem
for /f "tokens=1,* delims==" %%a in ('findstr "UserRam=" "config.properties"') do (set UserRam=%%b)
set UserRam=%UserRam: =%
echo %INFO%�ڴ�����:%UserRam%MB

:ConfigReader2
for /f "tokens=1,* delims==" %%a in ('findstr "MinMem=" "config.properties"') do (set MinMem=%%b)
set MinMem=%MinMem: =%
echo %INFO%��С�ڴ�:%MinMem%MB

for /f "tokens=1,* delims==" %%a in ('findstr "AutoRestart=" "config.properties"') do (set AutoRestart=%%b)
set AutoRestart=%AutoRestart: =%
set AutoMemSetOut=%AutoMemSet:true=����%
set AutoMemSetOut=%AutoMemSetOut:false=�ر�%
echo %INFO%�Զ�����:%AutoMemSetOut%

if %AutoRestart% == false goto ConfigReader3
for /f "tokens=1,* delims==" %%a in ('findstr "RestartWait=" "config.properties"') do (set RestartWait=%%b)
set RestartWait=%RestartWait: =%
echo %INFO%�����ȴ�ʱ��:%RestartWait%s

:ConfigReader3
for /f "tokens=1,* delims==" %%a in ('findstr "LogAutoRemove=" "config.properties"') do (set LogAutoRemove=%%b)
set LogAutoRemove=%LogAutoRemove: =%
set LogAutoRemoveOut=%LogAutoRemove:true=����%
set LogAutoRemoveOut=%LogAutoRemoveOut:false=�ر�%
echo %INFO%�Զ������־:%LogAutoRemoveOut%

for /f "tokens=1,* delims==" %%a in ('findstr "EarlyLunchWait=" "config.properties"') do (set EarlyLunchWait=%%b)
set EarlyLunchWait=%EarlyLunchWait: =%
echo %INFO%����ǰ�ȴ�:%EarlyLunchWait%s

for /f "tokens=1,* delims==" %%a in ('findstr "ServerGUI=" "config.properties"') do (set ServerGUI=%%b)
set ServerGUI=%ServerGUI: =%
set ServerGUIOut=%ServerGUI:true=����%
set ServerGUIOut=%ServerGUIOut:false=�ر�%
echo %INFO%����������GUI:%ServerGUIOut%

for /f "tokens=1,* delims==" %%a in ('findstr "version=" "version.properties"') do (set version=%%b)
set version=%version: =%
for /f "tokens=1,* delims==" %%a in ('findstr "git=" "version.properties"') do (set git=%%b)
set git=%git: =%
for /f "tokens=1,* delims==" %%a in ('findstr "core=" "version.properties"') do (set core=%%b)
set core=%core: =%
for /f "tokens=1,* delims==" %%a in ('findstr "name=" "version.properties"') do (set name=%%b)
set name=%name: =%

goto Main

:ExtensionPackManager
echo %INFO%%DividingLine%
echo %INFO%��ѡ���Ƿ�������Ԩ������չ��
echo %INFO%��������չ�����ʺ�ԭ������
echo %INFO%��������и����淨,���ǿ��ܻ�Ӱ����������
echo %INFO%1.��			2.��
echo %INFO%%DividingLine%
set /p InputSub=%INPUT%
if %InputSub% equ 1 goto ExtensionPackLoader
if %InputSub% equ 2 rd .extensionpack /s/q && goto exit
echo %INFO%��������ȷ��ѡ��
goto ExtensionPackManager
	
:ExtensionPackLoader
echo %INFO%װ����չ����,���Ժ�...
xcopy .extensionpack plugins /S/E/Y/I>nul
rd .extensionpack /s/q
echo %INFO%װ����ɣ�
echo %INFO%%DividingLine%
goto exit

:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1

:exit













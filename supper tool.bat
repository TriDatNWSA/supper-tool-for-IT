@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title System Optimization & Maintenance Tool
color 0A

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Yeu cau quyen Administrator. Vui long chay lai voi quyen Admin.
    echo.
    echo Huong dan: Click chuot phai file -> "Run as administrator"
	echo Author: nptdatit
	echo Contact: nptdatit@gmail.com
    pause
    exit /b
)

:MAIN_MENU
cls
echo ========================================
echo    HE THONG TOI UU VA BAO TRI MAY TINH
echo ========================================
echo    Version 17.12.25 - Chay voi quyen Administrator
echo ========================================
echo 	Author: nptdatit
echo ========================================



echo.
echo [1]  Don dep rac he thong (nang cao)
echo [2]  Xoa cache Zalo (tren 2 thang)
echo [3]  Xoa cache trinh duyet (tren 1 thang)
echo [4]  Bat/Tat khoi dong nhanh
echo [5]  Quan ly ung dung khoi dong cung Windows
echo [6]  Kiem tra trang thai pin va Tiet kiem pin
echo [7]  Kiem tra SSD/HDD (S.M.A.R.T)
echo [8]  Doi ten may tinh
echo [9]  Doi mat khau may tinh
echo [10] Them nguoi dung moi
echo [11] Xoa Windows Credentials va Lich su
echo [12] Kiem tra toc do mang (Ping va Speedtest)
echo [13] Tat Windows Update (tam thoi)
echo [14] Bat Windows Update
echo [15] Cai dat phan mem (May moi) - AUTO
echo [16] Cai dat Windows Defender va Firewall
echo [17] Backup va Restore Registry
echo [18] Kiem tra va sua loi Windows
echo [19] Thong tin he thong chi tiet
echo [20] Thoat
echo.
set /p choice="Lua chon cua ban (1-20): "

if "%choice%"=="1" goto CLEAN_JUNK
if "%choice%"=="2" goto CLEAN_ZALO
if "%choice%"=="3" goto CLEAN_BROWSERS
if "%choice%"=="4" goto FAST_STARTUP
if "%choice%"=="5" goto STARTUP_APPS
if "%choice%"=="6" goto BATTERY_CHECK
if "%choice%"=="7" goto DISK_CHECK
if "%choice%"=="8" goto RENAME_PC
if "%choice%"=="9" goto CHANGE_PASSWORD
if "%choice%"=="10" goto ADD_USER
if "%choice%"=="11" goto CLEAN_CREDENTIALS
if "%choice%"=="12" goto NETWORK_SPEED
if "%choice%"=="13" goto DISABLE_UPDATES
if "%choice%"=="14" goto ENABLE_UPDATES
if "%choice%"=="15" goto INSTALL_SOFTWARE
if "%choice%"=="16" goto SECURITY_SETTINGS
if "%choice%"=="17" goto REGISTRY_BACKUP
if "%choice%"=="18" goto FIX_WINDOWS
if "%choice%"=="19" goto SYSTEM_INFO
if "%choice%"=="20" exit
goto MAIN_MENU

:: =================================================================
:: 1. Clean system junk (IMPROVED VERSION)
:: =================================================================
:CLEAN_JUNK
cls
echo ========================================
echo      DON DEP RAC HE THONG (NANG CAO)
echo ========================================
echo.
echo CANH BAO: Cac thao tac xoa la VIEN VIEN!
echo           Backup du lieu truoc khi tiep tuc.
echo.
echo [1] Don dep co ban (an toan)
echo [2] Don dep nang cao (xoa nhieu hon)
echo [3] Don dep toan bo + Thung rac
echo [4] Quay lai menu
echo.
set /p clean_level="Lua chon (1-4): "
if "%clean_level%"=="4" goto MAIN_MENU
if "%clean_level%"=="" goto MAIN_MENU

cls
echo Dang don dep rac he thong...
echo ============================
echo.

:: Common cleanup for all levels
echo [1] Dang xoa file tam nguoi dung...
del /q /f /s "%temp%\*.*" 2>nul
del /q /f /s "%tmp%\*.*" 2>nul
rd /s /q "%temp%" 2>nul
rd /s /q "%tmp%" 2>nul
md "%temp%" 2>nul

echo [2] Dang xoa file tam Windows...
del /q /f /s "C:\Windows\Temp\*.*" 2>nul
del /q /f /s "C:\Windows\Logs\*.log" 2>nul

echo [3] Dang xoa Prefetch (cai thien hieu nang)...
del /q /f /s "C:\Windows\Prefetch\*.*" 2>nul

echo [4] Dang xoa DNS cache...
ipconfig /flushdns >nul

if "%clean_level%"=="2" goto ADVANCED_CLEAN
if "%clean_level%"=="3" goto FULL_CLEAN

:BASIC_CLEAN_DONE
echo [5] Dang xoa lich su Windows Recent...
del /q /f "%appdata%\Microsoft\Windows\Recent\*.*" 2>nul
del /q /f "%appdata%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" 2>nul

echo.
echo [THANH CONG] Da hoan thanh don dep co ban!
echo.
goto CLEANUP_SUMMARY

:ADVANCED_CLEAN
echo [5] Dang xoa Windows Error Reports...
del /q /f /s "C:\ProgramData\Microsoft\Windows\WER\*.*" 2>nul

echo [6] Dang xoa cache Microsoft Store...
del /q /f /s "%localappdata%\Packages\*Cache*" 2>nul 2>nul

echo [7] Dang xoa thumbnails...
del /q /f /s "%localappdata%\Microsoft\Windows\Explorer\*.db" 2>nul

goto BASIC_CLEAN_DONE

:FULL_CLEAN
echo [5] Dang xoa thung rac (Recycle Bin)...
echo.
echo Chon phuong phap xoa thung rac:
echo [1] Su dung VBScript (an toan)
echo [2] Su dung PowerShell
echo [3] Bo qua
set /p rb_method="Lua chon (1-3): "

if "%rb_method%"=="1" (
    (
    echo Set objShell = CreateObject^("Shell.Application"^)
    echo Set objFolder = objShell.Namespace^(10^)
    echo For Each objItem in objFolder.Items
    echo     objItem.InvokeVerb^("Delete"^)
    echo Next
    ) > "%temp%\empty_recycle.vbs"
    cscript //nologo "%temp%\empty_recycle.vbs"
    del "%temp%\empty_recycle.vbs"
    echo Da xoa thung rac bang VBScript!
) else if "%rb_method%"=="2" (
    powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
    echo Da xoa thung rac bang PowerShell!
) else (
    echo Da bo qua xoa thung rac!
)

echo [6] Dang xoa file Internet Explorer cache...
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255

echo [7] Dang chay Disk Cleanup...
cleanmgr /sagerun:1 >nul 2>&1

goto ADVANCED_CLEAN

:CLEANUP_SUMMARY
echo.
echo ========================================
echo       TONG KET DON DEP
echo ========================================
echo.
echo Cac muc da duoc don dep:
echo - File tam nguoi dung
echo - File tam Windows
echo - Prefetch (cai thien toc do khoi dong)
echo - DNS cache
echo - Lich su Recent files
if "%clean_level%"=="2" (
echo - Windows Error Reports
echo - Microsoft Store cache
echo - Thumbnails cache
)
if "%clean_level%"=="3" (
echo - Thung rac (Recycle Bin)
echo - IE cache
echo - Disk Cleanup da duoc chay
)
echo.
echo Luu y: Khoi dong lai may de hieu qua tot nhat!
echo.
pause
goto MAIN_MENU

:: =================================================================
:: 2. Clean Zalo cache (IMPROVED)
:: =================================================================
:CLEAN_ZALO
cls
echo ========================================
echo       XOA CACHE ZALO (TREN 2 THANG)
echo ========================================
echo.
set ZALO_PATHS=0
set ZALO_FOUND=0

echo Dang tim kiem thu muc Zalo...
echo.

:: Check multiple possible Zalo paths
set "ZALO_PATH1=%userprofile%\Documents\Zalo Received Files"
set "ZALO_PATH2=%userprofile%\AppData\Roaming\ZaloData"
set "ZALO_PATH3=%appdata%\ZaloData"
for %%P in ("%ZALO_PATH1%" "%ZALO_PATH2%" "%ZALO_PATH3%" "%ZALO_PATH4%") do (
    if exist %%P (
        set /a ZALO_FOUND+=1
        echo Tim thay thu muc Zalo: %%P
        echo Dang xoa file cu hon 2 thang...
        forfiles /p %%P /s /d -60 /c "cmd /c if @isdir==FALSE echo Deleting: @path && del /q @path"
        echo.
    )
)

if %ZALO_FOUND%==0 (
    echo [THONG BAO] Khong tim thay thu muc Zalo nao!
    echo.
    echo Cac vi tri da kiem tra:
    echo 1. %userprofile%\Documents\Zalo
    echo 2. %userprofile%\AppData\Roaming\Zalo
    echo 3. %appdata%\Zalo
    echo 4. %localappdata%\Zalo
) else (
    echo [THANH CONG] Da xoa cache Zalo cu hon 2 thang!
    echo.
    echo Khuyen nghi: Dong Zalo truoc khi xoa de tranh loi!
)

echo.
pause
goto MAIN_MENU

:: =================================================================
:: 3. Clean browser cache (SIMPLE VERSION)
:: =================================================================
:CLEAN_BROWSERS
cls
echo ========================================
echo    XOA CACHE TRINH DUYET (TREN 1 THANG)
echo ========================================
echo.
echo Chon trinh duyet can xoa cache:
echo [1] Google Chrome
echo [2] Microsoft Edge
echo [3] Mozilla Firefox
echo [4] Tat ca trinh duyet tren
echo [5] Quay lai
echo.
set /p browser_choice="Lua chon (1-5): "

if "%browser_choice%"=="5" goto MAIN_MENU
if "%browser_choice%"=="" goto CLEAN_BROWSERS

cls
echo Dang xoa cache trinh duyet...
echo =============================
echo.

:: Initialize counter
set BROWSER_COUNT=0

:: Clean Chrome
if "%browser_choice%"=="1" goto DO_CHROME
if "%browser_choice%"=="4" goto DO_CHROME
goto CHECK_EDGE

:DO_CHROME
echo [CHROME] Dang xoa cache...
set "CHROME_PATH=%localappdata%\Google\Chrome\User Data\Default"
if exist "%CHROME_PATH%" (
    for %%D in ("Cache" "Cache2" "Code Cache" "GPUCache") do (
        if exist "%CHROME_PATH%\%%~D" (
            echo   Xoa thu muc: %%~D
            forfiles /p "%CHROME_PATH%\%%~D" /s /d -30 /c "cmd /c del /q @path" 2>nul
        )
    )
    echo [CHROME] Da xoa cache!
    set /a BROWSER_COUNT+=1
) else (
    echo [CHROME] Khong tim thay thu muc!
)
echo.

:CHECK_EDGE
:: Clean Edge
if "%browser_choice%"=="2" goto DO_EDGE
if "%browser_choice%"=="4" goto DO_EDGE
goto CHECK_FIREFOX

:DO_EDGE
echo [EDGE] Dang xoa cache...
set "EDGE_PATH=%localappdata%\Microsoft\Edge\User Data\Default"
if exist "%EDGE_PATH%" (
    for %%D in ("Cache" "Cache2" "Code Cache" "GPUCache") do (
        if exist "%EDGE_PATH%\%%~D" (
            echo   Xoa thu muc: %%~D
            forfiles /p "%EDGE_PATH%\%%~D" /s /d -30 /c "cmd /c del /q @path" 2>nul
        )
    )
    echo [EDGE] Da xoa cache!
    set /a BROWSER_COUNT+=1
) else (
    echo [EDGE] Khong tim thay thu muc!
)
echo.

:CHECK_FIREFOX
:: Clean Firefox
if "%browser_choice%"=="3" goto DO_FIREFOX
if "%browser_choice%"=="4" goto DO_FIREFOX
goto CLEANUP_COMPLETE

:DO_FIREFOX
echo [FIREFOX] Dang xoa cache...
set "FIREFOX_PATH=%appdata%\Mozilla\Firefox\Profiles"
if exist "%FIREFOX_PATH%" (
    for /d %%i in ("%FIREFOX_PATH%\*") do (
        if exist "%%i\cache2" (
            echo   Xoa cache Firefox profile...
            forfiles /p "%%i\cache2" /s /d -30 /c "cmd /c del /q @path" 2>nul
        )
    )
    echo [FIREFOX] Da xoa cache!
    set /a BROWSER_COUNT+=1
) else (
    echo [FIREFOX] Khong tim thay thu muc!
)
echo.

:CLEANUP_COMPLETE
echo ========================================
if %BROWSER_COUNT% gtr 0 (
    echo [THANH CONG] Da hoan thanh xoa cache!
    echo So trinh duyet da xoa: %BROWSER_COUNT%
) else (
    echo [THONG BAO] Khong xoa duoc cache nao!
)
echo ========================================
echo.
echo LUU Y:
echo 1. Dong tat ca trinh duyet truoc khi xoa
echo 2. Cache se tu dong tao lai khi su dung
echo.
pause
goto MAIN_MENU

:: =================================================================
:: 4. Fast startup (UNCHANGED but keep it)
:: =================================================================
:FAST_STARTUP
cls
echo [1] Bat khoi dong nhanh
echo [2] Tat khoi dong nhanh
echo.
set /p fs_choice="Lua chon: "
if "%fs_choice%"=="1" (
    powercfg /h on
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
    echo Da BAT khoi dong nhanh!
) else if "%fs_choice%"=="2" (
    powercfg /h off
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
    echo Da TAT khoi dong nhanh!
)
pause
goto MAIN_MENU

:: =================================================================
:: 5. Startup apps management (ADVANCED VERSION)
:: =================================================================
:STARTUP_APPS
cls
echo ========================================
echo    QUAN LY UNG DUNG KHOI DONG CUNG WINDOWS
echo ========================================
echo.

:REFRESH_STARTUP_LIST
:: Get startup apps with more details
echo Dang lay danh sach ung dung khoi dong...
echo.

:: Create arrays for apps
set "APP_INDEX=0"
set "TEMP_FILE=%temp%\startup_detailed.txt"

:: Get all startup apps with details
wmic startup get caption,command,location /format:csv > "%TEMP_FILE%" 2>nul

:: Parse the CSV file
setlocal enabledelayedexpansion
for /f "tokens=1-3 delims=," %%a in ('type "%TEMP_FILE%" ^| findstr /v /i "caption,command,location" ^| findstr /v /i "Node"') do (
    if not "%%a"=="" (
        set /a APP_INDEX+=1
        
        :: Clean up the app name (remove quotes if present)
        set "app_name=%%a"
        set "app_name=!app_name:"=!"
        
        :: Clean up the command
        set "app_cmd=%%b"
        set "app_cmd=!app_cmd:"=!"
        
        :: Clean up the location
        set "app_loc=%%c"
        set "app_loc=!app_loc:"=!"
        
        :: Store in arrays
        set "APP_NAME_!APP_INDEX!=!app_name!"
        set "APP_CMD_!APP_INDEX!=!app_cmd!"
        set "APP_LOC_!APP_INDEX!=!app_loc!"
    )
)
endlocal & set APP_INDEX=%APP_INDEX%

if %APP_INDEX% equ 0 (
    echo [THONG BAO] Khong tim thay ung dung nao khoi dong cung Windows!
    echo.
    echo CAC PHUONG PHAP KHAC DE QUAN LY:
    echo [1] Mo Task Manager (Ctrl+Shift+Esc -> Startup tab)
    echo [2] Mo thu muc Startup (shell:startup)
    echo [3] Mo Registry Editor (HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run)
    echo [4] Quay lai menu chinh
    echo.
    set /p empty_choice="Lua chon (1-4): "
    
    if "%empty_choice%"=="1" (
        taskmgr
        goto STARTUP_APPS
    )
    if "%empty_choice%"=="2" (
        explorer shell:startup
        goto STARTUP_APPS
    )
    if "%empty_choice%"=="3" (
        regedit
        goto STARTUP_APPS
    )
    if "%empty_choice%"=="4" goto MAIN_MENU
    goto STARTUP_APPS
)

:: Display apps in a nice table
echo DANH SACH UNG DUNG KHOI DONG (%APP_INDEX% ung dung):
echo ===================================================
echo.

echo STT  TEN UNG DUNG
echo ---  ---------------------------------
setlocal enabledelayedexpansion
for /l %%i in (1,1,%APP_INDEX%) do (
    set "app_name=!APP_NAME_%%i!"
    
    :: Truncate long names
    if "!app_name:~40!" neq "" (
        set "display_name=!app_name:~0,40!..."
    ) else (
        set "display_name=!app_name!"
    )
    
    :: Display with index
    if %%i lss 10 (
        echo  %%i.   !display_name!
    ) else (
        echo  %%i.  !display_name!
    )
)
endlocal

echo.
echo TONG CONG: %APP_INDEX% ung dung dang khoi dong cung Windows
echo.

:: Menu options
echo TINH NANG:
echo [1-...] Chon so ung dung de quan ly
echo [A]     Tat tat ca ung dung khoi dong (khuyen nghi can than)
echo [S]     Mo thu muc Startup
echo [T]     Mo Task Manager
echo [R]     Tai lai danh sach
echo [B]     Quay lai menu chinh
echo.
set /p app_choice="Lua chon cua ban: "

:: Handle special choices
if /i "%app_choice%"=="A" goto DISABLE_ALL
if /i "%app_choice%"=="S" (
    explorer shell:startup
    goto STARTUP_APPS
)
if /i "%app_choice%"=="T" (
    taskmgr
    goto STARTUP_APPS
)
if /i "%app_choice%"=="R" (
    del "%TEMP_FILE%" 2>nul
    goto REFRESH_STARTUP_LIST
)
if /i "%app_choice%"=="B" goto MAIN_MENU

:: Validate numeric choice
echo %app_choice% | findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo Lua chon khong hop le!
    pause
    goto STARTUP_APPS
)

set /a selected=%app_choice% 2>nul
if %selected% lss 1 (
    echo Lua chon khong hop le! So phai lon hon 0
    pause
    goto STARTUP_APPS
)

if %selected% gtr %APP_INDEX% (
    echo Lua chon khong hop le! So toi da la %APP_INDEX%
    pause
    goto STARTUP_APPS
)

:: Show app details and options
setlocal enabledelayedexpansion
set "selected_name=!APP_NAME_%selected%!"
set "selected_cmd=!APP_CMD_%selected%!"
set "selected_loc=!APP_LOC_%selected%!"

cls
echo ========================================
echo    CHI TIET UNG DUNG: !selected_name!
echo ========================================
echo.
echo THONG TIN:
echo - Ten: !selected_name!
echo - Vi tri: !selected_loc!
echo.
echo DUONG DAN: !selected_cmd!
echo.

echo THAO TAC:
echo [1] Vo hieu hoa (Tat khoi dong cung)
echo [2] Xem thong tin chi tiet
echo [3] Mo thu muc chua file
echo [4] Quay lai danh sach
echo.
set /p action_choice="Lua chon (1-4): "

if "%action_choice%"=="1" (
    echo.
    echo CANH BAO: Vo hieu hoa ung dung khoi dong cung!
    echo Ung dung: !selected_name!
    echo.
    echo Ban co chac chan muon vo hieu hoa? (y/n)
    set /p confirm=
    if /i "!confirm!"=="y" (
        echo Dang vo hieu hoa...
        wmic startup where caption="!selected_name!" call delete >nul 2>&1
        if errorlevel 0 (
            echo [THANH CONG] Da vo hieu hoa: !selected_name!
        ) else (
            echo [LOI] Khong the vo hieu hoa!
            echo Thu dung Task Manager (Ctrl+Shift+Esc -> Startup tab)
        )
    ) else (
        echo Da huy thao tac!
    )
    pause
    endlocal
    goto REFRESH_STARTUP_LIST
)

if "%action_choice%"=="2" (
    cls
    echo ========================================
    echo    THONG TIN CHI TIET UNG DUNG
    echo ========================================
    echo.
    echo TEN: !selected_name!
    echo VI TRI: !selected_loc!
    echo.
    echo DUONG DAN DAY DU:
    echo !selected_cmd!
    echo.
    echo [O] Mo file
    echo [R] Quay lai
    echo.
    set /p detail_choice="Lua chon: "
    
    if /i "!detail_choice!"=="O" (
        if exist "!selected_cmd!" (
            start "" "!selected_cmd!"
        ) else (
            echo Khong tim thay file!
        )
    )
    pause
    endlocal
    goto STARTUP_APPS
)

if "%action_choice%"=="3" (
    for %%F in ("!selected_cmd!") do (
        if exist "%%~dpF" (
            explorer "%%~dpF"
        ) else (
            echo Khong the mo thu muc!
        )
    )
    pause
    endlocal
    goto STARTUP_APPS
)

if "%action_choice%"=="4" (
    endlocal
    goto STARTUP_APPS
)

:: Invalid choice
echo Lua chon khong hop le!
pause
endlocal
goto STARTUP_APPS

:DISABLE_ALL
cls
echo ========================================
echo    TAT TAT CA UNG DUNG KHOI DONG
echo ========================================
echo.
echo CANH BAO NGHIEM TRONG!
echo.
echo Hanh dong nay se:
echo - Tat TAT CA ung dung khoi dong cung Windows
echo - Co the anh huong den hoat dong cua mot so phan mem
echo - Khong anh huong den Windows he thong
echo.
echo Ban co CHAC CHAN muon tat TAT CA %APP_INDEX% ung dung? (y/n)
set /p confirm_all=
if /i not "%confirm_all%"=="y" (
    echo Da huy thao tac!
    pause
    goto STARTUP_APPS
)

echo.
echo Dang vo hieu hoa tat ca ung dung khoi dong...
echo.

setlocal enabledelayedexpansion
set "DISABLED_COUNT=0"
for /l %%i in (1,1,%APP_INDEX%) do (
    set "app_name=!APP_NAME_%%i!"
    echo Dang vo hieu hoa: !app_name!
    wmic startup where caption="!app_name!" call delete >nul 2>&1
    if errorlevel 0 (
        echo   [OK] Da vo hieu hoa
        set /a DISABLED_COUNT+=1
    ) else (
        echo   [LOI] Khong the vo hieu hoa
    )
)

echo.
echo ========================================
echo    KET QUA
echo ========================================
echo Da vo hieu hoa: !DISABLED_COUNT!/%APP_INDEX% ung dung
echo.
echo LUU Y:
echo 1. Can khoi dong lai may de thay doi co hieu luc
echo 2. Neu can, ban co the bat lai tung ung dung trong Task Manager
echo 3. Cac ung dung Windows he thong van hoat dong binh thuong
echo.
pause
endlocal
goto REFRESH_STARTUP_LIST

:: =================================================================
:: 6. Battery check (IMPROVED)
:: =================================================================
:BATTERY_CHECK
cls
echo ========================================
echo      KIEM TRA & TIET KIEM PIN
echo ========================================
echo.
echo [1] Tao bao cao pin chi tiet
echo [2] Bat che do tiet kiem pin
echo [3] Tat che do tiet kiem pin
echo [4] Hien thi thong tin pin hien tai
echo [5] Quay lai
echo.
set /p battery_choice="Lua chon (1-5): "

if "%battery_choice%"=="1" (
    powercfg /batteryreport /output "%userprofile%\Desktop\battery_report.html"
    if exist "%userprofile%\Desktop\battery_report.html" (
        echo Da tao bao cao pin: %userprofile%\Desktop\battery_report.html
        echo Mo file de xem chi tiet tu do!
    )
    pause
    goto BATTERY_CHECK
)

if "%battery_choice%"=="2" (
    powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    echo Da bat che do tiet kiem pin!
    pause
    goto BATTERY_CHECK
)

if "%battery_choice%"=="3" (
    powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
    echo Da tat che do tiet kiem pin!
    pause
    goto BATTERY_CHECK
)

if "%battery_choice%"=="4" (
    powercfg /batteryreport /duration 1
    echo Thong tin pin da duoc cap nhat!
    pause
    goto BATTERY_CHECK
)

if "%battery_choice%"=="5" goto MAIN_MENU
goto BATTERY_CHECK

:: =================================================================
:: 7. Disk check (FIXED - STABLE VERSION)
:: =================================================================
:DISK_CHECK
cls
echo ========================================
echo        KIEM TRA SSD/HDD
echo ========================================
echo.
echo [1] Hien thi thong tin o dia
echo [2] Kiem tra toc do doc/ghi
echo [3] Kiem tra o dia voi CHKDSK
echo [4] Kiem tra S.M.A.R.T status
echo [5] Phan tich dung luong o dia
echo [6] Kiem tra suc khoe SSD
echo [7] Quay lai menu chinh
echo.
set /p disk_choice="Lua chon (1-7): "

if "%disk_choice%"=="1" goto DISK_INFO
if "%disk_choice%"=="2" goto DISK_SPEED
if "%disk_choice%"=="3" goto DISK_CHKDSK
if "%disk_choice%"=="4" goto DISK_SMART_MENU
if "%disk_choice%"=="5" goto DISK_ANALYSIS_MENU
if "%disk_choice%"=="6" goto DISK_HEALTH_MENU
if "%disk_choice%"=="7" goto MAIN_MENU
goto DISK_CHECK

:: 1. Disk Information
:DISK_INFO
cls
echo ========================================
echo        THONG TIN O DIA CO BAN
echo ========================================
echo.

echo THONG TIN VAT LY O DIA:
echo ======================
wmic diskdrive get model,size,status,interfaceType,MediaType /format:table
echo.

echo THONG TIN O DIA LOGIC:
echo =====================
wmic logicaldisk where drivetype=3 get deviceid,size,freespace,volumename,filesystem /format:table
echo.

echo.
echo [1] Quay lai menu kiem tra o dia
echo [2] Quay lai menu chinh
echo.
set /p info_return="Lua chon (1-2): "
if "%info_return%"=="1" goto DISK_CHECK
if "%info_return%"=="2" goto MAIN_MENU
goto DISK_INFO

:: 2. Disk Speed Test
:DISK_SPEED
cls
echo ========================================
echo    KIEM TRA TOC DO DOC/GHI O DIA
echo ========================================
echo.
echo CANH BAO: Test toc do co the mat 1-5 phut!
echo.

echo Chon o dia can kiem tra:
echo [C] O C: (mac dinh)
echo [D] O D:
echo [E] O E:
echo [B] Quay lai
echo.
set /p speed_drive="Lua chon: "

if /i "%speed_drive%"=="B" goto DISK_CHECK
if /i "%speed_drive%"=="C" set "speed_drive=C"
if /i "%speed_drive%"=="D" set "speed_drive=D"
if /i "%speed_drive%"=="E" set "speed_drive=E"
if "%speed_drive%"=="" set "speed_drive=C"

:: Check if drive exists
if not exist "%speed_drive%:\" (
    echo O dia %speed_drive%: khong ton tai!
    pause
    goto DISK_SPEED
)

cls
echo ========================================
echo DANG KIEM TRA TOC DO O DIA %speed_drive%:
echo ========================================
echo.
echo DANG TEST - VUI LONG CHO...
echo.

winsat disk -drive %speed_drive%
echo.
echo Da hoan thanh kiem tra toc do!
echo.

echo [1] Quay lai menu kiem tra o dia
echo [2] Test o dia khac
echo [3] Quay lai menu chinh
echo.
set /p speed_return="Lua chon (1-3): "
if "%speed_return%"=="1" goto DISK_CHECK
if "%speed_return%"=="2" goto DISK_SPEED
if "%speed_return%"=="3" goto MAIN_MENU
goto DISK_SPEED

:: 3. Check Disk (CHKDSK)
:DISK_CHKDSK
cls
echo ========================================
echo         KIEM TRA O DIA (CHKDSK)
echo ========================================
echo.
echo CANH BAO: CHKDSK co the yeu cau khoi dong lai may!
echo.

echo Chon o dia can kiem tra:
echo [C] O C: (mac dinh)
echo [D] O D:
echo [E] O E:
echo [B] Quay lai
echo.
set /p chkdsk_drive="Lua chon: "

if /i "%chkdsk_drive%"=="B" goto DISK_CHECK
if /i "%chkdsk_drive%"=="C" set "chkdsk_drive=C:"
if /i "%chkdsk_drive%"=="D" set "chkdsk_drive=D:"
if /i "%chkdsk_drive%"=="E" set "chkdsk_drive=E:"
if "%chkdsk_drive%"=="" set "chkdsk_drive=C:"

if not exist "%chkdsk_drive%\" (
    echo O dia %chkdsk_drive% khong ton tai!
    pause
    goto DISK_CHKDSK
)

cls
echo ========================================
echo DANG KIEM TRA O DIA %chkdsk_drive%
echo ========================================
echo.
echo Ban co muon chay CHKDSK voi tu dong sua loi? (y/n)
echo - y: Tu dong sua loi (can khoi dong lai neu co)
echo - n: Chi kiem tra, khong sua
set /p chkdsk_fix="Lua chon: "

if /i "%chkdsk_fix%"=="y" (
    echo.
    echo Dang chay: chkdsk %chkdsk_drive% /f
    chkdsk %chkdsk_drive% /f
) else (
    echo.
    echo Dang chay: chkdsk %chkdsk_drive%
    chkdsk %chkdsk_drive%
)

echo.
echo Da hoan thanh kiem tra!
echo.

echo [1] Quay lai menu kiem tra o dia
echo [2] Kiem tra o dia khac
echo [3] Quay lai menu chinh
echo.
set /p chkdsk_return="Lua chon (1-3): "
if "%chkdsk_return%"=="1" goto DISK_CHECK
if "%chkdsk_return%"=="2" goto DISK_CHKDSK
if "%chkdsk_return%"=="3" goto MAIN_MENU
goto DISK_CHKDSK

:: 4. S.M.A.R.T Status Menu
:DISK_SMART_MENU
cls
echo ========================================
echo        KIEM TRA S.M.A.R.T STATUS
echo ========================================
echo.
echo Chon phuong phap kiem tra:
echo [1] Su dung PowerShell (nen dung)
echo [2] Su dung WMIC (co gioi han)
echo [3] Tai CrystalDiskInfo (phai tai ve)
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p smart_method="Lua chon (1-5): "

if "%smart_method%"=="1" goto SMART_PS
if "%smart_method%"=="2" goto SMART_WMIC
if "%smart_method%"=="3" goto SMART_CDI
if "%smart_method%"=="4" goto DISK_CHECK
if "%smart_method%"=="5" goto MAIN_MENU
goto DISK_SMART_MENU

:SMART_PS
cls
echo ========================================
echo   KIEM TRA S.M.A.R.T BANG POWERSHELL
echo ========================================
echo.
echo Dang kiem tra, vui long cho...
echo.

:: Run PowerShell with error handling
powershell -Command "& {
    Write-Host 'KIEM TRA O DIA' -ForegroundColor Yellow
    Write-Host '=============' -ForegroundColor Yellow
    
    try {
        # Try Get-PhysicalDisk first (Windows 8+)
        Write-Host '`n[Phuong phap 1: Get-PhysicalDisk]' -ForegroundColor Cyan
        Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size, HealthStatus, OperationalStatus | Format-Table -AutoSize
    } catch {
        Write-Host '   Khong ho tro Get-PhysicalDisk' -ForegroundColor Gray
    }
    
    try {
        # Try Get-Disk
        Write-Host '`n[Phuong phap 2: Get-Disk]' -ForegroundColor Cyan
        Get-Disk | Select-Object FriendlyName, Size, HealthStatus, OperationalStatus | Format-Table -AutoSize
    } catch {
        Write-Host '   Khong ho tro Get-Disk' -ForegroundColor Gray
    }
    
    try {
        # Try WMI (legacy)
        Write-Host '`n[Phuong phap 3: WMI]' -ForegroundColor Cyan
        Get-WmiObject -Class Win32_DiskDrive | Select-Object Model, Size, Status | Format-Table -AutoSize
    } catch {
        Write-Host '   Khong ho tro WMI' -ForegroundColor Gray
    }
    
    Write-Host '`nGIAI THICH:' -ForegroundColor Green
    Write-Host 'Healthy: Khoe manh' -ForegroundColor Green
    Write-Host 'Warning: Can theo doi' -ForegroundColor Yellow
    Write-Host 'Unhealthy: Co van de' -ForegroundColor Red
}"
echo.
echo [1] Quay lai menu S.M.A.R.T
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p smart_return="Lua chon (1-3): "
if "%smart_return%"=="1" goto DISK_SMART_MENU
if "%smart_return%"=="2" goto DISK_CHECK
if "%smart_return%"=="3" goto MAIN_MENU
goto SMART_PS

:SMART_WMIC
cls
echo ========================================
echo      KIEM TRA S.M.A.R.T BANG WMIC
echo ========================================
echo.
echo Dang lay thong tin o dia...
echo.

wmic diskdrive get model,size,status /format:table
echo.

echo THONG TIN CHI TIET HON:
echo ======================
wmic diskdrive list brief
echo.

echo LUU Y: WMIC co the khong hien thi day du thong tin S.M.A.R.T.
echo Hay su dung CrystalDiskInfo de co ket qua tot hon.
echo.

echo [1] Quay lai menu S.M.A.R.T
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p wmic_return="Lua chon (1-3): "
if "%wmic_return%"=="1" goto DISK_SMART_MENU
if "%wmic_return%"=="2" goto DISK_CHECK
if "%wmic_return%"=="3" goto MAIN_MENU
goto SMART_WMIC

:SMART_CDI
cls
echo ========================================
echo      TAI CRYSTALDISKINFO
echo ========================================
echo.
echo CrystalDiskInfo la phan mem mien phi tot nhat de kiem tra S.M.A.R.T.
echo.
echo Ban muon:
echo [1] Tai CrystalDiskInfo (mo trinh duyet)
echo [2] Huong dan su dung CrystalDiskInfo
echo [3] Quay lai menu S.M.A.R.T
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p cdi_choice="Lua chon (1-5): "

if "%cdi_choice%"=="1" (
    echo Dang mo trinh duyet...
    start https://crystalmark.info/en/software/crystaldiskinfo/
    echo Da mo trinh duyet!
    pause
    goto SMART_CDI
)

if "%cdi_choice%"=="2" (
    cls
    echo ========================================
    echo    HUONG DAN SU DUNG CRYSTALDISKINFO
    echo ========================================
    echo.
    echo 1. Tai CrystalDiskInfo tu trang chu:
    echo    https://crystalmark.info/en/software/crystaldiskinfo/
    echo.
    echo 2. Cai dat va mo phan mem
    echo.
    echo 3. CrystalDiskInfo se tu dong:
    echo    - Hien thi thong tin tat ca o dia
    echo    - Cho biet suc khoe (Health Status)
    echo    - Hien thi nhiet do (Temperature)
    echo    - Hien thi thong so S.M.A.R.T
    echo.
    echo 4. Mau sac:
    echo    XANH LA: Tot
    echo    VANG: Canh bao
    echo    DO: Nguy hiem
    echo.
    pause
    goto SMART_CDI
)

if "%cdi_choice%"=="3" goto DISK_SMART_MENU
if "%cdi_choice%"=="4" goto DISK_CHECK
if "%cdi_choice%"=="5" goto MAIN_MENU
goto SMART_CDI

:: 5. Disk Analysis Menu
:DISK_ANALYSIS_MENU
cls
echo ========================================
echo      PHAN TICH DUNG LUONG O DIA
echo ========================================
echo.
echo Chon phuong phap phan tich:
echo [1] Phan tich nhanh cac thu muc lon
echo [2] Phan tich theo loai file
echo [3] Tai TreeSize Free (khuyen dung)
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p analysis_method="Lua chon (1-5): "

if "%analysis_method%"=="1" goto ANALYSIS_FOLDER
if "%analysis_method%"=="2" goto ANALYSIS_TYPE
if "%analysis_method%"=="3" goto ANALYSIS_TREESIZE
if "%analysis_method%"=="4" goto DISK_CHECK
if "%analysis_method%"=="5" goto MAIN_MENU
goto DISK_ANALYSIS_MENU

:ANALYSIS_FOLDER
cls
echo ========================================
echo    PHAN TICH CAC THU MUC LON NHAT
echo ========================================
echo.
echo Dang phan tich cac thu muc lon nhat tren C:\...
echo (Co the mat vai phut)
echo.

echo TOP 10 THU MUC LON NHAT TREN C:\:
echo ================================
echo.

:: Simple analysis using dir command
(
echo @echo off
echo echo DANG PHAN TICH, VUI LONG CHO...
echo echo.
echo for /d %%d in ("C:\*") do (
echo     dir "%%d" /s /a 2^>nul | find "File(s)" >nul
echo     if not errorlevel 1 (
echo         for /f "tokens=3" %%s in ('dir "%%d" /s /a 2^>nul ^| find "File(s)"') do (
echo             echo %%d - %%s bytes
echo         )
echo     )
echo )
echo echo.
echo echo PHAN TICH DA HOAN TAT!
) > "%temp%\analyze.bat"

call "%temp%\analyze.bat"
echo.

echo LUU Y: Day la phan tich don gian.
echo Su dung TreeSize Free de co ket qua chinh xac hon.
echo.

echo [1] Quay lai menu phan tich
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p folder_return="Lua chon (1-3): "
if "%folder_return%"=="1" goto DISK_ANALYSIS_MENU
if "%folder_return%"=="2" goto DISK_CHECK
if "%folder_return%"=="3" goto MAIN_MENU
goto ANALYSIS_FOLDER

:ANALYSIS_TYPE
cls
echo ========================================
echo    PHAN TICH THEO LOAI FILE
echo ========================================
echo.
echo Dang phan tich cac loai file tren C:\...
echo (Co the mat 3-10 phut)
echo.

echo Phan tich top loai file chiem dung luong:
echo ========================================
echo.

:: PowerShell script for file type analysis
(
echo $results = @{}
echo $totalSize = 0
echo 
echo Get-ChildItem -Path "C:\" -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
echo     $ext = $_.Extension.ToLower()
echo     if (-not $ext) { $ext = "[khong co duoi]" }
echo     
echo     if (-not $results.ContainsKey($ext)) {
echo         $results[$ext] = @{Count=0; Size=0}
echo     }
echo     
echo     $results[$ext].Count++
echo     $results[$ext].Size += $_.Length
echo     $totalSize += $_.Length
echo }
echo 
echo Write-Host "Tong dung luong: {0:N2} GB" -f ($totalSize / 1GB)
echo Write-Host ""
echo 
echo $results.GetEnumerator() | Sort-Object { $_.Value.Size } -Descending | Select-Object -First 10 | ForEach-Object {
echo     $gb = $_.Value.Size / 1GB
echo     $percent = ($_.Value.Size / $totalSize) * 100
echo     Write-Host ("{0,-15} {1,10} files {2,10:N2} GB ({3,5:N1}%%)" -f $_.Key, $_.Value.Count, $gb, $percent)
echo }
) > "%temp%\filetypes.ps1"

powershell -ExecutionPolicy Bypass -File "%temp%\filetypes.ps1"
echo.

echo [1] Quay lai menu phan tich
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p type_return="Lua chon (1-3): "
if "%type_return%"=="1" goto DISK_ANALYSIS_MENU
if "%type_return%"=="2" goto DISK_CHECK
if "%type_return%"=="3" goto MAIN_MENU
goto ANALYSIS_TYPE

:ANALYSIS_TREESIZE
cls
echo ========================================
echo        TAI TREESIZE FREE
echo ========================================
echo.
echo TreeSize Free la cong cu tot nhat de phan tich dung luong.
echo.
echo Ban muon:
echo [1] Tai TreeSize Free (mo trinh duyet)
echo [2] Huong dan su dung TreeSize
echo [3] Quay lai menu phan tich
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p treesize_choice="Lua chon (1-5): "

if "%treesize_choice%"=="1" (
    echo Dang mo trinh duyet...
    start https://www.jam-software.com/treesize_free
    echo Da mo trinh duyet!
    pause
    goto ANALYSIS_TREESIZE
)

if "%treesize_choice%"=="2" (
    cls
    echo ========================================
    echo    HUONG DAN SU DUNG TREESIZE
    echo ========================================
    echo.
    echo 1. Tai TreeSize Free tu:
    echo    https://www.jam-software.com/treesize_free
    echo.
    echo 2. Cai dat va mo phan mem
    echo.
    echo 3. TreeSize cho phep ban:
    echo    - Xem dung luong tung thu muc
    echo    - Sap xep theo kich thuoc
    echo    - Tim cac file lon nhat
    echo    - Xoa file truc tiep tu TreeSize
    echo.
    echo 4. Dac biet huu ich de:
    echo    - Tim file ranh chiem dung luong
    echo    - Quan ly dung luong o dia
    echo    - Do xem thu muc nao can don dep
    echo.
    pause
    goto ANALYSIS_TREESIZE
)

if "%treesize_choice%"=="3" goto DISK_ANALYSIS_MENU
if "%treesize_choice%"=="4" goto DISK_CHECK
if "%treesize_choice%"=="5" goto MAIN_MENU
goto ANALYSIS_TREESIZE

:: 6. Disk Health Menu
:DISK_HEALTH_MENU
cls
echo ========================================
echo    KIEM TRA SUC KHOE SSD
echo ========================================
echo.
echo Chon tinh nang kiem tra:
echo [1] Kiem tra suc khoe SSD
echo [2] Toi uu o dia (Optimize Drives)
echo [3] Kiem tra TRIM status cho SSD
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p health_choice="Lua chon (1-5): "

if "%health_choice%"=="1" goto HEALTH_CHECK
if "%health_choice%"=="2" goto HEALTH_OPTIMIZE
if "%health_choice%"=="3" goto HEALTH_TRIM
if "%health_choice%"=="4" goto DISK_CHECK
if "%health_choice%"=="5" goto MAIN_MENU
goto DISK_HEALTH_MENU

:HEALTH_CHECK
cls
echo ========================================
echo    KIEM TRA SUC KHOE SSD
echo ========================================
echo.
echo Dang kiem tra suc khoe cac o dia...
echo.

powershell -Command "& {
    Write-Host 'KIEM TRA SUC KHOE O DIA' -ForegroundColor Yellow
    Write-Host '========================' -ForegroundColor Yellow
    Write-Host ''
    
    try {
        $disks = Get-Disk -ErrorAction Stop
        
        foreach ($disk in $disks) {
            Write-Host ('O dia {0}: {1}' -f $disk.Number, $disk.FriendlyName) -ForegroundColor Cyan
            
            if ($disk.MediaType -eq 'SSD') {
                Write-Host '   Loai: SSD' -ForegroundColor Green
            } elseif ($disk.MediaType -eq 'HDD') {
                Write-Host '   Loai: HDD' -ForegroundColor Yellow
            } else {
                Write-Host ('   Loai: {0}' -f $disk.MediaType) -ForegroundColor Gray
            }
            
            Write-Host ('   Suc khoe: {0}' -f $disk.HealthStatus) -ForegroundColor Green
            Write-Host ('   Trang thai: {0}' -f $disk.OperationalStatus) -ForegroundColor Green
            
            $sizeGB = [math]::Round($disk.Size / 1GB, 2)
            Write-Host ('   Dung luong: {0} GB' -f $sizeGB) -ForegroundColor Green
            
            if ($disk.IsBoot) {
                Write-Host '   [O DIA BOOT]' -ForegroundColor Red
            }
            
            Write-Host ''
        }
    } catch {
        Write-Host 'Khong the lay thong tin o dia!' -ForegroundColor Red
        Write-Host 'Co the do quyen Administrator hoac phien ban Windows.' -ForegroundColor Yellow
    }
    
    Write-Host '`nGIAI THICH:' -ForegroundColor Magenta
    Write-Host 'Healthy: Khoe manh' -ForegroundColor Green
    Write-Host 'Warning: Can theo doi' -ForegroundColor Yellow
    Write-Host 'Unhealthy: Co van de' -ForegroundColor Red
}"
echo.

echo [1] Quay lai menu kiem tra suc khoe
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p health_check_return="Lua chon (1-3): "
if "%health_check_return%"=="1" goto DISK_HEALTH_MENU
if "%health_check_return%"=="2" goto DISK_CHECK
if "%health_check_return%"=="3" goto MAIN_MENU
goto HEALTH_CHECK

:HEALTH_OPTIMIZE
cls
echo ========================================
echo        TOI UU O DIA
echo ========================================
echo.
echo Tinh nang Optimize Drives giup:
echo - Toi uu SSD (TRIM)
echo - Chong phan manh HDD
echo.

echo Ban muon:
echo [1] Mo Optimize Drives
echo [2] Toi uu tat ca o dia
echo [3] Quay lai menu kiem tra suc khoe
echo [4] Quay lai menu kiem tra o dia
echo [5] Quay lai menu chinh
echo.
set /p optimize_choice="Lua chon (1-5): "

if "%optimize_choice%"=="1" (
    echo Dang mo Optimize Drives...
    %windir%\system32\dfrgui.exe
    echo Da mo Optimize Drives!
    pause
    goto HEALTH_OPTIMIZE
)

if "%optimize_choice%"=="2" (
    echo Dang toi uu tat ca o dia...
    echo.
    powershell -Command "Optimize-Volume -DriveLetter C -Defrag -Verbose"
    echo.
    echo Da hoan thanh toi uu!
    pause
    goto HEALTH_OPTIMIZE
)

if "%optimize_choice%"=="3" goto DISK_HEALTH_MENU
if "%optimize_choice%"=="4" goto DISK_CHECK
if "%optimize_choice%"=="5" goto MAIN_MENU
goto HEALTH_OPTIMIZE

:HEALTH_TRIM
cls
echo ========================================
echo        KIEM TRA TRIM STATUS
echo ========================================
echo.
echo TRIM la tinh nang quan trong giup SSD hoat dong tot.
echo.
echo Dang kiem tra TRIM...
echo.

powershell -Command "& {
    Write-Host 'KIEM TRA TRIM' -ForegroundColor Yellow
    
    $trim = fsutil behavior query DisableDeleteNotify 2>$null
    
    if ($trim -match 'DisableDeleteNotify\s*=\s*0') {
        Write-Host 'TRIM: DANG BAT (Tot cho SSD)' -ForegroundColor Green
    } elseif ($trim -match 'DisableDeleteNotify\s*=\s*1') {
        Write-Host 'TRIM: DANG TAT (Can bat len)' -ForegroundColor Red
        Write-Host 'Chay lenh sau de bat TRIM:' -ForegroundColor Yellow
        Write-Host 'fsutil behavior set DisableDeleteNotify 0' -ForegroundColor White
    } else {
        Write-Host 'Khong the kiem tra TRIM' -ForegroundColor Gray
    }
}"
echo.

echo [1] Quay lai menu kiem tra suc khoe
echo [2] Quay lai menu kiem tra o dia
echo [3] Quay lai menu chinh
echo.
set /p trim_return="Lua chon (1-3): "
if "%trim_return%"=="1" goto DISK_HEALTH_MENU
if "%trim_return%"=="2" goto DISK_CHECK
if "%trim_return%"=="3" goto MAIN_MENU
goto HEALTH_TRIM

:: =================================================================
:: 8. Rename computer (UNCHANGED)
:: =================================================================
:RENAME_PC
cls
echo ========================================
echo          DOI TEN MAY TINH
echo ========================================
echo.
echo Ten may hien tai: %COMPUTERNAME%
echo.
set /p new_name="Nhap ten moi cho may tinh: "
if "%new_name%"=="" goto MAIN_MENU

echo.
echo CANH BAO: May tinh se khoi dong lai sau khi doi ten!
echo Ban co chac chan muon doi ten thanh: %new_name% ? (y/n)
set /p confirm=
if /i "%confirm%"=="y" (
    wmic computersystem where name="%computername%" call rename name="%new_name%"
    echo.
    echo [THANH CONG] May tinh se duoc doi ten sau khi khoi dong lai!
    echo.
    echo Co muon khoi dong lai ngay bay gio khong? (y/n)
    set /p restart_now=
    if /i "%restart_now%"=="y" shutdown /r /t 10 /c "May tinh dang khoi dong lai sau khi doi ten..."
)
pause
goto MAIN_MENU

:: =================================================================
:: 9. Change password (IMPROVED)
:: =================================================================
:CHANGE_PASSWORD
cls
echo ========================================
echo          DOI MAT KHAU MAY TINH
echo ========================================
echo.
echo DANH SACH NGUOI DUNG HIEN CO:
echo ============================
net user
echo.
set /p username="Nhap ten nguoi dung can doi mat khau: "
if "%username%"=="" goto MAIN_MENU

net user %username% >nul 2>&1
if errorlevel 1 (
    echo [LOI] Nguoi dung "%username%" khong ton tai!
    pause
    goto CHANGE_PASSWORD
)

echo.
echo Dang doi mat khau cho nguoi dung: %username%
echo.
echo HUONG DAN: Nhap mat khau moi (khong hien thi), Enter, nhap lai lan nua
net user %username% *
if errorlevel 0 (
    echo [THANH CONG] Da doi mat khau cho nguoi dung: %username%
) else (
    echo [LOI] Khong the doi mat khau!
)
pause
goto MAIN_MENU

:: =================================================================
:: 10. Add new user (IMPROVED)
:: =================================================================
:ADD_USER
cls
echo ========================================
echo          THEM NGUOI DUNG MOI
echo ========================================
echo.
set /p newuser="Nhap ten nguoi dung moi: "
if "%newuser%"=="" goto MAIN_MENU

:: Check if user already exists
net user %newuser% >nul 2>&1
if not errorlevel 1 (
    echo [LOI] Nguoi dung "%newuser%" da ton tai!
    pause
    goto ADD_USER
)

set /p userpass="Nhap mat khau: "
if "%userpass%"=="" (
    echo [CANH BAO] Khong nhap mat khau se tao tai khoan khong mat khau!
)

echo.
echo CHON QUYEN CHO NGUOI DUNG:
echo [1] Administrator (Day du quyen)
echo [2] Standard User (Quyen han che)
echo [3] Guest (Quyen rat han che)
echo.
set /p userrole="Lua chon (1-3): "

echo.
echo Dang tao nguoi dung...
if "%userpass%"=="" (
    net user %newuser% /add
) else (
    net user %newuser% %userpass% /add
)

if errorlevel 1 (
    echo [LOI] Khong the tao nguoi dung!
    pause
    goto ADD_USER
)

if "%userrole%"=="1" (
    net localgroup administrators %newuser% /add
    echo Da tao nguoi dung voi quyen Administrator!
) else if "%userrole%"=="2" (
    echo Da tao nguoi dung voi quyen Standard User!
) else if "%userrole%"=="3" (
    net localgroup guests %newuser% /add
    echo Da tao nguoi dung voi quyen Guest!
) else (
    echo Da tao nguoi dung (mac dinh: Standard User)!
)

echo.
echo THONG TIN TAI KHOAN:
echo - Ten dang nhap: %newuser%
if not "%userpass%"=="" echo - Mat khau: [Da duoc cai dat]
if "%userrole%"=="1" echo - Quyen: Administrator
if "%userrole%"=="2" echo - Quyen: Standard User
if "%userrole%"=="3" echo - Quyen: Guest
echo.
pause
goto MAIN_MENU

:: =================================================================
:: 11. Clean credentials (IMPROVED)
:: =================================================================
:CLEAN_CREDENTIALS
cls
echo ========================================
echo      XOA WINDOWS CREDENTIALS
echo ========================================
echo.
echo DANH SACH CREDENTIALS HIEN CO:
echo =============================
cmdkey /list
echo.

echo LUA CHON THAO TAC:
echo [1] Xoa tat ca credentials
echo [2] Xoa credential cu the
echo [3] Xoa lich su Windows (Recent, Run, etc.)
echo [4] Quay lai
echo.
set /p cred_choice="Lua chon (1-4): "

if "%cred_choice%"=="1" (
    echo Dang xoa tat ca credentials...
    for /f "tokens=2 delims=:" %%i in ('cmdkey /list ^| findstr "Target"') do (
        echo   Xoa: %%i
        cmdkey /delete:%%i
    )
    echo [THANH CONG] Da xoa tat ca credentials!
    pause
    goto CLEAN_CREDENTIALS
)

if "%cred_choice%"=="2" (
    set /p cred_target="Nhap Target can xoa (copy tu danh sach tren): "
    if not "%cred_target%"=="" (
        cmdkey /delete:"%cred_target%"
        echo Da xoa credential: %cred_target%
    )
    pause
    goto CLEAN_CREDENTIALS
)

if "%cred_choice%"=="3" (
    echo Dang xoa lich su Windows...
    :: Clear Run history
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f 2>nul
    
    :: Clear Recent documents
    del /q /f "%appdata%\Microsoft\Windows\Recent\*.*" 2>nul
    
    :: Clear typed URLs in IE/Edge
    reg delete "HKCU\Software\Microsoft\Internet Explorer\TypedURLs" /f 2>nul
    
    echo Da xoa lich su Windows!
    pause
    goto CLEAN_CREDENTIALS
)

if "%cred_choice%"=="4" goto MAIN_MENU
goto CLEAN_CREDENTIALS

:: =================================================================
:: 12. Network speed test (FIXED - PROPER EXIT TO MAIN MENU)
:: =================================================================
:NETWORK_SPEED
cls
echo ========================================
echo        KIEM TRA TOC DO MANG
echo ========================================
echo.
echo [1] Kiem tra ping co ban
echo [2] Kiem tra ket noi Internet
echo [3] Hien thi thong tin mang
echo [4] Reset mang (TCP/IP)
echo [5] Kiem tra ports va ket noi
echo [6] Quay lai menu chinh
echo.
set /p net_choice="Lua chon (1-6): "

if "%net_choice%"=="1" goto NET_PING_MENU
if "%net_choice%"=="2" goto NET_INTERNET
if "%net_choice%"=="3" goto NET_INFO
if "%net_choice%"=="4" goto NET_RESET
if "%net_choice%"=="5" goto NET_PORTS_MENU
if "%net_choice%"=="6" (
    cls
    goto MAIN_MENU
)
goto NETWORK_SPEED

:: 1. Ping Test Menu
:NET_PING_MENU
cls
echo ========================================
echo        KIEM TRA PING
echo ========================================
echo.
echo Chon muc tieu kiem tra ping:
echo [1] Google (8.8.8.8)
echo [2] Cloudflare (1.1.1.1)
echo [3] OpenDNS (208.67.222.222)
echo [4] Tu nhap dia chi IP/domain
echo [5] Quay lai menu kiem tra mang
echo [6] Quay lai menu chinh
echo.
set /p ping_choice="Lua chon (1-6): "

if "%ping_choice%"=="1" (
    set "ping_target=8.8.8.8"
    set "ping_name=Google DNS"
    goto DO_PING
)

if "%ping_choice%"=="2" (
    set "ping_target=1.1.1.1"
    set "ping_name=Cloudflare DNS"
    goto DO_PING
)

if "%ping_choice%"=="3" (
    set "ping_target=208.67.222.222"
    set "ping_name=OpenDNS"
    goto DO_PING
)

if "%ping_choice%"=="4" (
    echo.
    set /p ping_target="Nhap dia chi IP hoac domain: "
    if "%ping_target%"=="" (
        echo Khong nhap gi, quay lai...
        pause
        goto NET_PING_MENU
    )
    set "ping_name=%ping_target%"
    goto DO_PING
)

if "%ping_choice%"=="5" goto NETWORK_SPEED
if "%ping_choice%"=="6" (
    cls
    goto MAIN_MENU
)
goto NET_PING_MENU

:DO_PING
cls
echo ========================================
echo    KIEM TRA PING: %ping_name%
echo ========================================
echo.
echo Dang ping %ping_target% (4 goi tin)...
echo.

ping %ping_target% -n 4
echo.

echo KET QUA PING:
echo - Neu co "Reply from": Ket noi tot
echo - Neu co "Request timed out": Mat ket noi
echo - Neu co "Destination host unreachable": Co van de mang
echo.

echo [1] Ping lai (10 goi tin)
echo [2] Ping muc tieu khac
echo [3] Quay lai menu ping
echo [4] Quay lai menu kiem tra mang
echo [5] Quay lai menu chinh
echo.
set /p ping_return="Lua chon (1-5): "

if "%ping_return%"=="1" (
    echo.
    echo Dang ping %ping_target% (10 goi tin)...
    ping %ping_target% -n 10
    pause
    goto DO_PING
)

if "%ping_return%"=="2" goto NET_PING_MENU
if "%ping_return%"=="3" goto NET_PING_MENU
if "%ping_return%"=="4" goto NETWORK_SPEED
if "%ping_return%"=="5" (
    cls
    goto MAIN_MENU
)
goto DO_PING

:: 2. Internet Connection Test
:NET_INTERNET
cls
echo ========================================
echo    KIEM TRA KET NOI INTERNET
echo ========================================
echo.
echo Dang kiem tra ket noi Internet...
echo.

echo 1. Kiem tra ket noi mang noi bo...
ipconfig | findstr "IPv4" | findstr /v "169.254"
echo.

echo 2. Kiem tra ket noi den Gateway...
setlocal enabledelayedexpansion
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%a"
    set "gateway=!gateway: =!"
    if not "!gateway!"=="" (
        echo Ping Gateway: !gateway!
        ping !gateway! -n 2 >nul
        if errorlevel 1 (
            echo   [LOI] Khong ket noi duoc den Gateway!
        ) else (
            echo   [OK] Ket noi Gateway thanh cong!
        )
    )
)
echo.

echo 3. Kiem tra ket noi DNS...
echo Ping Google DNS (8.8.8.8)...
ping 8.8.8.8 -n 2 >nul
if errorlevel 1 (
    echo   [LOI] Khong ket noi duoc DNS!
) else (
    echo   [OK] Ket noi DNS thanh cong!
)
echo.

echo 4. Kiem tra phan giai ten mien...
nslookup www.google.com >nul 2>&1
if errorlevel 1 (
    echo   [LOI] Khong phan giai duoc ten mien!
) else (
    echo   [OK] Phan giai ten mien thanh cong!
)
echo.

echo 5. Kiem tra ket noi website...
echo Test ket noi den google.com...
ping www.google.com -n 2 >nul
if errorlevel 1 (
    echo   [LOI] Khong ket noi duoc Internet!
    echo.
    echo NGUYEN NHAN CO THE:
    echo - Mat ket noi Internet
    echo - DNS bi loi
    echo - Firewall chan
    echo - Cau hinh mang sai
) else (
    echo   [OK] CO KET NOI INTERNET!
    echo.
    echo Ban co the truy cap Internet binh thuong.
)
echo.

echo [1] Quay lai menu kiem tra mang
echo [2] Quay lai menu chinh
echo.
set /p internet_return="Lua chon (1-2): "
if "%internet_return%"=="1" goto NETWORK_SPEED
if "%internet_return%"=="2" (
    cls
    goto MAIN_MENU
)
goto NET_INTERNET

:: 3. Network Information
:NET_INFO
cls
echo ========================================
echo        THONG TIN MANG
echo ========================================
echo.
echo Dang lay thong tin mang...
echo.

echo THONG TIN KET NOI MANG:
echo ======================
ipconfig /all | findstr /C:"Host Name" /C:"Node Type" /C:"DNS Suffix"
echo.

echo THONG TIN ADAPTER:
echo =================
ipconfig | findstr /C:"Ethernet adapter" /C:"Wireless LAN adapter" /C:"PPP adapter"
echo.

echo DIA CHI IP:
echo ==========
ipconfig | findstr "IPv4"
echo.

echo DEFAULT GATEWAY:
echo ===============
ipconfig | findstr "Default Gateway"
echo.

echo DNS SERVERS:
echo ===========
ipconfig /all | findstr "DNS Servers"
echo.

echo MAC ADDRESS (Dia chi vat ly):
echo ============================
ipconfig /all | findstr "Physical Address"
echo.

echo THONG TIN KET NOI HIEN TAI:
echo ==========================
netstat -an | findstr "ESTABLISHED" | findstr /v "127.0.0.1" | more
echo.

echo [1] Quay lai menu kiem tra mang
echo [2] Quay lai menu chinh
echo.
set /p info_return="Lua chon (1-2): "
if "%info_return%"=="1" goto NETWORK_SPEED
if "%info_return%"=="2" (
    cls
    goto MAIN_MENU
)
goto NET_INFO

:: 4. Network Reset
:NET_RESET
cls
echo ========================================
echo        RESET MANG (TCP/IP)
echo ========================================
echo.
echo CANH BAO: Reset mang co the:
echo - Lam mat ket noi Internet tam thoi
echo - Xoa cau hinh mang
echo - Can khoi dong lai may
echo.
echo Ban co chac chan muon reset mang? (y/n)
set /p reset_confirm=
if /i not "%reset_confirm%"=="y" (
    echo Da huy thao tac!
    pause
    goto NETWORK_SPEED
)

cls
echo ========================================
echo        DANG RESET MANG
echo ========================================
echo.

echo 1. Dang reset Winsock...
netsh winsock reset catalog
echo   [OK] Da reset Winsock!
echo.

echo 2. Dang reset TCP/IP...
netsh int ip reset reset.log
echo   [OK] Da reset TCP/IP!
echo.

echo 3. Dang xoa DNS cache...
ipconfig /flushdns
echo   [OK] Da xoa DNS cache!
echo.

echo 4. Dang dang ky lai DNS...
ipconfig /registerdns
echo   [OK] Da dang ky DNS!
echo.

echo 5. Dang reset Firewall...
netsh advfirewall reset
echo   [OK] Da reset Firewall!
echo.

echo ========================================
echo    DA HOAN THANH RESET MANG!
echo ========================================
echo.
echo CAC BUOC TIEP THEO:
echo 1. KHOI DONG LAI MAY de thay doi co hieu luc
echo 2. Sau khi khoi dong, kiem tra lai ket noi mang
echo 3. Neu van co van de, lien he nha mang
echo.
echo Co muon khoi dong lai may ngay bay gio? (y/n)
set /p reset_reboot=

if /i "%reset_reboot%"=="y" (
    echo May se khoi dong lai sau 30 giay...
    shutdown /r /t 30 /c "Dang khoi dong lai sau khi reset mang"
) else (
    echo Hay nho khoi dong lai may som!
)

echo.
echo [1] Quay lai menu kiem tra mang
echo [2] Quay lai menu chinh
echo.
set /p reset_return="Lua chon (1-2): "
if "%reset_return%"=="1" goto NETWORK_SPEED
if "%reset_return%"=="2" (
    cls
    goto MAIN_MENU
)
goto NET_RESET

:: 5. Ports and Connections Menu
:NET_PORTS_MENU
cls
echo ========================================
echo    KIEM TRA PORTS VA KET NOI
echo ========================================
echo.
echo [1] Hien thi cac ket noi dang active
echo [2] Kiem tra port cu the
echo [3] Scan cac port thuong dung
echo [4] Quay lai menu kiem tra mang
echo [5] Quay lai menu chinh
echo.
set /p ports_choice="Lua chon (1-5): "

if "%ports_choice%"=="1" goto PORTS_ACTIVE
if "%ports_choice%"=="2" goto PORTS_CHECK
if "%ports_choice%"=="3" goto PORTS_SCAN
if "%ports_choice%"=="4" goto NETWORK_SPEED
if "%ports_choice%"=="5" (
    cls
    goto MAIN_MENU
)
goto NET_PORTS_MENU

:PORTS_ACTIVE
cls
echo ========================================
echo    CAC KET NOI DANG ACTIVE
echo ========================================
echo.
echo Dang lay danh sach ket noi...
echo.

echo KET NOI ESTABLISHED (dang hoat dong):
echo ====================================
netstat -an | findstr "ESTABLISHED" | head -20
echo.

echo KET NOI LISTENING (dang lang nghe):
echo ==================================
netstat -an | findstr "LISTENING" | head -20
echo.

echo TONG SO KET NOI:
echo ===============
netstat -an | find /c "TCP"
echo.

echo [1] Quay lai menu kiem tra ports
echo [2] Quay lai menu kiem tra mang
echo [3] Quay lai menu chinh
echo.
set /p active_return="Lua chon (1-3): "
if "%active_return%"=="1" goto NET_PORTS_MENU
if "%active_return%"=="2" goto NETWORK_SPEED
if "%active_return%"=="3" (
    cls
    goto MAIN_MENU
)
goto PORTS_ACTIVE

:PORTS_CHECK
cls
echo ========================================
echo    KIEM TRA PORT CU THE
echo ========================================
echo.
echo Nhap port can kiem tra (1-65535):
set /p check_port=
if "%check_port%"=="" (
    echo Khong nhap gi, quay lai...
    pause
    goto PORTS_CHECK
)

echo %check_port% | findstr /r "^[0-9][0-9]*$" >nul
if errorlevel 1 (
    echo Port khong hop le!
    pause
    goto PORTS_CHECK
)

set /a port_num=%check_port%
if %port_num% lss 1 (
    echo Port phai lon hon 0!
    pause
    goto PORTS_CHECK
)

if %port_num% gtr 65535 (
    echo Port toi da la 65535!
    pause
    goto PORTS_CHECK
)

cls
echo ========================================
echo    KIEM TRA PORT %port_num%
echo ========================================
echo.

echo Dang kiem tra port %port_num%...
echo.

netstat -an | findstr ":%port_num% "
echo.

if %port_num% equ 80 (
    echo GIAI THICH: Port 80 - HTTP (Web)
) else if %port_num% equ 443 (
    echo GIAI THICH: Port 443 - HTTPS (Web bao mat)
) else if %port_num% equ 21 (
    echo GIAI THICH: Port 21 - FTP
) else if %port_num% equ 22 (
    echo GIAI THICH: Port 22 - SSH
) else if %port_num% equ 23 (
    echo GIAI THICH: Port 23 - Telnet
) else if %port_num% equ 25 (
    echo GIAI THICH: Port 25 - SMTP (Email)
) else if %port_num% equ 110 (
    echo GIAI THICH: Port 110 - POP3 (Email)
) else if %port_num% equ 143 (
    echo GIAI THICH: Port 143 - IMAP (Email)
) else if %port_num% equ 3389 (
    echo GIAI THICH: Port 3389 - Remote Desktop
) else (
    echo GIAI THICH: Day la port tu dinh nghia
)

echo.
echo [1] Kiem tra port khac
echo [2] Quay lai menu kiem tra ports
echo [3] Quay lai menu kiem tra mang
echo [4] Quay lai menu chinh
echo.
set /p check_return="Lua chon (1-4): "
if "%check_return%"=="1" goto PORTS_CHECK
if "%check_return%"=="2" goto NET_PORTS_MENU
if "%check_return%"=="3" goto NETWORK_SPEED
if "%check_return%"=="4" (
    cls
    goto MAIN_MENU
)
goto PORTS_CHECK

:PORTS_SCAN
cls
echo ========================================
echo    SCAN CAC PORT THUONG DUNG
echo ========================================
echo.
echo Dang kiem tra cac port thuong dung...
echo (Co the mat vai giay)
echo.

echo PORT    DICH VU          TRANG THAI
echo ==================================

setlocal enabledelayedexpansion
set "ports=21 22 23 25 53 80 110 143 443 445 3389 8080"
set "open_count=0"

for %%p in (%ports%) do (
    :: Get port name
    if %%p equ 21 set "port_name=FTP"
    if %%p equ 22 set "port_name=SSH"
    if %%p equ 23 set "port_name=Telnet"
    if %%p equ 25 set "port_name=SMTP"
    if %%p equ 53 set "port_name=DNS"
    if %%p equ 80 set "port_name=HTTP"
    if %%p equ 110 set "port_name=POP3"
    if %%p equ 143 set "port_name=IMAP"
    if %%p equ 443 set "port_name=HTTPS"
    if %%p equ 445 set "port_name=SMB"
    if %%p equ 3389 set "port_name=RDP"
    if %%p equ 8080 set "port_name=HTTP Alt"
    
    netstat -an | findstr ":%%p " >nul
    if errorlevel 1 (
        if %%p lss 1000 (
            echo %%p       !port_name!           [CLOSED]
        ) else (
            echo %%p      !port_name!           [CLOSED]
        )
    ) else (
        if %%p lss 1000 (
            echo %%p       !port_name!           [OPEN]
        ) else (
            echo %%p      !port_name!           [OPEN]
        )
        set /a open_count+=1
    )
)

echo.
echo TONG CONG: !open_count! port dang mo
echo.

echo GIAI THICH:
echo - OPEN: Port dang duoc su dung
echo - CLOSED: Port khong duoc su dung
echo - Neu co qua nhieu port OPEN, co the bi hack!
echo.

echo [1] Quay lai menu kiem tra ports
echo [2] Quay lai menu kiem tra mang
echo [3] Quay lai menu chinh
echo.
set /p scan_return="Lua chon (1-3): "
if "%scan_return%"=="1" goto NET_PORTS_MENU
if "%scan_return%"=="2" goto NETWORK_SPEED
if "%scan_return%"=="3" (
    cls
    goto MAIN_MENU
)
goto PORTS_SCAN

:: =================================================================
:: 13. Disable Windows Update (IMPROVED)
:: =================================================================
:DISABLE_UPDATES
cls
echo ========================================
echo      TAT WINDOWS UPDATE (TAM THOI)
echo ========================================
echo.
echo CANH BAO: Tat Windows Update co the gay mat bao mat!
echo Chi tam thoi tat cho may khong ket noi Internet.
echo.
echo [1] Tat Windows Update hoan toan
echo [2] Tat Windows Update tam thoi (co the bat lai)
echo [3] Quay lai
echo.
set /p disable_choice="Lua chon (1-3): "

if "%disable_choice%"=="1" (
    echo Dang tat Windows Update...
    sc config wuauserv start= disabled
    sc stop wuauserv
    net stop wuauserv 2>nul
    
    :: Disable via Registry
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 1 /f
    
    echo [THANH CONG] Da tat Windows Update hoan toan!
    pause
    goto MAIN_MENU
)

if "%disable_choice%"=="2" (
    echo Dang tam tat Windows Update...
    net stop wuauserv 2>nul
    sc stop wuauserv
    echo [THANH CONG] Da tam tat Windows Update!
    echo.
    echo Luu y: Windows Update se tu bat lai sau khi khoi dong may.
    pause
    goto MAIN_MENU
)

if "%disable_choice%"=="3" goto MAIN_MENU
goto DISABLE_UPDATES

:: =================================================================
:: 14. Enable Windows Update (UNCHANGED)
:: =================================================================
:ENABLE_UPDATES
cls
echo Dang bat Windows Update...
sc config wuauserv start= auto
sc start wuauserv
echo Da bat Windows Update!
pause
goto MAIN_MENU

:: =================================================================
:: 15. Software installation (IMPROVED WITH BACKUP)
:: =================================================================
:INSTALL_SOFTWARE
cls
echo ========================================
echo      CAI DAT PHAN MEM (MAY MOI)
echo ========================================
echo.
echo DANH SACH PHAN MEM CO SAN:
echo =========================
echo [1]  WinRAR (Nen giai nen)
echo [2]  Google Chrome (Trinh duyet)
echo [3]  Unikey (Go tieng Viet)
echo [4]  Zalo (Nhan tin)
echo [5]  Microsoft Teams (Hoi thao)
echo [6]  OneDrive (Luu tru dam may)
echo [7]  UltraViewer (Dieu khien tu xa)
echo [8]  VLC Media Player (Xem video)
echo [9]  Adobe Reader (Doc PDF)
echo [10] 7-Zip (Nen giai nen mien phi)
echo [11] CAI TAT CA phan mem tren
echo [12] Quay lai
echo.
set /p install_choice="Lua chon (1-12): "

if "%install_choice%"=="12" goto MAIN_MENU
if "%install_choice%"=="" goto INSTALL_SOFTWARE

cls
echo ========================================
echo      DANG CAI DAT PHAN MEM
echo ========================================
echo.
echo LUA CHON CAI DAT:
echo [A] Cai dat tu dong (khong can tuong tac)
echo [B] Cai dat thu cong (tuong tac)
set /p install_mode="Lua chon (A/B): "

if /i "%install_mode%"=="A" (
    set "SILENT_SWITCH=/S"
    set "PS_SILENT=-silent"
) else (
    set "SILENT_SWITCH="
    set "PS_SILENT="
)

:: Create software list for batch install
if "%install_choice%"=="11" (
    set "SOFTWARE_LIST=1 2 3 4 5 6 7 8 9 10"
) else (
    set "SOFTWARE_LIST=%install_choice%"
)

:: Installation functions
for %%S in (%SOFTWARE_LIST%) do (
    if "%%S"=="1" call :INSTALL_WINRAR
    if "%%S"=="2" call :INSTALL_CHROME
    if "%%S"=="3" call :INSTALL_UNIKEY
    if "%%S"=="4" call :INSTALL_ZALO
    if "%%S"=="5" call :INSTALL_TEAMS
    if "%%S"=="6" call :INSTALL_ONEDRIVE
    if "%%S"=="7" call :INSTALL_ULTRAVIEW
    if "%%S"=="8" call :INSTALL_VLC
    if "%%S"=="9" call :INSTALL_READER
    if "%%S"=="10" call :INSTALL_7ZIP
)

echo.
echo ========================================
echo    DA HOAN THANH CAI DAT PHAN MEM!
echo ========================================
echo.
pause
goto MAIN_MENU

:INSTALL_WINRAR
echo [1/10] Dang tai WinRAR...
powershell -Command "Invoke-WebRequest -Uri 'https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-624.exe' -OutFile '%temp%\winrar_install.exe' -ErrorAction Stop"
echo    Dang cai dat WinRAR...
start /wait "" "%temp%\winrar_install.exe" %SILENT_SWITCH%
echo    [OK] WinRAR da duoc cai dat!
goto :EOF

:INSTALL_CHROME
echo [2/10] Dang tai Google Chrome...
powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -OutFile '%temp%\chrome_installer.exe' -ErrorAction Stop"
echo    Dang cai dat Chrome...
start /wait "" "%temp%\chrome_installer.exe" %SILENT_SWITCH%
echo    [OK] Chrome da duoc cai dat!
goto :EOF

:INSTALL_UNIKEY
echo [3/10] Dang tai Unikey...
powershell -Command "Invoke-WebRequest -Uri 'https://unikey.vn/download/UniKey-4.3RC4-200729-setup.exe' -OutFile '%temp%\unikey_setup.exe' -ErrorAction Stop"
echo    Dang cai dat Unikey...
start /wait "" "%temp%\unikey_setup.exe" %SILENT_SWITCH%
echo    [OK] Unikey da duoc cai dat!
goto :EOF

:INSTALL_ZALO
echo [4/10] Dang tai Zalo...
powershell -Command "Invoke-WebRequest -Uri 'https://zalo.me/download/zalo-pc' -OutFile '%temp%\zalo_install.exe' -ErrorAction Stop"
echo    Dang cai dat Zalo...
start /wait "" "%temp%\zalo_install.exe" %SILENT_SWITCH%
echo    [OK] Zalo da duoc cai dat!
goto :EOF

:INSTALL_TEAMS
echo [5/10] Dang tai Microsoft Teams...
powershell -Command "Invoke-WebRequest -Uri 'https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&download=true' -OutFile '%temp%\teams_setup.exe' -ErrorAction Stop"
echo    Dang cai dat Teams...
start /wait "" "%temp%\teams_setup.exe" %PS_SILENT%
echo    [OK] Teams da duoc cai dat!
goto :EOF

:INSTALL_ONEDRIVE
echo [6/10] Dang tai OneDrive...
powershell -Command "Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/?linkid=844652' -OutFile '%temp%\onedrive_setup.exe' -ErrorAction Stop"
echo    Dang cai dat OneDrive...
start /wait "" "%temp%\onedrive_setup.exe" %SILENT_SWITCH%
echo    [OK] OneDrive da duoc cai dat!
goto :EOF

:INSTALL_ULTRAVIEW
echo [7/10] Dang tai UltraViewer...
powershell -Command "Invoke-WebRequest -Uri 'https://ultraviewer.net/en/UltraViewer_setup.exe' -OutFile '%temp%\ultraviewer_setup.exe' -ErrorAction Stop"
echo    Dang cai dat UltraViewer...
start /wait "" "%temp%\ultraviewer_setup.exe" %SILENT_SWITCH%
echo    [OK] UltraViewer da duoc cai dat!
goto :EOF

:INSTALL_VLC
echo [8/10] Dang tai VLC Media Player...
powershell -Command "Invoke-WebRequest -Uri 'https://get.videolan.org/vlc/3.0.20/win64/vlc-3.0.20-win64.exe' -OutFile '%temp%\vlc_setup.exe' -ErrorAction Stop"
echo    Dang cai dat VLC...
start /wait "" "%temp%\vlc_setup.exe" %SILENT_SWITCH%
echo    [OK] VLC da duoc cai dat!
goto :EOF

:INSTALL_READER
echo [9/10] Dang tai Adobe Reader...
powershell -Command "Invoke-WebRequest -Uri 'https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120141/AcroRdrDC2200120141_en_US.exe' -OutFile '%temp%\reader_setup.exe' -ErrorAction Stop"
echo    Dang cai dat Adobe Reader...
start /wait "" "%temp%\reader_setup.exe" %SILENT_SWITCH%
echo    [OK] Adobe Reader da duoc cai dat!
goto :EOF

:INSTALL_7ZIP
echo [10/10] Dang tai 7-Zip...
powershell -Command "Invoke-WebRequest -Uri 'https://www.7-zip.org/a/7z2301-x64.exe' -OutFile '%temp%\7zip_setup.exe' -ErrorAction Stop"
echo    Dang cai dat 7-Zip...
start /wait "" "%temp%\7zip_setup.exe" %SILENT_SWITCH%
echo    [OK] 7-Zip da duoc cai dat!
goto :EOF

:: =================================================================
:: 16. Security settings (NEW)
:: =================================================================
:SECURITY_SETTINGS
cls
echo ========================================
echo    CAI DAT BAO MAT WINDOWS DEFENDER
echo ========================================
echo.
echo [1] Bat Windows Defender (mac dinh)
echo [2] Tat Windows Defender (khuyen nghi can than)
echo [3] Bat Windows Firewall
echo [4] Tat Windows Firewall
echo [5] Quet virus nhanh voi Windows Defender
echo [6] Quay lai
echo.
set /p sec_choice="Lua chon (1-6): "

if "%sec_choice%"=="1" (
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    echo Da bat Windows Defender!
    pause
    goto SECURITY_SETTINGS
)

if "%sec_choice%"=="2" (
    powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    echo Da tat Windows Defender!
    echo CANH BAO: May tinh co nguy co bi virus!
    pause
    goto SECURITY_SETTINGS
)

if "%sec_choice%"=="3" (
    netsh advfirewall set allprofiles state on
    echo Da bat Windows Firewall!
    pause
    goto SECURITY_SETTINGS
)

if "%sec_choice%"=="4" (
    netsh advfirewall set allprofiles state off
    echo Da tat Windows Firewall!
    echo CANH BAO: May tinh co nguy co bi tan cong!
    pause
    goto SECURITY_SETTINGS
)

if "%sec_choice%"=="5" (
    echo Dang quet virus nhanh...
    MpCmdRun.exe -Scan -ScanType 1
    echo Da bat dau quet virus!
    pause
    goto SECURITY_SETTINGS
)

if "%sec_choice%"=="6" goto MAIN_MENU
goto SECURITY_SETTINGS

:: =================================================================
:: 17. Registry backup (NEW)
:: =================================================================
:REGISTRY_BACKUP
cls
echo ========================================
echo      BACKUP & RESTORE REGISTRY
echo ========================================
echo CANH BAO: Thao tac voi Registry rat nguy hiem!
echo           Chi thuc hien neu ban biet ro minh dang lam gi.
echo.
echo [1] Backup Registry hien tai
echo [2] Restore Registry tu backup
echo [3] Xoa backup cu
echo [4] Quay lai
echo.
set /p reg_choice="Lua chon (1-4): "

if "%reg_choice%"=="1" (
    set "BACKUP_PATH=%userprofile%\Desktop\RegistryBackup_%date:~10,4%%date:~4,2%%date:~7,2%"
    mkdir "%BACKUP_PATH%" 2>nul
    echo Dang backup Registry...
    reg export HKLM "%BACKUP_PATH%\HKLM.reg"
    reg export HKCU "%BACKUP_PATH%\HKCU.reg"
    echo Da backup Registry toi: %BACKUP_PATH%
    pause
    goto REGISTRY_BACKUP
)

if "%reg_choice%"=="2" (
    echo Nhap duong dan toi file .reg backup:
    set /p reg_file=
    if exist "!reg_file!" (
        reg import "!reg_file!"
        echo Da restore Registry!
    ) else (
        echo File khong ton tai!
    )
    pause
    goto REGISTRY_BACKUP
)

if "%reg_choice%"=="3" (
    del /q /f "%userprofile%\Desktop\RegistryBackup_*" 2>nul
    echo Da xoa cac backup cu!
    pause
    goto REGISTRY_BACKUP
)

if "%reg_choice%"=="4" goto MAIN_MENU
goto REGISTRY_BACKUP

:: =================================================================
:: 18. Fix Windows errors (NEW)
:: =================================================================
:FIX_WINDOWS
cls
echo ========================================
echo     KIEM TRA & SUA LOI WINDOWS
echo ========================================
echo.
echo [1] Kiem tra file Windows bi hong (SFC)
echo [2] Kiem tra image Windows (DISM)
echo [3] Fix loi Windows Update
echo [4] Reset Windows Store
echo [5] Quay lai
echo.
set /p fix_choice="Lua chon (1-5): "

if "%fix_choice%"=="1" (
    echo Dang kiem tra file Windows bi hong...
    sfc /scannow
    echo.
    echo Da hoan thanh kiem tra!
    pause
    goto FIX_WINDOWS
)

if "%fix_choice%"=="2" (
    echo Dang kiem tra image Windows...
    DISM /Online /Cleanup-Image /CheckHealth
    echo.
    echo Chay DISM /Online /Cleanup-Image /RestoreHealth de sua loi.
    pause
    goto FIX_WINDOWS
)

if "%fix_choice%"=="3" (
    echo Dang fix loi Windows Update...
    net stop wuauserv
    net stop cryptSvc
    net stop bits
    net stop msiserver
    
    ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
    ren C:\Windows\System32\catroot2 catroot2.old
    
    net start wuauserv
    net start cryptSvc
    net start bits
    net start msiserver
    
    echo Da fix loi Windows Update!
    pause
    goto FIX_WINDOWS
)

if "%fix_choice%"=="4" (
    echo Dang reset Windows Store...
    wsreset.exe
    echo Da reset Windows Store!
    pause
    goto FIX_WINDOWS
)

if "%fix_choice%"=="5" goto MAIN_MENU
goto FIX_WINDOWS

:: =================================================================
:: 19. System information (NEW)
:: =================================================================
:SYSTEM_INFO
cls
echo ========================================
echo      THONG TIN HE THONG CHI TIET
echo ========================================
echo.
echo Dang thu thap thong tin he thong...
echo.

echo [THONG TIN MAY TINH]
echo ===================
echo Ten may: %COMPUTERNAME%
echo Nguoi dung: %USERNAME%
echo.

echo [THONG TIN PHAN CUNG]
echo ====================
systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" /C:"Total Physical Memory"
echo.

echo [THONG TIN CPU]
echo ==============
wmic cpu get name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed
echo.

echo [THONG TIN RAM]
echo ==============
wmic memorychip get capacity,speed,manufacturer,partnumber
echo.

echo [THONG TIN CARD MAN HINH]
echo ========================
wmic path win32_videocontroller get name,adapterram
echo.

echo [THONG TIN MANG]
echo ===============
ipconfig | findstr IPv4
echo.

echo Thong tin da duoc hien thi tren man hinh.
echo Nhan phim bat ky de quay lai...
pause >nul
goto MAIN_MENU
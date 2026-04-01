@echo off
chcp 65001 >nul

echo ============================================================
echo   系统环境诊断工具 (增强版)
echo ============================================================
echo 此脚本将帮助诊断部署问题
echo 按任意键继续...
pause >nul
echo.

echo [1] 检查当前目录
echo ------------------------------------------------------------
echo 当前目录: %CD%
echo 脚本目录: %~dp0
echo.
echo 按任意键继续...
pause >nul
echo.

echo [2] 检查系统 PATH 环境变量
echo ------------------------------------------------------------
echo 检查 Conda 是否在 PATH 中...
where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Conda 未在 PATH 中找到
    echo [ERROR] 请确保 Conda 已正确安装并添加到系统 PATH
    echo [INFO] 常见安装路径:
    echo        C:\Users\您的用户名\anaconda3\Scripts
    echo        C:\Users\您的用户名\miniconda3\Scripts
) else (
    echo [OK] Conda 已在 PATH 中找到
    for /f "delims=" %%i in ('where conda') do set CONDA_PATH=%%i
    echo Conda 路径: %CONDA_PATH%
    echo Conda 版本:
    conda --version
)
echo.
echo 按任意键继续...
pause >nul
echo.

echo [3] 检查 Python 环境
echo ------------------------------------------------------------
echo 检查 Python 是否在 PATH 中...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python 未在 PATH 中找到
) else (
    echo [OK] Python 已在 PATH 中找到
    echo Python 版本:
    python --version
)
echo.
echo 按任意键继续...
pause >nul
echo.
echo [4] 检查项目文件
echo ------------------------------------------------------------
if exist "%~dp0environment_optimized.yml" (
    echo [OK] 找到 environment_optimized.yml
    echo 文件大小: %~z0environment_optimized.yml 字节
) else (
    echo [ERROR] 未找到 environment_optimized.yml
    echo 当前目录文件:
    dir "%~dp0"
)
echo.
echo 按任意键继续...
pause >nul
echo.
echo [5] 检查 PowerShell 执行策略
echo ------------------------------------------------------------
echo 检查 PowerShell 执行策略...
powershell -Command "Get-ExecutionPolicy"
echo.
echo 按任意键继续...
pause >nul
echo.
echo [6] 检查系统架构
echo ------------------------------------------------------------
echo 系统信息:
systeminfo | findstr /C:"系统类型" /C:"处理器"
echo.
echo 按任意键继续...
pause >nul
echo.
echo [7] 检查磁盘空间
echo ------------------------------------------------------------
echo 磁盘空间:
dir C:\ | findstr /C:"可用字节"
echo.
echo 按任意键继续...
pause >nul
echo.
echo ============================================================
echo   诊断完成
echo ============================================================
echo.
echo 请根据以上信息判断问题所在
echo.
echo 常见问题:
echo 1. Conda 未安装或未添加到 PATH
echo 2. 项目文件不完整
echo 3. 磁盘空间不足
echo 4. 权限不足
echo.
echo 解决方案:
echo 1. 重新安装 Anaconda/Miniconda
echo 2. 确保所有项目文件完整
echo 3. 清理磁盘空间
echo 4. 以管理员身份运行命令提示符
echo.
echo 按任意键退出...
pause >nul

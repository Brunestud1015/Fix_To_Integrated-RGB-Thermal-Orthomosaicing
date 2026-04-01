@echo off
chcp 65001 >nul
setlocal

set ENV_NAME=integrated_rgb_thermal_ortho
set PROJECT_DIR=%~dp0

echo ============================================================
echo   Integrated RGB-Thermal Orthomosaicing - GUI 启动器
echo ============================================================
echo.

call conda activate %ENV_NAME%
if %errorlevel% neq 0 (
    echo [错误] 无法激活环境: %ENV_NAME%
    echo 请先运行 deploy.bat 创建环境
    pause
    exit /b 1
)

cd /d "%PROJECT_DIR%"
echo 正在启动 GUI...
python pipeline_tool.py

endlocal

@echo off
chcp 65001 >nul
echo ============================================================
echo   系统环境诊断工具
echo ============================================================
echo.

echo [检查 Conda]
where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Conda 未安装
    echo     下载地址: https://docs.conda.io/en/latest/miniconda.html
) else (
    echo [OK] Conda 已安装
    conda --version
)
echo.

echo [检查 Python]
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Python 未找到
) else (
    echo [OK] Python 已安装
    python --version
)
echo.

echo [检查 Git]
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] Git 未安装 ^(可选^)
) else (
    echo [OK] Git 已安装
    git --version
)
echo.

echo [检查 NVIDIA GPU]
where nvidia-smi >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] 未检测到 NVIDIA GPU 或驱动未安装
    echo     项目将使用 CPU 模式运行
) else (
    echo [OK] 检测到 NVIDIA GPU:
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
)
echo.

echo [检查项目文件]
if exist "%~dp0environment_optimized.yml" (
    echo [OK] 找到 environment_optimized.yml
) else (
    echo [X] 未找到 environment_optimized.yml
    echo     请确保文件存在于: %~dp0
)
echo.

echo [检查现有 Conda 环境]
conda env list | findstr /C:"integrated_rgb_thermal_ortho" >nul
if %errorlevel% equ 0 (
    echo [OK] 环境已存在: integrated_rgb_thermal_ortho
) else (
    echo [ ] 环境未创建: integrated_rgb_thermal_ortho
)
echo.

echo ============================================================
echo   诊断完成
echo ============================================================
echo.
echo 如果所有检查都通过，请运行 deploy.bat 开始部署
echo.

pause

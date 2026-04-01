@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set PROJECT_DIR=%~dp0
set ENV_NAME=integrated_rgb_thermal_ortho
set LOG_FILE=%PROJECT_DIR%deploy_log.txt

echo ============================================================ > "%LOG_FILE%" 2>&1
echo   Integrated RGB-Thermal Orthomosaicing 部署脚本 >> "%LOG_FILE%" 2>&1
echo   开始时间: %date% %time% >> "%LOG_FILE%" 2>&1
echo ============================================================ >> "%LOG_FILE%" 2>&1
echo. >> "%LOG_FILE%" 2>&1

echo ============================================================
echo   Integrated RGB-Thermal Orthomosaicing 部署脚本
echo ============================================================
echo.
echo 日志文件: %LOG_FILE%
echo.

echo [步骤 1/5] 检查系统环境... >> "%LOG_FILE%" 2>&1
echo [步骤 1/5] 检查系统环境...
echo.

where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Conda，请先安装 Anaconda 或 Miniconda >> "%LOG_FILE%" 2>&1
    echo [错误] 未找到 Conda，请先安装 Anaconda 或 Miniconda
    echo 下载地址: https://docs.conda.io/en/latest/miniconda.html
    echo.
    echo 请按任意键退出...
    pause >nul
    exit /b 1
)
echo [OK] Conda 已安装 >> "%LOG_FILE%" 2>&1
echo [OK] Conda 已安装
conda --version >> "%LOG_FILE%" 2>&1

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未找到 Git >> "%LOG_FILE%" 2>&1
    echo [警告] 未找到 Git，将无法自动克隆项目
    echo 请手动下载项目或安装 Git: https://git-scm.com/download/win
) else (
    echo [OK] Git 已安装 >> "%LOG_FILE%" 2>&1
    echo [OK] Git 已安装
    git --version >> "%LOG_FILE%" 2>&1
)

echo. >> "%LOG_FILE%" 2>&1
echo [步骤 2/5] 检查 NVIDIA GPU 和 CUDA... >> "%LOG_FILE%" 2>&1
echo.
echo [步骤 2/5] 检查 NVIDIA GPU 和 CUDA...
echo.

where nvidia-smi >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未检测到 NVIDIA GPU 或驱动未安装 >> "%LOG_FILE%" 2>&1
    echo [警告] 未检测到 NVIDIA GPU 或驱动未安装
    echo 项目将使用 CPU 模式运行，速度会较慢
) else (
    echo [OK] 检测到 NVIDIA GPU: >> "%LOG_FILE%" 2>&1
    echo [OK] 检测到 NVIDIA GPU:
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader >> "%LOG_FILE%" 2>&1
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
)

echo. >> "%LOG_FILE%" 2>&1
echo [步骤 3/5] 检查项目目录... >> "%LOG_FILE%" 2>&1
echo.
echo [步骤 3/5] 检查项目目录...
echo 项目目录: %PROJECT_DIR% >> "%LOG_FILE%" 2>&1
echo 项目目录: %PROJECT_DIR%
echo.

if not exist "%PROJECT_DIR%environment_optimized.yml" (
    echo [错误] 未找到 environment_optimized.yml >> "%LOG_FILE%" 2>&1
    echo [错误] 未找到 environment_optimized.yml
    echo 请确保该文件存在于: %PROJECT_DIR%
    echo.
    echo 请按任意键退出...
    pause >nul
    exit /b 1
)
echo [OK] 找到 environment_optimized.yml >> "%LOG_FILE%" 2>&1
echo [OK] 找到 environment_optimized.yml

echo. >> "%LOG_FILE%" 2>&1
echo [步骤 4/5] 创建 Conda 虚拟环境... >> "%LOG_FILE%" 2>&1
echo.
echo [步骤 4/5] 创建 Conda 虚拟环境...
echo 这可能需要较长时间，请耐心等待...
echo.

conda env list | findstr /C:"%ENV_NAME%" >nul
if %errorlevel% equ 0 (
    echo 环境已存在: %ENV_NAME% >> "%LOG_FILE%" 2>&1
    echo 环境已存在: %ENV_NAME%
    echo.
    choice /C YN /M "是否要重新创建环境"
    if !errorlevel! equ 1 (
        echo 正在删除旧环境... >> "%LOG_FILE%" 2>&1
        echo 正在删除旧环境...
        conda env remove -n %ENV_NAME% -y >> "%LOG_FILE%" 2>&1
        echo 正在创建新环境... >> "%LOG_FILE%" 2>&1
        echo 正在创建新环境...
        echo 创建环境中...请查看日志文件: %LOG_FILE%
        conda env create -f "%PROJECT_DIR%environment_optimized.yml" >> "%LOG_FILE%" 2>&1
    )
) else (
    echo 正在创建环境: %ENV_NAME% >> "%LOG_FILE%" 2>&1
    echo 正在创建环境: %ENV_NAME%
    echo 创建环境中...请查看日志文件: %LOG_FILE%
    conda env create -f "%PROJECT_DIR%environment_optimized.yml" >> "%LOG_FILE%" 2>&1
)

if %errorlevel% neq 0 (
    echo [错误] 环境创建失败，请查看日志文件: %LOG_FILE% >> "%LOG_FILE%" 2>&1
    echo.
    echo [错误] 环境创建失败
    echo 请查看日志文件: %LOG_FILE%
    echo.
    echo 请按任意键退出...
    pause >nul
    exit /b 1
)

echo [OK] 环境创建成功 >> "%LOG_FILE%" 2>&1
echo [OK] 环境创建成功

echo. >> "%LOG_FILE%" 2>&1
echo [步骤 5/5] 验证安装... >> "%LOG_FILE%" 2>&1
echo.
echo [步骤 5/5] 验证安装...
echo.

echo 激活环境... >> "%LOG_FILE%" 2>&1
call conda activate %ENV_NAME% >> "%LOG_FILE%" 2>&1

echo 检查 Python 版本... >> "%LOG_FILE%" 2>&1
echo 检查 Python 版本...
python --version >> "%LOG_FILE%" 2>&1
python --version

echo. >> "%LOG_FILE%" 2>&1
echo 检查 PyTorch CUDA 支持... >> "%LOG_FILE%" 2>&1
echo 检查 PyTorch CUDA 支持...
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')" >> "%LOG_FILE%" 2>&1
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyTorch 安装可能有问题 >> "%LOG_FILE%" 2>&1
    echo [警告] PyTorch 安装可能有问题
)

echo. >> "%LOG_FILE%" 2>&1
echo 检查 PyQt5... >> "%LOG_FILE%" 2>&1
echo 检查 PyQt5...
python -c "from PyQt5.QtWidgets import QApplication; print('PyQt5 OK')" >> "%LOG_FILE%" 2>&1
python -c "from PyQt5.QtWidgets import QApplication; print('PyQt5 OK')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyQt5 安装可能有问题 >> "%LOG_FILE%" 2>&1
    echo [警告] PyQt5 安装可能有问题
)

echo. >> "%LOG_FILE%" 2>&1
echo 检查 GDAL... >> "%LOG_FILE%" 2>&1
echo 检查 GDAL...
python -c "from osgeo import gdal; print(f'GDAL version: {gdal.__version__}')" >> "%LOG_FILE%" 2>&1
python -c "from osgeo import gdal; print(f'GDAL version: {gdal.__version__}')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] GDAL 安装可能有问题 >> "%LOG_FILE%" 2>&1
    echo [警告] GDAL 安装可能有问题
)

echo. >> "%LOG_FILE%" 2>&1
echo 检查其他核心依赖... >> "%LOG_FILE%" 2>&1
echo 检查其他核心依赖...
python -c "import cv2; print(f'OpenCV: {cv2.__version__}')" >> "%LOG_FILE%" 2>&1
python -c "import cv2; print(f'OpenCV: {cv2.__version__}')" 2>nul
python -c "import rasterio; print(f'rasterio: {rasterio.__version__}')" >> "%LOG_FILE%" 2>&1
python -c "import rasterio; print(f'rasterio: {rasterio.__version__}')" 2>nul
python -c "import geopandas; print(f'geopandas: {geopandas.__version__}')" >> "%LOG_FILE%" 2>&1
python -c "import geopandas; print(f'geopandas: {geopandas.__version__}')" 2>nul

echo. >> "%LOG_FILE%" 2>&1
echo ============================================================ >> "%LOG_FILE%" 2>&1
echo   部署完成! >> "%LOG_FILE%" 2>&1
echo   结束时间: %date% %time% >> "%LOG_FILE%" 2>&1
echo ============================================================ >> "%LOG_FILE%" 2>&1
echo.
echo ============================================================
echo   部署完成!
echo ============================================================
echo.
echo 项目目录: %PROJECT_DIR%
echo 虚拟环境: %ENV_NAME%
echo 日志文件: %LOG_FILE%
echo.
echo 使用方法:
echo   1. 激活环境: conda activate %ENV_NAME%
echo   2. 启动 GUI: python pipeline_tool.py
echo   3. 命令行模式: python mosaic.py configs/combined.yml
echo.
echo 或直接运行 run_gui.bat 启动图形界面
echo.

echo 请按任意键退出...
pause >nul

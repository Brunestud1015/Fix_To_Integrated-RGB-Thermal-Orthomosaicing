@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================================
echo   Integrated RGB-Thermal Orthomosaicing 部署脚本
echo ============================================================
echo.

set PROJECT_DIR=%~dp0
set ENV_NAME=integrated_rgb_thermal_ortho
set TARGET_DIR=E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2

echo [步骤 1/5] 检查系统环境...
echo.

where conda >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 Conda，请先安装 Anaconda 或 Miniconda
    echo 下载地址: https://docs.conda.io/en/latest/miniconda.html
    pause
    exit /b 1
)
echo [OK] Conda 已安装

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未找到 Git，将无法自动克隆项目
    echo 请手动下载项目或安装 Git: https://git-scm.com/download/win
) else (
    echo [OK] Git 已安装
)

echo.
echo [步骤 2/5] 检查 NVIDIA GPU 和 CUDA...
echo.

where nvidia-smi >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] 未检测到 NVIDIA GPU 或驱动未安装
    echo 项目将使用 CPU 模式运行，速度会较慢
) else (
    echo [OK] 检测到 NVIDIA GPU:
    nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader
)

echo.
echo [步骤 3/5] 检查项目目录...
echo.

if not exist "%TARGET_DIR%" (
    echo 目标目录不存在: %TARGET_DIR%
    echo.
    set /p CLONE_CHOICE=是否要克隆项目到该目录? (Y/N): 
    if /i "!CLONE_CHOICE!"=="Y" (
        echo 正在创建目录...
        mkdir "%TARGET_DIR%" 2>nul
        echo 正在克隆项目...
        git clone https://github.com/rudrakshkapil/Integrated-RGB-Thermal-Orthomosaicing.git "%TARGET_DIR%"
        if !errorlevel! neq 0 (
            echo [错误] 克隆失败，请检查网络连接或手动下载项目
            pause
            exit /b 1
        )
        echo [OK] 项目克隆成功
    ) else (
        echo 请手动将项目文件复制到: %TARGET_DIR%
        echo 然后重新运行此脚本
        pause
        exit /b 1
    )
) else (
    echo [OK] 目标目录已存在: %TARGET_DIR%
)

echo.
echo [步骤 4/5] 创建 Conda 虚拟环境...
echo.

conda env list | findstr /C:"%ENV_NAME%" >nul
if %errorlevel% equ 0 (
    echo 环境已存在: %ENV_NAME%
    set /p RECREATE=是否要重新创建环境? (Y/N): 
    if /i "!RECREATE!"=="Y" (
        echo 正在删除旧环境...
        conda env remove -n %ENV_NAME% -y
        echo 正在创建新环境...
        conda env create -f "%TARGET_DIR%\environment_optimized.yml"
    )
) else (
    echo 正在创建环境: %ENV_NAME%
    if exist "%TARGET_DIR%\environment_optimized.yml" (
        conda env create -f "%TARGET_DIR%\environment_optimized.yml"
    ) else (
        echo [错误] 未找到 environment_optimized.yml
        echo 请确保该文件存在于: %TARGET_DIR%
        pause
        exit /b 1
    )
)

if %errorlevel% neq 0 (
    echo [错误] 环境创建失败
    pause
    exit /b 1
)

echo [OK] 环境创建成功

echo.
echo [步骤 5/5] 验证安装...
echo.

call conda activate %ENV_NAME%

echo 检查 Python 版本...
python --version

echo.
echo 检查 PyTorch CUDA 支持...
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyTorch 安装可能有问题
)

echo.
echo 检查 PyQt5...
python -c "from PyQt5.QtWidgets import QApplication; print('PyQt5 OK')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyQt5 安装可能有问题
)

echo.
echo 检查 GDAL...
python -c "from osgeo import gdal; print(f'GDAL version: {gdal.__version__}')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] GDAL 安装可能有问题
)

echo.
echo 检查其他核心依赖...
python -c "import cv2; print(f'OpenCV: {cv2.__version__}')" 2>nul
python -c "import rasterio; print(f'rasterio: {rasterio.__version__}')" 2>nul
python -c "import geopandas; print(f'geopandas: {geopandas.__version__}')" 2>nul

echo.
echo ============================================================
echo   部署完成!
echo ============================================================
echo.
echo 项目目录: %TARGET_DIR%
echo 虚拟环境: %ENV_NAME%
echo.
echo 使用方法:
echo   1. 激活环境: conda activate %ENV_NAME%
echo   2. 启动 GUI: python pipeline_tool.py
echo   3. 命令行模式: python mosaic.py configs/combined.yml
echo.
echo 或直接运行 run_gui.bat 启动图形界面
echo.

pause

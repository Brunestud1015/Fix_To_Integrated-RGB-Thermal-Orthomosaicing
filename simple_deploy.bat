@echo off
chcp 65001 >nul

echo ============================================================
echo   简化部署脚本
 echo ============================================================
echo 此脚本将在当前目录创建虚拟环境
echo 按任意键开始...
pause >nul
echo.

echo 步骤 1: 检查环境文件
echo ------------------------------------------------------------
if not exist "%~dp0environment_optimized.yml" (
    echo [错误] 未找到 environment_optimized.yml 文件
    echo 请确保文件存在于: %~dp0
    echo 按任意键退出...
    pause >nul
    exit /b 1
)
echo [OK] 找到 environment_optimized.yml
echo.

echo 步骤 2: 创建 Conda 虚拟环境
echo ------------------------------------------------------------
echo 正在创建环境...
echo 这可能需要 10-30 分钟，请耐心等待...
echo 按任意键开始创建环境...
pause >nul

echo 执行命令: conda env create -f "%~dp0environment_optimized.yml"
echo ------------------------------------------------------------
conda env create -f "%~dp0environment_optimized.yml"

if %errorlevel% neq 0 (
    echo [错误] 环境创建失败
    echo 请检查错误信息
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo ------------------------------------------------------------
echo [OK] 环境创建成功
echo 按任意键继续...
pause >nul
echo.

echo 步骤 3: 激活环境并验证
echo ------------------------------------------------------------
echo 正在激活环境...
call conda activate integrated_rgb_thermal_ortho

if %errorlevel% neq 0 (
    echo [错误] 无法激活环境
    echo 按任意键退出...
    pause >nul
    exit /b 1
)

echo [OK] 环境激活成功
echo 验证关键依赖...
echo ------------------------------------------------------------
echo 检查 Python 版本:
python --version
echo.
echo 检查 PyTorch:
python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA 可用:', torch.cuda.is_available())"
echo.
echo 检查 PyQt5:
python -c "try: from PyQt5.QtWidgets import QApplication; print('PyQt5: OK') except Exception as e: print('PyQt5 错误:', e)"
echo.
echo 检查 GDAL:
python -c "try: from osgeo import gdal; print('GDAL 版本:', gdal.__version__) except Exception as e: print('GDAL 错误:', e)"
echo ------------------------------------------------------------
echo 验证完成
echo.
echo ============================================================
echo   部署完成!
echo ============================================================
echo 虚拟环境: integrated_rgb_thermal_ortho
echo 项目目录: %~dp0
echo.
echo 启动方法:
echo 1. 激活环境: conda activate integrated_rgb_thermal_ortho
echo 2. 启动 GUI: python pipeline_tool.py
echo 3. 命令行模式: python mosaic.py configs/combined.yml
echo.
echo 按任意键退出...
pause >nul

@echo off
chcp 65001 >nul

echo 开始部署项目...
echo 按任意键继续...
pause

echo 1. 检查环境文件...
if not exist "%~dp0environment_optimized.yml" (
    echo 错误: 未找到 environment_optimized.yml 文件
    echo 请确保文件存在于当前目录
    pause
    exit /b 1
)
echo 找到 environment_optimized.yml

pause

echo 2. 创建虚拟环境...
echo 这可能需要较长时间，请耐心等待...
echo 执行命令: conda env create -f environment_optimized.yml
conda env create -f "%~dp0environment_optimized.yml"

if %errorlevel% neq 0 (
    echo 错误: 环境创建失败
    echo 请检查错误信息
    pause
    exit /b 1
)
echo 环境创建成功

pause

echo 3. 激活环境...
call conda activate integrated_rgb_thermal_ortho

if %errorlevel% neq 0 (
    echo 错误: 无法激活环境
    pause
    exit /b 1
)
echo 环境激活成功

pause

echo 4. 验证安装...
echo 检查 Python 版本:
python --version
echo 检查 PyTorch:
python -c "import torch; print('PyTorch:', torch.__version__); print('CUDA 可用:', torch.cuda.is_available())"
echo 检查 PyQt5:
python -c "try: from PyQt5.QtWidgets import QApplication; print('PyQt5: OK') except: print('PyQt5: 错误')"
echo 检查 GDAL:
python -c "try: from osgeo import gdal; print('GDAL 版本:', gdal.__version__) except: print('GDAL: 错误')"

echo 部署完成!
echo 虚拟环境: integrated_rgb_thermal_ortho
echo 项目目录: %~dp0
echo 启动方法:
echo 1. 激活环境: conda activate integrated_rgb_thermal_ortho
echo 2. 启动 GUI: python pipeline_tool.py
echo 3. 命令行模式: python mosaic.py configs/combined.yml

pause

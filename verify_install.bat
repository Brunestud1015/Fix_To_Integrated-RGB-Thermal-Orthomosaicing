@echo off
chcp 65001 >nul
setlocal

set ENV_NAME=integrated_rgb_thermal_ortho

echo ============================================================
echo   环境验证脚本
echo ============================================================
echo.

call conda activate %ENV_NAME%
if %errorlevel% neq 0 (
    echo [错误] 无法激活环境: %ENV_NAME%
    pause
    exit /b 1
)

echo [1] Python 版本
echo ------------------------------------------------------------
python --version
echo.

echo [2] PyTorch 和 CUDA 状态
echo ------------------------------------------------------------
python -c "import torch; print(f'PyTorch 版本: {torch.__version__}'); print(f'CUDA 可用: {torch.cuda.is_available()}'); print(f'CUDA 版本: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}'); print(f'GPU 数量: {torch.cuda.device_count()}'); [print(f'GPU {i}: {torch.cuda.get_device_name(i)}') for i in range(torch.cuda.device_count())]" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyTorch 检查失败
)
echo.

echo [3] PyQt5 状态
echo ------------------------------------------------------------
python -c "from PyQt5.QtWidgets import QApplication; from PyQt5.QtCore import QT_VERSION_STR; print(f'Qt 版本: {QT_VERSION_STR}'); print('PyQt5: OK')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] PyQt5 检查失败
)
echo.

echo [4] GDAL 状态
echo ------------------------------------------------------------
python -c "from osgeo import gdal, ogr, osr; print(f'GDAL 版本: {gdal.__version__}'); print('OGR: OK'); print('OSR: OK')" 2>nul
if %errorlevel% neq 0 (
    echo [警告] GDAL 检查失败
)
echo.

echo [5] 地理空间库状态
echo ------------------------------------------------------------
python -c "import rasterio; print(f'rasterio: {rasterio.__version__}')" 2>nul
python -c "import geopandas; print(f'geopandas: {geopandas.__version__}')" 2>nul
python -c "import fiona; print(f'fiona: {fiona.__version__}')" 2>nul
python -c "import shapely; print(f'shapely: {shapely.__version__}')" 2>nul
echo.

echo [6] 图像处理库状态
echo ------------------------------------------------------------
python -c "import cv2; print(f'OpenCV: {cv2.__version__}')" 2>nul
python -c "import skimage; print(f'scikit-image: {skimage.__version__}')" 2>nul
python -c "import PIL; print(f'Pillow: {PIL.__version__}')" 2>nul
echo.

echo [7] 科学计算库状态
echo ------------------------------------------------------------
python -c "import numpy; print(f'numpy: {numpy.__version__}')" 2>nul
python -c "import scipy; print(f'scipy: {scipy.__version__}')" 2>nul
python -c "import pandas; print(f'pandas: {pandas.__version__}')" 2>nul
echo.

echo [8] 深度学习库状态
echo ------------------------------------------------------------
python -c "import pytorch_lightning; print(f'pytorch-lightning: {pytorch_lightning.__version__}')" 2>nul
python -c "import torchmetrics; print(f'torchmetrics: {torchmetrics.__version__}')" 2>nul
python -c "import deepforest; print('deepforest: OK')" 2>nul
echo.

echo [9] 项目核心模块测试
echo ------------------------------------------------------------
cd /d "%~dp0"
python -c "import mosaic; print('mosaic.py: OK')" 2>nul
python -c "import transform_NGF; print('transform_NGF.py: OK')" 2>nul
python -c "from GUI_generated import Ui_MainWindow; print('GUI_generated.py: OK')" 2>nul
echo.

echo ============================================================
echo   验证完成
echo ============================================================
echo.
echo 如果所有检查都显示 OK，说明环境配置正确。
echo 如果有警告或错误，请检查对应的依赖安装。
echo.

pause

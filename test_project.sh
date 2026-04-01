#!/bin/bash

# 项目测试脚本

echo "测试项目功能..."

# 1. 激活环境
conda activate integrated_rgb_thermal_ortho

# 2. 测试Python环境
python --version

# 3. 测试核心依赖
python -c "import torch; print('PyTorch version:', torch.__version__)"
python -c "import cv2; print('OpenCV version:', cv2.__version__)"
python -c "import numpy; print('NumPy version:', numpy.__version__)"
python -c "import matplotlib; print('Matplotlib version:', matplotlib.__version__)"
python -c "import geopandas; print('GeoPandas version:', geopandas.__version__)"
python -c "import rasterio; print('Rasterio version:', rasterio.__version__)"

# 4. 测试项目模块
python -c "import pipeline_tool; print('Pipeline tool imported successfully')"

# 5. 测试GPU加速
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
if python -c "import torch; exit(0 if torch.cuda.is_available() else 1)"; then
    echo "GPU加速已启用"
else
    echo "警告: GPU加速不可用，将使用CPU模式"
fi

# 6. 测试配置文件读取
python -c "import yaml; with open('configs/default.yml', 'r') as f: config = yaml.safe_load(f); print('配置文件读取成功')"

# 7. 测试DJI Thermal SDK
if [ -d "DJI_Thermal_SDK" ]; then
    echo "DJI Thermal SDK 目录存在"
else
    echo "警告: DJI Thermal SDK 目录不存在"
fi

# 8. 测试OpenDroneMap
if [ -d "ODM" ]; then
    echo "OpenDroneMap 目录存在"
else
    echo "警告: OpenDroneMap 目录不存在"
fi

echo "项目测试完成！"

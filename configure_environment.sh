#!/bin/bash

# 环境配置脚本

echo "配置项目运行环境..."

# 1. 激活环境
conda activate integrated_rgb_thermal_ortho

# 2. 检查GPU是否可用
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"
python -c "import torch; print('CUDA device count:', torch.cuda.device_count())"
python -c "import torch; print('CUDA device name:', torch.cuda.get_device_name(0))"

# 3. 配置ODM路径
export ODM_PATH="$(pwd)/ODM"
echo "ODM_PATH=$ODM_PATH" >> ~/.bashrc

# 4. 检查配置文件
if [ -f "configs/default.yml" ]; then
    echo "默认配置文件存在: configs/default.yml"
else
    echo "警告: 默认配置文件不存在"
fi

# 5. 检查DJI Thermal SDK
if [ -d "DJI_Thermal_SDK" ]; then
    echo "DJI Thermal SDK 存在"
else
    echo "警告: DJI Thermal SDK 不存在"
fi

# 6. 检查OpenDroneMap
if [ -d "ODM" ]; then
    echo "OpenDroneMap 存在"
else
    echo "警告: OpenDroneMap 不存在"
fi

# 7. 测试Python依赖
python -c "import numpy, matplotlib, cv2, torch, geopandas, rasterio"
if [ $? -eq 0 ]; then
    echo "Python依赖检查通过"
else
    echo "Python依赖检查失败"
fi

echo "环境配置完成！"

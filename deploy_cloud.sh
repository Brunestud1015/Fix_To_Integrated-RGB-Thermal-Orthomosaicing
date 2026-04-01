#!/bin/bash

# 部署脚本 - 云端服务器部署项目

echo "开始部署项目到云端服务器..."

# 1. 更新系统
apt-get update && apt-get upgrade -y

# 2. 安装必要的基础软件
apt-get install -y \
    build-essential \
    git \
    wget \
    curl \
    unzip \
    htop \
    tmux

# 3. 安装Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2023.03-Linux-x86_64.sh
bash Anaconda3-2023.03-Linux-x86_64.sh -b -p /opt/anaconda3
echo 'export PATH="/opt/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 4. 安装CUDA驱动（如果需要）
# 注意：对于g5实例，CUDA驱动已经预装

# 5. 克隆项目代码
git clone https://github.com/rudrakshkapil/Integrated-RGB-Thermal-Orthomosaicing.git IntegratedOrtho
cd IntegratedOrtho

# 6. 创建并激活环境
conda env create -f environment.yml
conda activate integrated_rgb_thermal_ortho

# 7. 下载ODMVirtual环境（如果需要）
# wget -O ODM/venv.zip https://drive.google.com/drive/folders/1s9TMOsA4KC155mleJuzGay14aj-xPTyD?usp=sharing
# unzip ODM/venv.zip -d ODM/

# 8. 测试GPU是否可用
python -c "import torch; print('CUDA available:', torch.cuda.is_available())"

# 9. 下载示例数据集（可选）
# wget -O dataset.zip https://doi.org/10.5281/zenodo.7662405
# unzip dataset.zip

echo "部署完成！"
echo "使用以下命令启动应用："
echo "conda activate integrated_rgb_thermal_ortho && python ./pipeline_tool.py"

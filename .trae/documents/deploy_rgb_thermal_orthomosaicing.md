# Integrated RGB-Thermal Orthomosaicing 项目部署计划

## 概述

本文档描述了在本地 Windows 电脑上部署 **Integrated RGB-Thermal Orthomosaicing** 项目的完整步骤。项目是一个森林热成像无人机图像正射镶嵌工具，使用 Python + PyTorch (CUDA) + PyQt5 构建。

---

## 当前状态分析

### 项目技术栈
| 组件 | 技术 | 说明 |
|------|------|------|
| 编程语言 | Python 3.8/3.12 | 原版用 3.8，修复版用 3.12 |
| 深度学习 | PyTorch + CUDA | 需要 NVIDIA GPU |
| GUI 框架 | PyQt5 | 图形用户界面 |
| 地理空间 | GDAL, rasterio, geopandas | 正射影像处理 |
| 图像处理 | OpenCV, scikit-image | 图像配准和预处理 |
| 外部工具 | DJI Thermal SDK, OpenDroneMap | 已包含在项目中 |

### 环境配置文件对比

项目提供两个环境配置文件：

| 文件 | Python 版本 | PyTorch 版本 | 状态 |
|------|-------------|--------------|------|
| `environment.yml` | 3.8 | 1.13.1 (CUDA 11.6) | 原版，版本过于具体 |
| `integrated_rgb_thermal_ortho_env.yml` | 3.12 | 2.4.1 (通过 pip) | 修复版，版本较新 |

### 已识别的问题
1. 原版 `environment.yml` 版本过于具体，可能导致依赖冲突
2. 需要检查系统 CUDA 版本兼容性
3. ODM 虚拟环境已预装，但路径可能需要调整

---

## 部署方案

### 目标环境
- **目标路径**: `E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2`
- **操作系统**: Windows 10/11
- **GPU**: NVIDIA GPU (CUDA 支持)
- **Python 环境**: Conda (Anaconda 或 Miniconda)

### 部署步骤概览

```
┌─────────────────────────────────────────────────────────────────┐
│  阶段 1: 环境准备                                                │
│  - 检查 CUDA 版本                                               │
│  - 安装/确认 Conda 环境                                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  阶段 2: 项目克隆                                                │
│  - 从 GitHub 克隆项目到指定目录                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  阶段 3: 虚拟环境配置                                            │
│  - 创建优化的 environment.yml                                   │
│  - 创建 Conda 虚拟环境                                          │
│  - 安装核心依赖                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  阶段 4: 项目配置                                                │
│  - 配置 ODM 路径                                                │
│  - 配置 DJI Thermal SDK                                         │
│  - 验证配置文件                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  阶段 5: 验证测试                                                │
│  - 测试 GUI 启动                                                │
│  - 测试命令行模式                                               │
│  - 验证核心功能                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 详细实施步骤

### 阶段 1: 环境准备

#### 1.1 检查 CUDA 版本
```powershell
# 在 PowerShell 或 CMD 中运行
nvidia-smi
```
- 确认显示的 CUDA Version >= 11.6
- 如果未安装或版本过低，需要安装/更新 NVIDIA 驱动

#### 1.2 确认 Conda 安装
```powershell
conda --version
```
- 如果未安装，下载安装 [Miniconda](https://docs.conda.io/en/latest/miniconda.html) 或 [Anaconda](https://www.anaconda.com/download)

---

### 阶段 2: 项目克隆

#### 2.1 创建目标目录并克隆项目
```powershell
# 创建目标目录
mkdir E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2

# 克隆项目
cd E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
git clone https://github.com/rudrakshkapil/Integrated-RGB-Thermal-Orthomosaicing.git .
```

**注意**: 如果 GitHub 克隆速度慢，可以考虑：
- 使用镜像站点
- 下载 ZIP 压缩包后解压

---

### 阶段 3: 虚拟环境配置

#### 3.1 创建优化的环境配置文件

基于项目需求，创建一个新的 `environment_optimized.yml` 文件，解决版本冲突问题：

**核心依赖版本策略**:
- **PyTorch**: 使用 pip 安装最新稳定版，自动匹配 CUDA
- **GDAL/geopandas/rasterio**: 使用 conda-forge 渠道，版本兼容
- **PyQt5**: pip 安装最新兼容版
- **其他依赖**: 放宽版本限制，使用兼容范围

#### 3.2 创建 Conda 环境
```powershell
cd E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2

# 使用优化配置创建环境
conda env create -f environment_optimized.yml

# 激活环境
conda activate integrated_rgb_thermal_ortho
```

#### 3.3 验证核心包安装
```powershell
# 验证 Python 版本
python --version

# 验证 PyTorch CUDA 支持
python -c "import torch; print(f'PyTorch: {torch.__version__}'); print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda if torch.cuda.is_available() else \"N/A\"}')"

# 验证 PyQt5
python -c "from PyQt5.QtWidgets import QApplication; print('PyQt5 OK')"

# 验证 GDAL
python -c "from osgeo import gdal; print(f'GDAL version: {gdal.__version__}')"
```

---

### 阶段 4: 项目配置

#### 4.1 配置 ODM 路径

项目已包含 ODM 文件夹和预装的 venv，需要确认路径配置：

1. 检查 `ODM/venv` 目录是否存在
2. 如果不存在，需要从 [Google Drive](https://drive.google.com/drive/folders/1s9TMOsA4KC155mleJuzGay14aj-xPTyD) 下载

#### 4.2 配置 DJI Thermal SDK

DJI Thermal SDK 已包含在 `DJI_Thermal_SDK` 目录中，无需额外配置。

#### 4.3 配置文件检查

确认 `configs/` 目录下的配置文件：
- `default.yml` - 默认配置
- `combined.yml` - 当前配置（运行时生成）
- `rgb_only.yml` - 仅 RGB 模式
- `thermal_only.yml` - 仅热成像模式

---

### 阶段 5: 验证测试

#### 5.1 测试 GUI 启动
```powershell
conda activate integrated_rgb_thermal_ortho
cd E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
python pipeline_tool.py
```

#### 5.2 测试命令行模式
```powershell
conda activate integrated_rgb_thermal_ortho
cd E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
python mosaic.py --help
```

#### 5.3 下载测试数据（可选）
从 Zenodo 下载示例数据集: https://doi.org/10.5281/zenodo.7662405

---

## 需要创建的文件

### 1. `environment_optimized.yml` - 优化的环境配置文件

将创建一个新的环境配置文件，解决以下问题：
- 放宽非核心依赖的版本限制
- 使用 conda-forge 作为主要渠道
- PyTorch 通过 pip 安装以获得最佳 CUDA 兼容性
- 确保所有依赖兼容

### 2. `deploy.bat` - 一键部署脚本

创建 Windows 批处理脚本，自动化部署流程：
- 检查环境依赖
- 创建 Conda 环境
- 验证安装

### 3. `run_gui.bat` - GUI 启动脚本

简化 GUI 启动流程。

---

## 假设与决策

### 假设
1. 用户已安装 NVIDIA 显卡驱动
2. 用户已安装 Conda (Anaconda 或 Miniconda)
3. 系统有足够的磁盘空间（建议 > 20GB）
4. 网络可以访问 GitHub 和 PyPI

### 决策
1. **Python 版本**: 选择 Python 3.10 作为平衡点
   - 原版 3.8 较旧，部分新包不支持
   - 修复版 3.12 可能存在兼容性问题
   - 3.10 是稳定且广泛支持的选择

2. **PyTorch 安装方式**: 使用 pip 安装
   - conda 渠道的 PyTorch 版本可能滞后
   - pip 可以获取最新稳定版和最佳 CUDA 匹配

3. **依赖版本策略**: 核心依赖固定版本，其他依赖放宽
   - 避免版本冲突
   - 保持功能稳定性

---

## 验证步骤

### 成功标准
1. Conda 环境创建成功，无错误
2. PyTorch 能够识别 GPU
3. GUI 能够正常启动并显示界面
4. 命令行模式能够解析配置文件

### 验证命令清单
```powershell
# 1. 环境检查
conda activate integrated_rgb_thermal_ortho
python --version  # 应显示 Python 3.10.x

# 2. PyTorch CUDA 检查
python -c "import torch; assert torch.cuda.is_available(), 'CUDA not available'"

# 3. GUI 启动测试
python pipeline_tool.py  # 应显示 GUI 窗口

# 4. 命令行测试
python mosaic.py configs/default.yml --help
```

---

## 故障排除

### 常见问题

| 问题 | 可能原因 | 解决方案 |
|------|----------|----------|
| CUDA not available | 驱动版本过低 | 更新 NVIDIA 驱动 |
| GDAL 导入失败 | conda-forge 渠道问题 | 重新安装 gdal |
| PyQt5 无法启动 | 缺少系统依赖 | 安装 Visual C++ Redistributable |
| ODM 运行失败 | venv 路径问题 | 检查 ODM/venv 目录 |

---

## 文件清单

部署完成后，项目目录应包含以下关键文件：

```
E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2\
├── pipeline_tool.py          # GUI 主程序
├── mosaic.py                 # 命令行入口
├── transform_NGF.py          # 图像配准算法
├── environment_optimized.yml # 优化的环境配置 (新建)
├── deploy.bat                # 部署脚本 (新建)
├── run_gui.bat               # GUI 启动脚本 (新建)
├── configs/
│   ├── default.yml
│   ├── combined.yml
│   ├── rgb_only.yml
│   └── thermal_only.yml
├── DJI_Thermal_SDK/          # DJI 热成像 SDK
├── ODM/                      # OpenDroneMap
│   └── venv/                 # ODM 虚拟环境
└── df_repo/                  # DeepForest
```

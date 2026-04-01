# Integrated RGB-Thermal Orthomosaicing 部署指南

## 快速开始

### 前置条件

1. **操作系统**: Windows 10/11 (64位)
2. **NVIDIA GPU**: 建议使用支持 CUDA 的显卡
3. **磁盘空间**: 至少 20GB 可用空间
4. **Conda**: 已安装 Anaconda 或 Miniconda

### 一键部署

1. 将项目文件复制到目标目录:
   ```
   E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
   ```

2. 双击运行 `deploy.bat`

3. 等待环境创建完成

4. 运行 `verify_install.bat` 验证安装

5. 运行 `run_gui.bat` 启动图形界面

---

## 手动部署步骤

### 步骤 1: 检查环境

```powershell
# 检查 Conda
conda --version

# 检查 GPU
nvidia-smi
```

### 步骤 2: 克隆项目

```powershell
mkdir E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
cd E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2
git clone https://github.com/rudrakshkapil/Integrated-RGB-Thermal-Orthomosaicing.git .
```

### 步骤 3: 创建虚拟环境

```powershell
conda env create -f environment_optimized.yml
conda activate integrated_rgb_thermal_ortho
```

### 步骤 4: 验证安装

```powershell
python --version
python -c "import torch; print(torch.cuda.is_available())"
python -c "from PyQt5.QtWidgets import QApplication; print('OK')"
python -c "from osgeo import gdal; print(gdal.__version__)"
```

### 步骤 5: 启动程序

```powershell
# GUI 模式
python pipeline_tool.py

# 命令行模式
python mosaic.py configs/combined.yml
```

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `environment_optimized.yml` | 优化的 Conda 环境配置 |
| `deploy.bat` | 一键部署脚本 |
| `run_gui.bat` | GUI 启动脚本 |
| `verify_install.bat` | 安装验证脚本 |

---

## 常见问题

### Q: CUDA not available

**原因**: NVIDIA 驱动版本过低或未安装

**解决方案**:
1. 更新 NVIDIA 驱动: https://www.nvidia.com/Download/index.aspx
2. 确保驱动版本支持 CUDA 11.x 或更高

### Q: GDAL 导入失败

**原因**: conda-forge 渠道问题

**解决方案**:
```powershell
conda install -c conda-forge gdal
```

### Q: PyQt5 无法启动

**原因**: 缺少系统依赖

**解决方案**:
安装 Visual C++ Redistributable:
https://aka.ms/vs/17/release/vc_redist.x64.exe

### Q: 环境创建失败

**原因**: 网络问题或版本冲突

**解决方案**:
1. 使用国内镜像:
   ```powershell
   conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
   conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
   conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
   ```
2. 或尝试使用 pip 逐个安装依赖

### Q: ODM 运行失败

**原因**: ODM 虚拟环境未正确配置

**解决方案**:
1. 检查 `ODM/venv` 目录是否存在
2. 如不存在，从 Google Drive 下载:
   https://drive.google.com/drive/folders/1s9TMOsA4KC155mleJuzGay14aj-xPTyD

---

## 使用示例

### 1. GUI 模式

1. 运行 `run_gui.bat`
2. 在左侧面板指定数据目录名称 (如 `2022_08_30`)
3. 根据需要调整设置
4. 点击 `Save Settings` 保存配置
5. 点击 `Start Processing` 开始处理

### 2. 命令行模式

```powershell
conda activate integrated_rgb_thermal_ortho
python mosaic.py configs/combined.yml
```

### 3. 处理模式

| 模式 | 配置文件 | 说明 |
|------|----------|------|
| 组合模式 | `configs/combined.yml` | RGB + 热成像联合处理 |
| 仅 RGB | `configs/rgb_only.yml` | 仅 RGB 正射镶嵌 |
| 仅热成像 | `configs/thermal_only.yml` | 仅热成像正射镶嵌 |

---

## 测试数据

可从 Zenodo 下载示例数据集:
https://doi.org/10.5281/zenodo.7662405

下载后解压到项目根目录，目录结构应为:
```
E:\Fix_To_Integrated-RGB-Thermal-Orthomosaicing2\
├── 2022_08_30\
│   └── mapping_data\
│       ├── RGB\
│       └── Thermal\
└── ...
```

---

## 技术支持

如遇问题，可参考:
- 项目文档: https://integrated-rgb-thermal-orthomosaicing.readthedocs.io/
- 原始论文: https://www.mdpi.com/2072-4292/15/10/2653
- 联系作者: rkapil@ualberta.ca

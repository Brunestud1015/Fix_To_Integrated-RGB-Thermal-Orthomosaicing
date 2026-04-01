# 部署执行指南

## 快速开始

### 步骤 1: 检查系统环境

双击运行 `check_system.bat`，检查您的系统是否满足部署要求。

**必需组件**：
- ✅ Conda (Anaconda 或 Miniconda)
- ✅ Python 3.x

**可选组件**：
- NVIDIA GPU 和 CUDA 驱动（用于GPU加速）
- Git（用于克隆项目）

### 步骤 2: 执行部署

双击运行 `deploy.bat`，脚本会自动：
1. 检查系统环境
2. 检查 GPU 和 CUDA
3. 检查项目文件
4. 创建 Conda 虚拟环境
5. 验证安装

**重要提示**：
- 部署过程可能需要 **10-30 分钟**，取决于网络速度
- 所有输出都会记录到 `deploy_log.txt` 文件中
- 如果窗口没有显示，请检查任务栏或查看日志文件

### 步骤 3: 验证安装

双击运行 `verify_install.bat`，检查所有依赖是否正确安装。

### 步骤 4: 启动应用

双击运行 `run_gui.bat` 启动图形界面。

## 常见问题

### Q: 双击 deploy.bat 后窗口闪退或无反应

**可能原因**：
1. Conda 未正确安装或未添加到系统 PATH
2. 脚本路径包含中文字符或特殊字符
3. 权限不足

**解决方案**：
1. 打开 "Anaconda Prompt" 或 "命令提示符"
2. 导航到项目目录：
   ```cmd
   cd /d "项目路径"
   ```
3. 手动运行脚本：
   ```cmd
   deploy.bat
   ```

### Q: 如何查看部署进度？

**方法 1**: 查看 `deploy_log.txt` 文件
- 该文件位于项目根目录
- 实时记录所有部署输出

**方法 2**: 在命令行中运行
1. 打开命令提示符（cmd）
2. 运行 `deploy.bat`
3. 可以看到实时输出

### Q: 环境创建失败怎么办？

**常见错误**：

1. **网络超时**
   - 使用国内镜像源
   - 或使用 VPN

2. **版本冲突**
   - 删除旧环境：
     ```cmd
     conda env remove -n integrated_rgb_thermal_ortho
     ```
   - 重新运行 `deploy.bat`

3. **磁盘空间不足**
   - 清理磁盘空间
   - 至少需要 20GB

### Q: 如何手动创建环境？

如果自动部署失败，可以手动创建环境：

```cmd
# 1. 创建环境
conda env create -f environment_optimized.yml

# 2. 激活环境
conda activate integrated_rgb_thermal_ortho

# 3. 验证安装
python -c "import torch; print(torch.cuda.is_available())"
python -c "from PyQt5.QtWidgets import QApplication; print('OK')"
python -c "from osgeo import gdal; print(gdal.__version__)"
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `check_system.bat` | 系统环境诊断工具 |
| `deploy.bat` | 一键部署脚本 |
| `verify_install.bat` | 安装验证脚本 |
| `run_gui.bat` | GUI 启动脚本 |
| `environment_optimized.yml` | Conda 环境配置文件 |
| `deploy_log.txt` | 部署日志文件（部署时自动生成） |

## 部署成功标志

如果看到以下输出，说明部署成功：

```
============================================================
  部署完成!
============================================================

项目目录: [您的项目路径]
虚拟环境: integrated_rgb_thermal_ortho
日志文件: [项目路径]\deploy_log.txt

使用方法:
  1. 激活环境: conda activate integrated_rgb_thermal_ortho
  2. 启动 GUI: python pipeline_tool.py
  3. 命令行模式: python mosaic.py configs/combined.yml
```

## 技术支持

如果遇到问题，请提供以下信息：
1. `check_system.bat` 的输出截图
2. `deploy_log.txt` 文件内容
3. 错误信息截图

#!/bin/bash

# 远程访问设置脚本

echo "设置远程访问方式..."

# 1. 安装VNC服务器
apt-get install -y tightvncserver xfce4 xfce4-goodies

# 2. 初始化VNC密码
mkdir -p ~/.vnc
echo "设置VNC密码（输入两次）"
tightvncpasswd

# 3. 创建VNC配置文件
cat > ~/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startxfce4 &
EOF

chmod +x ~/.vnc/xstartup

# 4. 启动VNC服务器
vncserver :1 -geometry 1920x1080 -depth 24

# 5. 配置防火墙（如果需要）
ufw allow 5901/tcp

# 6. 显示访问信息
echo "远程访问设置完成！"
echo "使用VNC客户端连接到：<EC2实例IP>:5901"
echo "或者使用SSH隧道连接：ssh -L 5901:localhost:5901 <用户名>@<EC2实例IP>"
echo "然后在本地VNC客户端连接到 localhost:5901"

# 7. 提供启动和停止VNC服务器的命令
echo "\nVNC服务器管理命令："
echo "启动: vncserver :1 -geometry 1920x1080 -depth 24"
echo "停止: vncserver -kill :1"
echo "查看状态: vncserver -list"

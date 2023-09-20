#!/bin/bash

# 桥接接口名称的基础名称
# base_interface_name="veth"

# 获取物理网卡名称
# physical_interface=$(ip -o link show | awk -F': ' '!/lo/ && !/veth/ && !/\<(br|docker|virbr)\d+\>/ {print $2; exit}')


# 创建虚拟网卡并连接到桥接接口
for i in {1..150}; do
    # 构建虚拟网卡名称
    interface_name="veth${i}"

    # 清理旧的虚拟网卡
    if ip link show "${interface_name}" >/dev/null 2>&1; then
        ip link delete "${interface_name}"
    fi
    
    #if ip link show "${interface_name}p" >/dev/null 2>&1; then
        #ip link delete "${interface_name}p"
    #fi

    # 创建虚拟网卡
    ip link add name "${interface_name}" type dummy

    # 启动虚拟网卡
    ip link set dev "${interface_name}" up

    # 分配静态IP地址
    ip addr add 192.168.2.$((100 + i))/24 dev "${interface_name}"
done

#!/usr/bin/env fish

set config ./*.ovpn

function getPorts
    ps aux | grep 'openvpn --config' | awk '{print $2}'
end

function startVPN
    if [ (checkStart) -eq 0 ]
        echo openvpn 启动中...
        sudo openvpn --config $config &>/dev/null &
        if [ (checkStart) -eq 0 ]
            echo openvpn 启动失败
        else
            echo openvpn 启动成功
        end
    else
        echo openvpn 已启动
    end
end

function stopVPN
    set ports (getPorts)
    for port in $ports
        sudo kill -9 $port &>/dev/null
    end
    echo openvpn 关闭成功
end

function checkStart
    set ports (getPorts)
    if [ (count $ports) -gt 1 ]
        echo 1
    else
        echo 0
    end
end

if [ $argv[1] = status ]
    ps aux | grep 'openvpn --config'
    exit
end
sudo -v
switch $argv[1]
    case start
        startVPN
    case stop
        stopVPN
    case restart
        stopVPN
        startVPN
    case '*'
        echo '无效的参数(start or stop or status)'
end

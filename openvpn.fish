#!/usr/bin/env fish

set config ./*.ovpn

function getPorts
    ps aux | grep 'openvpn --config' | awk '{print $2}'
end

function startVPN
    if [ (checkStart) -eq 0 ]
        checkConfig
        echo openvpn 启动中...
        sudo openvpn --config $config &>/dev/null &
        sleep 1
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

function checkConfig
    if [ (count $config) -eq 0 ]
        echo 请检查当前路径下 .ovpn 文件是否存在
        exit
    end
    if [ (count $config) -gt 1 ]
        echo -e 请选择要使用的 .ovpn 文件
        set key 1
        for conf in $config
            echo -e $key: $conf
            set key (expr $key + 1)
        end
        while read num
            switch $num
                case -le (count $config) and -ge 1
                    set config $config[$num]
                    break
                case '*'
                    echo 请重新选择要使用的 .ovpn 文件
            end
        end
    end
end

if [ (count $argv) -ne 1 ]
    echo '无效的参数(start or stop or status)'
    exit
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

#!/bin/bash

python3 - "$@" <<EOF
#!/usr/bin/env python3

import socket
import sys
import time

def tcping(host, port, bytes_to_send=56):
    while True:
        try:
            start_time = time.time()
            # 创建一个TCP套接字
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            # 设置连接超时时间为2秒（与Linux ping默认值一致）
            sock.settimeout(2)
            # 尝试连接到主机和端口
            sock.connect((host, port))
            end_time = time.time()
            elapsed_time = (end_time - start_time) * 1000  # 毫秒

            # 发送指定字节数的0x00填充数据
            data_to_send = b"\x00" * bytes_to_send
            bytes_sent = sock.send(data_to_send)
            
            print(f"{bytes_sent} bytes sent, connected to {host}:{port} in {elapsed_time:.2f} ms")
        except Exception as e:
            print(f"Failed to connect to {host}:{port} ({str(e)})")
        finally:
            sock.close()
        
        # 计算实际延迟并休眠，以确保总延迟与Linux ping一样
        elapsed_time_ms = (time.time() - start_time) * 1000
        if elapsed_time_ms < 1000:
            time.sleep((1000 - elapsed_time_ms) / 1000)

if __name__ == "__main__":
    if len(sys.argv) < 3 or len(sys.argv) > 5:
        print("Usage: python tcping.py <host> <port> [-s bytes_to_send]")
        sys.exit(1)

    host = sys.argv[1]
    port = int(sys.argv[2])
    
    bytes_to_send = 56  # 默认字节数与Linux ping命令一致
    
    if "-s" in sys.argv:
        try:
            index = sys.argv.index("-s")
            bytes_to_send = int(sys.argv[index + 1])
        except (ValueError, IndexError):
            pass

    tcping(host, port, bytes_to_send)
EOF

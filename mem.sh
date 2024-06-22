# 分别提取每个字段
MemTotal=$(awk '/MemTotal:/ {print $2}' /proc/meminfo)
MemFree=$(awk '/MemFree:/ {print $2}' /proc/meminfo)
Buffers=$(awk '/Buffers:/ {print $2}' /proc/meminfo)
Cached=$(awk '/^Cached:/ {print $2}' /proc/meminfo)
SReclaimable=$(awk '/SReclaimable:/ {print $2}' /proc/meminfo)
SwapTotal=$(awk '/SwapTotal:/ {print $2}' /proc/meminfo)
SwapFree=$(awk '/SwapFree:/ {print $2}' /proc/meminfo)

# 计算已使用的交换空间
SwapUsed=$((SwapTotal - SwapFree))

# 打印获取的内存信息
echo "MemTotal: $MemTotal kB"  # 总物理内存
echo "MemFree: $MemFree kB"    # 空闲物理内存
echo "Buffers: $Buffers kB"    # 用于文件系统元数据的缓存
echo "Cached: $Cached kB"      # 用于文件数据的缓存
echo "SReclaimable: $SReclaimable kB"  # 可回收的 Slab 内存
echo "SwapTotal: $SwapTotal kB"  # 总交换空间
echo "SwapFree: $SwapFree kB"    # 空闲交换空间
echo "SwapUsed: $SwapUsed kB"    # 已使用的交换空间

# 获取所有进程的RSS总和
TotalRSS=$(ps -eo rss | awk '{sum+=$1} END {print sum}')

# 打印所有进程的RSS总和
echo "Total RSS (all processes): $TotalRSS kB"  # 所有进程的RSS总和

# 计算已使用的内存
Used=$((MemTotal - MemFree + SwapUsed))

# 打印已使用的内存
echo "Used memory: $Used kB (Used = MemTotal - MemFree + SwapUsed)"

# 计算用于缓存和缓冲区的内存
CacheBuffer=$((Buffers + Cached + SReclaimable))

# 打印用于缓存和缓冲区的内存，包括每个组成部分
echo "Cache and Buffer: $CacheBuffer kB (CacheBuffer = Buffers + Cached + SReclaimable, Buffers: $Buffers kB, Cached: $Cached kB, SReclaimable: $SReclaimable kB)"

# 计算系统占用的内存（不包括进程占用）
SystemOnly=$((Used - TotalRSS - CacheBuffer))

# 打印系统占用的内存（不包括进程占用）
echo "System memory used (excluding processes): $SystemOnly kB (SystemOnly = Used - TotalRSS - CacheBuffer)"

# 分别提取每个字段并转换为MB
MemTotal=$(awk '/MemTotal:/ {print $2/1024}' /proc/meminfo)
MemFree=$(awk '/MemFree:/ {print $2/1024}' /proc/meminfo)
Buffers=$(awk '/Buffers:/ {print $2/1024}' /proc/meminfo)
Cached=$(awk '/^Cached:/ {print $2/1024}' /proc/meminfo)
SReclaimable=$(awk '/SReclaimable:/ {print $2/1024}' /proc/meminfo)
SwapTotal=$(awk '/SwapTotal:/ {print $2/1024}' /proc/meminfo)
SwapFree=$(awk '/SwapFree:/ {print $2/1024}' /proc/meminfo)

# 计算已使用的交换空间并转换为MB
SwapUsed=$(awk "BEGIN {print $SwapTotal - $SwapFree}")

# 打印获取的内存信息
echo "MemTotal: $MemTotal MB"  # 总物理内存
echo "MemFree: $MemFree MB"    # 空闲物理内存
echo "Buffers: $Buffers MB"    # 用于文件系统元数据的缓存
echo "Cached: $Cached MB"      # 用于文件数据的缓存
echo "SReclaimable: $SReclaimable MB"  # 可回收的 Slab 内存
echo "SwapTotal: $SwapTotal MB"  # 总交换空间
echo "SwapFree: $SwapFree MB"    # 空闲交换空间
echo "SwapUsed: $SwapUsed MB"    # 已使用的交换空间

# 获取所有进程的RSS总和并转换为MB
TotalRSS=$(ps -eo rss | awk '{sum+=$1} END {print sum/1024}')

# 打印所有进程的RSS总和
echo "Total RSS (all processes): $TotalRSS MB"  # 所有进程的RSS总和

# 计算已使用的内存并转换为MB
Used=$(awk "BEGIN {print $MemTotal - $MemFree + $SwapUsed}")

# 打印已使用的内存
echo "Used memory: $Used MB (Used = MemTotal - MemFree + SwapUsed)"

# 计算用于缓存和缓冲区的内存并转换为MB
CacheBuffer=$(awk "BEGIN {print $Buffers + $Cached + $SReclaimable}")

# 打印用于缓存和缓冲区的内存，包括每个组成部分
echo "Cache and Buffer: $CacheBuffer MB (CacheBuffer = Buffers + Cached + SReclaimable, Buffers: $Buffers MB, Cached: $Cached MB, SReclaimable: $SReclaimable MB)"

# 计算系统占用的内存（不包括进程占用）并转换为MB
SystemOnly=$(awk "BEGIN {print $Used - $TotalRSS - $CacheBuffer}")

# 打印系统占用的内存（不包括进程占用）
echo "System memory used (excluding processes): $SystemOnly MB (SystemOnly = Used - TotalRSS - CacheBuffer)"

ps -eo rss | awk '{sum+=$1} END {print sum}'

#!/system/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 将二进制文件目录加入 PATH
export PATH="/data/adb/二进制文件:$PATH"
proxy="https://gh-proxy.com/"
# 并发任务数（可自定义，例如 3、5、10、30）
MAX_CONCURRENT=30

# 创建两个目标文件夹（如果不存在）
mkdir -p "$SCRIPT_DIR/1.ClashRule"
mkdir -p "$SCRIPT_DIR/1.SingboxRule"

# 检查 url.ini 是否存在
URL_INI="$SCRIPT_DIR/url.ini"
if [ ! -f "$URL_INI" ]; then
    echo "错误：找不到 $URL_INI，请创建该文件并在每行写入一个 URL（支持 # 注释）"
    exit 1
fi

# ----------------------------------------------------------------------
# 辅助函数：将文件名主体转换为期望的大写/首字母大写格式
format_filename() {
    local name="$1"
    if echo "$name" | grep -q '^[a-z]*$' && [ ${#name} -le 3 ]; then
        echo "$name" | tr 'a-z' 'A-Z'
    else
        echo "$(echo "${name:0:1}" | tr 'a-z' 'A-Z')$(echo "${name:1}" | tr 'A-Z' 'a-z')"
    fi
}

# 下载函数：根据原始 URL 自动决定目录和文件名
download_url() {
    local url="$1"
    local target_dir=""
    local prefix=""
    
    # 1. 判断目标目录（sing 或 meta）
    if echo "$url" | grep -q '/sing/'; then
        target_dir="$SCRIPT_DIR/1.SingboxRule"
    elif echo "$url" | grep -q '/meta/'; then
        target_dir="$SCRIPT_DIR/1.ClashRule"
    else
        echo "错误：URL 中未找到 '/sing/' 或 '/meta/'，跳过: $url"
        return 1
    fi
    
    # 2. 判断前缀（geosite 或 geoip）
    if echo "$url" | grep -q '/geosite/'; then
        prefix="GEOSITE"
    elif echo "$url" | grep -q '/geoip/'; then
        prefix="GEOIP"
    else
        echo "错误：URL 中未找到 '/geosite/' 或 '/geoip/'，跳过: $url"
        return 1
    fi
    
    # 3. 提取原始文件名
    local original_file="${url##*/}"
    local base="${original_file%.*}"
    local ext="${original_file##*.}"
    if [ "$base" = "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    # 4. 格式化主文件名
    local formatted_base=$(format_filename "$base")
    local new_filename="${prefix}_${formatted_base}${ext}"
    local output_path="${target_dir}/${new_filename}"
    
    # 5. 执行下载（使用代理前缀）
    local full_url="${proxy}${url}"
    echo "下载: $full_url"
    echo "  -> $output_path"
    
    curl -k -L -o "$output_path" "$full_url"
    if [ $? -eq 0 ]; then
        echo "成功: $output_path"
    else
        echo "失败: $full_url"
        return 1
    fi
}

# ----------------------------------------------------------------------
# 读取 url.ini 中的有效 URL，存入数组 URLS
URLS=()
while IFS= read -r line || [ -n "$line" ]; do
    line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    case "$line" in
        ''|'#'*) continue ;;
    esac
    URLS+=("$line")
done < "$URL_INI"

total=${#URLS[@]}
if [ $total -eq 0 ]; then
    echo "url.ini 中没有有效 URL，退出。"
    exit 0
fi

echo "共读取 $total 个 URL，并发数设为 $MAX_CONCURRENT"

# ----------------------------------------------------------------------
# 批次并发下载
start=0
while [ $start -lt $total ]; do
    end=$((start + MAX_CONCURRENT))
    [ $end -gt $total ] && end=$total
    echo "=== 开始下载批次：$((start+1)) 到 $end ==="
    
    idx=$start
    while [ $idx -lt $end ]; do
        download_url "${URLS[$idx]}" &
        idx=$((idx + 1))
    done
    
    wait
    echo "=== 批次完成 ==="
    start=$end
done

echo "所有下载任务完成！"
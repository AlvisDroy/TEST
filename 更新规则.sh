#!/system/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# 将二进制文件目录加入 PATH
export PATH="/data/adb/二进制文件:$PATH"
proxy="https://gh-proxy.com/"
# 创建两个目标文件夹（如果不存在）
mkdir -p "$SCRIPT_DIR/1.ClashRule"
mkdir -p "$SCRIPT_DIR/1.SingboxRule"

# 检查 url.txt 是否存在
URL_INI="$SCRIPT_DIR/url.txt"
if [ ! -f "$URL_INI" ]; then
    echo "错误：找不到 $URL_INI，请创建该文件并在每行写入一个 URL（支持 # 注释）"
    exit 1
fi

# ----------------------------------------------------------------------
# 辅助函数：将文件名主体转换为期望的大写/首字母大写格式
# 参数：原始文件名主体（不含扩展名）
# 返回：转换后的字符串
format_filename() {
    local name="$1"
    # 如果文件名全小写且长度<=3，转为全大写（处理cn, us, jp等缩写）
    if echo "$name" | grep -q '^[a-z]*$' && [ ${#name} -le 3 ]; then
        echo "$name" | tr 'a-z' 'A-Z'
    else
        # 首字母大写，其余小写
        echo "$(echo "${name:0:1}" | tr 'a-z' 'A-Z')$(echo "${name:1}" | tr 'A-Z' 'a-z')"
    fi
}

# 下载函数：根据 URL 自动决定目录和文件名
# 参数：原始 URL（不含代理前缀）
download_url() {
    local url="$1"
    local target_dir=""
    local prefix=""
    
    # 1. 判断目标目录（sing 或 meta）—— 依据原始 URL 中的路径
    if echo "$url" | grep -q -e '/sing/' -e '/sing-box/'; then
        target_dir="$SCRIPT_DIR/1.SingboxRule"
    elif echo "$url" | grep -q -e '/meta/' -e '/clash/'; then
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
    
    # 3. 提取原始文件名（最后一个 '/' 之后的内容）
    local original_file="${url##*/}"
    # 分离主文件名和扩展名
    local base="${original_file%.*}"
    local ext="${original_file##*.}"
    # 如果扩展名和主文件名相同（无扩展名的情况），则清空扩展名
    if [ "$base" = "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    # 4. 格式化主文件名
    local formatted_base=$(format_filename "$base")
    local new_filename="${prefix}_${formatted_base}${ext}"
    
    # 5. 完整输出路径
    local output_path="${target_dir}/${new_filename}"
    
    # 6. 执行下载（使用代理前缀）
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
# 从 url.txt 逐行读取 URL 并下载
while IFS= read -r line || [ -n "$line" ]; do
    # 去除行首尾空白
    line="$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    # 跳过空行和以 # 开头的注释行
    case "$line" in
        ''|'#'*) continue ;;
    esac
    download_url "$line"
    echo "----------------------------------------"
done < "$URL_INI"
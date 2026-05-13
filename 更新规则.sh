#!/system/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURL="$SCRIPT_DIR/bin/curl"   # 请确保 curl 已存在且可执行

# 创建两个目标文件夹（如果不存在）
mkdir -p "$SCRIPT_DIR/1.ClashRule"
mkdir -p "$SCRIPT_DIR/1.SingboxRule"
# ----------------------------------------------------------------------
# 在这里列出你要下载的所有 URL
# 示例URL（根据你的实际需要添加或删除）
URLS=(
#singbox
#geosite
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/cn.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/geolocation-!cn.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/steam.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/steam@cn.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/paypal.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/netflix.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/tiktok.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/telegram.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/apple.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/microsoft.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/onedrive.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/github.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/google.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/youtube.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/category-ai-!cn.srs"
#    "https://gh-proxy.com/https://raw.githubusercontent.com/qichiyuhub/rule/refs/heads/main/rules/fakeipfilter.json"
#geoip
    "https://gh-proxy.com/https://github.com/qljsyph/ruleset-icon/raw/refs/heads/main/sing-box/geoip/China-ASN-combined-ip.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/netflix.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/telegram.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo-lite/geoip/apple.srs"
    "https://gh-proxy.com/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/google.srs"
#clash
#geosite
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/google.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/discord.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/facebook.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/geolocation-!cn.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/cn.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/github.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/googlefcm.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/netflix.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/openai.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/spotify.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/steam.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/telegram.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/tiktok.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/twitter.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/youtube.mrs"
#geoip
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/facebook.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/google.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/netflix.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/telegram.mrs"
    "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/twitter.mrs"
)

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

# 下载函数：根据URL自动决定目录和文件名
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
        echo "错误：URL中未找到 '/sing/' 或 '/meta/'，跳过: $url"
        return 1
    fi
    
    # 2. 判断前缀（geosite 或 geoip）
    if echo "$url" | grep -q '/geosite/'; then
        prefix="GEOSITE"
    elif echo "$url" | grep -q '/geoip/'; then
        prefix="GEOIP"
    else
        echo "错误：URL中未找到 '/geosite/' 或 '/geoip/'，跳过: $url"
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
    
    echo "下载: $url"
    echo "  -> $output_path"
    
    # 6. 执行下载
    $CURL -k -L -o "$output_path" "$url"
    if [ $? -eq 0 ]; then
        echo "成功: $output_path"
    else
        echo "失败: $url"
        return 1
    fi
}


# 遍历并下载
for url in "${URLS[@]}"; do
    download_url "$url"
    echo "----------------------------------------"
done
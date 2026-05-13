#!/system/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURL="$SCRIPT_DIR/bin/curl"   # 请确保 curl 已存在且可执行

mkdir -p "$SCRIPT_DIR/1.ClashRule"
mkdir -p "$SCRIPT_DIR/1.SingboxRule"

# ----------------------------------------------------------------------
# 你的 URLS 数组（保持不变，这里省略显示，请粘贴你自己的）
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
# ----------------------------------------------------------------------

format_filename() {
    local name="$1"
    if echo "$name" | grep -q '^[a-z]*$' && [ ${#name} -le 3 ]; then
        echo "$name" | tr 'a-z' 'A-Z'
    else
        echo "$(echo "${name:0:1}" | tr 'a-z' 'A-Z')$(echo "${name:1}" | tr 'A-Z' 'a-z')"
    fi
}

download_url() {
    local url="$1"
    local target_dir=""
    local prefix=""
    
    if echo "$url" | grep -qE '/(sing|sing-box)/'; then
        target_dir="$SCRIPT_DIR/1.SingboxRule"
    elif echo "$url" | grep -q '/meta/'; then
        target_dir="$SCRIPT_DIR/1.ClashRule"
    else
        echo "错误：URL中未找到 '/sing/' 或 '/meta/'，跳过: $url"
        return 1
    fi
    
    if echo "$url" | grep -q '/geosite/'; then
        prefix="GEOSITE"
    elif echo "$url" | grep -q '/geoip/'; then
        prefix="GEOIP"
    else
        echo "错误：URL中未找到 '/geosite/' 或 '/geoip/'，跳过: $url"
        return 1
    fi
    
    local original_file="${url##*/}"
    local base="${original_file%.*}"
    local ext="${original_file##*.}"
    if [ "$base" = "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    local formatted_base=$(format_filename "$base")
    local new_filename="${prefix}_${formatted_base}${ext}"
    local output_path="${target_dir}/${new_filename}"
    
    echo "下载: $url"
    echo "  -> $output_path"
    
    $CURL -k -L -o "$output_path" "$url"
    if [ $? -eq 0 ]; then
        echo "成功: $output_path"
    else
        echo "失败: $url"
        return 1
    fi
}

# ==================== 并发下载（替换原来的串行 for 循环） ====================
MAX_CONCURRENT=30          # 同时下载的任务数，可改为 3 或 5
total=${#URLS[@]}
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
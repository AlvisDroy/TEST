#!/system/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 将二进制文件目录加入 PATH
export PATH="/data/adb/二进制文件:$PATH"

PROXY="https://gh-proxy.com/"
#PROXY="https://ghfast.top/"
#PROXY="https://ghproxy.com/"
#PROXY="https://github.moeyy.cn/"
#PROXY="https://mirror.ghproxy.com/"
#PROXY="https://kgithub.com/"
#PROXY="https://kgithub.com/"
#PROXY="https://kgithub.com/"
mkdir -p "$SCRIPT_DIR/1.ClashRule"
mkdir -p "$SCRIPT_DIR/1.SingboxRule"

# ----------------------------------------------------------------------
# URLS 数组
URLS=(
#singbox
#geosite
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/cn.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/geolocation-!cn.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/steam.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/steam@cn.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/paypal.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/netflix.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/tiktok.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/telegram.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/apple.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/microsoft.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/onedrive.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/github.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/google.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/youtube.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geosite/category-ai-!cn.srs"
#    "https://raw.githubusercontent.com/qichiyuhub/rule/refs/heads/main/rules/fakeipfilter.json"
#geoip
    "https://github.com/qljsyph/ruleset-icon/raw/refs/heads/main/sing-box/geoip/China-ASN-combined-ip.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/netflix.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/telegram.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo-lite/geoip/apple.srs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/sing/geo/geoip/google.srs"
#clash
#geosite
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/google.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/discord.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/facebook.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/geolocation-!cn.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/cn.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/github.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/googlefcm.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/netflix.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/openai.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/spotify.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/steam.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/telegram.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/tiktok.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/twitter.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geosite/youtube.mrs"
#geoip
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/facebook.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/google.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/netflix.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/telegram.mrs"
    "https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/meta/geo/geoip/twitter.mrs"
    # 新增的 JSON 文件（不包含 sing/meta，扩展名为 json → 归入 SingboxRule）
    "https://raw.githubusercontent.com/qichiyuhub/rule/refs/heads/main/rules/fakeipfilter-cn.json"
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
    
    # 1. 决定存放目录（优先按路径关键词，否则按扩展名）
    if echo "$url" | grep -qE '/sing/|/sing-box/'; then
        target_dir="$SCRIPT_DIR/1.SingboxRule"
    elif echo "$url" | grep -q '/meta/'; then
        target_dir="$SCRIPT_DIR/1.ClashRule"
    else
        # 不包含 sing 或 meta：按扩展名判断
        local ext="${url##*.}"   # 取最后点后的部分
        if [ "$ext" = "json" ]; then
            target_dir="$SCRIPT_DIR/1.SingboxRule"
        else
            target_dir="$SCRIPT_DIR/1.ClashRule"
        fi
    fi
    
    # 2. 决定前缀（仅当路径包含 geosite 或 geoip 时才添加）
    if echo "$url" | grep -q '/geosite/'; then
        prefix="GEOSITE"
    elif echo "$url" | grep -q '/geoip/'; then
        prefix="GEOIP"
    fi
    
    # 3. 提取文件名、基础名、扩展名
    local original_file="${url##*/}"
    local base="${original_file%.*}"
    local ext="${original_file##*.}"
    # 若无扩展名（如无点），则 ext 置空
    if [ "$base" = "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi
    
    # 4. 格式化基础名（首字母大写，其余小写，保持连字符等）
    local formatted_base=$(format_filename "$base")
    
    # 5. 组装新文件名
    local new_filename
    if [ -n "$prefix" ]; then
        new_filename="${prefix}_${formatted_base}${ext}"
    else
        new_filename="${formatted_base}${ext}"
    fi
    
    local output_path="${target_dir}/${new_filename}"
    
    echo "下载: $PROXY$url"
    echo "  -> $output_path"
    
    curl -k -L -o "$output_path" "$PROXY$url"
    if [ $? -eq 0 ]; then
        echo "成功: $output_path"
    else
        echo "失败: $PROXY$url"
        return 1
    fi
}

# ==================== 遍历并下载 ====================

for url in "${URLS[@]}"; do
    download_url "$proxy$url"
    echo "----------------------------------------"
done
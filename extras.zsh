# ~/.550w/extras.zsh — 550W 外围工具 v1.0
# 快捷键说明 / 别名 / 会话 / 提示符 / 统计 / 备份 / 日志 / 插件 / 主题

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ 路径 ══════════════════
typeset -g _550W_ALIAS_FILE="${HOME}/.550w/extras/aliases.sh"
typeset -g _550W_SESSION_DIR="${HOME}/.550w/extras/sessions"
typeset -g _550W_STATS_FILE="${HOME}/.550w/extras/stats.log"
typeset -g _550W_THEME_DIR="${HOME}/.550w/themes"
typeset -g _550W_PLUGIN_MARKET="${HOME}/.550w/plugins/_market"
typeset -g _550W_THEME_MARKET="${HOME}/.550w/themes/_market"

for d in "${HOME}/.550w/extras" "$_550W_SESSION_DIR" "$_550W_THEME_DIR" \
         "$_550W_PLUGIN_MARKET" "$_550W_THEME_MARKET"; do
    [[ -d "$d" ]] || mkdir -p "$d"
done

# ══════════════════ 辅助 ══════════════════

_550w_ex_head() {
    _550w_cls
    local title="$1"
    local w=50
    local bar="" i
    for (( i=0; i<w; i++ )); do bar+="═"; done
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B╔${bar}╗%b%f"
    print -P "  %F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[bright]}}%B${title}%b%f"
    print -P "  %F{${_550W_C[cyan]}}%B╚${bar}╝%b%f"
    print ""
}

_550w_ex_row() {
    local num="$1" text="$2"
    printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "$num" "$text"
}

_550w_ex_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

_550w_ex_msg() {
    local type="$1"; shift
    case "$type" in
        ok)  print -P "  %F{${_550W_C[ok]}}✓ $*%f" ;;
        err) print -P "  %F{${_550W_C[err]}}✗ $*%f" ;;
        wrn) print -P "  %F{${_550W_C[warn]}}⚠ $*%f" ;;
        inf) print -P "  %F{${_550W_C[cyan]}}→ $*%f" ;;
    esac
    sleep 0.8
}

# ══════════════════ 主菜单 ══════════════════

550w-extras() {
    while true; do
        _550w_ex_head "550W 外围工具"
        print -P "  %F{${_550W_C[dim]}}辅助功能 10 组%f"
        print ""
        _550w_ex_row "1"  "快捷键说明  Ctrl 组合键"
        _550w_ex_row "2"  "别名系统    自定义命令别名"
        _550w_ex_row "3"  "会话管理    保存/恢复/切换/导出"
        _550w_ex_row "4"  "提示符设置  自定义 PS1"
        _550w_ex_row "5"  "命令统计    调用次数排行"
        _550w_ex_row "6"  "备份系统    自动/手动/加密/恢复"
        _550w_ex_row "7"  "日志系统    轮转/清理/搜索/导出"
        _550w_ex_row "8"  "插件系统    本地加载/管理"
        _550w_ex_row "9"  "主题系统    本地切换/导入"
        _550w_ex_row "10" "数据导入导出"
        print ""
        _550w_ex_row "0"  "退出"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_ex_menu_keyboard ;;
            2)  _550w_ex_menu_alias ;;
            3)  _550w_ex_menu_session ;;
            4)  _550w_ex_menu_ps1 ;;
            5)  _550w_ex_menu_stats ;;
            6)  _550w_ex_menu_backup ;;
            7)  _550w_ex_menu_log ;;
            8)  _550w_ex_menu_plugin ;;
            9)  _550w_ex_menu_theme ;;
            10) _550w_ex_menu_data ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 快捷键说明 ══════════════════

_550w_ex_menu_keyboard() {
    _550w_ex_head "快捷键说明"
    print -P "  %F{${_550W_C[dim]}}zsh 内建 Ctrl 组合键（无需绑定）%f"
    print ""
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+A"  "光标移到行首"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+E"  "光标移到行尾"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+W"  "删除光标前一个词"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+U"  "删除光标到行首"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+K"  "删除光标到行尾"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+L"  "清屏"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+R"  "反向搜索历史"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+C"  "中断当前命令"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+D"  "退出 shell"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[ok]}"   "Ctrl+Z"  "挂起到后台"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[warn]}" "Tab"     "命令补全"
    printf '  \e[38;5;%sm%-10s\e[0m %s\n' "${_550W_C[warn]}" "↑ / ↓"   "浏览历史"
    print ""
    print -P "  %F{${_550W_C[dim]}}Alt 组合键在 Termux 下不可靠，已停用%f"
    print -P "  %F{${_550W_C[dim]}}Termux 屏幕底部工具栏可自定义%f"
    _550w_ex_pause
}

# ══════════════════ 2. 别名系统 ══════════════════

_550w_ex_menu_alias() {
    while true; do
        _550w_ex_head "别名系统"
        local n=0
        [[ -f "$_550W_ALIAS_FILE" ]] && n=$(wc -l < "$_550W_ALIAS_FILE" | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}已定义 $n 条 · 文件 $_550W_ALIAS_FILE%f"
        print ""
        _550w_ex_row "1"  "列出别名    查看所有"
        _550w_ex_row "2"  "添加别名    名称=命令"
        _550w_ex_row "3"  "删除别名    按名称"
        _550w_ex_row "4"  "应用别名    重新 source"
        _550w_ex_row "5"  "清空别名    删除全部"
        _550w_ex_row "6"  "编辑文件    nano 打开"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_alias_list ;;
            2) _550w_ex_alias_add ;;
            3) _550w_ex_alias_del ;;
            4) _550w_ex_alias_apply ;;
            5) _550w_ex_alias_clear ;;
            6) _550w_ex_alias_edit ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_alias_list() {
    _550w_ex_head "别名列表"
    if [[ -r "$_550W_ALIAS_FILE" ]]; then
        local line n=0
        while IFS= read -r line; do
            [[ -z "$line" || "$line" == \#* ]] && continue
            (( n++ ))
            printf '  \e[38;5;%sm[%2d]\e[0m %s\n' "${_550W_C[cyan]}" "$n" "$line"
        done < "$_550W_ALIAS_FILE"
        (( n == 0 )) && print -P "  %F{${_550W_C[dim]}}（空）%f"
    else
        print -P "  %F{${_550W_C[dim]}}（文件不存在）%f"
    fi
    _550w_ex_pause
}

_550w_ex_alias_add() {
    _550w_ex_head "添加别名"
    print "  格式：别名=命令"
    print "  例：ll=ls -la"
    print ""
    print -n "  > "
    local def
    read -r def
    [[ -z "$def" ]] && return
    [[ "$def" != *"="* ]] && { _550w_ex_msg err "格式错误"; return; }
    local name="${def%%=*}"
    if grep -q "^alias ${name}=" "$_550W_ALIAS_FILE" 2>/dev/null; then
        _550w_ex_msg wrn "别名 $name 已存在"
        return
    fi
    print "alias ${def}" >> "$_550W_ALIAS_FILE"
    source "$_550W_ALIAS_FILE" 2>/dev/null
    _550w_ex_msg ok "已添加: $name"
}

_550w_ex_alias_del() {
    _550w_ex_head "删除别名"
    print -n "  别名名称: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    if grep -q "^alias ${name}=" "$_550W_ALIAS_FILE" 2>/dev/null; then
        sed -i "/^alias ${name}=/d" "$_550W_ALIAS_FILE"
        unalias "$name" 2>/dev/null
        _550w_ex_msg ok "已删除: $name"
    else
        _550w_ex_msg err "别名不存在"
    fi
}

_550w_ex_alias_apply() {
    if [[ -r "$_550W_ALIAS_FILE" ]]; then
        source "$_550W_ALIAS_FILE" && _550w_ex_msg ok "已应用"
    else
        _550w_ex_msg wrn "文件不存在"
    fi
}

_550w_ex_alias_clear() {
    print -n "  确认清空所有别名? (y/N): "
    local c
    read -r c
    if [[ "$c" == "y" || "$c" == "Y" ]]; then
        : > "$_550W_ALIAS_FILE"
        _550w_ex_msg ok "已清空"
    fi
}

_550w_ex_alias_edit() {
    if command -v nano >/dev/null 2>&1; then
        nano "$_550W_ALIAS_FILE"
    else
        _550w_ex_msg err "未装 nano"
    fi
}

# ══════════════════ 历史管理 ══════════════════

_550w_ex_hist_search() {
    _550w_ex_head "历史搜索"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    print ""
    local hf="${HISTFILE:-$HOME/.550w/.550w_history}"
    if [[ -r "$hf" ]]; then
        grep --color=never "$kw" "$hf" | tail -30 | sed 's|^|  |'
    else
        _550w_ex_msg wrn "历史文件不存在"
    fi
    _550w_ex_pause
}

_550w_ex_hist_stats() {
    _550w_ex_head "历史统计"
    local hf="${HISTFILE:-$HOME/.550w/.550w_history}"
    if [[ ! -r "$hf" ]]; then
        _550w_ex_msg wrn "历史文件不存在"
        return
    fi
    local total
    total=$(wc -l < "$hf" | tr -d ' ')
    printf '  %-14s %s\n' "总条数" "$total"
    printf '  %-14s %s\n' "文件" "$hf"
    printf '  %-14s %s\n' "大小" "$(du -h "$hf" | cut -f1)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}Top 10 命令%f"
    awk '{print $1}' "$hf" | sort | uniq -c | sort -rn | head -10 | \
        awk '{printf "  %5d  %s\n", $1, $2}'
    _550w_ex_pause
}

_550w_ex_hist_clear() {
    _550w_ex_head "历史清理"
    print "  [1] 清空当前会话历史"
    print "  [2] 清空持久历史文件"
    print "  [3] 删除重复项"
    print -n "  选择: "
    local c
    read -r c
    case "$c" in
        1)
            history -c 2>/dev/null || print -p ""
            _550w_ex_msg ok "已清空当前"
            ;;
        2)
            print -n "  确认清空历史文件? (y/N): "; local a; read -r a
            if [[ "$a" == "y" ]]; then
                local hf="${HISTFILE:-$HOME/.550w/.550w_history}"
                : > "$hf"
                _550w_ex_msg ok "已清空"
            fi
            ;;
        3)
            local hf="${HISTFILE:-$HOME/.550w/.550w_history}"
            if [[ -r "$hf" ]]; then
                awk '!seen[$0]++' "$hf" > "$hf.tmp" && mv "$hf.tmp" "$hf"
                _550w_ex_msg ok "已去重"
            fi
            ;;
    esac
}

_550w_ex_hist_export() {
    _550w_ex_head "历史导出"
    local hf="${HISTFILE:-$HOME/.550w/.550w_history}"
    [[ -r "$hf" ]] || { _550w_ex_msg err "无历史"; return; }
    local dest="$HOME/.550w/backups/history_$(date +%Y%m%d_%H%M%S).txt"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    cp "$hf" "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

# ══════════════════ 3. 会话管理 ══════════════════

_550w_ex_menu_session() {
    while true; do
        _550w_ex_head "会话管理"
        local n=0
        [[ -d "$_550W_SESSION_DIR" ]] && n=$(ls -1 "$_550W_SESSION_DIR"/*.json 2>/dev/null | wc -l | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}已存 $n 个会话%f"
        print ""
        _550w_ex_row "1"  "保存当前    写入文件"
        _550w_ex_row "2"  "列出会话    浏览全部"
        _550w_ex_row "3"  "加载会话    恢复历史"
        _550w_ex_row "4"  "删除会话    按名称"
        _550w_ex_row "5"  "重命名会话  改名"
        _550w_ex_row "6"  "导出为 MD  文本格式"
        _550w_ex_row "7"  "查看统计    会话信息"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_sess_save ;;
            2) _550w_ex_sess_list ;;
            3) _550w_ex_sess_load ;;
            4) _550w_ex_sess_del ;;
            5) _550w_ex_sess_rename ;;
            6) _550w_ex_sess_export ;;
            7) _550w_ex_sess_info ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_sess_save() {
    _550w_ex_head "保存会话"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_ex_msg err "当前会话为空"
        return
    fi
    local name
    print -n "  会话名（默认时间戳）: "
    read -r name
    [[ -z "$name" ]] && name="sess_$(date +%Y%m%d_%H%M%S)"
    local file="$_550W_SESSION_DIR/${name}.json"
    {
        print "{"
        print "  \"sid\": \"$_550W_SESSION_ID\","
        print "  \"provider\": \"$_550W_MOSS_PROVIDER\","
        print "  \"model\": \"$_550W_MOSS_MODEL\","
        print "  \"saved\": \"$(date '+%Y-%m-%d %H:%M:%S')\","
        print "  \"messages\": ["
        local i
        for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
            local sep=","
            (( i == ${#_550W_MOSS_HISTORY[@]} )) && sep=""
            print "    ${_550W_MOSS_HISTORY[$i]}${sep}"
        done
        print "  ]"
        print "}"
    } > "$file"
    _550w_ex_msg ok "已保存: ${name}.json"
}

_550w_ex_sess_list() {
    _550w_ex_head "会话列表"
    local found=0 f i=0
    for f in "$_550W_SESSION_DIR"/*.json(N); do
        found=1
        (( i++ ))
        local sz
        sz=$(wc -c < "$f" | tr -d ' ')
        printf '  \e[38;5;%sm[%2d]\e[0m %-30s \e[38;5;%sm%s 字节\e[0m\n' \
            "${_550W_C[cyan]}" "$i" "${f:t:r}" "${_550W_C[dim]}" "$sz"
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（无会话）%f"
    _550w_ex_pause
}

_550w_ex_sess_load() {
    _550w_ex_head "加载会话"
    local -a files=("$_550W_SESSION_DIR"/*.json(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    _550W_MOSS_HISTORY=()
    local line
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        [[ "$line" == *'"role":'* && "$line" == *'"content":'* ]] || continue
        _550W_MOSS_HISTORY+=("$line")
    done < "${files[$n]}"
    _550w_moss_memory_save
    _550w_ex_msg ok "已加载 ${#_550W_MOSS_HISTORY[@]} 条"
}

_550w_ex_sess_del() {
    _550w_ex_head "删除会话"
    local -a files=("$_550W_SESSION_DIR"/*.json(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    print -n "  确认删除? (y/N): "
    local c
    read -r c
    if [[ "$c" == "y" || "$c" == "Y" ]]; then
        rm -f "${files[$n]}"
        _550w_ex_msg ok "已删除"
    fi
}

_550w_ex_sess_rename() {
    _550w_ex_head "重命名会话"
    local -a files=("$_550W_SESSION_DIR"/*.json(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    print -n "  新名称: "
    local newname
    read -r newname
    [[ -z "$newname" ]] && return
    mv "${files[$n]}" "$_550W_SESSION_DIR/${newname}.json"
    _550w_ex_msg ok "已重命名"
}

_550w_ex_sess_export() {
    _550w_ex_head "导出会话"
    local -a files=("$_550W_SESSION_DIR"/*.json(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local dest="$HOME/.550w/backups/sess_$(date +%Y%m%d_%H%M%S).md"
    {
        print "# 会话导出"
        print ""
        local line
        while IFS= read -r line; do
            [[ "$line" == *'"role":"user"'* ]]      && { print ""; print "**U:**"; }
            [[ "$line" == *'"role":"assistant"'* ]] && { print ""; print "**A:**"; }
            local c
            c=$(print -nr -- "$line" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | head -1)
            [[ -n "$c" ]] && print "$c"
        done < "${files[$n]}"
    } > "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

_550w_ex_sess_info() {
    _550w_ex_head "会话统计"
    printf '  %-14s %s\n' "当前会话 ID" "$_550W_SESSION_ID"
    printf '  %-14s %s\n' "当前消息数" "${#_550W_MOSS_HISTORY[@]}"
    printf '  %-14s %s\n' "会话目录" "$_550W_SESSION_DIR"
    local n=0
    [[ -d "$_550W_SESSION_DIR" ]] && n=$(ls -1 "$_550W_SESSION_DIR"/*.json 2>/dev/null | wc -l | tr -d ' ')
    printf '  %-14s %s\n' "已存会话" "$n"
    local total=0
    [[ -d "$_550W_SESSION_DIR" ]] && total=$(du -sh "$_550W_SESSION_DIR" 2>/dev/null | cut -f1)
    printf '  %-14s %s\n' "占用空间" "$total"
    _550w_ex_pause
}

# ══════════════════ 4. 提示符设置 ══════════════════

_550w_ex_menu_ps1() {
    while true; do
        _550w_ex_head "提示符设置"
        print -P "  %F{${_550W_C[dim]}}当前 PS1 = %f$PS1"
        print ""
        _550w_ex_row "1"  "样式         full/minimal/plain"
        _550w_ex_row "2"  "显示 SID     $_550W_PS1_SHOW_SID"
        _550w_ex_row "3"  "显示模式     $_550W_PS1_SHOW_MODE"
        _550w_ex_row "4"  "显示 MOSS    $_550W_PS1_SHOW_MOSS"
        _550w_ex_row "5"  "显示时间     $_550W_PS1_SHOW_TIME"
        _550w_ex_row "6"  "应用         重建 PS1"
        _550w_ex_row "7"  "恢复默认     完整样式"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1)
                print "  full / minimal / plain"
                print -n "  样式: "; local m; read -r m
                case "$m" in
                    full|minimal|plain)
                        _550W_PS1_MODE="$m"
                        _550w_build_ps1
                        _550w_config_save >/dev/null 2>&1
                        _550w_ex_msg ok "已设置: $m"
                        ;;
                esac
                ;;
            2)
                print -n "  显示 SID [0/1]: "; read -r _550W_PS1_SHOW_SID
                _550w_build_ps1; _550w_config_save >/dev/null 2>&1
                ;;
            3)
                print -n "  显示模式 [0/1]: "; read -r _550W_PS1_SHOW_MODE
                _550w_build_ps1; _550w_config_save >/dev/null 2>&1
                ;;
            4)
                print -n "  显示 MOSS [0/1]: "; read -r _550W_PS1_SHOW_MOSS
                _550w_build_ps1; _550w_config_save >/dev/null 2>&1
                ;;
            5)
                print -n "  显示时间 [0/1]: "; read -r _550W_PS1_SHOW_TIME
                _550w_build_ps1; _550w_config_save >/dev/null 2>&1
                ;;
            6)
                _550w_build_ps1
                _550w_ex_msg ok "已应用"
                ;;
            7)
                _550W_PS1_MODE="full"
                _550W_PS1_SHOW_SID=1
                _550W_PS1_SHOW_MODE=1
                _550W_PS1_SHOW_MOSS=1
                _550W_PS1_SHOW_TIME=1
                _550w_build_ps1
                _550w_config_save >/dev/null 2>&1
                _550w_ex_msg ok "已恢复默认"
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 5. 命令统计 ══════════════════

typeset -g _550W_STATS_ENABLED="${_550W_STATS_ENABLED:-1}"
typeset -g _550W_STATS_MAX_LINES=5000

_550w_ex_stats_log() {
    (( _550W_STATS_ENABLED )) || return 0
    local cmd="$1" ms="$2"
    print "$(date '+%Y-%m-%d %H:%M:%S')|${ms}ms|$cmd" >> "$_550W_STATS_FILE" 2>/dev/null
    # 超过上限裁剪
    local n
    n=$(wc -l < "$_550W_STATS_FILE" 2>/dev/null | tr -d ' ')
    if [[ -n "$n" ]] && (( n > _550W_STATS_MAX_LINES )); then
        tail -n "$_550W_STATS_MAX_LINES" "$_550W_STATS_FILE" > "${_550W_STATS_FILE}.tmp" 2>/dev/null
        mv "${_550W_STATS_FILE}.tmp" "$_550W_STATS_FILE" 2>/dev/null
    fi
}

_550w_ex_menu_stats() {
    while true; do
        _550w_ex_head "命令统计"
        local n=0
        [[ -f "$_550W_STATS_FILE" ]] && n=$(wc -l < "$_550W_STATS_FILE" 2>/dev/null | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}已记录 $n 条 · 开关 $_550W_STATS_ENABLED%f"
        print ""
        _550w_ex_row "1"  "开启记录    1=开 0=关"
        _550w_ex_row "2"  "调用次数    Top 20 排行"
        _550w_ex_row "3"  "耗时排行    慢命令 Top 20"
        _550w_ex_row "4"  "今日统计    当天调用"
        _550w_ex_row "5"  "查看记录    最新 30 条"
        _550w_ex_row "6"  "清空记录    删除日志"
        _550w_ex_row "7"  "导出记录    备份到文件"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1)
                print -n "  统计开关 [0/1]: "
                read -r _550W_STATS_ENABLED
                _550w_config_save >/dev/null 2>&1
                ;;
            2) _550w_ex_stats_freq ;;
            3) _550w_ex_stats_slow ;;
            4) _550w_ex_stats_today ;;
            5) _550w_ex_stats_tail ;;
            6) _550w_ex_stats_clear ;;
            7) _550w_ex_stats_export ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_stats_freq() {
    _550w_ex_head "命令调用排行 Top 20"
    if [[ ! -r "$_550W_STATS_FILE" ]]; then
        _550w_ex_msg wrn "无记录"
        return
    fi
    awk -F'|' '{print $3}' "$_550W_STATS_FILE" | \
        awk '{print $1}' | sort | uniq -c | sort -rn | head -20 | \
        awk '{printf "  %5d  %s\n", $1, $2}'
    _550w_ex_pause
}

_550w_ex_stats_slow() {
    _550w_ex_head "慢命令排行 Top 20"
    if [[ ! -r "$_550W_STATS_FILE" ]]; then
        _550w_ex_msg wrn "无记录"
        return
    fi
    awk -F'|' '{
        ms = $2
        sub(/ms$/, "", ms)
        cmd = $3
        gsub(/^ +| +$/, "", cmd)
        if (cmd != "") print ms "|" cmd
    }' "$_550W_STATS_FILE" | \
        sort -t'|' -k1 -rn | head -20 | \
        awk -F'|' '{printf "  %6s ms  %s\n", $1, $2}'
    _550w_ex_pause
}

_550w_ex_stats_today() {
    _550w_ex_head "今日统计"
    if [[ ! -r "$_550W_STATS_FILE" ]]; then
        _550w_ex_msg wrn "无记录"
        return
    fi
    local today
    today=$(date '+%Y-%m-%d')
    local count=0
    count=$(grep -c "^$today" "$_550W_STATS_FILE" 2>/dev/null)
    printf '  %-14s %s\n' "日期" "$today"
    printf '  %-14s %s\n' "调用次数" "$count"
    print ""
    print -P "  %F{${_550W_C[cyan]}}Top 10（今日）%f"
    grep "^$today" "$_550W_STATS_FILE" 2>/dev/null | \
        awk -F'|' '{print $3}' | awk '{print $1}' | \
        sort | uniq -c | sort -rn | head -10 | \
        awk '{printf "  %5d  %s\n", $1, $2}'
    _550w_ex_pause
}

_550w_ex_stats_tail() {
    _550w_ex_head "最新记录"
    if [[ ! -r "$_550W_STATS_FILE" ]]; then
        _550w_ex_msg wrn "无记录"
        return
    fi
    tail -30 "$_550W_STATS_FILE" | sed 's|^|  |'
    _550w_ex_pause
}

_550w_ex_stats_clear() {
    print -n "  确认清空统计? (y/N): "
    local c
    read -r c
    if [[ "$c" == "y" || "$c" == "Y" ]]; then
        : > "$_550W_STATS_FILE"
        _550w_ex_msg ok "已清空"
    fi
}

_550w_ex_stats_export() {
    [[ -r "$_550W_STATS_FILE" ]] || { _550w_ex_msg err "无记录"; return; }
    local dest="$HOME/.550w/backups/stats_$(date +%Y%m%d_%H%M%S).log"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    cp "$_550W_STATS_FILE" "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

# ══════════════════ 慢命令警告 ══════════════════

_550w_ex_preexec_stats() {
    (( _550W_STATS_ENABLED )) || return 0
    _550W_EX_CMD_START="${EPOCHREALTIME:-}"
    _550W_EX_CMD_TEXT="$1"
}

_550w_ex_precmd_stats() {
    (( _550W_STATS_ENABLED )) || return 0
    [[ -z "$_550W_EX_CMD_START" ]] && return 0
    local t1="${EPOCHREALTIME:-}"
    [[ -z "$t1" ]] && return 0
    local ms=$(( (${t1%.*} - ${_550W_EX_CMD_START%.*}) * 1000 ))
    (( ms < 0 )) && ms=0
    local cmd="${_550W_EX_CMD_TEXT:-unknown}"
    _550w_ex_stats_log "$cmd" "$ms"
    if (( ms >= _550W_CMD_TIMING_THRESHOLD * 1000 )); then
        print -P "%F{${_550W_C[warn]}}  ⏱ 慢命令：${ms}ms  $cmd%f"
    fi
    _550W_EX_CMD_START=""
    _550W_EX_CMD_TEXT=""
}

_550w_ex_stats_install() {
    autoload -Uz add-zsh-hook
    _550w_ex_stats_uninstall
    add-zsh-hook preexec _550w_ex_preexec_stats
    add-zsh-hook precmd  _550w_ex_precmd_stats
}

_550w_ex_stats_uninstall() {
    preexec_functions=(${preexec_functions:#_550w_ex_preexec_stats})
    precmd_functions=(${precmd_functions:#_550w_ex_precmd_stats})
}

# 自动挂载（仅统计，不影响核心钩子）
_550w_ex_stats_install

# ══════════════════ 6. 备份系统 ══════════════════

typeset -g _550W_EX_BACKUP_DIR="${HOME}/.550w/backups"
typeset -g _550W_EX_BACKUP_KEEP="${_550W_BACKUP_KEEP:-10}"

_550w_ex_menu_backup() {
    while true; do
        _550w_ex_head "备份系统"
        local n=0
        [[ -d "$_550W_EX_BACKUP_DIR" ]] && n=$(ls -1 "$_550W_EX_BACKUP_DIR" 2>/dev/null | wc -l | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}目录 $_550W_EX_BACKUP_DIR · 已有 $n 个%f"
        print ""
        _550w_ex_row "1"  "立即备份    压缩整个 .550w"
        _550w_ex_row "2"  "不压缩备份  复制目录"
        _550w_ex_row "3"  "加密备份    密码保护"
        _550w_ex_row "4"  "从备份恢复  选择文件"
        _550w_ex_row "5"  "列出备份    ls 目录"
        _550w_ex_row "6"  "清理旧备份  超保留数删除"
        _550w_ex_row "7"  "校验备份    sha256 对比"
        _550w_ex_row "8"  "自动备份    开机时备份"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_bak_quick ;;
            2) _550w_ex_bak_copy ;;
            3) _550w_ex_bak_encrypt ;;
            4) _550w_ex_bak_restore ;;
            5) _550w_ex_bak_list ;;
            6) _550w_ex_bak_clean ;;
            7) _550w_ex_bak_verify ;;
            8) _550w_ex_bak_auto ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_bak_mkdir() {
    [[ -d "$_550W_EX_BACKUP_DIR" ]] || mkdir -p "$_550W_EX_BACKUP_DIR"
}

# 1. 快速备份（tar.gz）
_550w_ex_bak_quick() {
    _550w_ex_head "立即备份"
    _550w_ex_bak_mkdir
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    local dest="$_550W_EX_BACKUP_DIR/backup_${stamp}.tar.gz"
    print -P "  %F{${_550W_C[dim]}}打包中...%f"
    if tar -czf "$dest" -C "$HOME" ".550w" 2>/dev/null; then
        local sz
        sz=$(du -h "$dest" | cut -f1)
        _550w_ex_msg ok "已备份: ${dest:t} ($sz)"
    else
        _550w_ex_msg err "备份失败"
    fi
}

# 2. 不压缩备份（cp -r）
_550w_ex_bak_copy() {
    _550w_ex_head "不压缩备份"
    _550w_ex_bak_mkdir
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    local dest="$_550W_EX_BACKUP_DIR/backup_${stamp}"
    print -P "  %F{${_550W_C[dim]}}复制中...%f"
    if cp -r "$HOME/.550w" "$dest" 2>/dev/null; then
        _550w_ex_msg ok "已备份: ${dest:t}"
    else
        _550w_ex_msg err "备份失败"
    fi
}

# 3. 加密备份（tar + openssl，若无 openssl 降级为普通 tar）
_550w_ex_bak_encrypt() {
    _550w_ex_head "加密备份"
    _550w_ex_bak_mkdir
    print -n "  加密密码（回车取消）: "
    local pw
    read -rs pw
    print ""
    [[ -z "$pw" ]] && return

    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    local tmp="$_550W_EX_BACKUP_DIR/.tmp_${stamp}.tar.gz"
    local dest="$_550W_EX_BACKUP_DIR/enc_${stamp}.tar.gz.enc"

    print -P "  %F{${_550W_C[dim]}}打包中...%f"
    if ! tar -czf "$tmp" -C "$HOME" ".550w" 2>/dev/null; then
        _550w_ex_msg err "打包失败"
        return
    fi

    if command -v openssl >/dev/null 2>&1; then
        if print "$pw" | openssl enc -aes-256-cbc -a -pass stdin -in "$tmp" -out "$dest" 2>/dev/null; then
            rm -f "$tmp"
            _550w_ex_msg ok "已加密备份: ${dest:t}"
        else
            mv "$tmp" "$dest"
            _550w_ex_msg wrn "openssl 加密失败，已保存未加密版本"
        fi
    else
        mv "$tmp" "${dest%.enc}"
        _550w_ex_msg wrn "无 openssl，已保存未加密版本"
    fi
}

# 4. 恢复
_550w_ex_bak_restore() {
    _550w_ex_head "从备份恢复"
    _550w_ex_bak_mkdir
    local -a files=("$_550W_EX_BACKUP_DIR"/*(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无备份"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        local sz
        sz=$(du -h "${files[$i]}" 2>/dev/null | cut -f1)
        printf '  \e[38;5;%sm[%2d]\e[0m %-40s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$i" "${files[$i]:t}" "${_550W_C[dim]}" "$sz"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return

    local src="${files[$n]}"
    print ""
    print -P "  %F{${_550W_C[warn]}}恢复会覆盖当前 .550w 目录内容%f"
    print -n "  先备份当前状态? (Y/n): "
    local pre
    read -r pre
    if [[ "$pre" != "n" && "$pre" != "N" ]]; then
        local pre_dest="$_550W_EX_BACKUP_DIR/prerestore_$(date +%Y%m%d_%H%M%S).tar.gz"
        tar -czf "$pre_dest" -C "$HOME" ".550w" 2>/dev/null
        print -P "  %F{${_550W_C[ok]}}✓ 已预备份: ${pre_dest:t}%f"
    fi

    print -n "  确认恢复? (y/N): "
    local ok
    read -r ok
    [[ "$ok" != "y" && "$ok" != "Y" ]] && return

    local tmpdir
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/550w-restore.XXXXXX") || return

    case "$src" in
        *.tar.gz|*.tgz)
            if ! tar -xzf "$src" -C "$tmpdir" 2>/dev/null; then
                _550w_ex_msg err "解包失败"
                rm -rf "$tmpdir"
                return
            fi
            ;;
        *.enc)
            print -n "  解密密码: "
            local dpw
            read -rs dpw
            print ""
            if command -v openssl >/dev/null 2>&1; then
                if ! print "$dpw" | openssl enc -d -aes-256-cbc -a -pass stdin -in "$src" 2>/dev/null | tar -xz -C "$tmpdir" 2>/dev/null; then
                    _550w_ex_msg err "解密失败"
                    rm -rf "$tmpdir"
                    return
                fi
            else
                _550w_ex_msg err "无 openssl"
                rm -rf "$tmpdir"
                return
            fi
            ;;
        *)
            if [[ -d "$src" ]]; then
                cp -r "$src"/. "$tmpdir"/ 2>/dev/null
            else
                _550w_ex_msg err "未知格式"
                rm -rf "$tmpdir"
                return
            fi
            ;;
    esac

    local restore_src="$tmpdir/.550w"
    [[ -d "$restore_src" ]] || restore_src="$tmpdir"

    local ts
    ts=$(date +%Y%m%d_%H%M%S)
    local hold="${HOME}/.550w_restored_${ts}"
    mv "$HOME/.550w" "$hold" 2>/dev/null
    cp -r "$restore_src" "$HOME/.550w" 2>/dev/null
    rm -rf "$tmpdir"

    _550w_ex_msg ok "已恢复（旧目录保留在 ${hold##*/}）"
    print -P "  %F{${_550W_C[dim]}}请执行：unset _550W_LOADED && source ~/.zshrc%f"
    sleep 2
}

# 5. 列出备份
_550w_ex_bak_list() {
    _550w_ex_head "备份列表"
    if [[ -d "$_550W_EX_BACKUP_DIR" ]]; then
        ls -lah "$_550W_EX_BACKUP_DIR" 2>/dev/null
    else
        print -P "  %F{${_550W_C[dim]}}（目录不存在）%f"
    fi
    _550w_ex_pause
}

# 6. 清理旧备份
_550w_ex_bak_clean() {
    _550w_ex_head "清理旧备份"
    local keep="$_550W_EX_BACKUP_KEEP"
    print "  保留最新 $keep 个，其余删除"
    print -n "  确认? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return

    local total
    total=$(ls -1 "$_550W_EX_BACKUP_DIR" 2>/dev/null | wc -l | tr -d ' ')
    if (( total <= keep )); then
        _550w_ex_msg inf "无需清理（$total ≤ $keep）"
        return
    fi
    local del=$(( total - keep ))
    ls -1t "$_550W_EX_BACKUP_DIR" 2>/dev/null | tail -n "$del" | \
        while IFS= read -r f; do
            rm -rf "$_550W_EX_BACKUP_DIR/$f"
        done
    _550w_ex_msg ok "已清理 $del 个"
}

# 7. 校验
_550w_ex_bak_verify() {
    _550w_ex_head "校验备份"
    local -a files=("$_550W_EX_BACKUP_DIR"/*.tar.gz(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无 tar.gz 备份"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local src="${files[$n]}"
    print -P "  %F{${_550W_C[cyan]}}验证中...%f"
    if tar -tzf "$src" >/dev/null 2>&1; then
        _550w_ex_msg ok "校验通过"
    else
        _550w_ex_msg err "文件损坏"
    fi
}

# 8. 自动备份开关
_550w_ex_bak_auto() {
    _550w_ex_head "自动备份"
    print "  当前: $_550W_BACKUP_AUTO（0=关 1=开）"
    print -n "  设为 [0/1]: "
    read -r _550W_BACKUP_AUTO
    _550w_config_save >/dev/null 2>&1
    _550w_ex_msg ok "已设为 $_550W_BACKUP_AUTO"
}

# 自动备份（登录时调用）
_550w_ex_bak_auto_run() {
    (( _550W_BACKUP_AUTO )) || return 0
    _550w_ex_bak_mkdir
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    local dest="$_550W_EX_BACKUP_DIR/auto_${stamp}.tar.gz"
    tar -czf "$dest" -C "$HOME" ".550w" 2>/dev/null
    # 保留数量控制
    local total
    total=$(ls -1 "$_550W_EX_BACKUP_DIR"/auto_*.tar.gz 2>/dev/null | wc -l | tr -d ' ')
    if (( total > _550W_EX_BACKUP_KEEP )); then
        local del=$(( total - _550W_EX_BACKUP_KEEP ))
        ls -1t "$_550W_EX_BACKUP_DIR"/auto_*.tar.gz 2>/dev/null | tail -n "$del" | \
            while IFS= read -r f; do rm -f "$f"; done
    fi
}

# ══════════════════ 7. 日志系统 ══════════════════

typeset -g _550W_EX_LOG_DIR="${HOME}/.550w/logs"
typeset -g _550W_EX_LOG_ROTATE_KB="${_550W_LOG_ROTATE_SIZE:-1024}"
typeset -g _550W_EX_LOG_KEEP="${_550W_LOG_KEEP_DAYS:-30}"

_550w_ex_menu_log() {
    while true; do
        _550w_ex_head "日志系统"
        print -P "  %F{${_550W_C[dim]}}目录 $_550W_EX_LOG_DIR%f"
        print ""
        _550w_ex_row "1"  "查看今日    今日日志"
        _550w_ex_row "2"  "列出日志    ls 目录"
        _550w_ex_row "3"  "搜索日志    关键词查找"
        _550w_ex_row "4"  "清理过期    超保留天数"
        _550w_ex_row "5"  "轮转日志    超大小切分"
        _550w_ex_row "6"  "清空全部    删除所有"
        _550w_ex_row "7"  "导出日志    打包备份"
        _550w_ex_row "8"  "记录测试    写一条测试"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_log_today ;;
            2) _550w_ex_log_list ;;
            3) _550w_ex_log_search ;;
            4) _550w_ex_log_clean ;;
            5) _550w_ex_log_rotate ;;
            6) _550w_ex_log_clear ;;
            7) _550w_ex_log_export ;;
            8) _550w_ex_log_test ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_log_mkdir() {
    [[ -d "$_550W_EX_LOG_DIR" ]] || mkdir -p "$_550W_EX_LOG_DIR"
}

_550w_ex_log_today() {
    _550w_ex_head "今日日志"
    local f="$_550W_EX_LOG_DIR/550w_$(date +%Y%m%d).log"
    if [[ -r "$f" ]]; then
        print -P "  %F{${_550W_C[dim]}}文件: $f%f"
        print ""
        tail -60 "$f" | sed 's|^|  |'
    else
        print -P "  %F{${_550W_C[dim]}}（今日无日志）%f"
    fi
    _550w_ex_pause
}

_550w_ex_log_list() {
    _550w_ex_head "日志文件"
    if [[ -d "$_550W_EX_LOG_DIR" ]]; then
        ls -lah "$_550W_EX_LOG_DIR" 2>/dev/null
    else
        print -P "  %F{${_550W_C[dim]}}（目录不存在）%f"
    fi
    _550w_ex_pause
}

_550w_ex_log_search() {
    _550w_ex_head "搜索日志"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}搜索结果：%f"
    local f found=0
    for f in "$_550W_EX_LOG_DIR"/*.log(N); do
        local cnt
        cnt=$(grep -c "$kw" "$f" 2>/dev/null)
        if (( cnt > 0 )); then
            found=1
            print "  ${f:t}: $cnt 处"
            grep -n "$kw" "$f" 2>/dev/null | head -5 | sed 's|^|    |'
        fi
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}无匹配%f"
    _550w_ex_pause
}

_550w_ex_log_clean() {
    _550w_ex_head "清理过期日志"
    print "  保留最近 $_550W_EX_LOG_KEEP 天"
    print -n "  确认? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    local n=0 f
    for f in "$_550W_EX_LOG_DIR"/*.log(N); do
        if [[ -n "$(find "$f" -mtime +$_550W_EX_LOG_KEEP 2>/dev/null)" ]]; then
            rm -f "$f" && (( n++ ))
        fi
    done
    _550w_ex_msg ok "已清理 $n 个"
}

_550w_ex_log_rotate() {
    _550w_ex_head "轮转日志"
    print "  超过 ${_550W_EX_LOG_ROTATE_KB}KB 的日志切分"
    print -n "  确认? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    local n=0 f sz
    for f in "$_550W_EX_LOG_DIR"/*.log(N); do
        sz=$(wc -c < "$f" | tr -d ' ')
        if (( sz > _550W_EX_LOG_ROTATE_KB * 1024 )); then
            local tail_file="${f}.$(date +%Y%m%d_%H%M%S)"
            tail -n 500 "$f" > "$tail_file"
            head -n -500 "$f" > "${f}.old" 2>/dev/null
            mv "${f}.old" "$f"
            (( n++ ))
        fi
    done
    _550w_ex_msg ok "已轮转 $n 个"
}

_550w_ex_log_clear() {
    _550w_ex_head "清空日志"
    print -n "  确认删除所有日志? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    rm -f "$_550W_EX_LOG_DIR"/*.log
    _550w_ex_msg ok "已清空"
}

_550w_ex_log_export() {
    _550w_ex_head "导出日志"
    [[ -d "$_550W_EX_LOG_DIR" ]] || { _550w_ex_msg err "目录不存在"; return; }
    local dest="$HOME/.550w/backups/logs_$(date +%Y%m%d_%H%M%S).tar.gz"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    if tar -czf "$dest" -C "$(dirname "$_550W_EX_LOG_DIR")" "$(basename "$_550W_EX_LOG_DIR")" 2>/dev/null; then
        _550w_ex_msg ok "已导出: ${dest:t}"
    else
        _550w_ex_msg err "导出失败"
    fi
}

_550w_ex_log_test() {
    _550w_ex_log_mkdir
    local f="$_550W_EX_LOG_DIR/550w_$(date +%Y%m%d).log"
    print "$(_550w_ts) [TEST] 日志系统测试写入" >> "$f"
    _550w_ex_msg ok "已写入: $f"
}

# 通用日志写入（供其它模块调用）
_550w_ex_log_write() {
    local level="$1"; shift
    _550w_ex_log_mkdir
    local f="$_550W_EX_LOG_DIR/550w_$(date +%Y%m%d).log"
    print "$(_550w_ts) [$level] $*" >> "$f" 2>/dev/null
}

# ══════════════════ 10. 数据导入导出 ══════════════════

_550w_ex_menu_data() {
    while true; do
        _550w_ex_head "数据导入导出"
        _550w_ex_row "1"  "导出全部    打包 .550w 配置"
        _550w_ex_row "2"  "导出配置    仅配置文件"
        _550w_ex_row "3"  "导出档案    仅用户档案"
        _550w_ex_row "4"  "导出记忆    AI 记忆文件"
        _550w_ex_row "5"  "导入配置    恢复配置文件"
        _550w_ex_row "6"  "导入档案    恢复用户档案"
        _550w_ex_row "7"  "导入记忆    恢复 AI 记忆"
        _550w_ex_row "8"  "跨设备同步  生成同步包"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_data_export_all ;;
            2) _550w_ex_data_export_config ;;
            3) _550w_ex_data_export_profile ;;
            4) _550w_ex_data_export_memory ;;
            5) _550w_ex_data_import_config ;;
            6) _550w_ex_data_import_profile ;;
            7) _550w_ex_data_import_memory ;;
            8) _550w_ex_data_sync ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_data_export_all() {
    _550w_ex_head "导出全部"
    local dest="$HOME/.550w/backups/export_all_$(date +%Y%m%d_%H%M%S).tar.gz"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    if tar -czf "$dest" -C "$HOME" ".550w" 2>/dev/null; then
        _550w_ex_msg ok "已导出: ${dest:t}"
    else
        _550w_ex_msg err "导出失败"
    fi
}

_550w_ex_data_export_config() {
    _550w_ex_head "导出配置"
    [[ -r "$_550W_CONFIG_FILE" ]] || { _550w_ex_msg err "无配置文件"; return; }
    local dest="$HOME/.550w/backups/config_$(date +%Y%m%d_%H%M%S).cfg"
    cp "$_550W_CONFIG_FILE" "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

_550w_ex_data_export_profile() {
    _550w_ex_head "导出档案"
    [[ -r "$_550W_PROFILE_FILE" ]] || { _550w_ex_msg err "无档案"; return; }
    local dest="$HOME/.550w/backups/profile_$(date +%Y%m%d_%H%M%S).cfg"
    cp "$_550W_PROFILE_FILE" "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

_550w_ex_data_export_memory() {
    _550w_ex_head "导出记忆"
    [[ -r "$_550W_MOSS_MEMORY_FILE" ]] || { _550w_ex_msg err "无记忆"; return; }
    local dest="$HOME/.550w/backups/memory_$(date +%Y%m%d_%H%M%S).jsonl"
    cp "$_550W_MOSS_MEMORY_FILE" "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

_550w_ex_data_import_config() {
    _550w_ex_head "导入配置"
    print -n "  源文件路径: "
    local src
    read -r src
    [[ -r "$src" ]] || { _550w_ex_msg err "文件不存在"; return; }
    cp "$src" "$_550W_CONFIG_FILE" && _550w_config_load
    _550w_ex_msg ok "已导入"
}

_550w_ex_data_import_profile() {
    _550w_ex_head "导入档案"
    print -n "  源文件路径: "
    local src
    read -r src
    [[ -r "$src" ]] || { _550w_ex_msg err "文件不存在"; return; }
    cp "$src" "$_550W_PROFILE_FILE" && _550w_profile_load
    _550w_ex_msg ok "已导入"
}

_550w_ex_data_import_memory() {
    _550w_ex_head "导入记忆"
    print -n "  源文件路径: "
    local src
    read -r src
    [[ -r "$src" ]] || { _550w_ex_msg err "文件不存在"; return; }
    cp "$src" "$_550W_MOSS_MEMORY_FILE" && _550w_moss_memory_load
    _550w_ex_msg ok "已导入 ${#_550W_MOSS_HISTORY[@]} 条"
}

_550w_ex_data_sync() {
    _550w_ex_head "跨设备同步包"
    local stamp
    stamp=$(date +%Y%m%d_%H%M%S)
    local dest="$HOME/.550w/backups/sync_${stamp}.tar.gz"
    local tmpdir
    tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/550w-sync.XXXXXX") || return
    local syncdir="${tmpdir}/550w_sync"
    mkdir -p "$syncdir"

    [[ -r "$_550W_CONFIG_FILE" ]]      && cp "$_550W_CONFIG_FILE" "$syncdir/"
    [[ -r "$_550W_PROFILE_FILE" ]]     && cp "$_550W_PROFILE_FILE" "$syncdir/"
    [[ -r "$_550W_MOSS_MEMORY_FILE" ]] && cp "$_550W_MOSS_MEMORY_FILE" "$syncdir/"

    tar -czf "$dest" -C "$tmpdir" "550w_sync" 2>/dev/null
    rm -rf "$tmpdir"

    if [[ -f "$dest" ]]; then
        _550w_ex_msg ok "同步包: ${dest:t}"
        print -P "  %F{${_550W_C[dim]}}传到另一台设备，用导入功能恢复%f"
        sleep 1
    else
        _550w_ex_msg err "生成失败"
    fi
}

# ══════════════════ 8. 插件系统 ══════════════════

typeset -g _550W_EX_PLUGIN_DIR="${HOME}/.550w/plugins"
typeset -g _550W_EX_PLUGIN_INDEX="${HOME}/.550w/plugin_index"
typeset -g _550W_EX_PLUGIN_TEMPLATE_DIR="${HOME}/.550w/plugins/_template"

[[ -d "$_550W_EX_PLUGIN_DIR" ]] || mkdir -p "$_550W_EX_PLUGIN_DIR"

_550w_ex_menu_plugin() {
    while true; do
        _550w_ex_head "插件系统"
        local n=0 d=0
        [[ -d "$_550W_EX_PLUGIN_DIR" ]] && {
            n=$(ls -1 "$_550W_EX_PLUGIN_DIR"/*.zsh(N) 2>/dev/null | wc -l | tr -d ' ')
            d=$(ls -1 "$_550W_EX_PLUGIN_DIR"/*.zsh.disabled(N) 2>/dev/null | wc -l | tr -d ' ')
        }
        print -P "  %F{${_550W_C[dim]}}已装 $n · 已禁用 $d · 目录 $_550W_EX_PLUGIN_DIR%f"
        print ""
        _550w_ex_row "1"  "列出插件    全部扫描"
        _550w_ex_row "2"  "加载插件    source 文件"
        _550w_ex_row "3"  "卸载插件    删除文件"
        _550w_ex_row "4"  "启用插件    .disabled → .zsh"
        _550w_ex_row "5"  "禁用插件    .zsh → .disabled"
        _550w_ex_row "6"  "重载全部    重新 source"
        _550w_ex_row "7"  "依赖检查    # requires: 注释"
        _550w_ex_row "8"  "创建模板    生成示例插件"
        _550w_ex_row "9"  "打包插件    tar.gz"
        _550w_ex_row "10" "校验签名    sha256"
        _550w_ex_row "11" "本地市场    浏览 _market/"
        _550w_ex_row "12" "从市场安装  复制到插件目录"
        _550w_ex_row "13" "查看索引    plugin_index"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-13]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_pl_list ;;
            2) _550w_ex_pl_load ;;
            3) _550w_ex_pl_unload ;;
            4) _550w_ex_pl_enable ;;
            5) _550w_ex_pl_disable ;;
            6) _550w_ex_pl_reload ;;
            7) _550w_ex_pl_deps ;;
            8) _550w_ex_pl_template ;;
            9) _550w_ex_pl_pack ;;
            10) _550w_ex_pl_sign ;;
            11) _550w_ex_pl_market ;;
            12) _550w_ex_pl_install ;;
            13) _550w_ex_pl_index ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_pl_list() {
    _550w_ex_head "插件列表"
    local found=0 f
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh(N); do
        found=1
        printf '  \e[38;5;%sm●\e[0m %-30s \e[38;5;%sm%s 字节\e[0m\n' \
            "${_550W_C[ok]}" "${f:t}" "${_550W_C[dim]}" "$(wc -c < "$f" | tr -d ' ')"
    done
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh.disabled(N); do
        found=1
        printf '  \e[38;5;%sm○\e[0m %-30s \e[38;5;%sm已禁用\e[0m\n' \
            "${_550W_C[dim]}" "${f:t}" "${_550W_C[dim]}"
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（无插件）%f"
    _550w_ex_pause
}

_550w_ex_pl_load() {
    _550w_ex_head "加载插件"
    print -n "  文件名（如 demo.zsh）: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_PLUGIN_DIR/$name"
    [[ -r "$target" ]] || { _550w_ex_msg err "文件不存在"; return; }
    if source "$target" 2>/dev/null; then
        [[ -f "$_550W_EX_PLUGIN_INDEX" ]] || : > "$_550W_EX_PLUGIN_INDEX"
        grep -q "^$name$" "$_550W_EX_PLUGIN_INDEX" 2>/dev/null || \
            print "$name" >> "$_550W_EX_PLUGIN_INDEX"
        _550w_ex_msg ok "已加载: $name"
    else
        _550w_ex_msg err "加载失败（语法错误？）"
    fi
}

_550w_ex_pl_unload() {
    _550w_ex_head "卸载插件"
    print -n "  文件名: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_PLUGIN_DIR/$name"
    [[ -e "$target" ]] || { _550w_ex_msg err "文件不存在"; return; }
    print -n "  确认删除 ${name}? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    rm -f "$target"
    [[ -f "$_550W_EX_PLUGIN_INDEX" ]] && sed -i "/^${name}$/d" "$_550W_EX_PLUGIN_INDEX"
    _550w_ex_msg ok "已删除"
}

_550w_ex_pl_enable() {
    _550w_ex_head "启用插件"
    local found=0 f i=0
    local -a files=()
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh.disabled(N); do
        found=1
        (( i++ ))
        files+=("$f")
        print "  [$i] ${f:t}"
    done
    if (( !found )); then
        _550w_ex_msg wrn "无禁用插件"
        return
    fi
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local src="${files[$n]}"
    local dst="${src%.disabled}"
    mv "$src" "$dst"
    _550w_ex_msg ok "已启用: ${dst:t}"
}

_550w_ex_pl_disable() {
    _550w_ex_head "禁用插件"
    local found=0 f i=0
    local -a files=()
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh(N); do
        found=1
        (( i++ ))
        files+=("$f")
        print "  [$i] ${f:t}"
    done
    if (( !found )); then
        _550w_ex_msg wrn "无插件"
        return
    fi
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    mv "${files[$n]}" "${files[$n]}.disabled"
    _550w_ex_msg ok "已禁用"
}

_550w_ex_pl_reload() {
    _550w_ex_head "重载全部插件"
    local n=0 f
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh(N); do
        if source "$f" 2>/dev/null; then
            (( n++ ))
        else
            print -P "  %F{${_550W_C[err]}}✗ 加载失败: ${f:t}%f"
        fi
    done
    _550w_ex_msg ok "已重载 $n 个"
}

_550w_ex_pl_deps() {
    _550w_ex_head "依赖检查"
    local found=0 f n=0 missing=0
    for f in "$_550W_EX_PLUGIN_DIR"/*.zsh(N); do
        found=1
        (( n++ ))
        local deps
        deps=$(grep -m1 '^# *requires:' "$f" 2>/dev/null | sed 's/^# *requires: *//')
        printf '  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[cyan]}" "${f:t}"
        if [[ -z "$deps" ]]; then
            print -P "    %F{${_550W_C[dim]}}（无依赖声明）%f"
            continue
        fi
        local d
        for d in ${=deps}; do
            if command -v "$d" >/dev/null 2>&1; then
                print -P "    %F{${_550W_C[ok]}}✓%f $d"
            else
                print -P "    %F{${_550W_C[err]}}✗%f $d (缺失)"
                (( missing++ ))
            fi
        done
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（无插件）%f"
    print ""
    if (( missing > 0 )); then
        print -P "  %F{${_550W_C[err]}}缺失 $missing 个依赖%f"
    else
        print -P "  %F{${_550W_C[ok]}}✓ 依赖齐全%f"
    fi
    _550w_ex_pause
}

_550w_ex_pl_template() {
    _550w_ex_head "创建插件模板"
    print -n "  插件名（无空格）: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_PLUGIN_DIR/${name}.zsh"
    [[ -e "$target" ]] && { _550w_ex_msg err "已存在"; return; }

    cat > "$target" << 'PLUGIN_EOF'
# 550W 插件示例
# requires: curl
# 说明：可选的依赖声明（用 # requires: 列命令，用空格分隔）

# 插件信息
_550w_plugin_info_xxx() {
    print "插件名：demo"
    print "版本：1.0"
    print "作者：you"
    print "说明：550W 插件示例"
}

# 注册菜单入口（可选）
# 如果插件要在主菜单加项，定义 550w-plugin-xxx 函数
550w-plugin-demo() {
    print "Hello from plugin!"
}

# 自动注册到 550W
# 若插件目录被扫描到，这些函数自动可用
print "[550W 插件] demo 已加载"
PLUGIN_EOF
    print -P "  %F{${_550W_C[ok]}}✓ 已创建: ${target:t}%f"
    print -P "  %F{${_550W_C[dim]}}编辑后再加载%f"
    sleep 2
}

_550w_ex_pl_pack() {
    _550w_ex_head "打包插件"
    print -n "  文件名: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_PLUGIN_DIR/$name"
    [[ -r "$target" ]] || { _550w_ex_msg err "文件不存在"; return; }
    local dest="$HOME/.550w/backups/plugin_${name%.zsh}_$(date +%Y%m%d_%H%M%S).tar.gz"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    if tar -czf "$dest" -C "$_550W_EX_PLUGIN_DIR" "$name" 2>/dev/null; then
        _550w_ex_msg ok "已打包: ${dest:t}"
    else
        _550w_ex_msg err "打包失败"
    fi
}

_550w_ex_pl_sign() {
    _550w_ex_head "校验签名"
    print -n "  文件名: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_PLUGIN_DIR/$name"
    [[ -r "$target" ]] || { _550w_ex_msg err "文件不存在"; return; }
    local hash
    hash=$(sha256sum "$target" | awk '{print $1}')
    print ""
    printf '  %-10s %s\n' "文件" "${target:t}"
    printf '  %-10s %s\n' "SHA256" "$hash"
    # 若存在 .sha256 文件，比对
    if [[ -r "${target}.sha256" ]]; then
        local expected
        expected=$(cat "${target}.sha256")
        if [[ "$hash" == "$expected" ]]; then
            print -P "  %F{${_550W_C[ok]}}✓ 签名匹配%f"
        else
            print -P "  %F{${_550W_C[err]}}✗ 签名不符%f"
        fi
    else
        print ""
        print "  未找到签名文件，可创建："
        print -P "  %F{${_550W_C[dim]}}echo '$hash' > ${target}.sha256%f"
    fi
    _550w_ex_pause
}

_550w_ex_pl_market() {
    _550w_ex_head "本地插件市场"
    local mdir="$_550W_EX_PLUGIN_DIR/_market"
    [[ -d "$mdir" ]] || mkdir -p "$mdir"
    print -P "  %F{${_550W_C[dim]}}目录: $mdir%f"
    print ""
    local found=0 f
    for f in "$mdir"/*.zsh(N); do
        found=1
        local sz
        sz=$(wc -c < "$f" | tr -d ' ')
        printf '  \e[38;5;%sm●\e[0m %-30s \e[38;5;%sm%s 字节\e[0m\n' \
            "${_550W_C[cyan]}" "${f:t}" "${_550W_C[dim]}" "$sz"
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（市场为空，把 .zsh 文件复制进去）%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}说明：本地市场 = _market/ 目录%f"
    print -P "  %F{${_550W_C[dim]}}把别人的插件 .zsh 拖进来即可%f"
    _550w_ex_pause
}

_550w_ex_pl_install() {
    _550w_ex_head "从市场安装"
    local mdir="$_550W_EX_PLUGIN_DIR/_market"
    local -a files=("$mdir"/*.zsh(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "市场为空"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local name
    name="${files[$n]:t}"
    cp "${files[$n]}" "$_550W_EX_PLUGIN_DIR/$name"
    _550w_ex_msg ok "已安装: $name"
}

_550w_ex_pl_index() {
    _550w_ex_head "插件索引"
    if [[ -r "$_550W_EX_PLUGIN_INDEX" ]]; then
        cat "$_550W_EX_PLUGIN_INDEX" | sed 's|^|  |'
    else
        print -P "  %F{${_550W_C[dim]}}（索引为空）%f"
    fi
    _550w_ex_pause
}

# ══════════════════ 9. 主题系统 ══════════════════

typeset -g _550W_EX_THEME_DIR="${HOME}/.550w/themes"
[[ -d "$_550W_EX_THEME_DIR" ]] || mkdir -p "$_550W_EX_THEME_DIR"

_550w_ex_menu_theme() {
    while true; do
        _550w_ex_head "主题系统"
        print -P "  %F{${_550W_C[dim]}}当前 $_550W_THEME · 目录 $_550W_EX_THEME_DIR%f"
        print ""
        _550w_ex_row "1"  "列出主题    内置+自定义"
        _550w_ex_row "2"  "切换主题    立即生效"
        _550w_ex_row "3"  "预览主题    显示配色"
        _550w_ex_row "4"  "导出主题    备份当前"
        _550w_ex_row "5"  "导入主题    从文件加载"
        _550w_ex_row "6"  "编辑主题    nano 打开"
        _550w_ex_row "7"  "创建主题    生成模板"
        _550w_ex_row "8"  "打包主题    tar.gz"
        _550w_ex_row "9"  "本地市场    浏览 _market/"
        _550w_ex_row "10" "从市场安装  复制到主题目录"
        _550w_ex_row "11" "恢复默认    切回 cyber"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-11]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_th_list ;;
            2) _550w_ex_th_switch ;;
            3) _550w_ex_th_preview ;;
            4) _550w_ex_th_export ;;
            5) _550w_ex_th_import ;;
            6) _550w_ex_th_edit ;;
            7) _550w_ex_th_create ;;
            8) _550w_ex_th_pack ;;
            9) _550w_ex_th_market ;;
            10) _550w_ex_th_install ;;
            11) _550w_ex_th_reset ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_th_builtin_list() {
    print "cyber amber ice moss crimson"
}

_550w_ex_th_list() {
    _550w_ex_head "主题列表"
    print -P "  %F{${_550W_C[cyan]}}▸ 内置主题%f"
    local t mark
    for t in cyber amber ice moss crimson; do
        mark=" "
        [[ "$t" == "$_550W_THEME" ]] && mark="*"
        printf '  %s \e[38;5;%sm%-12s\e[0m %s\n' \
            "$mark" "${_550W_C[ok]}" "$t" "$(_550w_ex_th_desc "$t")"
    done
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 自定义主题%f"
    local found=0 f
    for f in "$_550W_EX_THEME_DIR"/*.theme(N); do
        found=1
        printf '  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[cyan]}" "${f:t:r}"
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（无自定义主题）%f"
    _550w_ex_pause
}

_550w_ex_th_desc() {
    case "$1" in
        cyber)   print "经典青蓝（默认）" ;;
        amber)   print "琥珀暖色" ;;
        ice)     print "冰蓝冷色" ;;
        moss)    print "深绿" ;;
        crimson) print "猩红" ;;
        *)       print "自定义" ;;
    esac
}

_550w_ex_th_apply() {
    local t="$1"
    case "$t" in
        cyber)
            typeset -gA _550W_C=(
                cyan 51 blue 45 amber 214 orange 208 red 196
                white 231 grey 245 dim 240
                ok 46 warn 220 err 196 bright 231
            )
            ;;
        amber)
            typeset -gA _550W_C=(
                cyan 214 blue 208 amber 220 orange 208 red 196
                white 231 grey 245 dim 240
                ok 220 warn 208 err 196 bright 231
            )
            ;;
        ice)
            typeset -gA _550W_C=(
                cyan 45 blue 51 amber 117 orange 153 red 196
                white 231 grey 245 dim 240
                ok 51 warn 153 err 196 bright 231
            )
            ;;
        moss)
            typeset -gA _550W_C=(
                cyan 34 blue 28 amber 70 orange 106 red 196
                white 231 grey 245 dim 240
                ok 46 warn 106 err 196 bright 231
            )
            ;;
        crimson)
            typeset -gA _550W_C=(
                cyan 196 blue 160 amber 208 orange 202 red 196
                white 231 grey 245 dim 240
                ok 196 warn 208 err 160 bright 231
            )
            ;;
        *)
            # 自定义主题：source 文件
            local f="$_550W_EX_THEME_DIR/${t}.theme"
            [[ -r "$f" ]] && source "$f"
            ;;
    esac
    typeset -g _550W_THEME="$t"
}

_550w_ex_th_switch() {
    _550w_ex_head "切换主题"
    local -a all=(cyber amber ice moss crimson)
    local f
    for f in "$_550W_EX_THEME_DIR"/*.theme(N); do
        all+=("${f:t:r}")
    done
    local i
    for (( i=1; i<=${#all[@]}; i++ )); do
        printf '  \e[38;5;%sm[%2d]\e[0m %-12s %s\n' \
            "${_550W_C[cyan]}" "$i" "${all[$i]}" "$(_550w_ex_th_desc "${all[$i]}")"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#all[@]} )) && return
    local t="${all[$n]}"
    _550w_ex_th_apply "$t"
    _550w_config_save >/dev/null 2>&1
    _550w_build_ps1
    _550w_ex_msg ok "已切换: $t（立即生效）"
}

_550w_ex_th_preview() {
    _550w_ex_head "主题预览"
    print -P "  %F{${_550W_C[cyan]}}■ cyan (${_550W_C[cyan]})%f"
    print -P "  %F{${_550W_C[blue]}}■ blue (${_550W_C[blue]})%f"
    print -P "  %F{${_550W_C[amber]}}■ amber (${_550W_C[amber]})%f"
    print -P "  %F{${_550W_C[orange]}}■ orange (${_550W_C[orange]})%f"
    print -P "  %F{${_550W_C[red]}}■ red (${_550W_C[red]})%f"
    print -P "  %F{${_550W_C[ok]}}■ ok (${_550W_C[ok]})%f"
    print -P "  %F{${_550W_C[warn]}}■ warn (${_550W_C[warn]})%f"
    print -P "  %F{${_550W_C[err]}}■ err (${_550W_C[err]})%f"
    print -P "  %F{${_550W_C[grey]}}■ grey (${_550W_C[grey]})%f"
    print -P "  %F{${_550W_C[dim]}}■ dim (${_550W_C[dim]})%f"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B加粗亮色测试%b%f"
    _550w_ex_pause
}

_550w_ex_th_export() {
    _550w_ex_head "导出当前主题"
    local t="$_550W_THEME"
    local dest="$HOME/.550w/backups/theme_${t}_$(date +%Y%m%d_%H%M%S).theme"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    {
        print "# 550W 主题：$t"
        print "# 导出时间：$(date '+%Y-%m-%d %H:%M:%S')"
        print ""
        print "_550W_C[cyan]=${_550W_C[cyan]}"
        print "_550W_C[blue]=${_550W_C[blue]}"
        print "_550W_C[amber]=${_550W_C[amber]}"
        print "_550W_C[orange]=${_550W_C[orange]}"
        print "_550W_C[red]=${_550W_C[red]}"
        print "_550W_C[ok]=${_550W_C[ok]}"
        print "_550W_C[warn]=${_550W_C[warn]}"
        print "_550W_C[err]=${_550W_C[err]}"
        print "_550W_C[grey]=${_550W_C[grey]}"
        print "_550W_C[dim]=${_550W_C[dim]}"
        print "_550W_C[white]=${_550W_C[white]}"
        print "_550W_C[bright]=${_550W_C[bright]}"
    } > "$dest"
    _550w_ex_msg ok "已导出: ${dest:t}"
}

_550w_ex_th_import() {
    _550w_ex_head "导入主题"
    print -n "  源文件路径: "
    local src
    read -r src
    [[ -r "$src" ]] || { _550w_ex_msg err "文件不存在"; return; }
    local name
    name=$(basename "${src%.theme}")
    cp "$src" "$_550W_EX_THEME_DIR/${name}.theme"
    _550w_ex_msg ok "已导入为: ${name}"
}

_550w_ex_th_edit() {
    _550w_ex_head "编辑主题"
    local -a files=("$_550W_EX_THEME_DIR"/*.theme(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无自定义主题（内置主题不可编辑）"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    if command -v nano >/dev/null 2>&1; then
        nano "${files[$n]}"
    else
        _550w_ex_msg err "未装 nano"
    fi
}

_550w_ex_th_create() {
    _550w_ex_head "创建主题"
    print -n "  主题名（无空格）: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    local target="$_550W_EX_THEME_DIR/${name}.theme"
    [[ -e "$target" ]] && { _550w_ex_msg err "已存在"; return; }

    cat > "$target" << 'THEME_EOF'
# 550W 自定义主题
# 修改色号后切换生效

_550W_C[cyan]=51
_550W_C[blue]=45
_550W_C[amber]=214
_550W_C[orange]=208
_550W_C[red]=196
_550W_C[ok]=46
_550W_C[warn]=220
_550W_C[err]=196
_550W_C[grey]=245
_550W_C[dim]=240
_550W_C[white]=231
_550W_C[bright]=231
THEME_EOF
    _550w_ex_msg ok "已创建: ${target:t}"
    print -P "  %F{${_550W_C[dim]}}用 6 号功能编辑色号%f"
    sleep 1.5
}

_550w_ex_th_pack() {
    _550w_ex_head "打包主题"
    local -a files=("$_550W_EX_THEME_DIR"/*.theme(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "无主题可打包"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local base
    base=$(basename "${files[$n]}")
    local dest="$HOME/.550w/backups/${base%.theme}_$(date +%Y%m%d_%H%M%S).tar.gz"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    tar -czf "$dest" -C "$_550W_EX_THEME_DIR" "$base" 2>/dev/null
    _550w_ex_msg ok "已打包: ${dest:t}"
}

_550w_ex_th_market() {
    _550w_ex_head "本地主题市场"
    local mdir="$_550W_EX_THEME_DIR/_market"
    [[ -d "$mdir" ]] || mkdir -p "$mdir"
    print -P "  %F{${_550W_C[dim]}}目录: $mdir%f"
    print ""
    local found=0 f
    for f in "$mdir"/*.theme(N); do
        found=1
        printf '  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[cyan]}" "${f:t:r}"
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}（市场为空，把 .theme 拖进去）%f"
    _550w_ex_pause
}

_550w_ex_th_install() {
    _550w_ex_head "从市场安装"
    local mdir="$_550W_EX_THEME_DIR/_market"
    local -a files=("$mdir"/*.theme(N))
    if (( ${#files[@]} == 0 )); then
        _550w_ex_msg wrn "市场为空"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t:r}"
    done
    print ""
    print -n "  选择: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local name
    name="${files[$n]:t}"
    cp "${files[$n]}" "$_550W_EX_THEME_DIR/$name"
    _550w_ex_msg ok "已安装: ${name%.theme}"
}

_550w_ex_th_reset() {
    print -n "  切回默认主题 cyber? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    _550w_ex_th_apply "cyber"
    _550w_config_save >/dev/null 2>&1
    _550w_build_ps1
    _550w_ex_msg ok "已恢复 cyber"
}

# ══════════════════ 帮助/更新/关于 ══════════════════

typeset -g _550W_EX_HELP_DIR="${HOME}/.550w/extras/help"
typeset -g _550W_EX_CHANGELOG="${HOME}/.550w/extras/changelog.txt"
typeset -g _550W_EX_TERMS="${HOME}/.550w/extras/terms.txt"
typeset -g _550W_EX_FAQ="${HOME}/.550w/extras/faq.txt"

[[ -d "$_550W_EX_HELP_DIR" ]] || mkdir -p "$_550W_EX_HELP_DIR"

_550w_ex_menu_help() {
    while true; do
        _550w_ex_head "帮助与信息"
        _550w_ex_row "1"  "命令搜索    按关键词查找"
        _550w_ex_row "2"  "FAQ         常见问题"
        _550w_ex_row "3"  "术语表      550W/MOSS/SID 等"
        _550w_ex_row "4"  "变更日志    版本历史"
        _550w_ex_row "5"  "版本信息    当前版本"
        _550w_ex_row "6"  "关于        致谢与许可"
        _550w_ex_row "7"  "反馈渠道    报告问题"
        print ""
        _550w_ex_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_ex_help_search ;;
            2) _550w_ex_help_faq ;;
            3) _550w_ex_help_terms ;;
            4) _550w_ex_help_changelog ;;
            5) _550w_ex_help_version ;;
            6) _550w_ex_help_about ;;
            7) _550w_ex_help_feedback ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_ex_help_search() {
    _550w_ex_head "命令搜索"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}匹配命令：%f"
    local fn found=0
    for fn in ${(k)functions}; do
        case "$fn" in
            550w-*|_550w_*)
                if [[ "$fn" == *"$kw"* ]]; then
                    found=1
                    print "  $fn"
                fi
                ;;
        esac
    done
    (( found )) || print -P "  %F{${_550W_C[dim]}}无匹配%f"
    _550w_ex_pause
}

_550w_ex_help_faq() {
    _550w_ex_head "常见问题 FAQ"
    print -P "  %F{${_550W_C[cyan]}}%BQ1. 开机动画太长%f"
    print "  进入 550w-settings → 外观设置 → 速度改为 flash"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ2. 密码忘了%f"
    print "  默认密码 563214789"
    print "  或手动编辑：~/.550w/.550w_pass"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ3. AI 不回复%f"
    print "  1. 检查环境变量：export ZHIPU_API_KEY=xxx"
    print "  2. 测健康：550w-moss"
    print "  3. 换 provider：550w-moss-set"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ4. 想恢复默认%f"
    print "  550w-settings → 8 配置管理 → 6 恢复默认"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ5. 扩展文件不加载%f"
    print "  确认 ~/.550w/xxx.zsh 存在，且语法正确："
    print "  zsh -n ~/.550w/xxx.zsh"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ6. 主题切换不生效%f"
    print "  部分主题需重启：unset _550W_LOADED; source ~/.zshrc"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%BQ7. 清理所有配置%f"
    print "  rm -rf ~/.550w"
    print ""
    _550w_ex_pause
}

_550w_ex_help_terms() {
    _550w_ex_head "术语表"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "550W" "量子智能主机（《流浪地球》设定）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "MOSS" "550W 的 AI 核心代号"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "SID" "会话标识（MOSS-XXXX-XXXX）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Provider" "AI 服务商（glm/deepseek/openai 等）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "MOOS" "MOSS 的变体缩写（界面用）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Phase" "开机阶段（0-15）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "hold" "定格速度（不缩放）"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "provider preset" "provider 预设表"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "ctx window" "上下文保留轮数"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "rate limit" "每日调用上限"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "audit" "对话审计日志"
    _550w_ex_pause
}

_550w_ex_help_changelog() {
    _550w_ex_head "变更日志"
    print -P "  %F{${_550W_C[bright]}}%Bv1.0%b%f  $(date '+%Y-%m-%d')"
    print "    · 核心重写"
    print "    · 15 个 provider"
    print "    · 欢迎画 6 行渐变大字"
    print "    · 速度 5 级（flash/fast/normal/slow/hold）"
    print "    · 目录重构 ~/.550w/"
    print "    · 6 扩展文件（settings/new/extras/help/anim/scan）"
    print ""
    print -P "  %F{${_550W_C[dim]}}%Bv5.5.0-core%b（旧）%f"
    print "    · 初版 20 段"
    print "    · 基础动画 + 认证 + MOSS"
    print ""
    _550w_ex_pause
}

_550w_ex_help_version() {
    _550w_ex_head "版本信息"
    printf '  %-14s %s\n' "版本" "$_550W_VERSION"
    printf '  %-14s %s\n' "构建" "$_550W_BUILD_DATE"
    printf '  %-14s %s\n' "会话" "$_550W_SESSION_ID"
    printf '  %-14s %s\n' "模式" "$_550W_MODE"
    printf '  %-14s %s\n' "速度" "$_550W_SPEED"
    printf '  %-14s %s\n' "主题" "$_550W_THEME"
    local core_lines=0
    [[ -r "$HOME/.550w/core.zsh" ]] && core_lines=$(wc -l < "$HOME/.550w/core.zsh" | tr -d ' ')
    printf '  %-14s %s 行\n' "核心" "$core_lines"
    local ext_total=0 f
    for f in "$HOME/.550w"/*.zsh(N); do
        [[ "${f:t}" == "core.zsh" ]] && continue
        local n
        n=$(wc -l < "$f" 2>/dev/null | tr -d ' ')
        [[ "$n" =~ '^[0-9]+$' ]] && (( ext_total += n ))
    done
    printf '  %-14s %s 行\n' "扩展" "$ext_total"
    _550w_ex_pause
}

_550w_ex_help_about() {
    _550w_ex_head "关于"
    print -P "  %F{${_550W_C[ok]}}%B550W 超算接管系统%b%f"
    print ""
    print "  把 Termux 启动过程改造成 550W 接管动画的"
    print "  zsh 脚本系统。致敬《流浪地球》MOSS。"
    print ""
    printf '  %-10s %s\n' "版本" "$_550W_VERSION"
    printf '  %-10s %s\n' "作者" "Trans"
    printf '  %-10s %s\n' "协议" "MIT"
    printf '  %-10s %s\n' "核心" "~/.550w/core.zsh"
    printf '  %-10s %s\n' "扩展" "~/.550w/{settings,new,extras,help,anim,scan}.zsh"
    print ""
    print -P "  %F{${_550W_C[dim]}}感谢：%f"
    print "    · 流浪地球（550W / MOSS 设定来源）"
    print "    · 智谱 GLM / DeepSeek / OpenAI 等 API"
    print ""
    _550w_ex_pause
}

_550w_ex_help_feedback() {
    _550w_ex_head "反馈渠道"
    print "  遇到问题请记录："
    print "    1. 触发命令"
    print "    2. 报错信息（完整贴出）"
    print "    3. 系统信息："
    print ""
    printf '  %-14s %s\n' "版本" "$_550W_VERSION"
    printf '  %-14s %s\n' "内核" "$(uname -s -r)"
    printf '  %-14s %s\n' "shell" "$ZSH_VERSION"
    printf '  %-14s %s\n' "终端" "${TERM:-unknown}"
    printf '  %-14s %s\n' "扩展数" "$(ls -1 ~/.550w/*.zsh 2>/dev/null | wc -l | tr -d ' ')"
    print ""
    print -P "  %F{${_550W_C[dim]}}报告位置：把问题贴到 GitHub issues 或本地记录%f"
    _550w_ex_pause
}

# ══════════════════ 主菜单追加（合并 help）══════════════════

typeset -g _550W_EX_ORIG_MENU_DONE=0

# 覆盖主菜单，加 help 入口
550w-extras() {
    while true; do
        _550w_ex_head "550W 外围工具"
        print -P "  %F{${_550W_C[dim]}}辅助功能 11 组%f"
        print ""
        _550w_ex_row "1"  "快捷键说明  Ctrl 组合键"
        _550w_ex_row "2"  "别名系统    自定义命令别名"
        _550w_ex_row "3"  "会话管理    保存/恢复/切换/导出"
        _550w_ex_row "4"  "提示符设置  自定义 PS1"
        _550w_ex_row "5"  "命令统计    调用次数排行"
        _550w_ex_row "6"  "备份系统    自动/手动/加密/恢复"
        _550w_ex_row "7"  "日志系统    轮转/清理/搜索/导出"
        _550w_ex_row "8"  "插件系统    本地加载/管理"
        _550w_ex_row "9"  "主题系统    本地切换/导入"
        _550w_ex_row "10" "数据导入导出"
        _550w_ex_row "11" "帮助与信息  FAQ/术语/更新"
        print ""
        _550w_ex_row "0"  "退出"
        print ""
        print -n "  选择 [0-11]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_ex_menu_keyboard ;;
            2)  _550w_ex_menu_alias ;;
            3)  _550w_ex_menu_session ;;
            4)  _550w_ex_menu_ps1 ;;
            5)  _550w_ex_menu_stats ;;
            6)  _550w_ex_menu_backup ;;
            7)  _550w_ex_menu_log ;;
            8)  _550w_ex_menu_plugin ;;
            9)  _550w_ex_menu_theme ;;
            10) _550w_ex_menu_data ;;
            11) _550w_ex_menu_help ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 收尾：自动挂载 ══════════════════

# 统计钩子已在段 4 自动挂载，此处不重复

# 自动备份（如果开启）
if (( ${_550W_BACKUP_AUTO:-0} )); then
    _550w_ex_bak_auto_run
fi

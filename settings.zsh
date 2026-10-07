# ~/.550w/settings.zsh — 550W 设置中心 v2.0
# 13 大类 · 110 项 · 支持跳转到其它模块

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ 辅助函数 ══════════════════

# 页头：清屏 + 双线框 + 标题
_550w_set_head() {
    _550w_cls
    local title="$1"
    local sub="${2:-}"
    local w=56
    local bar="" i
    for (( i=0; i<w; i++ )); do bar+="═"; done

    print ""
    print -P "  %F{${_550W_C[cyan]}}%B╔${bar}╗%b%f"
    print -P "  %F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[bright]}}%B${title}%b%f"
    if [[ -n "$sub" ]]; then
        print -P "  %F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[dim]}}${sub}%f"
    fi
    print -P "  %F{${_550W_C[cyan]}}%B╚${bar}╝%b%f"
    print ""
}

# 菜单行：[序号] 名称（左对齐 20 宽） 描述（暗色）
# 用法：_550w_set_row "1" "外观设置" "颜色/字体/动画"
_550w_set_row() {
    local num="$1" text="$2" desc="${3:-}"
    if [[ -n "$desc" ]]; then
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%-20s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text" "${_550W_C[dim]}" "$desc"
    else
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text"
    fi
}

# 分区标题：▸ 名称 + 分隔线
_550w_set_sub() {
    local text="$1"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ ${text}%b%f"
    print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
}

# 显示当前值（在菜单上方，方便看状态）
# 用法：_550w_set_stat "速度" "$_550W_SPEED" "特效" "$_550W_FX"
_550w_set_stat() {
    local line=""
    while (( $# >= 2 )); do
        local k="$1" v="$2"
        line+="$(printf '\e[38;5;%sm%s\e[0m=\e[1m%s\e[0m  ' "${_550W_C[dim]}" "$k" "$v")"
        shift 2
    done
    print -P "  ${line}"
}

# 提示消息：ok/err/wrn/inf + 自动暂停
_550w_set_msg() {
    local type="$1"; shift
    local color prefix
    case "$type" in
        ok)  color="${_550W_C[ok]}";   prefix="✓" ;;
        err) color="${_550W_C[err]}";  prefix="✗" ;;
        wrn) color="${_550W_C[warn]}"; prefix="⚠" ;;
        inf) color="${_550W_C[cyan]}"; prefix="→" ;;
    esac
    print ""
    print -P "  %F{${color}}%B${prefix}%b%f  $*"
    sleep 1
}

# 保存配置 + 提示
_550w_set_save() {
    if _550w_config_save >/dev/null 2>&1; then
        print ""
        print -P "  %F{${_550W_C[ok]}}✓ 已保存%f"
    else
        print ""
        print -P "  %F{${_550W_C[err]}}✗ 保存失败（检查 $_550W_CONFIG_FILE 权限）%f"
    fi
    sleep 0.8
}

# 回车返回
_550w_set_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# 读取整数 + 范围校验
# 用法：_550w_set_read_int "心跳间隔" _550W_HEARTBEAT_INTERVAL 10 3600
_550w_set_read_int() {
    local prompt="$1" varname="$2" min="$3" max="$4"
    local val
    print ""
    print -P "  %F{${_550W_C[cyan]}}${prompt}%f"
    print -P "  %F{${_550W_C[dim]}}范围 ${min}~${max}（回车取消）%f"
    print -n "  > "
    read -r val
    [[ -z "$val" ]] && return 1
    if ! [[ "$val" =~ '^-?[0-9]+$' ]]; then
        _550w_set_msg err "必须为整数"
        return 1
    fi
    if (( val < min || val > max )); then
        _550w_set_msg err "超出范围 ${min}~${max}"
        return 1
    fi
    typeset -g "$varname"="$val"
    return 0
}

# 读取字符串
# 用法：_550w_set_read_str "用户名" _550W_USER_NAME
_550w_set_read_str() {
    local prompt="$1" varname="$2"
    local val
    print ""
    print -P "  %F{${_550W_C[cyan]}}${prompt}%f"
    print -n "  > "
    read -r val
    [[ -z "$val" ]] && return 1
    typeset -g "$varname"="$val"
    return 0
}

# 是/否确认
# 用法：_550w_set_confirm "确认删除?" && rm ...
_550w_set_confirm() {
    local prompt="${1:-确认}"
    print ""
    print -n "  ${prompt} (y/N): "
    local c
    read -r c
    [[ "$c" == "y" || "$c" == "Y" ]]
}

# 切换 0/1 开关
# 用法：_550w_set_toggle _550W_FX "特效"
_550w_set_toggle() {
    local varname="$1" label="$2"
    local cur="${(P)varname}"
    local next=$(( 1 - cur ))
    typeset -g "$varname"="$next"
    _550w_set_msg ok "${label}: $next"
}

# ══════════════════ 主菜单 ══════════════════

550w-settings() {
    while true; do
        _550w_set_head "550W 设置中心" "v2.0 · 13 类 · 110 项"
        _550w_set_stat "速度" "$_550W_SPEED" "特效" "$_550W_FX" "主题" "$_550W_THEME"
        _550w_set_stat "MOSS" "$_550W_MOSS_PROVIDER" "记忆" "$_550W_MOSS_MEMORY_MAX"
        print ""

        _550w_set_sub "界面外观"
        _550w_set_row "1"  "外观设置"     "速度/特效/颜色/字体/主题"
        _550w_set_row "2"  "提示符"       "PS1 显示内容自定义"
        _550w_set_row "3"  "主题管理"     "切换/创建/导入导出"

        _550w_set_sub "身份与安全"
        _550w_set_row "4"  "认证"         "密码/超时/冷却/锁定"
        _550w_set_row "5"  "用户档案"     "用户名/等级/权限/签名"

        _550w_set_sub "AI 与扩展"
        _550w_set_row "6"  "MOSS 配置"    "Provider/模型/温度/记忆"
        _550w_set_row "7"  "插件管理"     "创建/编辑/删除/重载"
        _550w_set_row "8"  "开机动画"     "加入/删除开机时播的动画"

        _550w_set_sub "数据与维护"
        _550w_set_row "9"  "备份"         "创建/恢复/清理/校验"
        _550w_set_row "10" "日志"         "查看/搜索/清理/导出"
        _550w_set_row "11" "数据导入导出" "配置/档案/记忆/同步"
        _550w_set_row "12" "高级设置"     "心跳/阈值/保留策略"

        _550w_set_sub "其它"
        _550w_set_row "13" "关于与重置"   "版本信息/恢复默认"

        print ""
        _550w_set_row "0"  "退出"
        print ""
        print -n "  选择 [0-13]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_set_menu_appear ;;
            2)  _550w_set_menu_ps1 ;;
            3)  _550w_set_menu_theme ;;
            4)  _550w_set_menu_auth ;;
            5)  _550w_set_menu_profile ;;
            6)  _550w_set_menu_moss ;;
            7)  _550w_set_menu_plugin ;;
            8)  _550w_set_menu_boot ;;
            9)  _550w_set_menu_backup ;;
            10) _550w_set_menu_log ;;
            11) _550w_set_menu_data ;;
            12) _550w_set_menu_adv ;;
            13) _550w_set_menu_about ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 外观设置 ══════════════════
# 速度/特效/蜂鸣/颜色/光标/动画模式/日志等级/主题
# 主色/强调色/背景色/字体/字号/时间/日期/边框/扫描线/状态栏

_550w_set_menu_appear() {
    while true; do
        _550w_set_head "外观设置" "18 项 · 界面显示相关"
        _550w_set_stat "速度" "$_550W_SPEED" "特效" "$_550W_FX" "主题" "$_550W_THEME"
        print ""

        _550w_set_sub "动画"
        _550w_set_row "1"  "速度级别"   "flash/fast/normal/slow/hold"
        _550w_set_row "2"  "特效开关"   "矩阵雨/扫描线等高级动画"
        _550w_set_row "3"  "动画模式"   "performance 完整 / silent 静默"

        _550w_set_sub "显示"
        _550w_set_row "4"  "颜色开关"   "0 单色 / 1 彩色"
        _550w_set_row "5"  "光标控制"   "0 不控制 / 1 控制"
        _550w_set_row "6"  "蜂鸣开关"   "0 关 / 1 开"
        _550w_set_row "7"  "扫描线"     "0 关 / 1 开（底部装饰线）"
        _550w_set_row "8"  "状态栏"     "0 关 / 1 开（底部信息条）"

        _550w_set_sub "配色"
        _550w_set_row "9"  "主题"       "cyber/amber/ice/moss/crimson"
        _550w_set_row "10" "主色调"     "主界面颜色"
        _550w_set_row "11" "强调色"     "成功/高亮颜色"
        _550w_set_row "12" "背景色"     "背景色（记录用）"

        _550w_set_sub "文字"
        _550w_set_row "13" "字体"       "记录用（Termux 决定渲染）"
        _550w_set_row "14" "字号"       "记录用"
        _550w_set_row "15" "时间格式"   "12h / 24h"
        _550w_set_row "16" "日期格式"   "Y-m-d / d-m-Y"
        _550w_set_row "17" "边框风格"   "single / double / rounded"
        _550w_set_row "18" "日志等级"   "1 error / 2 warn / 3 info / 4 debug"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-18]: "
        local c
        read -r c
        case "$c" in
            1)
                print ""
                print -P "  %F{${_550W_C[cyan]}}可选速度%f"
                print "    flash   30%  极快（闪现类）"
                print "    fast    60%  快"
                print "    normal 100%  标准"
                print "    slow   180%  慢"
                print "    hold     0%  定格（不缩放）"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    flash|fast|normal|slow|hold)
                        _550W_SPEED="$v"
                        _550w_set_save
                        ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            2) _550w_set_toggle _550W_FX "特效"; _550w_set_save ;;
            3)
                print ""
                print "  performance  完整动画"
                print "  silent       静默（无动画）"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    performance|silent)
                        _550W_MODE_ANIM="$v"
                        _550w_set_save
                        ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            4) _550w_set_toggle _550W_COLORS "颜色"; _550w_set_save ;;
            5) _550w_set_toggle _550W_CURSOR_CTL "光标控制"; _550w_set_save ;;
            6) _550w_set_toggle _550W_BEEP "蜂鸣"; _550w_set_save ;;
            7) _550w_set_toggle _550W_SCANLINE "扫描线"; _550w_set_save ;;
            8) _550w_set_toggle _550W_STATUSBAR "状态栏"; _550w_set_save ;;
            9)
                _550w_set_menu_theme
                ;;
            10|11|12)
                local label
                case "$c" in
                    10) label="主色调" ;;
                    11) label="强调色" ;;
                    12) label="背景色" ;;
                esac
                _550w_set_color_pick "$label"
                ;;
            13)
                print ""
                print "  例: monospace / FiraCode / JetBrains Mono"
                print -n "  > "
                local v
                read -r v
                [[ -z "$v" ]] && continue
                _550W_FONT="$v"
                _550w_set_save
                ;;
            14)
                if _550w_set_read_int "字号（8~72）" _550W_FONT_SIZE 8 72; then
                    _550w_set_save
                fi
                ;;
            15)
                print ""
                print "  12h  上午/下午格式"
                print "  24h  24 小时格式"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    12h|24h) _550W_TIME_FORMAT="$v"; _550w_set_save ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            16)
                print ""
                print "  Y-m-d  2026-10-07"
                print "  d-m-Y  07-10-2026"
                print "  m-d-Y  10-07-2026"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    Y-m-d|d-m-Y|m-d-Y) _550W_DATE_FORMAT="$v"; _550w_set_save ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            17)
                print ""
                print "  single   单线 ┌─┐"
                print "  double   双线 ╔═╗"
                print "  rounded  圆角 ╭─╮"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    single|double|rounded) _550W_BORDER_STYLE="$v"; _550w_set_save ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            18)
                _550w_set_read_int "日志等级（1~4）" _550W_LOG_LEVEL 1 4 \
                    && _550w_set_save
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# 颜色选择器
_550w_set_color_pick() {
    local label="$1"
    local varname
    case "$label" in
        主色调) varname="_550W_COLOR_PRIMARY" ;;
        强调色) varname="_550W_COLOR_ACCENT" ;;
        背景色) varname="_550W_COLOR_BG" ;;
        *) varname="_550W_COLOR_PRIMARY" ;;
    esac
    _550w_set_head "选择$label"
    print "  当前: ${(P)varname}"
    print ""

    # 预设色板（名称|色号）
    local -a palette=(
        "cyan|51"    "blue|45"   "green|46"  "amber|214"
        "orange|208" "red|196"   "pink|205"  "purple|135"
        "white|231"  "grey|245"  "black|232" "yellow|220"
    )
    local i
    for (( i=1; i<=${#palette[@]}; i++ )); do
        local name="${palette[$i]%%|*}"
        local code="${palette[$i]#*|}"
        printf '  \e[38;5;%sm[%2d]\e[0m \e[38;5;%sm%-8s\e[0m code=%s\n' \
            "${_550W_C[cyan]}" "$i" "$code" "$name" "$code"
    done
    print ""
    print -n "  选择 [1-${#palette[@]}] 或输入色号（0 取消）: "
    local c
    read -r c
    [[ -z "$c" || "$c" == "0" ]] && return

    local chosen=""
    if [[ "$c" =~ '^[0-9]+$' ]] && (( c >= 1 && c <= ${#palette[@]} )); then
        chosen="${palette[$c]%%|*}"
    elif [[ "$c" =~ '^[0-9]+$' ]] && (( c >= 0 && c <= 255 )); then
        chosen="$c"
    else
        _550w_set_msg err "无效输入"
        return
    fi

    typeset -g "$varname"="$chosen"
    _550w_set_msg ok "$label 已设为: $chosen"
    _550w_set_save
}

# ══════════════════ 2. 提示符设置 ══════════════════
# 样式/显示 SID/显示模式/显示 MOSS/显示时间/应用/预览/恢复默认

_550w_set_menu_ps1() {
    while true; do
        _550w_set_head "提示符设置" "8 项 · PS1 自定义"
        print -P "  %F{${_550W_C[dim]}}当前:%f $PS1"
        print ""
        _550w_set_stat "样式" "${_550W_PS1_MODE:-full}" "SID" "${_550W_PS1_SHOW_SID:-1}" "MOSS" "${_550W_PS1_SHOW_MOSS:-1}"
        print ""

        _550w_set_sub "样式"
        _550w_set_row "1"  "样式模式"   "full/minimal/plain"

        _550w_set_sub "显示开关"
        _550w_set_row "2"  "显示 SID"   "会话 ID（MOSS-XXXX-XXXX）"
        _550w_set_row "3"  "显示模式"   "capture/normal/locked"
        _550w_set_row "4"  "显示 MOSS"  "健康圆点 ●/◐/○"
        _550w_set_row "5"  "显示时间"   "HH:MM:SS"

        _550w_set_sub "操作"
        _550w_set_row "6"  "应用"       "立即生效（不用重启）"
        _550w_set_row "7"  "预览"       "看效果"
        _550w_set_row "8"  "恢复默认"   "完整样式"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1)
                print ""
                print "  full     完整（SID+模式+MOSS+时间）"
                print "  minimal  简洁（仅时间）"
                print "  plain    纯文本（无颜色）"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    full|minimal|plain)
                        typeset -g _550W_PS1_MODE="$v"
                        _550w_build_ps1
                        _550w_set_save
                        ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            2) _550w_set_toggle _550W_PS1_SHOW_SID "显示 SID"; _550w_build_ps1; _550w_set_save ;;
            3) _550w_set_toggle _550W_PS1_SHOW_MODE "显示模式"; _550w_build_ps1; _550w_set_save ;;
            4) _550w_set_toggle _550W_PS1_SHOW_MOSS "显示 MOSS"; _550w_build_ps1; _550w_set_save ;;
            5) _550w_set_toggle _550W_PS1_SHOW_TIME "显示时间"; _550w_build_ps1; _550w_set_save ;;
            6)
                _550w_build_ps1
                _550w_set_msg ok "已应用"
                ;;
            7)
                print ""
                print -P "  %F{${_550W_C[dim]}}预览：%f"
                print -P "  %F{${_550W_C[ok]}}%B550W_computer_Earth Engine%b%f %F{${_550W_C[ok]}}●%f %F{${_550W_C[dim]}}19:30:00%f %F{${_550W_C[ok]}}root@Max-System:~#%f "
                _550w_set_pause
                ;;
            8)
                typeset -g _550W_PS1_MODE="full"
                typeset -g _550W_PS1_SHOW_SID=1
                typeset -g _550W_PS1_SHOW_MODE=1
                typeset -g _550W_PS1_SHOW_MOSS=1
                typeset -g _550W_PS1_SHOW_TIME=1
                _550w_build_ps1
                _550w_set_save
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 3. 主题管理 ══════════════════
# 5 内置 + 创建/编辑/导入/导出/预览

_550w_set_menu_theme() {
    while true; do
        _550w_set_head "主题管理" "8 项 · 配色方案"
        _550w_set_stat "当前" "$_550W_THEME"
        print ""
        _550w_set_sub "内置主题"
        _550w_set_row "1"  "cyber"     "经典青蓝（默认）"
        _550w_set_row "2"  "amber"     "琥珀暖色"
        _550w_set_row "3"  "ice"       "冰蓝冷色"
        _550w_set_row "4"  "moss"      "深绿"
        _550w_set_row "5"  "crimson"   "猩红"

        _550w_set_sub "自定义"
        _550w_set_row "6"  "创建主题"  "生成 .theme 模板"
        _550w_set_row "7"  "编辑主题"  "nano 打开"
        _550w_set_row "8"  "预览配色"  "色板预览"

        _550w_set_sub "文件"
        _550w_set_row "9"  "导出当前"  "备份当前配色"
        _550w_set_row "10" "导入主题"  "从文件加载"
        _550w_set_row "11" "列表"      "所有可用主题"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-11]: "
        local c
        read -r c
        case "$c" in
            1|2|3|4|5)
                local -a themes=(cyber amber ice moss crimson)
                local name="${themes[$c]}"
                typeset -g _550W_THEME="$name"
                _550w_set_msg ok "已切换: $name（下次启动生效）"
                _550w_set_save
                ;;
            6)
                print -n "  主题名（无空格）: "
                local name
                read -r name
                [[ -z "$name" ]] && continue
                local target="$HOME/.550w/themes/${name}.theme"
                [[ -d "$(dirname "$target")" ]] || mkdir -p "$(dirname "$target")"
                if [[ -e "$target" ]]; then
                    _550w_set_msg wrn "已存在: $name"
                    continue
                fi
                cat > "$target" << 'THEME_EOF'
# 550W 主题
_550W_C[cyan]=51
_550W_C[blue]=45
_550W_C[amber]=214
_550W_C[orange]=208
_550W_C[red]=196
_550W_C[ok]=46
_550w_C[warn]=220
_550W_C[err]=196
_550W_C[grey]=245
_550W_C[dim]=240
_550W_C[white]=231
_550W_C[bright]=231
THEME_EOF
                _550w_set_msg ok "已创建: ${name}.theme"
                ;;
            7)
                local -a files=("$HOME/.550w/themes"/*.theme(N))
                if (( ${#files[@]} == 0 )); then
                    _550w_set_msg wrn "无自定义主题"
                    continue
                fi
                print ""
                local i
                for (( i=1; i<=${#files[@]}; i++ )); do
                    printf '  [%d] %s\n' "$i" "${files[$i]:t:r}"
                done
                print -n "  选择: "
                local n
                read -r n
                [[ "$n" =~ '^[0-9]+$' ]] || continue
                (( n < 1 || n > ${#files[@]} )) && continue
                if command -v nano >/dev/null 2>&1; then
                    nano "${files[$n]}"
                else
                    _550w_set_msg err "未装 nano"
                fi
                ;;
            8)
                _550w_set_head "色板预览"
                printf '  \e[38;5;%sm■ cyan (51)\e[0m\n' "${_550W_C[cyan]}"
                printf '  \e[38;5;%sm■ blue (45)\e[0m\n' "${_550W_C[blue]}"
                printf '  \e[38;5;%sm■ amber (214)\e[0m\n' "${_550W_C[amber]}"
                printf '  \e[38;5;%sm■ orange (208)\e[0m\n' "${_550W_C[orange]}"
                printf '  \e[38;5;%sm■ red (196)\e[0m\n' "${_550W_C[red]}"
                printf '  \e[38;5;%sm■ ok (46)\e[0m\n' "${_550W_C[ok]}"
                printf '  \e[38;5;%sm■ warn (220)\e[0m\n' "${_550W_C[warn]}"
                printf '  \e[38;5;%sm■ err (196)\e[0m\n' "${_550W_C[err]}"
                _550w_set_pause
                ;;
            9)
                local dest="$HOME/.550w/backups/theme_${_550W_THEME}_$(date +%Y%m%d_%H%M%S).theme"
                [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
                {
                    print "# 550W 主题导出：$_550W_THEME"
                    print "# 时间：$(date '+%Y-%m-%d %H:%M:%S')"
                    local k
                    for k in cyan blue amber orange red ok warn err grey dim white bright; do
                        print "_550W_C[$k]=${_550W_C[$k]}"
                    done
                } > "$dest"
                _550w_set_msg ok "已导出: ${dest:t}"
                ;;
            10)
                print -n "  主题文件路径: "
                local src
                read -r src
                [[ -r "$src" ]] || { _550w_set_msg err "文件不存在"; continue; }
                local name="${${src:t}%.theme}"
                cp "$src" "$HOME/.550w/themes/${name}.theme"
                _550w_set_msg ok "已导入: $name"
                ;;
            11)
                _550w_set_head "所有主题"
                print -P "  %F{${_550W_C[cyan]}}▸ 内置%f"
                local t
                for t in cyber amber ice moss crimson; do
                    local mark=" "; [[ "$t" == "$_550W_THEME" ]] && mark="*"
                    print "  $mark $t"
                done
                print ""
                print -P "  %F{${_550W_C[cyan]}}▸ 自定义%f"
                local found=0 f
                for f in "$HOME/.550w/themes"/*.theme(N); do
                    found=1
                    print "    ${f:t:r}"
                done
                (( found )) || print -P "  %F{${_550W_C[dim]}}（无）%f"
                _550w_set_pause
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 4. 认证设置 ══════════════════
# 改密码/重置/最小长度/最大尝试/输入超时/冷却次数/冷却秒数/空闲锁定/掩码长度

_550w_set_menu_auth() {
    while true; do
        _550w_set_head "认证设置" "9 项 · 密码与安全"
        _550w_set_stat "尝试" "$_550W_MAX_ATTEMPTS" "超时" "$_550W_READ_TIMEOUT" "锁定" "$_550W_IDLE_LOCKOUT"
        print ""

        _550w_set_sub "密码"
        _550w_set_row "1"  "修改密码"     "输入两次确认"
        _550w_set_row "2"  "重置为默认"   "563214789"
        _550w_set_row "3"  "最小长度"     "密码最少位数"
        _550w_set_row "4"  "掩码长度"     "显示多少个 ●"

        _550w_set_sub "失败保护"
        _550w_set_row "5"  "最大尝试"     "几次失败后锁定"
        _550w_set_row "6"  "冷却次数"     "几次失败触发冷却"
        _550w_set_row "7"  "冷却秒数"     "冷却时长"

        _550w_set_sub "会话"
        _550w_set_row "8"  "输入超时"     "等待输入多少秒"
        _550w_set_row "9"  "空闲锁定"     "无操作多少秒锁定"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-9]: "
        local c
        read -r c
        case "$c" in
            1) _550w_set_change_pass ;;
            2) _550w_set_reset_pass ;;
            3)
                if _550w_set_read_int "最小长度（4~32）" _550W_PASS_MIN_LEN 4 32; then
                    _550w_set_save
                fi
                ;;
            4)
                if _550w_set_read_int "掩码长度（4~32）" _550W_PW_MASK_MAX 4 32; then
                    _550w_set_save
                fi
                ;;
            5)
                if _550w_set_read_int "最大尝试（1~10）" _550W_MAX_ATTEMPTS 1 10; then
                    _550w_set_save
                fi
                ;;
            6)
                if _550w_set_read_int "冷却触发次数（1~20）" _550W_COOLDOWN_ATTEMPTS 1 20; then
                    _550w_set_save
                fi
                ;;
            7)
                if _550w_set_read_int "冷却秒数（10~3600）" _550W_COOLDOWN_SECONDS 10 3600; then
                    _550w_set_save
                fi
                ;;
            8)
                if _550w_set_read_int "输入超时（5~300）" _550W_READ_TIMEOUT 5 300; then
                    _550w_set_save
                fi
                ;;
            9)
                if _550w_set_read_int "空闲锁定（60~86400）" _550W_IDLE_LOCKOUT 60 86400; then
                    _550w_set_save
                fi
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_set_change_pass() {
    _550w_set_head "修改密码"
    local min_len="${_550W_PASS_MIN_LEN:-4}"
    print -P "  %F{${_550W_C[dim]}}最小长度: $min_len 位%f"
    print ""

    local p1 p2
    print -n "  新密码（回车取消）: "
    read -rs p1
    print ""
    [[ -z "$p1" ]] && return

    if (( ${#p1} < min_len )); then
        _550w_set_msg err "长度不足 $min_len 位"
        return
    fi

    print -n "  确认新密码: "
    read -rs p2
    print ""

    if [[ "$p1" != "$p2" ]]; then
        _550w_set_msg err "两次输入不一致"
        return
    fi

    print "$p1" > "$_550W_PASS_FILE"
    chmod 600 "$_550W_PASS_FILE"
    _550W_PASS="$p1"
    _550w_set_msg ok "密码已更新"
}

_550w_set_reset_pass() {
    _550w_set_head "重置密码"
    print -P "  %F{${_550W_C[warn]}}重置后密码变为默认值: 563214789%f"
    if ! _550w_set_confirm "确认重置"; then
        return
    fi
    print "563214789" > "$_550W_PASS_FILE"
    chmod 600 "$_550W_PASS_FILE"
    _550W_PASS="563214789"
    _550w_set_msg ok "已重置为默认"
}

# ══════════════════ 5. 用户档案 ══════════════════
# 用户名/等级/权限/签名/头像/加入时间/登录次数/查看/导出/重置

_550w_set_menu_profile() {
    while true; do
        _550w_set_head "用户档案" "10 项 · 欢迎画显示的信息"
        _550w_set_stat "用户名" "$_550W_USER_NAME" "等级" "$_550W_USER_LEVEL"
        print ""

        _550w_set_sub "基本信息"
        _550w_set_row "1"  "用户名"     "$_550W_USER_NAME"
        _550w_set_row "2"  "等级"       "$_550W_USER_LEVEL"
        _550w_set_row "3"  "权限"       "$_550W_USER_ROLE"
        _550w_set_row "4"  "签名"       "$_550W_USER_MOTTO"
        _550w_set_row "5"  "头像符号"   "${_550W_USER_AVATAR:-(空)}"

        _550w_set_sub "统计"
        _550w_set_row "6"  "加入时间"   "$_550W_USER_JOINED"
        _550w_set_row "7"  "登录次数"   "$_550W_USER_LOGINS"
        _550w_set_row "8"  "上次登录"   "${_550W_USER_LASTLOGIN:-(无)}"

        _550w_set_sub "操作"
        _550w_set_row "9"  "完整查看"   "所有字段一览"
        _550w_set_row "10" "导出档案"   "备份到文件"
        _550w_set_row "11" "恢复默认"   "重置所有字段"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-11]: "
        local c
        read -r c
        case "$c" in
            1)
                _550w_set_read_str "新用户名" _550W_USER_NAME \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            2)
                _550w_set_read_str "新等级" _550W_USER_LEVEL \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            3)
                _550w_set_read_str "新权限" _550W_USER_ROLE \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            4)
                _550w_set_read_str "新签名" _550W_USER_MOTTO \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            5)
                print ""
                print "  1 个字符，比如 ★ ⚡ ◆ ✦"
                _550w_set_read_str "头像符号" _550W_USER_AVATAR \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            6)
                _550w_set_read_str "加入时间（YYYY-MM-DD）" _550W_USER_JOINED \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            7)
                _550w_set_read_int "登录次数" _550W_USER_LOGINS 0 999999 \
                    && _550w_profile_save >/dev/null 2>&1 \
                    && _550w_set_msg ok "已更新"
                ;;
            8)
                print ""
                print -P "  %F{${_550W_C[dim]}}上次登录由系统自动记录，不可手动修改%f"
                _550w_set_pause
                ;;
            9)
                _550w_set_head "完整档案"
                printf '  %-14s %s\n' "用户名"   "$_550W_USER_NAME"
                printf '  %-14s %s\n' "等级"     "$_550W_USER_LEVEL"
                printf '  %-14s %s\n' "权限"     "$_550W_USER_ROLE"
                printf '  %-14s %s\n' "签名"     "$_550W_USER_MOTTO"
                printf '  %-14s %s\n' "头像"     "${_550W_USER_AVATAR:-(空)}"
                printf '  %-14s %s\n' "加入时间" "$_550W_USER_JOINED"
                printf '  %-14s %s\n' "登录次数" "$_550W_USER_LOGINS"
                printf '  %-14s %s\n' "上次登录" "${_550W_USER_LASTLOGIN:-(无)}"
                printf '  %-14s %s\n' "档案文件" "$_550W_PROFILE_FILE"
                _550w_set_pause
                ;;
            10)
                local dest="$HOME/.550w/backups/profile_$(date +%Y%m%d_%H%M%S).cfg"
                [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
                if cp "$_550W_PROFILE_FILE" "$dest" 2>/dev/null; then
                    _550w_set_msg ok "已导出: ${dest:t}"
                else
                    _550w_set_msg err "导出失败"
                fi
                ;;
            11)
                if _550w_set_confirm "恢复默认档案"; then
                    _550w_profile_reset
                    _550w_set_msg ok "已恢复默认"
                fi
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 6. MOSS 配置 ══════════════════
# 启用/Provider/模型/模式/温度/MaxTokens/上下文/记忆上限
# 速率/超时/审计/API Key/健康检查

_550w_set_menu_moss() {
    while true; do
        _550w_set_head "MOSS 配置" "13 项 · AI 引擎"
        _550w_set_stat "启用" "$_550W_MOSS_ENABLED" "Provider" "$_550W_MOSS_PROVIDER" "模式" "$_550W_MOSS_MODE"
        print ""

        _550w_set_sub "基础"
        _550w_set_row "1"  "启用开关"     "0 关 / 1 开"
        _550w_set_row "2"  "Provider"     "15 个可选"
        _550w_set_row "3"  "模型名"       "$_550W_MOSS_MODEL"
        _550w_set_row "4"  "模式"         "cloud/local/auto"

        _550w_set_sub "生成参数"
        _550w_set_row "5"  "温度"         "$_550W_MOSS_TEMPERATURE（0.0~2.0）"
        _550w_set_row "6"  "MaxTokens"    "$_550W_MOSS_MAX_TOKENS"
        _550w_set_row "7"  "上下文窗口"   "$_550W_MOSS_CTX_WINDOW 轮"

        _550w_set_sub "记忆与限制"
        _550w_set_row "8"  "记忆上限"     "$_550W_MOSS_MEMORY_MAX 条"
        _550w_set_row "9"  "速率限制"     "$_550W_MOSS_RATELIMIT_DAILY/天"

        _550w_set_sub "网络与安全"
        _550w_set_row "10" "请求超时"     "$_550W_MOSS_TIMEOUT s"
        _550w_set_row "11" "审计开关"     "0 关 / 1 开"
        _550w_set_row "12" "API Key"      "查看配置状态"
        _550w_set_row "13" "健康检查"     "立即检测 MOSS"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-13]: "
        local c
        read -r c
        case "$c" in
            1) _550w_set_toggle _550W_MOSS_ENABLED "MOSS 启用"; _550w_set_save ;;
            2) 550w-moss-set ;;
            3)
                _550w_set_read_str "新模型名" _550W_MOSS_MODEL \
                    && _550w_set_save
                ;;
            4)
                print ""
                print "  cloud  云端 API"
                print "  local  本地 Ollama"
                print "  auto   云端不通时自动切本地"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    cloud|local|auto)
                        _550W_MOSS_MODE="$v"
                        _550w_set_save
                        ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            5)
                print ""
                print -P "  %F{${_550W_C[dim]}}0.0 严谨 / 0.7 默认 / 1.0 平衡 / 1.5 发散%f"
                print -n "  > "
                local v
                read -r v
                [[ -z "$v" ]] && continue
                if [[ "$v" =~ '^[0-2](\.[0-9]+)?$' ]]; then
                    _550W_MOSS_TEMPERATURE="$v"
                    _550w_set_save
                else
                    _550w_set_msg err "范围 0.0~2.0"
                fi
                ;;
            6)
                if _550w_set_read_int "MaxTokens（128~32000）" _550W_MOSS_MAX_TOKENS 128 32000; then
                    _550w_set_save
                fi
                ;;
            7)
                if _550w_set_read_int "上下文轮数（1~50）" _550W_MOSS_CTX_WINDOW 1 50; then
                    _550w_set_save
                fi
                ;;
            8)
                if _550w_set_read_int "记忆上限（4~500）" _550W_MOSS_MEMORY_MAX 4 500; then
                    _550w_set_save
                fi
                ;;
            9)
                if _550w_set_read_int "每日上限（10~99999）" _550W_MOSS_RATELIMIT_DAILY 10 99999; then
                    _550w_set_save
                fi
                ;;
            10)
                if _550w_set_read_int "请求超时（5~300）" _550W_MOSS_TIMEOUT 5 300; then
                    _550w_set_save
                fi
                ;;
            11) _550w_set_toggle _550W_MOSS_AUDIT_ENABLED "审计"; _550w_set_save ;;
            12)
                _550w_set_head "API Key 状态"
                printf '  %-14s %s\n' "Provider" "$_550W_MOSS_PROVIDER"
                printf '  %-14s %s\n' "环境变量" "$(_550w_moss_envvar_of "$_550W_MOSS_PROVIDER" 2>/dev/null || echo '(N/A)')"
                if [[ -n "$_550W_MOSS_TOKEN" ]]; then
                    printf '  %-14s %s\n' "状态" "✓ 已配置"
                    printf '  %-14s %s\n' "长度" "${#_550W_MOSS_TOKEN} 字符"
                else
                    printf '  %-14s %s\n' "状态" "✗ 未配置"
                fi
                print ""
                print -P "  %F{${_550W_C[dim]}}设置：在 ~/.zshrc 里 export 对应环境变量%f"
                _550w_set_pause
                ;;
            13)
                _550w_set_head "健康检查"
                print "  检测中..."
                _550w_moss_health
                print ""
                printf '  %-14s %s\n' "状态" "$_550W_MOSS_HEALTH"
                printf '  %-14s %s\n' "端点" "$_550W_MOSS_CLOUD_URL"
                printf '  %-14s %s\n' "模型" "$_550W_MOSS_MODEL"
                _550w_set_pause
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 7. 插件管理 ══════════════════
# 跳转到 core.zsh 里的 550w-plugin-* 命令

_550w_set_menu_plugin() {
    while true; do
        _550w_set_head "插件管理" "7 项 · 扩展功能"
        local n=0
        [[ -d "$HOME/.550w/扩展" ]] && \
            n=$(ls -d "$HOME/.550w/扩展"/*/ 2>/dev/null | wc -l | tr -d ' ')
        _550w_set_stat "已装" "$n 个"
        print ""

        _550w_set_row "1"  "列出插件"     "查看所有已装插件"
        _550w_set_row "2"  "创建插件"     "生成新的插件骨架"
        _550w_set_row "3"  "查看信息"     "元信息/文件/函数/依赖"
        _550w_set_row "4"  "编辑插件"     "nano 打开 main.zsh"
        _550w_set_row "5"  "重载插件"     "重新 source 单个/全部"
        _550w_set_row "6"  "打开目录"     "ls 插件目录"
        _550w_set_row "7"  "删除插件"     "移除整个插件文件夹"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) 550w-plugins ;;
            2)
                print -n "  插件名（小写字母/短横线）: "
                local name
                read -r name
                [[ -n "$name" ]] && 550w-plugin-new "$name"
                _550w_set_pause
                ;;
            3)
                print -n "  插件名: "
                local name
                read -r name
                [[ -n "$name" ]] && 550w-plugin-info "$name"
                ;;
            4)
                print -n "  插件名: "
                local name
                read -r name
                [[ -n "$name" ]] && 550w-plugin-edit "$name"
                ;;
            5)
                print -n "  插件名（回车重载全部）: "
                local name
                read -r name
                550w-plugin-reload "$name"
                _550w_set_pause
                ;;
            6)
                print -n "  插件名: "
                local name
                read -r name
                [[ -n "$name" ]] && 550w-plugin-open "$name"
                ;;
            7)
                print -n "  插件名: "
                local name
                read -r name
                [[ -n "$name" ]] && 550w-plugin-remove "$name"
                _550w_set_pause
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 8. 开机动画 ══════════════════
# 跳转到 anim.zsh 的 _550w_anim_menu_boot

_550w_set_menu_boot() {
    while true; do
        _550w_set_head "开机动画" "4 项 · 开机时播的动画"
        local n=0
        [[ -d "$HOME/.550w/boot_anim" ]] && \
            n=$(ls -1 "$HOME/.550w/boot_anim"/*.zsh(N) 2>/dev/null | wc -l | tr -d ' ')
        _550w_set_stat "已加" "$n 个"
        print ""

        _550w_set_row "1"  "加入动画"   "从 62 个预设里选"
        _550w_set_row "2"  "删除动画"   "从开机列表删一个"
        _550w_set_row "3"  "查看列表"   "当前所有开机动画"
        _550w_set_row "4"  "清空全部"   "删除所有开机动画"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-4]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_boot_add ;;
            2) _550w_anim_boot_del ;;
            3) _550w_anim_boot_list ;;
            4) _550w_anim_boot_clear ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 9. 备份 ══════════════════
# 跳转到 extras.zsh 的备份函数

_550w_set_menu_backup() {
    while true; do
        _550w_set_head "备份管理" "8 项 · 数据保护"
        local n=0
        [[ -d "$HOME/.550w/backups" ]] && \
            n=$(ls -1 "$HOME/.550w/backups" 2>/dev/null | wc -l | tr -d ' ')
        _550w_set_stat "备份数" "$n 个" "保留" "${_550W_BACKUP_KEEP:-10}"
        print ""

        _550w_set_sub "创建"
        _550w_set_row "1"  "立即备份"     "tar.gz 压缩打包"
        _550w_set_row "2"  "不压缩备份"   "cp -r 复制目录"
        _550w_set_row "3"  "加密备份"     "密码保护"

        _550w_set_sub "恢复"
        _550w_set_row "4"  "从备份恢复"   "选择文件覆盖"

        _550w_set_sub "管理"
        _550w_set_row "5"  "列出备份"     "ls 备份目录"
        _550w_set_row "6"  "清理旧备份"   "超保留数删除"
        _550w_set_row "7"  "校验备份"     "tar 完整性检查"
        _550w_set_row "8"  "自动备份"     "开机时自动（当前 ${_550W_BACKUP_AUTO:-0}）"

        print ""
        _550w_set_row "0"  "返回"
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

# ══════════════════ 10. 日志 ══════════════════
# 跳转到 extras.zsh 的日志函数

_550w_set_menu_log() {
    while true; do
        _550w_set_head "日志管理" "7 项 · 日志查看与维护"
        local n=0
        [[ -d "$HOME/.550w/logs" ]] && \
            n=$(ls -1 "$HOME/.550w/logs"/*.log(N) 2>/dev/null | wc -l | tr -d ' ')
        _550w_set_stat "日志数" "$n 个" "等级" "$_550W_LOG_LEVEL"
        print ""

        _550w_set_sub "查看"
        _550w_set_row "1"  "查看今日"     "今天的日志"
        _550w_set_row "2"  "列出文件"     "所有日志文件"
        _550w_set_row "3"  "搜索日志"     "按关键词查找"

        _550w_set_sub "维护"
        _550w_set_row "4"  "清理过期"     "超过保留天数"
        _550w_set_row "5"  "轮转日志"     "超过大小切分"
        _550w_set_row "6"  "清空全部"     "删除所有日志"

        _550w_set_sub "导出"
        _550w_set_row "7"  "导出日志"     "打包到 backups/"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
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
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 11. 数据导入导出 ══════════════════
# 跳转到 extras.zsh 的 data 函数

_550w_set_menu_data() {
    while true; do
        _550w_set_head "数据导入导出" "8 项 · 迁移与备份"
        print ""

        _550w_set_sub "导出"
        _550w_set_row "1"  "导出全部"   "打包 .550w 目录"
        _550w_set_row "2"  "导出配置"   "仅 .550w_config"
        _550w_set_row "3"  "导出档案"   "仅 .550w_profile"
        _550w_set_row "4"  "导出记忆"   "仅 AI 记忆文件"

        _550w_set_sub "导入"
        _550w_set_row "5"  "导入配置"   "恢复 .550w_config"
        _550w_set_row "6"  "导入档案"   "恢复 .550w_profile"
        _550w_set_row "7"  "导入记忆"   "恢复 AI 记忆"

        _550w_set_sub "同步"
        _550w_set_row "8"  "跨设备同步" "生成同步包"

        print ""
        _550w_set_row "0"  "返回"
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

# ══════════════════ 12. 高级设置 ══════════════════
# 心跳/命令耗时/统计开关/日志保留/备份保留 等

_550w_set_menu_adv() {
    while true; do
        _550w_set_head "高级设置" "7 项 · 精细控制"
        _550w_set_stat "心跳" "$_550W_HEARTBEAT_INTERVAL" "命令阈值" "$_550W_CMD_TIMING_THRESHOLD"
        print ""

        _550w_set_sub "会话"
        _550w_set_row "1"  "心跳间隔"     "打印状态的频率（秒）"
        _550w_set_row "2"  "命令耗时阈值" "超过多少秒显示提示"

        _550w_set_sub "统计"
        _550w_set_row "3"  "统计开关"     "记录命令调用（0/1）"
        _550w_set_row "4"  "统计上限"     "日志文件最大行数"

        _550w_set_sub "日志与备份保留"
        _550w_set_row "5"  "日志保留天数" "超过自动清理"
        _550w_set_row "6"  "备份保留个数" "超过自动清理"
        _550w_set_row "7"  "备份压缩"     "0 不压缩 / 1 压缩"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1)
                if _550w_set_read_int "心跳间隔（10~3600）" _550W_HEARTBEAT_INTERVAL 10 3600; then
                    _550w_set_save
                fi
                ;;
            2)
                if _550w_set_read_int "命令耗时阈值（1~300）" _550W_CMD_TIMING_THRESHOLD 1 300; then
                    _550w_set_save
                fi
                ;;
            3) _550w_set_toggle _550W_STATS_ENABLED "统计开关"; _550w_set_save ;;
            4)
                if _550w_set_read_int "统计上限（100~99999）" _550W_STATS_MAX_LINES 100 99999; then
                    _550w_set_save
                fi
                ;;
            5)
                if _550w_set_read_int "日志保留天数（1~365）" _550W_LOG_KEEP_DAYS 1 365; then
                    _550w_set_save
                fi
                ;;
            6)
                if _550w_set_read_int "备份保留个数（1~100）" _550W_BACKUP_KEEP 1 100; then
                    _550w_set_save
                fi
                ;;
            7) _550w_set_toggle _550W_BACKUP_COMPRESS "备份压缩"; _550w_set_save ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 13. 关于与重置 ══════════════════

_550w_set_menu_about() {
    while true; do
        _550w_set_head "关于与重置" "3 项"
        print ""

        _550w_set_row "1"  "版本信息"     "查看当前版本和文件"
        _550w_set_row "2"  "恢复所有默认" "重置全部配置"
        _550w_set_row "3"  "完全重置"     "删除所有数据（危险）"

        print ""
        _550w_set_row "0"  "返回"
        print ""
        print -n "  选择 [0-3]: "
        local c
        read -r c
        case "$c" in
            1)
                _550w_set_head "版本信息"
                printf '  %-14s %s\n' "版本" "$_550W_VERSION"
                printf '  %-14s %s\n' "构建" "$_550W_BUILD_DATE"
                printf '  %-14s %s\n' "核心" "$(wc -l < "$HOME/.550w/core.zsh" 2>/dev/null | tr -d ' ') 行"
                local total=0 f n
                for f in "$HOME/.550w"/*.zsh(N); do
                    n=$(wc -l < "$f" 2>/dev/null | tr -d ' ')
                    [[ "$n" =~ '^[0-9]+$' ]] && (( total += n ))
                done
                printf '  %-14s %s\n' "总行数" "$total 行"
                printf '  %-14s %s\n' "会话" "$_550W_SESSION_ID"
                printf '  %-14s %s\n' "用户" "$_550W_USER_NAME"
                _550w_set_pause
                ;;
            2)
                if _550w_set_confirm "恢复所有默认配置"; then
                    _550w_config_reset
                    _550w_set_msg ok "已恢复"
                fi
                ;;
            3)
                print ""
                print -P "  %F{${_550W_C[err]}}%B⚠ 将删除整个 ~/.550w 目录%f"
                print -P "  %F{${_550W_C[err]}}包括插件/主题/备份/所有数据%f"
                print ""
                print -n "  输入 RESET 确认: "
                local confirm
                read -r confirm
                if [[ "$confirm" == "RESET" ]]; then
                    print -n "  真的确认? (y/N): "
                    local yn
                    read -r yn
                    if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
                        print -P "  %F{${_550W_C[warn]}}删除中...%f"
                        print -P "  %F{${_550W_C[dim]}}请手动执行: rm -rf ~/.550w%f"
                        _550w_set_pause
                    fi
                else
                    _550w_set_msg err "输入不匹配，已取消"
                fi
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 变量兜底 ══════════════════
# 如果 core.zsh 里没定义（旧版本），在这里补默认值

typeset -g _550W_PASS_MIN_LEN="${_550W_PASS_MIN_LEN:-4}"
typeset -g _550W_TIME_FORMAT="${_550W_TIME_FORMAT:-24h}"
typeset -g _550W_DATE_FORMAT="${_550W_DATE_FORMAT:-Y-m-d}"
typeset -g _550W_BORDER_STYLE="${_550W_BORDER_STYLE:-double}"
typeset -g _550W_SCANLINE="${_550W_SCANLINE:-1}"
typeset -g _550W_STATUSBAR="${_550W_STATUSBAR:-1}"
typeset -g _550W_COLOR_PRIMARY="${_550W_COLOR_PRIMARY:-cyan}"
typeset -g _550W_COLOR_ACCENT="${_550W_COLOR_ACCENT:-ok}"
typeset -g _550W_COLOR_BG="${_550W_COLOR_BG:-black}"
typeset -g _550W_FONT="${_550W_FONT:-monospace}"
typeset -g _550W_FONT_SIZE="${_550W_FONT_SIZE:-14}"
typeset -g _550W_PS1_MODE="${_550W_PS1_MODE:-full}"
typeset -g _550W_PS1_SHOW_SID="${_550W_PS1_SHOW_SID:-1}"
typeset -g _550W_PS1_SHOW_MODE="${_550W_PS1_SHOW_MODE:-1}"
typeset -g _550W_PS1_SHOW_MOSS="${_550W_PS1_SHOW_MOSS:-1}"
typeset -g _550W_PS1_SHOW_TIME="${_550W_PS1_SHOW_TIME:-1}"
typeset -g _550W_STATS_ENABLED="${_550W_STATS_ENABLED:-1}"
typeset -g _550W_STATS_MAX_LINES="${_550W_STATS_MAX_LINES:-5000}"
typeset -g _550W_LOG_KEEP_DAYS="${_550W_LOG_KEEP_DAYS:-30}"
typeset -g _550W_BACKUP_KEEP="${_550W_BACKUP_KEEP:-10}"
typeset -g _550W_BACKUP_AUTO="${_550W_BACKUP_AUTO:-0}"
typeset -g _550W_BACKUP_COMPRESS="${_550W_BACKUP_COMPRESS:-1}"
typeset -g _550W_LOG_ROTATE_SIZE="${_550W_LOG_ROTATE_SIZE:-1048576}"

# ══════════════════ 加载提示（调试用，默认静默）══════════════════

(( _550W_LOG_LEVEL >= 4 )) && \
    print -P "%F{${_550W_C[dim]}}[550W] settings.zsh 已加载（13 类 · 110 项）%f" >&2

# ══════════════════ 验证 ══════════════════
# 加载后可以跑：
#   550w-settings         打开设置中心
#   zsh -n ~/.550w/settings.zsh    语法检查

# ══════════════════ [补丁 v2.1] 辅助函数重写 ══════════════════

# 1. 中英混排对齐（用显示宽度算）
_550w_set_row() {
    local num="$1" text="$2" desc="${3:-}" cur="${4:-}"
    local w
    w=$(_550w_str_w "$text" 2>/dev/null) || w=${#text}
    local pad=$(( 20 - w ))
    (( pad < 0 )) && pad=0
    local sp
    sp=$(printf '%*s' "$pad" '')

    if [[ -n "$cur" ]]; then
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s%s\e[0m \e[38;5;%sm%s\e[0m \e[38;5;%sm[当前:%s]\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text" "$sp" \
            "${_550W_C[dim]}" "$desc" \
            "${_550W_C[ok]}" "$cur"
    elif [[ -n "$desc" ]]; then
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s%s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text" "$sp" \
            "${_550W_C[dim]}" "$desc"
    else
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text"
    fi
}

# 2. 每页底部统一提示"改完怎么生效"
_550w_set_footer() {
    local mode="${1:-save}"    # save / restart / instant
    print ""
    print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
    case "$mode" in
        instant)
            print -P "  %F{${_550W_C[ok]}}✓ 修改立即生效%f"
            ;;
        restart)
            print -P "  %F{${_550W_C[warn]}}⚠ 修改下次启动生效%f"
            print -P "  %F{${_550W_C[dim]}}  重启：unset _550W_LOADED && source ~/.zshrc%f"
            ;;
        save)
            print -P "  %F{${_550W_C[dim]}}  修改自动保存到 $_550W_CONFIG_FILE%f"
            ;;
    esac
}

# 3. 颜色选择器：改完真正应用到 _550W_C 色表
_550w_set_color_pick() {
    local label="$1"
    local varname target
    case "$label" in
        主色调) varname="_550W_COLOR_PRIMARY"; target="cyan" ;;
        强调色) varname="_550W_COLOR_ACCENT";  target="ok" ;;
        背景色) varname="_550W_COLOR_BG";      target="" ;;
        *) varname="_550W_COLOR_PRIMARY"; target="cyan" ;;
    esac

    _550w_set_head "选择$label"
    print "  当前: ${(P)varname}"
    print ""

    local -a palette=(
        "cyan|51"    "blue|45"   "green|46"  "amber|214"
        "orange|208" "red|196"   "pink|205"  "purple|135"
        "white|231"  "grey|245"  "black|232" "yellow|220"
    )
    local i
    for (( i=1; i<=${#palette[@]}; i++ )); do
        local pname="${palette[$i]%%|*}"
        local pcode="${palette[$i]#*|}"
        printf '  \e[38;5;%sm[%2d]\e[0m \e[38;5;%sm%-8s\e[0m code=%s\n' \
            "${_550W_C[cyan]}" "$i" "$pcode" "$pname" "$pcode"
    done
    print ""
    print -n "  选择 [1-${#palette[@]}] 或直接输入色号（0 取消）: "
    local c
    read -r c
    [[ -z "$c" || "$c" == "0" ]] && return

    local chosen="" code=""
    if [[ "$c" =~ '^[0-9]+$' ]] && (( c >= 1 && c <= ${#palette[@]} )); then
        chosen="${palette[$c]%%|*}"
        code="${palette[$c]#*|}"
    elif [[ "$c" =~ '^[0-9]+$' ]] && (( c >= 0 && c <= 255 )); then
        chosen="$c"
        code="$c"
    else
        _550w_set_msg err "无效输入"
        return
    fi

    typeset -g "$varname"="$chosen"

    # 应用颜色到 _550W_C（关键修复）
    if [[ -n "$target" ]]; then
        _550W_C[$target]="$code"
    fi

    _550w_set_msg ok "$label 已设为: $chosen (code=$code)"
    _550w_set_save
}

# 4. 配置总览页
_550w_set_overview() {
    _550w_set_head "配置总览" "所有可改项的当前值"
    print -P "  %F{${_550W_C[ok]}}%B▸ 外观%f"
    printf '  %-24s %s\n' "_550W_SPEED" "$_550W_SPEED"
    printf '  %-24s %s\n' "_550W_MODE_ANIM" "$_550W_MODE_ANIM"
    printf '  %-24s %s\n' "_550W_FX" "$_550W_FX"
    printf '  %-24s %s\n' "_550W_BEEP" "$_550W_BEEP"
    printf '  %-24s %s\n' "_550W_COLORS" "$_550W_COLORS"
    printf '  %-24s %s\n' "_550W_CURSOR_CTL" "$_550W_CURSOR_CTL"
    printf '  %-24s %s\n' "_550W_LOG_LEVEL" "$_550W_LOG_LEVEL"
    printf '  %-24s %s\n' "_550W_THEME" "$_550W_THEME"
    printf '  %-24s %s\n' "_550W_COLOR_PRIMARY" "$_550W_COLOR_PRIMARY"
    printf '  %-24s %s\n' "_550W_COLOR_ACCENT" "$_550W_COLOR_ACCENT"
    printf '  %-24s %s\n' "_550W_COLOR_BG" "$_550W_COLOR_BG"
    printf '  %-24s %s\n' "_550W_FONT" "$_550W_FONT"
    printf '  %-24s %s\n' "_550W_FONT_SIZE" "$_550W_FONT_SIZE"
    printf '  %-24s %s\n' "_550W_TIME_FORMAT" "$_550W_TIME_FORMAT"
    printf '  %-24s %s\n' "_550W_DATE_FORMAT" "$_550W_DATE_FORMAT"
    printf '  %-24s %s\n' "_550W_BORDER_STYLE" "$_550W_BORDER_STYLE"
    printf '  %-24s %s\n' "_550W_SCANLINE" "$_550W_SCANLINE"
    printf '  %-24s %s\n' "_550W_STATUSBAR" "$_550W_STATUSBAR"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 提示符%f"
    printf '  %-24s %s\n' "_550W_PS1_MODE" "${_550W_PS1_MODE:-full}"
    printf '  %-24s %s\n' "_550W_PS1_SHOW_SID" "${_550W_PS1_SHOW_SID:-1}"
    printf '  %-24s %s\n' "_550W_PS1_SHOW_MODE" "${_550W_PS1_SHOW_MODE:-1}"
    printf '  %-24s %s\n' "_550W_PS1_SHOW_MOSS" "${_550W_PS1_SHOW_MOSS:-1}"
    printf '  %-24s %s\n' "_550W_PS1_SHOW_TIME" "${_550W_PS1_SHOW_TIME:-1}"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 认证%f"
    printf '  %-24s %s\n' "_550W_MAX_ATTEMPTS" "$_550W_MAX_ATTEMPTS"
    printf '  %-24s %s\n' "_550W_READ_TIMEOUT" "$_550W_READ_TIMEOUT"
    printf '  %-24s %s\n' "_550W_PW_MASK_MAX" "$_550W_PW_MASK_MAX"
    printf '  %-24s %s\n' "_550W_COOLDOWN_ATTEMPTS" "$_550W_COOLDOWN_ATTEMPTS"
    printf '  %-24s %s\n' "_550W_COOLDOWN_SECONDS" "$_550W_COOLDOWN_SECONDS"
    printf '  %-24s %s\n' "_550W_IDLE_LOCKOUT" "$_550W_IDLE_LOCKOUT"
    printf '  %-24s %s\n' "_550W_PASS_MIN_LEN" "${_550W_PASS_MIN_LEN:-4}"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ MOSS%f"
    printf '  %-24s %s\n' "_550W_MOSS_ENABLED" "$_550W_MOSS_ENABLED"
    printf '  %-24s %s\n' "_550W_MOSS_PROVIDER" "$_550W_MOSS_PROVIDER"
    printf '  %-24s %s\n' "_550W_MOSS_MODEL" "$_550W_MOSS_MODEL"
    printf '  %-24s %s\n' "_550W_MOSS_MODE" "$_550W_MOSS_MODE"
    printf '  %-24s %s\n' "_550W_MOSS_TEMPERATURE" "$_550W_MOSS_TEMPERATURE"
    printf '  %-24s %s\n' "_550W_MOSS_MAX_TOKENS" "$_550W_MOSS_MAX_TOKENS"
    printf '  %-24s %s\n' "_550W_MOSS_CTX_WINDOW" "$_550W_MOSS_CTX_WINDOW"
    printf '  %-24s %s\n' "_550W_MOSS_MEMORY_MAX" "$_550W_MOSS_MEMORY_MAX"
    printf '  %-24s %s\n' "_550W_MOSS_TIMEOUT" "$_550W_MOSS_TIMEOUT"
    printf '  %-24s %s\n' "_550W_MOSS_AUDIT_ENABLED" "$_550W_MOSS_AUDIT_ENABLED"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 用户%f"
    printf '  %-24s %s\n' "_550W_USER_NAME" "$_550W_USER_NAME"
    printf '  %-24s %s\n' "_550W_USER_LEVEL" "$_550W_USER_LEVEL"
    printf '  %-24s %s\n' "_550W_USER_ROLE" "$_550W_USER_ROLE"
    printf '  %-24s %s\n' "_550W_USER_MOTTO" "$_550W_USER_MOTTO"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 高级%f"
    printf '  %-24s %s\n' "_550W_HEARTBEAT_INTERVAL" "$_550W_HEARTBEAT_INTERVAL"
    printf '  %-24s %s\n' "_550W_CMD_TIMING_THRESHOLD" "$_550W_CMD_TIMING_THRESHOLD"
    printf '  %-24s %s\n' "_550W_STATS_ENABLED" "${_550W_STATS_ENABLED:-1}"
    printf '  %-24s %s\n' "_550W_STATS_MAX_LINES" "${_550W_STATS_MAX_LINES:-5000}"
    printf '  %-24s %s\n' "_550W_LOG_KEEP_DAYS" "${_550W_LOG_KEEP_DAYS:-30}"
    printf '  %-24s %s\n' "_550W_BACKUP_KEEP" "${_550W_BACKUP_KEEP:-10}"
    printf '  %-24s %s\n' "_550W_BACKUP_COMPRESS" "${_550W_BACKUP_COMPRESS:-1}"
    print ""
    _550w_set_pause
}

# ══════════════════ [补丁 v2.1] 主菜单覆盖 ══════════════════

550w-settings() {
    while true; do
        _550w_set_head "550W 设置中心" "v2.1 · 13 类 · 110 项"

        # 状态行（多行显示，避免超宽）
        print -P "  %F{${_550W_C[dim]}}速度%f \e[1m$_550W_SPEED\e[0m  %F{${_550W_C[dim]}}特效%f \e[1m$_550W_FX\e[0m  %F{${_550W_C[dim]}}主题%f \e[1m$_550W_THEME\e[0m"
        print -P "  %F{${_550W_C[dim]}}MOSS%f \e[1m$_550W_MOSS_PROVIDER\e[0m  %F{${_550W_C[dim]}}记忆%f \e[1m$_550W_MOSS_MEMORY_MAX\e[0m  %F{${_550W_C[dim]}}用户%f \e[1m$_550W_USER_NAME\e[0m"

        _550w_set_sub "界面外观"
        _550w_set_row "1"  "外观设置"     "速度/特效/颜色/字体/主题" "$_550W_SPEED"
        _550w_set_row "2"  "提示符"       "PS1 显示内容自定义"       "${_550W_PS1_MODE:-full}"
        _550w_set_row "3"  "主题管理"     "切换/创建/导入导出"        "$_550W_THEME"

        _550w_set_sub "身份与安全"
        _550w_set_row "4"  "认证"         "密码/超时/冷却/锁定"       "$_550W_MAX_ATTEMPTS 次"
        _550w_set_row "5"  "用户档案"     "用户名/等级/权限/签名"     "$_550W_USER_NAME"

        _550w_set_sub "AI 与扩展"
        _550w_set_row "6"  "MOSS 配置"    "Provider/模型/温度/记忆"   "$_550W_MOSS_PROVIDER"
        _550w_set_row "7"  "插件管理"     "创建/编辑/删除/重载"
        _550w_set_row "8"  "开机动画"     "加入/删除开机时播的动画"

        _550w_set_sub "数据与维护"
        _550w_set_row "9"  "备份"         "创建/恢复/清理/校验"
        _550w_set_row "10" "日志"         "查看/搜索/清理/导出"
        _550w_set_row "11" "数据导入导出" "配置/档案/记忆/同步"
        _550w_set_row "12" "高级设置"     "心跳/阈值/保留策略"

        _550w_set_sub "其它"
        _550w_set_row "13" "配置总览"     "所有可改项的当前值"
        _550w_set_row "14" "关于与重置"   "版本信息/恢复默认"

        print ""
        _550w_set_row "0"  "退出"

        _550w_set_footer save
        print ""
        print -n "  选择 [0-14]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_set_menu_appear ;;
            2)  _550w_set_menu_ps1 ;;
            3)  _550w_set_menu_theme ;;
            4)  _550w_set_menu_auth ;;
            5)  _550w_set_menu_profile ;;
            6)  _550w_set_menu_moss ;;
            7)  _550w_set_menu_plugin ;;
            8)  _550w_set_menu_boot ;;
            9)  _550w_set_menu_backup ;;
            10) _550w_set_menu_log ;;
            11) _550w_set_menu_data ;;
            12) _550w_set_menu_adv ;;
            13) _550w_set_overview ;;
            14) _550w_set_menu_about ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ [补丁 v2.1] 保存后带提示 ══════════════════

_550w_set_save() {
    if _550w_config_save >/dev/null 2>&1; then
        print ""
        print -P "  %F{${_550W_C[ok]}}✓ 已保存%f  %F{${_550W_C[dim]}}→ $_550W_CONFIG_FILE%f"
        print -P "  %F{${_550W_C[warn]}}⚠ 下次启动生效%f  %F{${_550W_C[dim]}}(unset _550W_LOADED && source ~/.zshrc)%f"
    else
        print ""
        print -P "  %F{${_550W_C[err]}}✗ 保存失败%f"
        print -P "  %F{${_550W_C[dim]}}检查文件权限：ls -la $_550W_CONFIG_FILE%f"
    fi
    sleep 1.2
}

# 提示符相关：改完立即生效（特殊）
_550w_set_save_instant() {
    if _550w_config_save >/dev/null 2>&1; then
        print ""
        print -P "  %F{${_550W_C[ok]}}✓ 已保存并立即生效%f"
    else
        print ""
        print -P "  %F{${_550W_C[err]}}✗ 保存失败%f"
    fi
    sleep 1
}

# ══════════════════ [补丁 v2.1] MOSS API Key 可编辑 ══════════════════

_550w_set_moss_apikey() {
    _550w_set_head "设置 API Key"
    local envvar
    envvar=$(_550w_moss_envvar_of "$_550W_MOSS_PROVIDER" 2>/dev/null)
    if [[ -z "$envvar" || "$envvar" == "?" ]]; then
        _550w_set_msg wrn "当前 Provider 无需 API Key"
        return
    fi
    print -P "  %F{${_550W_C[dim]}}Provider: $_550W_MOSS_PROVIDER%f"
    print -P "  %F{${_550W_C[dim]}}环境变量: $envvar%f"
    print ""
    print -P "  %F{${_550W_C[cyan]}}方式 1：一次性设置（当前会话）%f"
    print -n "  粘贴 Key（回车取消）: "
    local key
    read -r key
    [[ -z "$key" ]] && return

    # 写入 ~/.zshrc
    print -P "  %F{${_550W_C[cyan]}}方式 2：永久写入 ~/.zshrc%f"
    if _550w_set_confirm "写入 ~/.zshrc？"; then
        # 删旧行
        sed -i "/^export ${envvar}=/d" ~/.zshrc 2>/dev/null
        # 加新行
        print "export ${envvar}=\"${key}\"" >> ~/.zshrc
        # 当前会话也设置
        typeset -g "$envvar"="$key"
        _550w_moss_resolve_provider 1 >/dev/null 2>&1
        _550w_set_msg ok "已写入 ~/.zshrc 并生效"
    else
        typeset -g "$envvar"="$key"
        _550w_moss_resolve_provider 1 >/dev/null 2>&1
        _550w_set_msg ok "已设置（仅当前会话）"
    fi
}

# ══════════════════ [补丁 v2.1] MOSS 菜单加 API Key 编辑 ══════════════════

_550w_set_menu_moss() {
    while true; do
        _550w_set_head "MOSS 配置" "14 项 · AI 引擎"
        _550w_set_stat "启用" "$_550W_MOSS_ENABLED" "Provider" "$_550W_MOSS_PROVIDER"
        print -P "  %F{${_550W_C[dim]}}模型%f $_550W_MOSS_MODEL  %F{${_550W_C[dim]}}模式%f $_550W_MOSS_MODE"
        print ""

        _550w_set_sub "基础"
        _550w_set_row "1"  "启用开关"   "0 关 / 1 开"           "$_550W_MOSS_ENABLED"
        _550w_set_row "2"  "Provider"   "15 个可选"             "$_550W_MOSS_PROVIDER"
        _550w_set_row "3"  "模型名"     "生成用的模型"          "$_550W_MOSS_MODEL"
        _550w_set_row "4"  "模式"       "cloud/local/auto"      "$_550W_MOSS_MODE"

        _550w_set_sub "生成参数"
        _550w_set_row "5"  "温度"       "0.0~2.0"               "$_550W_MOSS_TEMPERATURE"
        _550w_set_row "6"  "MaxTokens"  "单次最多生成"          "$_550W_MOSS_MAX_TOKENS"
        _550w_set_row "7"  "上下文窗口" "保留几轮对话"          "$_550W_MOSS_CTX_WINDOW"

        _550w_set_sub "记忆与限制"
        _550w_set_row "8"  "记忆上限"   "最多存几条"            "$_550W_MOSS_MEMORY_MAX"
        _550w_set_row "9"  "速率限制"   "每日上限"              "$_550W_MOSS_RATELIMIT_DAILY"

        _550w_set_sub "网络与安全"
        _550w_set_row "10" "请求超时"   "秒"                    "$_550W_MOSS_TIMEOUT"
        _550w_set_row "11" "审计开关"   "记录对话到审计"        "$_550W_MOSS_AUDIT_ENABLED"
        _550w_set_row "12" "API Key"    "查看/编辑"             "$([[ -n "$_550W_MOSS_TOKEN" ]] && echo 已配置 || echo 未配置)"
        _550w_set_row "13" "健康检查"   "立即检测 MOSS"         "$_550W_MOSS_HEALTH"

        _550w_set_sub "测试"
        _550w_set_row "14" "测试对话"   "发一条消息验证"

        print ""
        _550w_set_row "0"  "返回"
        _550w_set_footer save
        print ""
        print -n "  选择 [0-14]: "
        local c
        read -r c
        case "$c" in
            1) _550w_set_toggle _550W_MOSS_ENABLED "MOSS 启用"; _550w_set_save ;;
            2) 550w-moss-set ;;
            3) _550w_set_read_str "新模型名" _550W_MOSS_MODEL && _550w_set_save ;;
            4)
                print ""
                print "  cloud  云端 API"
                print "  local  本地 Ollama"
                print "  auto   云端不通切本地"
                print -n "  > "
                local v
                read -r v
                case "$v" in
                    cloud|local|auto) _550W_MOSS_MODE="$v"; _550w_set_save ;;
                    *) _550w_set_msg err "无效值" ;;
                esac
                ;;
            5)
                print ""
                print "  0.0 严谨 / 0.7 默认 / 1.0 平衡 / 1.5 发散"
                print -n "  > "
                local v
                read -r v
                [[ -z "$v" ]] && continue
                if [[ "$v" =~ '^[0-2](\.[0-9]+)?$' ]]; then
                    _550W_MOSS_TEMPERATURE="$v"
                    _550w_set_save
                else
                    _550w_set_msg err "范围 0.0~2.0"
                fi
                ;;
            6) _550w_set_read_int "MaxTokens（128~32000）" _550W_MOSS_MAX_TOKENS 128 32000 && _550w_set_save ;;
            7) _550w_set_read_int "上下文轮数（1~50）" _550W_MOSS_CTX_WINDOW 1 50 && _550w_set_save ;;
            8) _550w_set_read_int "记忆上限（4~500）" _550W_MOSS_MEMORY_MAX 4 500 && _550w_set_save ;;
            9) _550w_set_read_int "每日上限（10~99999）" _550W_MOSS_RATELIMIT_DAILY 10 99999 && _550w_set_save ;;
            10) _550w_set_read_int "请求超时（5~300）" _550W_MOSS_TIMEOUT 5 300 && _550w_set_save ;;
            11) _550w_set_toggle _550W_MOSS_AUDIT_ENABLED "审计"; _550w_set_save ;;
            12) _550w_set_moss_apikey ;;
            13)
                _550w_set_head "健康检查"
                print "  检测中..."
                _550w_moss_health
                print ""
                printf '  %-14s %s\n' "状态" "$_550W_MOSS_HEALTH"
                printf '  %-14s %s\n' "端点" "$_550W_MOSS_CLOUD_URL"
                printf '  %-14s %s\n' "模型" "$_550W_MOSS_MODEL"
                _550w_set_pause
                ;;
            14)
                print ""
                print -n "  消息: "
                local msg
                read -r msg
                [[ -z "$msg" ]] && continue
                print ""
                _550w_moss_chat "$msg"
                if [[ -n "$_550W_MOSS_REPLY" ]]; then
                    print -P "  %F{${_550W_C[ok]}}[MOSS]%f $_550W_MOSS_REPLY"
                fi
                _550w_set_pause
                ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}
# ══════════════════ [补丁 v2.2] 菜单行紧凑显示 ══════════════════

_550w_set_row() {
    local num="$1" text="$2" desc="${3:-}" cur="${4:-}"
    local w
    w=$(_550w_str_w "$text" 2>/dev/null) || w=${#text}
    local pad=$(( 16 - w ))
    (( pad < 0 )) && pad=0
    local sp
    sp=$(printf '%*s' "$pad" '')

    # 第一行：编号 + 名称 + 描述
    if [[ -n "$desc" ]]; then
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s%s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text" "$sp" \
            "${_550W_C[dim]}" "$desc"
    else
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text"
    fi

    # 第二行：当前值（缩进 + 暗色）
    if [[ -n "$cur" ]]; then
        printf '        \e[38;5;%sm当前: %s\e[0m\n' \
            "${_550W_C[ok]}" "$cur"
    fi
}

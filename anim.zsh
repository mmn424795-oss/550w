# ~/.550w/anim.zsh — 550W 动画引擎 v1.0
# 234 种动画：基础/强调/故障/进度/图表/拓扑/编解码/密码/神经网络/机器学习

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ 1. 打字机 v1/v2/v3 ══════════════════

_550w_anim_typing_v1() {
    local text="$1" delay="${2:-40}"
    local len=${#text} i
    for (( i=1; i<=len; i++ )); do
        print -n "${text[$i]}"
        (( _550W_SKIP )) && { print -n "${text[$((i+1)),-1]}"; break; }
        _550w_pause "$delay"
    done
    print ""
}

_550w_anim_typing_v2() {
    local text="$1" delay="${2:-40}"
    local len=${#text} i
    for (( i=1; i<=len; i++ )); do
        print -n "${text[$i]}"
        (( _550W_SKIP )) && { print -n "${text[$((i+1)),-1]}"; break; }
        _550w_pause "$delay"
    done
    local j
    for (( j=0; j<3; j++ )); do
        print -n "█"
        _550w_pause 200
        print -n $'\b \b'
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_typing_v3() {
    local text="$1" delay="${2:-40}"
    local len=${#text} i
    local typos="!@#\$%^&*"
    for (( i=1; i<=len; i++ )); do
        if (( RANDOM % 100 < 15 )); then
            local wrong="${typos[$((RANDOM % ${#typos} + 1))]}"
            print -n "$wrong"
            _550w_pause "$delay"
            print -n $'\b \b'
            _550w_pause "$delay"
        fi
        print -n "${text[$i]}"
        (( _550W_SKIP )) && { print -n "${text[$((i+1)),-1]}"; break; }
        _550w_pause "$delay"
    done
    print ""
}

# ══════════════════ 2. 淡入 / 淡出 ══════════════════

_550w_anim_fade_in() {
    local text="$1"
    local color="${2:-${_550W_C[ok]}}"
    local steps=(240 245 250 231)
    local s
    for s in "${steps[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "$s" "$text"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm\e[1m%s\e[0m\n' "$color" "$text"
}

_550w_anim_fade_out() {
    local text="$1"
    local steps=(231 250 245 240)
    local s
    for s in "${steps[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "$s" "$text"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 3. 滑动进入 ══════════════════

_550w_anim_slide_in() {
    local text="$1"
    local color="${2:-${_550W_C[cyan]}}"
    local len=${#text}
    local pad i
    for (( i=len; i>=0; i-=2 )); do
        pad=$(printf '%*s' "$i" '')
        printf '\r\e[K  %s\e[38;5;%sm%s\e[0m' "$pad" "$color" "$text"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "$color" "$text"
}

# ══════════════════ 4. 放大 / 缩小 ══════════════════

_550w_anim_zoom_in() {
    local text="$1"
    local -a sizes=("·" "•" "$text")
    local s
    for s in "${sizes[@]}"; do
        printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$s"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_zoom_out() {
    local text="$1"
    printf '  \e[1m\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
    _550w_pause 200
    local -a sizes=("•" "·")
    local s
    for s in "${sizes[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$s"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 5. 旋转 / 翻转 ══════════════════

_550w_anim_rotate() {
    local text="$1"
    local -a frames=(◐ ◓ ◑ ◒)
    local i
    for (( i=0; i<8; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m  %s' \
            "${_550W_C[cyan]}" "${frames[$((i%4+1))]}" "$text"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m  %s\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_flip() {
    local text="$1"
    local -a frames=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃ ▂ ▁)
    local i
    for (( i=1; i<=${#frames[@]}; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[ok]}" "${frames[$i]}" "$text"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 6. 抖动 / 脉冲 ══════════════════

_550w_anim_shake() {
    local text="$1"
    local -a shifts=("" " " "  " " " "")
    local i
    for (( i=0; i<10; i++ )); do
        printf '\r\e[K  %s%s' "${shifts[$((i%5+1))]}" "$text"
        _550w_pause 50
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

_550w_anim_pulse_text() {
    local text="$1" cycles="${2:-3}"
    local c i
    for (( c=0; c<cycles; c++ )); do
        printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 200
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$text"
        _550w_pause 200
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 7. 呼吸 / 闪烁 ══════════════════

_550w_anim_breathe_text() {
    local text="$1" cycles="${2:-4}"
    local c
    for (( c=0; c<cycles; c++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 300
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$text"
        _550w_pause 300
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_blink() {
    local text="$1" times="${2:-5}"
    local i
    for (( i=0; i<times; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 150
        printf '\r\e[K'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 8. 扫描 / 擦除 ══════════════════

_550w_anim_sweep_text() {
    local text="$1"
    local len=${#text}
    local i
    for (( i=0; i<=len; i++ )); do
        local left="${text:0:$i}"
        local right="${text:$i}"
        printf '\r\e[K  \e[38;5;%sm%s\e[38;5;%sm%s\e[0m' \
            "${_550W_C[ok]}" "$left" "${_550W_C[dim]}" "$right"
        _550w_pause 50
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_wipe() {
    local text="$1"
    local len=${#text}
    local i
    for (( i=len; i>=0; i-- )); do
        printf '\r\e[K  %s' "${text:0:$i}"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 9. 溶解 / 马赛克 / 像素化 ══════════════════

_550w_anim_dissolve() {
    local text="$1"
    local chars="░▒▓█"
    local len=${#text}
    local i
    for (( i=0; i<6; i++ )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            if (( RANDOM % 3 == 0 )); then
                out+="${chars[$((RANDOM % ${#chars} + 1))]}"
            else
                out+="${text[$j]}"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$out"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_mosaic() {
    local text="$1"
    local chars="◯◉◍◎●○"
    local len=${#text}
    local i
    for (( i=0; i<5; i++ )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            out+="${chars[$((RANDOM % ${#chars} + 1))]}"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$out"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_pixelate() {
    local text="$1"
    local -a blocks=("█" "▓" "▒" "░" " ")
    local len=${#text}
    local i
    for (( i=0; i<5; i++ )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            local b="${blocks[$((i + RANDOM % 3 + 1))]}"
            out+="$b"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$out"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 10. 故障风文字 ══════════════════

_550w_anim_glitch_text_v2() {
    local text="$1" dur="${2:-8}"
    local chars='!@#$%^&*()_+-=[]{}|;:,.<>?/~`'
    local i j
    for (( i=0; i<dur; i++ )); do
        local out=""
        for (( j=1; j<=${#text}; j++ )); do
            if (( RANDOM % 3 == 0 )); then
                out+="${chars[$((RANDOM % ${#chars} + 1))]}"
            else
                out+="${text[$j]}"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$out"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 11. 边框流动 ══════════════════

_550w_anim_border_flow() {
    local text="$1"
    local color="${2:-${_550W_C[cyan]}}"
    local len=${#text}
    local i
    for (( i=0; i<10; i++ )); do
        local pos=$(( i % len ))
        local left="${text:0:$pos}"
        local mid="${text:$pos:1}"
        local right="${text:$((pos+1))}"
        printf '\r\e[K  \e[38;5;%sm│\e[0m %s\e[1m%s\e[0m%s \e[38;5;%sm│\e[0m' \
            "$color" "$left" "$mid" "$right" "$color"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm│\e[0m %s \e[38;5;%sm│\e[0m\n' "$color" "$text" "$color"
}

_550w_anim_border_breathe() {
    local text="$1"
    local cycles="${2:-3}"
    local -a cols=(240 245 250 231)
    local c i
    for (( c=0; c<cycles; c++ )); do
        for i in 1 2 3 4 3 2; do
            printf '\r\e[K  \e[38;5;%sm┃ %s ┃\e[0m' "${cols[$i]}" "$text"
            _550w_pause 120
            (( _550W_SKIP )) && break
        done
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm┃ %s ┃\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_border_color() {
    local text="$1"
    local -a colors=(
        "${_550W_C[ok]}" "${_550W_C[cyan]}" "${_550W_C[blue]}"
        "${_550W_C[amber]}" "${_550W_C[orange]}" "${_550W_C[red]}"
    )
    local c
    for c in "${colors[@]}"; do
        printf '\r\e[K  \e[38;5;%sm╔════════════╗\e[0m\n' "$c"
        printf '\r  \e[38;5;%sm║ %-12s ║\e[0m\n' "$c" "$text"
        printf '\r  \e[38;5;%sm╚════════════╝\e[0m' "$c"
        _550w_pause 150
        printf '\r\e[K\e[2A'
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
    printf '  \e[38;5;%sm╔════════════╗\e[0m\n' "${_550W_C[ok]}"
    printf '  \e[38;5;%sm║ %-12s ║\e[0m\n' "${_550W_C[ok]}" "$text"
    printf '  \e[38;5;%sm╚════════════╝\e[0m\n' "${_550W_C[ok]}"
}

_550w_anim_border_dashed() {
    local text="$1"
    local color="${2:-${_550W_C[cyan]}}"
    local -a patterns=(
        "┄┄┄┄┄┄┄┄┄┄┄┄"
        "╌╌╌╌╌╌╌╌╌╌╌╌"
        "╴╴╴╴╴╴╴╴╴╴╴╴"
        "════════════"
    )
    local p
    for p in "${patterns[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' "$color" "$p" "$text"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm════════════\e[0m %s\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 12. 蚂蚁线 ══════════════════

_550w_anim_ant_line() {
    local text="$1"
    local color="${2:-${_550W_C[cyan]}}"
    local len=$(( ${#text} + 4 ))
    local i
    for (( i=0; i<10; i++ )); do
        local line=""
        local j
        for (( j=0; j<len; j++ )); do
            if (( (j + i) % 2 == 0 )); then
                line+="█"
            else
                line+="░"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "$color" "$line"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 13. 光晕 / 阴影 ══════════════════

_550w_anim_glow() {
    local text="$1"
    local cycles="${2:-4}"
    local c
    for (( c=0; c<cycles; c++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$text"
        _550w_pause 150
        printf '\r\e[K  \e[1m\e[97m%s\e[0m' "$text"
        _550w_pause 150
        printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_shadow() {
    local text="$1"
    printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "  ╲ ╲ ╲"
    printf '  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
    _550w_pause 400
}

# ══════════════════ 14. 高亮 / 聚焦 ══════════════════

_550w_anim_highlight() {
    local text="$1"
    local hl="${2:-1}"
    if [[ -n "$hl" ]]; then
        local left="${text:0:$hl}"
        local mid="${text:$hl:1}"
        local right="${text:$((hl+1))}"
        printf '  %s\e[1m\e[38;5;%sm%s\e[0m%s\n' "$left" "${_550W_C[ok]}" "$mid" "$right"
    else
        printf '  %s\n' "$text"
    fi
}

_550w_anim_focus() {
    local text="$1"
    local i
    for (( i=0; i<8; i++ )); do
        local prefix=""
        local j
        for (( j=0; j<i; j++ )); do prefix+=" "; done
        printf '\r\e[K%s\e[1m\e[38;5;%sm▶ %s\e[0m' "$prefix" "${_550W_C[ok]}" "$text"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm▶ %s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 15. 波纹 / 螺旋 ══════════════════

_550w_anim_ripple() {
    local text="$1"
    local -a patterns=("·" "∘" "○" "◯" "⬤" "◉")
    local p
    for p in "${patterns[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s %s %s\e[0m' \
            "${_550W_C[cyan]}" "$p" "$text" "$p"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_spiral() {
    local text="$1"
    local -a chars=(⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${chars[$((i%8+1))]}" "$text"
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 16. 雷达 / 声波 ══════════════════

_550w_anim_radar_v2() {
    local text="$1"
    local -a sweep=(◜ ◝ ◞ ◟ ◜ ◝ ◞ ◟)
    local i
    for (( i=0; i<12; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m  \e[38;5;%sm%s\e[0m' \
            "${_550W_C[ok]}" "${sweep[$((i%8+1))]}" \
            "${_550W_C[dim]}" "$text"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm◉\e[0m  %s\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_sound_wave() {
    local text="$1"
    local width="${2:-20}"
    local -a bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃ ▂ ▁)
    local i
    for (( i=0; i<6; i++ )); do
        printf '\r\e[K  '
        local j
        for (( j=1; j<=width; j++ )); do
            local v=$(( (RANDOM % 8) + 1 ))
            printf '\e[38;5;%sm%s' "${_550W_C[ok]}" "${bars[$v]}"
        done
        printf '\e[0m  %s' "$text"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 17. 心电图 / 频谱 ══════════════════

_550w_anim_ecg() {
    local width="${1:-50}"
    local -a pattern=("▁" "▁" "▂" "▄" "█" "▄" "▂" "▁" "▁" "▁")
    local plen=${#pattern[@]}
    local step i
    for (( step=0; step<20; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        for (( i=1; i<=width; i++ )); do
            printf '%s' "${pattern[$(((i + step) % plen + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_spectrum() {
    local width="${1:-30}"
    local -a seeds
    local i
    for (( i=1; i<=width; i++ )); do
        seeds[$i]=$((RANDOM % 8))
    done
    local step
    for (( step=0; step<15; step++ )); do
        printf '\r  '
        for (( i=1; i<=width; i++ )); do
            local v=$(( (seeds[$i] + RANDOM % 3) % 8 ))
            local color=$(( 46 + v * 10 ))
            printf '\e[38;5;%sm%s\e[0m' "$color" "$(printf '%*s' 1 '' | tr ' ' '█')"
        done
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 18. 音频可视化 ══════════════════

_550w_anim_audio_viz() {
    local width="${1:-30}"
    local i
    for (( i=0; i<6; i++ )); do
        printf '\r\e[K  '
        local j
        for (( j=1; j<=width; j++ )); do
            local h=$(( RANDOM % 8 + 1 ))
            local color=$(( 46 + h * 5 ))
            local ch
            case $h in
                1) ch="▁" ;; 2) ch="▂" ;; 3) ch="▃" ;; 4) ch="▄" ;;
                5) ch="▅" ;; 6) ch="▆" ;; 7) ch="▇" ;; 8) ch="█" ;;
            esac
            printf '\e[38;5;%sm%s\e[0m' "$color" "$ch"
        done
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_wave_stack() {
    local width="${1:-30}"
    local step
    for (( step=0; step<8; step++ )); do
        printf '\r\e[K  \e[38;5;%sm' "${_550W_C[cyan]}"
        local i
        for (( i=1; i<=width; i++ )); do
            local v=$(( (i + step) % 8 ))
            local ch
            case $v in
                0) ch="▁" ;; 1) ch="▂" ;; 2) ch="▃" ;; 3) ch="▄" ;;
                4) ch="▅" ;; 5) ch="▆" ;; 6) ch="▇" ;; 7) ch="█" ;;
            esac
            printf '%s' "$ch"
        done
        printf '\e[0m'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 19. 粒子汇聚 / 扩散 ══════════════════

_550w_anim_particles_gather() {
    local text="$1"
    local cycles=5
    local c
    for (( c=0; c<cycles; c++ )); do
        local len=${#text}
        local out=""
        local i
        for (( i=1; i<=len; i++ )); do
            if (( RANDOM % (c + 2) == 0 )); then
                out+="${text[$i]}"
            else
                out+="·"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$out"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

_550w_anim_particles_scatter() {
    local text="$1"
    local cycles=5
    local c
    for (( c=0; c<cycles; c++ )); do
        local len=${#text}
        local out=""
        local i
        for (( i=1; i<=len; i++ )); do
            if (( RANDOM % (cycles - c + 1) == 0 )); then
                out+="·"
            else
                out+="${text[$i]}"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$out"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 21. glitch 增强 ══════════════════

_550w_anim_glitch_v3() {
    local text="$1" dur="${2:-10}"
    local chars='!@#$%^&*()_+-=[]{}|;:,.<>?/~`'
    local i j
    for (( i=0; i<dur; i++ )); do
        local out=""
        for (( j=1; j<=${#text}; j++ )); do
            if (( RANDOM % 4 < 2 )); then
                out+="${chars[$((RANDOM % ${#chars} + 1))]}"
            else
                out+="${text[$j]}"
            fi
        done
        local color="${_550W_C[err]}"
        (( RANDOM % 2 == 0 )) && color="${_550W_C[ok]}"
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "$color" "$out"
        _550w_pause 30
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 22. 雪花 ══════════════════

_550w_anim_snow() {
    (( _550W_FX )) || return 0
    local cols
    cols=$(_550w_cols)
    local rows=5
    local chars=".·*°❄❅❆✻✼❋"
    local -a lines
    local i j
    for (( i=1; i<=rows; i++ )); do
        local line="  "
        for (( j=0; j<cols-2; j++ )); do
            if (( RANDOM % 6 == 0 )); then
                line+="${chars[$((RANDOM % ${#chars} + 1))]}"
            else
                line+=" "
            fi
        done
        lines+=("$line")
    done
    _550w_cur_hide
    for (( i=1; i<=rows; i++ )); do print ""; done
    printf '\e[%dA' "$rows"
    local step
    for (( step=0; step<8; step++ )); do
        for (( i=1; i<=rows; i++ )); do
            printf '\r\e[38;5;%sm%s\e[0m\n' "${_550W_C[grey]}" "${lines[$i]}"
        done
        printf '\e[%dA' "$rows"
        # 下一帧
        for (( i=1; i<=rows; i++ )); do
            lines[$i]="${lines[$i]:1} "
            if (( RANDOM % 5 == 0 )); then
                lines[$i]="${chars[$((RANDOM % ${#chars} + 1))]}${lines[$i]:1}"
            fi
        done
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\e[%dB' "$rows"
    _550w_cur_reset
}

# ══════════════════ 23. 撕裂 v2 ══════════════════

_550w_anim_tear_v2() {
    local text="$1"
    local chars="▓▒░█▄▀■□▪▫"
    local len=${#text}
    local i
    for (( i=0; i<5; i++ )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            out+="${chars[$((RANDOM % ${#chars} + 1))]}"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$out"
        _550w_pause 60
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 24. 扫线偏移 ══════════════════

_550w_anim_scan_offset() {
    local text="$1"
    local cycles=8
    local c
    for (( c=0; c<cycles; c++ )); do
        local off=$(( RANDOM % 5 - 2 ))
        local prefix=""
        if (( off > 0 )); then
            prefix=$(printf '%*s' "$off" '')
        fi
        printf '\r\e[K  %s\e[38;5;%sm%s\e[0m' "$prefix" "${_550W_C[cyan]}" "$text"
        _550w_pause 50
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 25. RGB 分离 ══════════════════

_550w_anim_rgb_split() {
    local text="$1"
    local i
    for (( i=0; i<6; i++ )); do
        printf '\r\e[K  \e[38;5;196m%s\e[0m \e[38;5;46m%s\e[0m \e[38;5;45m%s\e[0m' \
            "$text" "$text" "$text"
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 26. 色块错位 ══════════════════

_550w_anim_block_shift() {
    local text="$1"
    local len=${#text}
    local i
    for (( i=0; i<5; i++ )); do
        local chars="█▓▒░"
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            out+="${chars[$(( (i + j) % 4 + 1 ))]}"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$out"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 27. 帧抖动 ══════════════════

_550w_anim_jitter() {
    local text="$1"
    local -a shifts=("  " "   " "  " " " "  ")
    local i
    for (( i=0; i<12; i++ )); do
        printf '\r\e[K%s%s\e[38;5;%sm%s\e[0m' \
            "${shifts[$((i%5+1))]}" "" "${_550W_C[cyan]}" "$text"
        _550w_pause 30
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 28. 信号丢失 ══════════════════

_550w_anim_signal_lost() {
    local text="$1"
    local -a patterns=(
        "▓░░▓░░▓░"
        "░░▓▓░░░░"
        "▓▓▓▓▓▓▓▓"
        "░░░░░░░░"
    )
    local p
    for p in "${patterns[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s  %s\e[0m' "${_550W_C[err]}" "$p" "$text"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 29. 数据损坏 ══════════════════

_550w_anim_corrupt() {
    local text="$1"
    local chars="¤§¥₩€£µ¶Ø¿¡"
    local len=${#text}
    local i
    for (( i=0; i<6; i++ )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            if (( RANDOM % 2 == 0 )); then
                out+="${chars[$((RANDOM % ${#chars} + 1))]}"
            else
                out+="${text[$j]}"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$out"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 30. 十六进制乱码 ══════════════════

_550w_anim_hex_scramble() {
    local text="$1"
    local hex="0123456789ABCDEF"
    local len=$(( ${#text} * 2 ))
    local i
    for (( i=0; i<6; i++ )); do
        local out=""
        local j
        for (( j=0; j<len; j++ )); do
            out+="${hex[$((RANDOM % 16 + 1))]}"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$out"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 31. 字符替换 ══════════════════

_550w_anim_char_replace() {
    local text="$1"
    local len=${#text}
    local chars="αβγδεζηθικλμνξοπρστυφχψω"
    local locked=0
    local i
    while (( locked < len )); do
        local out=""
        local j
        for (( j=1; j<=len; j++ )); do
            if (( j <= locked )); then
                out+="${text[$j]}"
            else
                out+="${chars[$((RANDOM % ${#chars} + 1))]}"
            fi
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$out"
        _550w_pause 60
        (( _550W_SKIP )) && break
        (( locked++ ))
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 32. 屏幕冻结 ══════════════════

_550w_anim_freeze() {
    local text="$1"
    local chars="░▒▓█"
    local len=${#text}
    local out=""
    local j
    for (( j=1; j<=len; j++ )); do
        out+="${chars[$((RANDOM % 4 + 1))]}"
    done
    printf '  \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$out"
    _550w_pause 800
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 33. 雪花噪点 ══════════════════

_550w_anim_noise() {
    local cols
    cols=$(_550w_cols)
    local chars="░▒▓·."
    local step
    for (( step=0; step<6; step++ )); do
        printf '\r\e[K  '
        local i
        for (( i=0; i<cols-4; i++ )); do
            printf '\e[38;5;%sm%s' "${_550W_C[dim]}" "${chars[$((RANDOM % ${#chars} + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 34. 水平/垂直条纹 ══════════════════

_550w_anim_h_stripes() {
    local rows="${1:-3}"
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<50; j++ )); do
            if (( (j + i) % 2 == 0 )); then
                printf '\e[38;5;%sm━' "${_550W_C[cyan]}"
            else
                printf '\e[38;5;%sm─' "${_550W_C[dim]}"
            fi
        done
        printf '\e[0m\n'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

_550w_anim_v_stripes() {
    local rows="${1:-3}"
    local cols="${2:-30}"
    local i j
    for (( i=1; i<=rows; i++ )); do
        printf '  '
        for (( j=1; j<=cols; j++ )); do
            if (( j % 3 == 0 )); then
                printf '\e[38;5;%sm│' "${_550W_C[cyan]}"
            else
                printf ' '
            fi
        done
        printf '\e[0m\n'
    done
}

# ══════════════════ 35. 干扰波纹 ══════════════════

_550w_anim_interference() {
    local text="$1"
    local i
    for (( i=0; i<6; i++ )); do
        local wave=""
        local j
        for (( j=0; j<20; j++ )); do
            local v=$(( (i + j) % 4 ))
            case $v in
                0) wave+="~" ;;
                1) wave+="≈" ;;
                2) wave+="∼" ;;
                3) wave+="~" ;;
            esac
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[0m  %s' "${_550W_C[cyan]}" "$wave" "$text"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 36. 磁带信号 ══════════════════

_550w_anim_tape() {
    local text="$1"
    local -a frames=(
        "◀◀◀◀▶▶▶▶"
        "◀◀◀▶▶▶▶▶"
        "◀◀▶▶▶▶▶▶"
        "◀▶▶▶▶▶▶▶"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m  %s' "${_550W_C[amber]}" "$f" "$text"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K %s\n' "$text"
}

# ══════════════════ 37. VHS 风格 ══════════════════

_550w_anim_vhs() {
    local text="$1"
    local i
    for (( i=0; i<4; i++ )); do
        printf '\r\e[K  \e[38;5;196mREC\e[0m ● \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$text"
        _550w_pause 400
        printf '\r\e[K  \e[38;5;196m   \e[0m   \e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$text"
        _550w_pause 300
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 38. CRT 弯曲 ══════════════════

_550w_anim_crt() {
    local text="$1"
    local -a curves=(
        "╱               ╲"
        "│               │"
        "│     $text     │"
        "│               │"
        "╲               ╱"
    )
    local c
    for c in "${curves[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$c"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 39. 老电视 ══════════════════

_550w_anim_old_tv() {
    local text="$1"
    local -a lines=(
        "░░░░░░░░░░░░░░░░"
        "░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░"
        "░▒  $text  ▒░"
        "░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░"
        "░░░░░░░░░░░░░░░░"
    )
    local l
    for l in "${lines[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[grey]}" "$l"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 40. 帧冻结闪烁 ══════════════════

_550w_anim_frame_flash() {
    local text="$1" times="${2:-5}"
    local i
    for (( i=0; i<times; i++ )); do
        printf '\r\e[K  \e[1m\e[97m%s\e[0m' "$text"
        _550w_pause 80
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$text"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 41. 进度条 v6 ══════════════════

_550w_anim_bar_basic() {
    local width="${1:-40}"
    local label="${2:-加载中}"
    local pct=0 i
    while (( pct <= 100 )); do
        local filled=$(( pct * width / 100 ))
        local bar=""
        for (( i=0; i<filled; i++ )); do bar+="█"; done
        for (( i=filled; i<width; i++ )); do bar+="░"; done
        printf '\r\e[K  \e[38;5;%sm[%s]\e[0m %3d%%  %s' \
            "${_550W_C[cyan]}" "$bar" "$pct" "$label"
        _550w_pause 30
        (( _550W_SKIP )) && break
        (( pct += 2 ))
    done
    print ""
}

_550w_anim_bar_segmented() {
    local segments="${1:-10}"
    local label="${2:-进度}"
    local seg=0 i
    while (( seg <= segments )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s ' \
            "${_550W_C[cyan]}" "$label" ""
        for (( i=1; i<=segments; i++ )); do
            if (( i <= seg )); then
                printf '\e[38;5;%sm■\e[0m' "${_550W_C[ok]}"
            else
                printf '\e[38;5;%sm□\e[0m' "${_550W_C[dim]}"
            fi
        done
        _550w_pause 100
        (( _550W_SKIP )) && break
        (( seg++ ))
    done
    print ""
}

_550w_anim_bar_multicolor() {
    local width="${1:-40}"
    local pct=0 i
    local -a colors=(46 51 45 39 135 214 208 196)
    while (( pct <= 100 )); do
        local filled=$(( pct * width / 100 ))
        printf '\r\e[K  '
        for (( i=0; i<filled; i++ )); do
            local c="${colors[$(( i % ${#colors[@]} + 1 ))]}"
            printf '\e[38;5;%sm█' "$c"
        done
        for (( i=filled; i<width; i++ )); do
            printf '\e[38;5;%sm░' "${_550W_C[dim]}"
        done
        printf '\e[0m %3d%%' "$pct"
        _550w_pause 30
        (( _550W_SKIP )) && break
        (( pct += 2 ))
    done
    print ""
}

_550w_anim_bar_dual() {
    local width="${1:-40}"
    local label="${2:-双向}"
    local pct=0 i
    while (( pct <= 100 )); do
        local half=$(( width / 2 ))
        local filled=$(( pct * half / 100 ))
        printf '\r\e[K  \e[38;5;%sm' "${_550W_C[cyan]}"
        for (( i=0; i<half-filled; i++ )); do printf '░'; done
        for (( i=0; i<filled; i++ )); do printf '█'; done
        printf '│'
        for (( i=0; i<filled; i++ )); do printf '█'; done
        for (( i=0; i<half-filled; i++ )); do printf '░'; done
        printf '\e[0m %3d%%  %s' "$pct" "$label"
        _550w_pause 30
        (( _550W_SKIP )) && break
        (( pct += 2 ))
    done
    print ""
}

_550w_anim_bar_loop() {
    local width="${1:-40}"
    local label="${2:-循环}"
    local cycle
    for (( cycle=0; cycle<3; cycle++ )); do
        local pos=0
        while (( pos < width )); do
            printf '\r\e[K  \e[38;5;%sm' "${_550W_C[cyan]}"
            local i
            for (( i=0; i<width; i++ )); do
                if (( i == pos )); then
                    printf '●'
                elif (( i > pos - 4 && i < pos )); then
                    printf '▓'
                else
                    printf '░'
                fi
            done
            printf '\e[0m  %s' "$label"
            _550w_pause 50
            (( _550W_SKIP )) && break
            (( pos++ ))
        done
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 42. 旋转器 v1~v5 ══════════════════

_550w_anim_spinner_dot() {
    local label="$1"
    local -a frames=("·" "•" "●" "•")
    local i
    for (( i=0; i<12; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${frames[$((i%4+1))]}" "$label"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$label"
}

_550w_anim_spinner_braille() {
    local label="$1"
    local -a frames=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${frames[$((i%8+1))]}" "$label"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$label"
}

_550w_anim_spinner_quarter() {
    local label="$1"
    local -a frames=(◴ ◷ ◶ ◵)
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${frames[$((i%4+1))]}" "$label"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$label"
}

_550w_anim_spinner_half() {
    local label="$1"
    local -a frames=(◐ ◓ ◑ ◒)
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${frames[$((i%4+1))]}" "$label"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$label"
}

_550w_anim_spinner_arrow() {
    local label="$1"
    local -a frames=(← ↖ ↑ ↗ → ↘ ↓ ↙)
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m %s' \
            "${_550W_C[cyan]}" "${frames[$((i%8+1))]}" "$label"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$label"
}

# ══════════════════ 43. 波浪 v2 / v3 ══════════════════

_550w_anim_wave_v2() {
    local width="${1:-40}"
    local -a bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        local i
        for (( i=1; i<=width; i++ )); do
            local v=$(( (i + step) % 8 ))
            printf '%s' "${bars[$((v+1))]}"
        done
        printf '\e[0m'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_wave_v3() {
    local width="${1:-40}"
    local -a bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
    local -a seeds
    local i
    for (( i=1; i<=width; i++ )); do
        seeds[$i]=$((RANDOM % 8))
    done
    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  '
        for (( i=1; i<=width; i++ )); do
            local v=$(( (seeds[$i] + step / 3) % 8 ))
            if (( v >= 6 )); then
                printf '\e[1m\e[97m%s\e[0m' "${bars[$((v+1))]}"
            else
                printf '\e[38;5;%sm%s' "${_550W_C[ok]}" "${bars[$((v+1))]}"
            fi
        done
        printf '\e[0m'
        _550w_pause 55
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 44. 频谱 v2 / v3 ══════════════════

_550w_anim_spectrum_v2() {
    local width="${1:-30}"
    local -a seeds
    local i
    for (( i=1; i<=width; i++ )); do
        seeds[$i]=$((RANDOM % 8))
    done
    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  '
        for (( i=1; i<=width; i++ )); do
            local v=$(( (seeds[$i] + RANDOM % 3) % 8 ))
            local color=$(( 46 + v * 4 ))
            printf '\e[38;5;%sm█\e[0m' "$color"
        done
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_spectrum_v3() {
    local width="${1:-30}"
    local -a bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
    local step
    for (( step=0; step<15; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local i
        for (( i=1; i<=width; i++ )); do
            local v=$(( RANDOM % 8 ))
            printf '%s' "${bars[$((v+1))]}"
        done
        printf '\e[0m'
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 45. 心电图 v2 / v3 ══════════════════

_550w_anim_ecg_v2() {
    local width="${1:-50}"
    local -a pattern=(
        "▁" "▁" "▂" "▄" "█" "█" "▄" "▂" "▁" "▁"
        "▁" "▁" "▂" "▁" "▁" "▁" "▁" "▁" "▁" "▁"
    )
    local plen=${#pattern[@]}
    local step i
    for (( step=0; step<30; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        for (( i=1; i<=width; i++ )); do
            printf '%s' "${pattern[$(((i + step) % plen + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 50
        (( _550W_SKIP )) && break
    done
    print ""
}

_550w_anim_ecg_v3() {
    local width="${1:-50}"
    local -a pattern=(
        "▁" "▁" "▂" "▄" "▆" "█" "▆" "▄" "▂" "▁"
        "▁" "▂" "▁" "▁" "▁" "▁" "▁" "▁" "▁" "▁"
    )
    local plen=${#pattern[@]}
    local step i
    for (( step=0; step<30; step++ )); do
        printf '\r  \e[1m\e[38;5;%sm' "${_550W_C[err]}"
        for (( i=1; i<=width; i++ )); do
            printf '%s' "${pattern[$(((i + step) % plen + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 45
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 46. 条形图动画 ══════════════════

_550w_anim_bars_grow() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(10 25 40 55 80)
    local max=0 v
    for v in "${values[@]}"; do
        (( v > max )) && max=$v
    done
    (( max == 0 )) && max=1
    local h
    for (( h=10; h>=1; h-- )); do
        printf '  '
        for v in "${values[@]}"; do
            local level=$(( v * 10 / max ))
            if (( level >= h )); then
                printf '\e[38;5;%sm█   ' "${_550W_C[ok]}"
            else
                printf '\e[38;5;%sm    ' "${_550W_C[dim]}"
            fi
        done
        printf '\e[0m\n'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    printf '  '
    for v in "${values[@]}"; do
        printf '\e[38;5;%sm%-4d' "${_550W_C[cyan]}" "$v"
    done
    printf '\e[0m\n'
}

# ══════════════════ 47. 饼图（文字版）══════════════════

_550w_anim_pie() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(30 25 20 15 10)
    local -a labels=("A" "B" "C" "D" "E")
    local -a colors=(196 214 46 51 45)
    local total=0 v
    for v in "${values[@]}"; do (( total += v )); done
    (( total == 0 )) && total=1
    print "  饼图（文字近似）："
    local i
    for (( i=1; i<=${#values[@]}; i++ )); do
        local pct=$(( values[$i] * 100 / total ))
        local blocks=$(( pct / 2 ))
        printf '  \e[38;5;%sm■\e[0m %s  ' "${colors[$((i%5+1))]}" "${labels[$i]}"
        local j
        for (( j=0; j<blocks; j++ )); do
            printf '\e[38;5;%sm█' "${colors[$((i%5+1))]}"
        done
        printf '\e[0m  %d%%\n' "$pct"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 48. 条形图 ══════════════════

_550w_anim_chart_bar() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(15 30 45 60 75 90)
    local max=0 v
    for v in "${values[@]}"; do (( v > max )) && max=$v; done
    (( max == 0 )) && max=1
    for v in "${values[@]}"; do
        local blocks=$(( v * 40 / max ))
        printf '  %4d ' "$v"
        local j
        for (( j=0; j<blocks; j++ )); do
            printf '\e[38;5;%sm▇' "${_550W_C[ok]}"
        done
        printf '\e[0m\n'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

_550w_anim_chart_bar_h() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(30 60 90 45 75)
    local max=0 v
    for v in "${values[@]}"; do (( v > max )) && max=$v; done
    (( max == 0 )) && max=1
    local h
    for (( h=8; h>=1; h-- )); do
        printf '  '
        for v in "${values[@]}"; do
            local level=$(( v * 8 / max ))
            if (( level >= h )); then
                printf '\e[38;5;%sm▇▇ ' "${_550W_C[cyan]}"
            else
                printf '   '
            fi
        done
        printf '\e[0m\n'
    done
    printf '  '
    for v in "${values[@]}"; do
        printf '\e[38;5;%sm%-3d' "${_550W_C[dim]}" "$v"
    done
    printf '\e[0m\n'
}

# ══════════════════ 49. 饼图 v2 ══════════════════

_550w_anim_chart_pie() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(30 25 20 15 10)
    local total=0 v
    for v in "${values[@]}"; do (( total += v )); done
    (( total == 0 )) && total=1
    print "  饼图："
    local i
    for (( i=1; i<=${#values[@]}; i++ )); do
        local pct=$(( values[$i] * 100 / total ))
        printf '  [%d] %3d%% ' "$i" "$pct"
        local blocks=$(( pct / 2 ))
        local j
        for (( j=0; j<blocks; j++ )); do
            printf '\e[38;5;%sm▓' "$(( 196 + i * 30 ))"
        done
        printf '\e[0m\n'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 50. 折线图 ══════════════════

_550w_anim_chart_line() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(10 25 40 30 55 70 45 80 60 90)
    local max=0 v
    for v in "${values[@]}"; do (( v > max )) && max=$v; done
    (( max == 0 )) && max=1
    local h
    for (( h=8; h>=1; h-- )); do
        printf '  '
        for v in "${values[@]}"; do
            local level=$(( v * 8 / max ))
            if (( level == h )); then
                printf '\e[38;5;%sm●' "${_550W_C[ok]}"
            elif (( level > h )); then
                printf '\e[38;5;%sm│' "${_550W_C[cyan]}"
            else
                printf ' '
            fi
        done
        printf '\e[0m\n'
    done
    printf '  '
    for v in "${values[@]}"; do printf '\e[38;5;%sm·' "${_550W_C[dim]}"; done
    printf '\e[0m\n'
}

# ══════════════════ 51. 散点图 ══════════════════

_550w_anim_chart_scatter() {
    local rows="${1:-10}" cols="${2:-40}"
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<cols; j++ )); do
            if (( RANDOM % 6 == 0 )); then
                printf '\e[38;5;%sm●' "${_550W_C[cyan]}"
            else
                printf ' '
            fi
        done
        printf '\e[0m\n'
    done
}

# ══════════════════ 52. 热力图 ══════════════════

_550w_anim_chart_heatmap() {
    local rows="${1:-8}" cols="${2:-24}"
    local chars=" ░▒▓█"
    local i j
    for (( i=1; i<=rows; i++ )); do
        printf '  '
        for (( j=1; j<=cols; j++ )); do
            local v=$(( (RANDOM % 5) + 1 ))
            local color=$(( 46 + v * 20 ))
            printf '\e[38;5;%sm%s' "$color" "${chars[$v]}"
        done
        printf '\e[0m\n'
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 53. 树图 ══════════════════

_550w_anim_chart_tree() {
    local -a data=(
        "root"
        "├── branch1"
        "│   ├── leaf1.1"
        "│   └── leaf1.2"
        "├── branch2"
        "│   ├── leaf2.1"
        "│   └── leaf2.2"
        "└── branch3"
        "    └── leaf3.1"
    )
    local l
    for l in "${data[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$l"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 54. 桑基图（简化）══════════════════

_550w_anim_chart_sankey() {
    print "  \e[38;5;46m████████\e[0m ━━━━━━━━ \e[38;5;51m██████\e[0m ━━━━━ \e[38;5;45m████\e[0m"
    _550w_pause 200
    print "  \e[38;5;46m███\e[0m ━━━━━━━━━━ \e[38;5;51m████\e[0m ━━━━━━━ \e[38;5;45m██\e[0m"
    _550w_pause 200
    print "  \e[38;5;46m██\e[0m ━━━━━━━ \e[38;5;51m███\e[0m ━━━━━━ \e[38;5;45m███\e[0m"
}

# ══════════════════ 55. 力导向图 ══════════════════

_550w_anim_chart_force() {
    local -a nodes=(
        "        ●"
        "       ╱ ╲"
        "      ●   ●"
        "     ╱ ╲ ╱ ╲"
        "    ●   ●   ●"
        "     ╲ ╱ ╲ ╱"
        "      ●   ●"
        "       ╲ ╱"
        "        ●"
    )
    local n
    for n in "${nodes[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$n"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 56. 弦图 ══════════════════

_550w_anim_chart_chord() {
    print "  \e[38;5;51m╭──────────╮\e[0m"
    print "  \e[38;5;51m│          │\e[0m"
    print "  \e[38;5;46m●──╮  ╭──●\e[0m"
    print "  \e[38;5;46m│   ╲╱   │\e[0m"
    print "  \e[38;5;214m●──╮╱╲╮──●\e[0m"
    print "  \e[38;5;214m│   ╲╱   │\e[0m"
    print "  \e[38;5;46m●──╯  ╰──●\e[0m"
    print "  \e[38;5;51m│          │\e[0m"
    print "  \e[38;5;51m╰──────────╯\e[0m"
    _550w_pause 300
}

# ══════════════════ 57. 雷达图 ══════════════════

_550w_anim_chart_radar() {
    local -a values=("$@")
    (( ${#values[@]} == 0 )) && values=(8 6 9 5 7 4)
    local labels=("A" "B" "C" "D" "E" "F")
    local i
    for (( i=1; i<=${#values[@]}; i++ )); do
        local v="${values[$i]}"
        local blocks=$(( v * 4 ))
        printf '  \e[38;5;%sm%-3s\e[0m ' "${_550W_C[cyan]}" "${labels[$i]}"
        local j
        for (( j=0; j<blocks; j++ )); do
            printf '\e[38;5;%sm◆' "${_550W_C[ok]}"
        done
        printf ' %d/10\e[0m\n' "$v"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 58. 甘特图 ══════════════════

_550w_anim_chart_gantt() {
    local -a tasks=(
        "设计    ────────────────"
        "开发        ──────────────"
        "测试            ────────"
        "部署                ────"
    )
    local t
    for t in "${tasks[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$t"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 59. 泳道图 ══════════════════

_550w_anim_chart_swimlane() {
    print "  \e[38;5;51m───┬───┬───┬───┬───\e[0m"
    print "  \e[38;5;51m L1│   │   │   │   \e[0m"
    print "  \e[38;5;51m───┼───┼───┼───┼───\e[0m"
    print "  \e[38;5;51m L2│   │   │   │   \e[0m"
    print "  \e[38;5;51m───┼───┼───┼───┼───\e[0m"
    print "  \e[38;5;51m L3│   │   │   │   \e[0m"
    print "  \e[38;5;51m───┴───┴───┴───┴───\e[0m"
    _550w_pause 300
}

# ══════════════════ 60. 流程图 ══════════════════

_550w_anim_chart_flowchart() {
    local -a steps=(
        "  ┌─────┐"
        "  │开始 │"
        "  └──┬──┘"
        "     ▼"
        "  ┌─────┐"
        "  │处理 │"
        "  └──┬──┘"
        "     ▼"
        "  ┌─────┐"
        "  │结束 │"
        "  └─────┘"
    )
    local s
    for s in "${steps[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$s"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 61. 状态机 ══════════════════

_550w_anim_chart_state() {
    print "  \e[38;5;46m┌────┐  →  \e[38;5;214m┌────┐  →  \e[38;5;196m┌────┐\e[0m"
    print "  \e[38;5;46m│IDLE│      \e[38;5;214m│RUN │      \e[38;5;196m│DONE│\e[0m"
    print "  \e[38;5;46m└────┘  ←  \e[38;5;214m└────┘  ←  \e[38;5;196m└────┘\e[0m"
    _550w_pause 300
}

# ══════════════════ 62. 时序图 ══════════════════

_550w_anim_chart_sequence() {
    local -a seq=(
        "  A         B         C"
        "  │         │         │"
        "  │── 请求 ─►│         │"
        "  │         │── 转发 ─►│"
        "  │         │         │"
        "  │         │◄─ 响应 ──│"
        "  │◄─ 返回 ──│         │"
    )
    local s
    for s in "${seq[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$s"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 63. ER 图 ══════════════════

_550w_anim_chart_er() {
    print "  \e[38;5;46m┌──────┐        ┌──────┐\e[0m"
    print "  \e[38;5;46m│ User │───1:N──│ Post │\e[0m"
    print "  \e[38;5;46m└──────┘        └──────┘\e[0m"
    print "                    │"
    print "                    │N:1"
    print "                    ▼"
    print "  \e[38;5;214m                ┌──────┐\e[0m"
    print "  \e[38;5;214m                │ Tag  │\e[0m"
    print "  \e[38;5;214m                └──────┘\e[0m"
    _550w_pause 300
}

# ══════════════════ 64. 网络图 ══════════════════

_550w_anim_chart_network() {
    local -a nodes=(
        "     ●───●───●"
        "     │   │   │"
        "     ●───●───●"
        "     │   │   │"
        "     ●───●───●"
    )
    local n
    for n in "${nodes[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$n"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 65. 树型拓扑 ══════════════════

_550w_anim_chart_tree_topology() {
    local -a tree=(
        "          ROOT"
        "         ╱ │ ╲"
        "        ●  ●  ●"
        "       ╱│╲ ╱│╲"
        "      ●● ● ●●●"
    )
    local t
    for t in "${tree[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$t"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 66. 环形拓扑 ══════════════════

_550w_anim_chart_ring_topology() {
    local -a ring=(
        "         ●"
        "       ╱   ╲"
        "      ●     ●"
        "      │     │"
        "      ●     ●"
        "       ╲   ╱"
        "         ●"
    )
    local r
    for r in "${ring[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$r"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 67. 混合拓扑 ══════════════════

_550w_anim_chart_mixed_topology() {
    print "  \e[38;5;46m●━━━●━━━●\e[0m"
    print "  \e[38;5;46m┃   ┃   ┃\e[0m"
    print "  \e[38;5;214m●━━━●━━━●\e[0m"
    print "  \e[38;5;214m┃   ┃   ┃\e[0m"
    print "  \e[38;5;51m●━━━●━━━●\e[0m"
    _550w_pause 300
}

# ══════════════════ 68. 节点连线 ══════════════════

_550w_anim_nodes_connect() {
    local n="${1:-6}"
    local i
    for (( i=1; i<=n; i++ )); do
        printf '  \e[38;5;%sm●\e[0m' "${_550W_C[ok]}"
        if (( i < n )); then
            printf ' ─── '
        fi
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 69. 数据流动 ══════════════════

_550w_anim_data_flow() {
    local width="${1:-30}"
    local -a frames=(
        "●                    "
        "  ●                  "
        "    ●                "
        "      ●              "
        "        ●            "
        "          ●          "
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$f"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 70. 数据包 ══════════════════

_550w_anim_packets() {
    local -a packets=(
        "┌──────┐"
        "│ 04 12│"
        "└──┬───┘"
        "   ▼"
        "┌──────┐"
        "│ 04 13│"
        "└──┬───┘"
        "   ▼"
        "┌──────┐"
        "│ 04 14│"
        "└──────┘"
    )
    local p
    for p in "${packets[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$p"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 71. 比特流 ══════════════════

_550w_anim_bits() {
    local width="${1:-40}"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        local j
        for (( j=0; j<width; j++ )); do
            printf '%d' "$((RANDOM % 2))"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 72. 字节流 ══════════════════

_550w_anim_bytes() {
    local width="${1:-8}"
    local hex="0123456789ABCDEF"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<width; j++ )); do
            printf '%s%s ' "${hex[$((RANDOM%16+1))]}" "${hex[$((RANDOM%16+1))]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 73. 十六进制流 ══════════════════

_550w_anim_hex_stream() {
    local rows="${1:-4}"
    local hex="0123456789ABCDEF"
    local r i
    for (( r=0; r<rows; r++ )); do
        printf '  \e[38;5;%sm%08X  \e[0m' "${_550W_C[dim]}" $((RANDOM * 4096))
        for (( i=0; i<16; i++ )); do
            printf '\e[38;5;%sm%s%s \e[0m' "${_550W_C[ok]}" \
                "${hex[$((RANDOM%16+1))]}" "${hex[$((RANDOM%16+1))]}"
        done
        print ""
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 74. 八进制 ══════════════════

_550w_anim_octal() {
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<20; j++ )); do
            printf '%d' "$((RANDOM % 8))"
        done
        printf '\e[0m'
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 75. Base64 ══════════════════

_550w_anim_base64() {
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        local j
        for (( j=0; j<30; j++ )); do
            printf '%s' "${chars[$((RANDOM % ${#chars} + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 76. 哈希 ══════════════════

_550w_anim_hash() {
    local rows="${1:-4}"
    local hex="0123456789abcdef"
    local r i
    for (( r=0; r<rows; r++ )); do
        printf '  \e[38;5;%sm' "${_550W_C[cyan]}"
        for (( i=0; i<64; i++ )); do
            printf '%s' "${hex[$((RANDOM % 16 + 1))]}"
        done
        printf '\e[0m\n'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 77. MD5 动画 ══════════════════

_550w_anim_md5() {
    local text="$1"
    local hex="0123456789abcdef"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        local j
        for (( j=0; j<32; j++ )); do
            printf '%s' "${hex[$((RANDOM % 16 + 1))]}"
        done
        printf '\e[0m  %s' "$text"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 78. 拓扑图 v6 星型 ══════════════════

_550w_anim_topology_star() {
    local -a art=(
        "         ●   ●   ●"
        "          ╲  │  ╱"
        "           ╲ │ ╱"
        "            ╲│╱"
        "        ────CORE────"
        "            ╱│╲"
        "           ╱ │ ╲"
        "          ╱  │  ╲"
        "         ●   ●   ●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 79. 拓扑图 v7 环形 ══════════════════

_550w_anim_topology_ring() {
    local -a art=(
        "        ●─────●"
        "       ╱       ╲"
        "      ●         ●"
        "      │  CORE   │"
        "      ●         ●"
        "       ╲       ╱"
        "        ●─────●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 80. 拓扑图 v8 网格 ══════════════════

_550w_anim_topology_mesh() {
    local -a art=(
        "  ●━━━●━━━●"
        "  ┃ ╳ ┃ ╳ ┃"
        "  ●━━━●━━━●"
        "  ┃ ╳ ┃ ╳ ┃"
        "  ●━━━●━━━●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 81. 拓扑图 v9 树型 ══════════════════

_550w_anim_topology_tree() {
    local -a art=(
        "          ROOT"
        "         ╱ │ ╲"
        "        N1 N2 N3"
        "       ╱│╲ ╱│╲"
        "      ●●  ●●●  ●●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 82. 拓扑图 v10 混合 ══════════════════

_550w_anim_topology_mixed() {
    local -a art=(
        "      CORE"
        "     ╱│╲"
        "    N1 N2 N3"
        "    │  ╳  │"
        "    N4─N5─N6"
        "     ╲ │ ╱"
        "      MOSS"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 90
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 83. 节点连线 v2 ══════════════════

_550w_anim_edges() {
    local n="${1:-5}"
    local i
    for (( i=1; i<=n; i++ )); do
        printf '  \e[38;5;%sm●\e[0m' "${_550W_C[ok]}"
        if (( i < n )); then
            printf '━━━'
        fi
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 84. 数据流 v2 ══════════════════

_550w_anim_flow_v2() {
    local width="${1:-30}"
    local step
    for (( step=0; step<10; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local i
        for (( i=0; i<width; i++ )); do
            if (( (i + step) % 5 == 0 )); then
                printf '▶'
            elif (( (i + step) % 5 == 1 )); then
                printf '▷'
            else
                printf '·'
            fi
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 85. 数据包 v2 ══════════════════

_550w_anim_packet_v2() {
    local text="${1:-DATA}"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm┌──────┐ \e[0m' "${_550W_C[cyan]}"
        _550w_pause 60
        printf '\r  \e[38;5;%sm│ %s │ \e[0m' "${_550W_C[cyan]}" "$text"
        _550w_pause 60
        printf '\r  \e[38;5;%sm└──────┘ \e[0m' "${_550W_C[cyan]}"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 86. 比特流 v2 ══════════════════

_550w_anim_bitstream() {
    local width="${1:-40}"
    local step
    for (( step=0; step<8; step++ )); do
        printf '\r  '
        local i
        for (( i=0; i<width; i++ )); do
            local b=$(( (i + step) % 2 ))
            if (( b == 0 )); then
                printf '\e[38;5;%sm0\e[0m' "${_550W_C[dim]}"
            else
                printf '\e[1m\e[38;5;%sm1\e[0m' "${_550W_C[ok]}"
            fi
        done
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 87. 字节流 v2 ══════════════════

_550w_anim_bytestream() {
    local width="${1:-10}"
    local hex="0123456789ABCDEF"
    local step
    for (( step=0; step<6; step++ )); do
        printf '\r  '
        local i
        for (( i=0; i<width; i++ )); do
            printf '\e[38;5;%sm%s%s \e[0m' "${_550W_C[cyan]}" \
                "${hex[$(( (i+step) % 16 + 1 ))]}" \
                "${hex[$(( (i+step+1) % 16 + 1 ))]}"
        done
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 88. 二进制 v2 ══════════════════

_550w_anim_binary_v2() {
    local rows="${1:-3}" cols="${2:-40}"
    local r i
    for (( r=0; r<rows; r++ )); do
        printf '  '
        for (( i=0; i<cols; i++ )); do
            local b=$((RANDOM % 2))
            printf '\e[38;5;%sm%s' "$(( 46 + b * 150 ))" "$b"
        done
        printf '\e[0m\n'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 89. 十六进制 v2 ══════════════════

_550w_anim_hex_v2() {
    local rows="${1:-3}" cols="${2:-16}"
    local hex="0123456789ABCDEF"
    local r i
    for (( r=0; r<rows; r++ )); do
        printf '  \e[38;5;%sm%04X  \e[0m' "${_550W_C[dim]}" $((RANDOM % 65536))
        for (( i=0; i<cols; i++ )); do
            printf '\e[38;5;%sm%s%s \e[0m' "${_550W_C[ok]}" \
                "${hex[$((RANDOM%16+1))]}" "${hex[$((RANDOM%16+1))]}"
        done
        print ""
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 90. 编码转换 ══════════════════

_550w_anim_encode() {
    local text="${1:-hello}"
    print "  \e[38;5;%sm原文：\e[0m $text" "${_550W_C[dim]}"
    _550w_pause 200
    print "  \e[38;5;%smASCII：\e[0m $(printf '%s' "$text" | od -An -c | tr -s ' ')" "${_550W_C[dim]}"
    _550w_pause 200
    print "  \e[38;5;%smHEX：\e[0m $(printf '%s' "$text" | od -An -tx1 | tr -d ' \n')" "${_550W_C[dim]}"
    _550w_pause 200
    print "  \e[38;5;%smBase64：\e[0m $(printf '%s' "$text" | base64 | tr -d '\n')" "${_550W_C[dim]}"
    _550w_pause 300
}

# ══════════════════ 91. 解码 ══════════════════

_550w_anim_decode() {
    local encoded="$1"
    print "  \e[38;5;%sm输入：\e[0m $encoded" "${_550W_C[dim]}"
    _550w_pause 200
    local decoded
    decoded=$(printf '%s' "$encoded" | base64 -d 2>/dev/null)
    print "  \e[38;5;%sm解码：\e[0m $decoded" "${_550W_C[ok]}"
    _550w_pause 300
}

# ══════════════════ 92. 压缩动画 ══════════════════

_550w_anim_compress() {
    local text="${1:-data}"
    print "  \e[38;5;%sm原始长度：\e[0m ${#text}" "${_550W_C[dim]}"
    _550w_pause 200
    local step
    for (( step=5; step>=1; step-- )); do
        printf '\r  \e[38;5;%sm压缩中... %d\e[0m' "${_550W_C[cyan]}" "$step"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm压缩后：\e[0m %d 字节\n' "${_550W_C[ok]}" "$(( ${#text} / 2 ))"
}

# ══════════════════ 93. 解压动画 ══════════════════

_550w_anim_decompress() {
    local text="${1:-data}"
    local step
    for (( step=1; step<=5; step++ )); do
        printf '\r  \e[38;5;%sm解压中... %d\e[0m' "${_550W_C[cyan]}" "$step"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm解压完成：\e[0m %s\n' "${_550W_C[ok]}" "$text"
}

# ══════════════════ 94. 加密动画 ══════════════════

_550w_anim_encrypt() {
    local text="${1:-plaintext}"
    print "  \e[38;5;%sm明文：\e[0m $text" "${_550W_C[dim]}"
    _550w_pause 150
    local i
    for (( i=0; i<4; i++ )); do
        printf '\r  \e[38;5;%sm加密中... \e[0m' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<${#text}; j++ )); do
            printf '\e[38;5;%sm*\e[0m' "${_550W_C[err]}"
        done
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    local enc=""
    local j
    for (( j=0; j<${#text}; j++ )); do
        enc+=$(printf '%02X' $((RANDOM % 256)))
    done
    printf '\r\e[K  \e[38;5;%sm密文：\e[0m %s\n' "${_550W_C[ok]}" "$enc"
}

# ══════════════════ 95. 解密动画 ══════════════════

_550w_anim_decrypt_text() {
    local enc="$1"
    print "  \e[38;5;%sm密文：\e[0m ${enc:0:32}..." "${_550W_C[dim]}"
    _550w_pause 150
    local i
    for (( i=0; i<4; i++ )); do
        printf '\r  \e[38;5;%sm解密中... \e[0m' "${_550W_C[cyan]}"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm明文：\e[0m <解密结果>\n' "${_550W_C[ok]}"
}

# ══════════════════ 96. 密钥交换 ══════════════════

_550w_anim_key_exchange() {
    local -a art=(
        "  A                              B"
        "  │ ─── 公钥 A ──────────────► │"
        "  │ ◄─── 公钥 B ─────────────── │"
        "  │                              │"
        "  │   [共享密钥 = f(A, B)]      │"
        "  │                              │"
        "  │ ─── 加密数据 ────────────► │"
    )
    local a
    for a in "${art[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 97. 非对称 RSA ══════════════════

_550w_anim_rsa() {
    print "  \e[38;5;%sm生成 RSA-2048 密钥对...\e[0m" "${_550W_C[cyan]}"
    _550w_pause 200
    local i
    for (( i=0; i<6; i++ )); do
        printf '\r  \e[38;5;%sm密钥对生成中... %d/6\e[0m' "${_550W_C[dim]}" "$i"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    print ""
    print "  \e[38;5;%sm公钥：\e[0m-----BEGIN PUBLIC KEY-----" "${_550W_C[dim]}"
    print "  \e[38;5;%sm$((RANDOM%9000+1000))...\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm私钥：\e[0m-----BEGIN PRIVATE KEY-----" "${_550W_C[dim]}"
    print "  \e[38;5;%sm$((RANDOM%9000+1000))...\e[0m" "${_550W_C[err]}"
}

# ══════════════════ 98. 对称 AES ══════════════════

_550w_anim_aes() {
    print "  \e[38;5;%smAES-256-GCM 加解密\e[0m" "${_550W_C[cyan]}"
    _550w_pause 150
    local i
    for (( i=1; i<=4; i++ )); do
        printf '\r  \e[38;5;%sm轮次 %d/14 ...\e[0m' "${_550W_C[dim]}" "$i"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    print ""
    print "  \e[38;5;%sm✓ 加密完成\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 99. 椭圆曲线 ECC ══════════════════

_550w_anim_ecc() {
    local -a art=(
        "              ●"
        "         ╱     ╲"
        "       ●         ●"
        "      ╱           ╲"
        "     ●             ●"
        "      ╲           ╱"
        "       ●         ●"
        "         ╲     ╱"
        "              ●"
    )
    print "  \e[38;5;%sm椭圆曲线 P-256\e[0m" "${_550W_C[cyan]}"
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 100. 数字签名 ══════════════════

_550w_anim_signature() {
    print "  \e[38;5;%sm[原文档]\e[0m Document A" "${_550W_C[dim]}"
    _550w_pause 150
    print "  \e[38;5;%sm计算哈希...\e[0m" "${_550W_C[cyan]}"
    local hex="0123456789abcdef"
    local hash=""
    local i
    for (( i=0; i<32; i++ )); do hash+="${hex[$((RANDOM%16+1))]}"; done
    print "  \e[38;5;%sm$hash\e[0m" "${_550W_C[ok]}"
    _550w_pause 200
    print "  \e[38;5;%sm用私钥加密哈希...\e[0m" "${_550W_C[cyan]}"
    _550w_pause 150
    print "  \e[38;5;%sm┌──────────┐\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm│ ✓ 已签名 │\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm└──────────┘\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 101. 证书链 ══════════════════

_550w_anim_cert_chain() {
    local -a chain=(
        "  ┌─────────────────┐"
        "  │  Root CA        │"
        "  └────────┬────────┘"
        "           ▼"
        "  ┌─────────────────┐"
        "  │  Intermediate   │"
        "  └────────┬────────┘"
        "           ▼"
        "  ┌─────────────────┐"
        "  │  Server Cert    │"
        "  └─────────────────┘"
    )
    local c
    for c in "${chain[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$c"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 102. TSA 时间戳 ══════════════════

_550w_anim_tsa() {
    print "  \e[38;5;%sm时间戳服务\e[0m" "${_550W_C[cyan]}"
    _550w_pause 150
    printf '  \e[38;5;%sm时间：\e[0m %s\n' "${_550W_C[dim]}" "$(date '+%Y-%m-%d %H:%M:%S')"
    _550w_pause 150
    print "  \e[38;5;%sm✓ 时间戳已签发\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 103. 随机数 RNG ══════════════════

_550w_anim_rng() {
    local hex="0123456789ABCDEF"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<32; j++ )); do
            printf '%s' "${hex[$((RANDOM%16+1))]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 104. 熵池 ══════════════════

_550w_anim_entropy() {
    local width="${1:-30}"
    local -a chars=(░ ▒ ▓ █)
    local i
    for (( i=0; i<6; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<width; j++ )); do
            printf '%s' "${chars[$((RANDOM % 4 + 1))]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 105. 量子比特 ══════════════════

_550w_anim_qubit() {
    local -a frames=(
        "  |0⟩"
        "  |+⟩"
        "  |1⟩"
        "  |-⟩"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$f"
        _550w_pause 200
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 106. 量子门 ══════════════════

_550w_anim_quantum_gate() {
    print "  \e[38;5;%sm量子门操作\e[0m" "${_550W_C[cyan]}"
    _550w_pause 100
    print "  ┌───┐"
    print "  │ H │───|0⟩ ──► (|0⟩+|1⟩)/√2"
    print "  └───┘"
    _550w_pause 150
    print "  ┌───┐"
    print "  │ X │───|0⟩ ──► |1⟩"
    print "  └───┘"
    _550w_pause 150
    print "  ┌───┐"
    print "  │ Z │───|+⟩ ──► |-⟩"
    print "  └───┘"
}

# ══════════════════ 107. 量子纠缠 ══════════════════

_550w_anim_entangle() {
    local -a frames=(
        "  ⚛            ⚛"
        "   ╲          ╱"
        "    ╲        ╱"
        "     ━━━━━━━━"
        "    ╱        ╲"
        "   ╱          ╲"
        "  ⚛            ⚛"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$f"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    print ""
}
# ══════════════════ 108. 波函数 ══════════════════

_550w_anim_wavefunction() {
    local width="${1:-40}"
    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local i
        for (( i=0; i<width; i++ )); do
            local phase=$(( (i + step * 3) % 20 ))
            if (( phase < 5 )); then printf '▁'
            elif (( phase < 10 )); then printf '▃'
            elif (( phase < 15 )); then printf '▆'
            else printf '█'
            fi
        done
        printf '\e[0m'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 109. 薛定谔猫 ══════════════════

_550w_anim_schrodinger() {
    local -a states=(
        "  ┌─────────┐"
        "  │ 🐱 ？   │"
        "  └─────────┘"
    )
    local -a final1=(
        "  ┌─────────┐"
        "  │ 🐱 活着 │"
        "  └─────────┘"
    )
    local -a final2=(
        "  ┌─────────┐"
        "  │ 💀 死了 │"
        "  └─────────┘"
    )
    local s
    for s in "${states[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$s"
        _550w_pause 200
        (( _550W_SKIP )) && break
    done
    print ""
    if (( RANDOM % 2 == 0 )); then
        for s in "${final1[@]}"; do
            printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$s"
        done
    else
        for s in "${final2[@]}"; do
            printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[err]}" "$s"
        done
    fi
}

# ══════════════════ 110. 双缝干涉 ══════════════════

_550w_anim_double_slit() {
    local -a art=(
        "  │         │         │"
        "  │    ┌────┐         │"
        "  │    │ ●  │  ●      │"
        "  │    │    │         │"
        "  │    │ ●  │      ●  │"
        "  │    └────┘         │"
        "  │         │         │"
        "  ├─────────┼─────────┤"
        "  │  ╲  ╱╲  ╱╲  ╱╲     │"
        "  │ ╲ ╱ ╲╱ ╲╱ ╲╱ ╲    │"
    )
    local a
    for a in "${art[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 111. 光子 ══════════════════

_550w_anim_photon() {
    local -a frames=(
        "  〰〰〰〰〰〰 ➤"
        "  〰〰〰〰〰〰  ➤"
        "  〰〰〰〰〰〰   ➤"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r\e[K\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$f"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 112. 电子轨道 ══════════════════

_550w_anim_electron() {
    local -a frames=(
        "        ⊙"
        "       ╱ ╲"
        "      ╱   ╲"
        "     ●     ●"
        "      ╲   ╱"
        "       ╲ ╱"
    )
    local -a frames2=(
        "        ⊙"
        "       ╱ ╲"
        "      ╱   ╲"
        "      ●   ●"
        "      ╲   ╱"
        "       ╲ ╱"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$f"
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 113. 原子 ══════════════════

_550w_anim_atom() {
    local -a art=(
        "       ╱‾‾‾╲"
        "      ╱  ●  ╲"
        "     │   ⊙   │"
        "      ╲     ╱"
        "       ╲___╱"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 114. 分子 ══════════════════

_550w_anim_molecule() {
    print "  \e[38;5;%smH   H\e[0m" "${_550W_C[cyan]}"
    print "  \e[38;5;%sm ╲ ╱\e[0m" "${_550W_C[cyan]}"
    print "  \e[38;5;%sm  O\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm ╱ ╲\e[0m" "${_550W_C[cyan]}"
    print "  \e[38;5;%smH   H\e[0m" "${_550W_C[cyan]}"
    _550w_pause 300
}

# ══════════════════ 115. 晶体晶格 ══════════════════

_550w_anim_lattice() {
    local -a art=(
        "  ●───●───●───●"
        "  │   │   │   │"
        "  ●───●───●───●"
        "  │   │   │   │"
        "  ●───●───●───●"
        "  │   │   │   │"
        "  ●───●───●───●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 116. 能带 ══════════════════

_550w_anim_band() {
    print "  \e[38;5;%sm  导带  ────────\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm  禁带  (带隙)\e[0m" "${_550W_C[dim]}"
    print "  \e[38;5;%sm  价带  ━━━━━━━━\e[0m" "${_550W_C[cyan]}"
    _550w_pause 300
}

# ══════════════════ 117. 费米面 ══════════════════

_550w_anim_fermi() {
    local -a art=(
        "        ●●●"
        "      ●●●●●●●"
        "     ●●●●●●●●●"
        "      ●●●●●●●"
        "        ●●●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 118. 自旋 ══════════════════

_550w_anim_spin() {
    local -a frames=(↑ ↗ → ↘ ↓ ↙ ← ↖)
    local i
    for (( i=0; i<16; i++ )); do
        printf '\r  \e[38;5;%sm%s\e[0m 自旋' "${_550W_C[ok]}" "${frames[$((i%8+1))]}"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 119. 磁场 ══════════════════

_550w_anim_magnetic() {
    local -a art=(
        "     ╱╱╱╱╱╱╱╱╱"
        "    ╱╱╱╱╱╱╱╱╱╱"
        "    ╲╲ N  S ╱╱"
        "    ╲╲╲╲╲╲╲╲╲╲"
        "     ╲╲╲╲╲╲╲╲╲"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 120. 电磁波 ══════════════════

_550w_anim_em_wave() {
    local width="${1:-30}"
    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  \e[38;5;%smE: \e[0m' "${_550W_C[err]}"
        local i
        for (( i=0; i<width; i++ )); do
            local v=$(( (i + step) % 12 ))
            if (( v < 3 )); then printf '╱'
            elif (( v < 6 )); then printf '─'
            elif (( v < 9 )); then printf '╲'
            else printf '─'
            fi
        done
        printf '\e[38;5;%smB: \e[0m' "${_550W_C[cyan]}"
        for (( i=0; i<width; i++ )); do
            local v=$(( (i + step + 6) % 12 ))
            if (( v < 3 )); then printf '╱'
            elif (( v < 6 )); then printf '─'
            elif (( v < 9 )); then printf '╲'
            else printf '─'
            fi
        done
        printf '\e[0m'
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 121. 声波 ══════════════════

_550w_anim_sound() {
    local -a art=(
        "   )))  声源  )))"
        "  ))))  ◉  ))))"
        "   )))  声源  )))"
    )
    local a
    for a in "${art[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "$a"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 122. 多普勒 ══════════════════

_550w_anim_doppler() {
    local -a art=(
        "      ●→"
        "    )))))"
        "   ))))))"
        "  )))))))"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 123. 干涉 ══════════════════

_550w_anim_interference_wave() {
    local width="${1:-40}"
    local step
    for (( step=0; step<15; step++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[ok]}"
        local i
        for (( i=0; i<width; i++ )); do
            local v=$(( (i * 2 + step) % 8 ))
            case $v in
                0|1) printf '▁' ;;
                2|3) printf '▃' ;;
                4|5) printf '▆' ;;
                6|7) printf '█' ;;
            esac
        done
        printf '\e[0m'
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 124. 衍射 ══════════════════

_550w_anim_diffraction() {
    local -a art=(
        "  │      │"
        "  │  ●   │"
        "  │      │"
        "  ├──────┤"
        "  ╲ ╲╲ ╲╲ ╱"
        "   ╲ ╲╲ ╲╲ ╱"
    )
    local a
    for a in "${art[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 125. 共振 ══════════════════

_550w_anim_resonance() {
    local -a art=(
        "  ╱╲    ╱╲    ╱╲"
        " ╱  ╲  ╱  ╲  ╱  ╲"
        "╱    ╲╱    ╲╱    ╲"
        "──────────────────"
        "╲    ╱╲    ╱╲    ╱"
        " ╲  ╱  ╲  ╱  ╲  ╱"
        "  ╲╱    ╲╱    ╲╱"
    )
    local a
    for a in "${art[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 126. 傅里叶变换 ══════════════════

_550w_anim_fourier() {
    print "  \e[38;5;%sm时域信号：\e[0m" "${_550W_C[cyan]}"
    print "  ▁▃▅█▇▅▃▁▁▃▅█▇▅▃▁"
    _550w_pause 200
    print "  \e[38;5;%sm↓ FFT\e[0m" "${_550W_C[dim]}"
    _550w_pause 200
    print "  \e[38;5;%sm频域：\e[0m" "${_550W_C[ok]}"
    print "  █▇▅▃▁▁▁▁▁▁▁▁▁▁▁▁"
    _550w_pause 300
}

# ══════════════════ 127. 小波变换 ══════════════════

_550w_anim_wavelet() {
    local -a art=(
        "  ╱╲    ╱╲  ╱╲╱╲"
        " ╱  ╲  ╱  ╲╱    ╲"
        "╱    ╲╱          "
    )
    local a
    for a in "${art[@]}"; do
        printf '\e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 128. 卷积 ══════════════════

_550w_anim_convolution() {
    print "  \e[38;5;%sm输入  ─┐\e[0m" "${_550W_C[cyan]}"
    print "  \e[38;5;%sm核   ─┤ * → 输出\e[0m" "${_550W_C[dim]}"
    print "  \e[38;5;%sm偏置 ─┘\e[0m" "${_550W_C[dim]}"
    _550w_pause 300
}

# ══════════════════ 129. 卡尔曼滤波 ══════════════════

_550w_anim_kalman() {
    local -a art=(
        "  真实值   ~~~~~~~"
        "  预测值   ~~~~~~~"
        "  观测值   · · · ·"
        "  卡尔曼   ━━━━━━━"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 130. 蒙特卡洛 ══════════════════

_550w_anim_monte_carlo() {
    local rows="${1:-8}" cols="${2:-20}"
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<cols; j++ )); do
            if (( RANDOM % 4 == 0 )); then
                printf '\e[38;5;%sm●\e[0m' "${_550W_C[ok]}"
            else
                printf ' '
            fi
        done
        printf '\n'
    done
}

# ══════════════════ 131. 马尔可夫链 ══════════════════

_550w_anim_markov() {
    print "  \e[38;5;46mA ──0.6──► B\e[0m"
    print "  \e[38;5;51mB ──0.4──► C\e[0m"
    print "  \e[38;5;214mC ──0.7──► A\e[0m"
    print "  \e[38;5;208mC ──0.3──► B\e[0m"
    _550w_pause 300
}

# ══════════════════ 132. 神经网络 ══════════════════

_550w_anim_nn() {
    local -a art=(
        "  ○ ○ ○"
        "  │╲│╱│"
        "  ○ ○ ○"
        "  │╲│╱│"
        "  ○ ○ ○"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 133. 前向传播 ══════════════════

_550w_anim_forward_prop() {
    local layers=4
    local l
    for (( l=1; l<=layers; l++ )); do
        printf '  \e[38;5;%sm第 %d 层：\e[0m ' "${_550W_C[cyan]}" "$l"
        local i
        for (( i=0; i<5; i++ )); do
            printf '\e[38;5;%sm●\e[0m ' "$(( 46 + i * 20 ))"
        done
        print ""
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 134. 反向传播 ══════════════════

_550w_anim_backward_prop() {
    local layers=4
    local l
    for (( l=layers; l>=1; l-- )); do
        printf '  \e[38;5;%sm梯度回流层 %d\e[0m ' "${_550W_C[err]}" "$l"
        local i
        for (( i=0; i<5; i++ )); do
            printf '▼'
        done
        print ""
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 135. 卷积网络 CNN ══════════════════

_550w_anim_cnn() {
    local -a art=(
        "  ┌───┐    ┌─┐"
        "  │███│ →  │●│"
        "  │███│    └─┘"
        "  └───┘"
        "  输入     卷积"
        ""
        "  ┌─┐    ┌──┐"
        "  │●│ →  │○│"
        "  └─┘    └──┘"
        " 池化    输出"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 136. 循环网络 RNN ══════════════════

_550w_anim_rnn() {
    local -a art=(
        "  ┌─┐  ┌─┐  ┌─┐  ┌─┐"
        "  │○│←→│○│←→│○│←→│○│"
        "  └─┘  └─┘  └─┘  └─┘"
        "   t1   t2   t3   t4"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[ok]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 137. 注意力机制 ══════════════════

_550w_anim_attention() {
    print "  \e[38;5;%smQuery\e[0m  ─── Q ────"
    print "  \e[38;5;%smKey\e[0m    ─── K ────"
    print "  \e[38;5;%smValue\e[0m  ─── V ────"
    print ""
    _550w_pause 150
    print "  \e[38;5;%smattention(Q,K,V) = softmax(QK^T/√d)V\e[0m" "${_550W_C[ok]}"
    _550w_pause 300
}

# ══════════════════ 138. Transformer ══════════════════

_550w_anim_transformer() {
    local -a art=(
        "   ┌─────────┐"
        "   │ Encoder │"
        "   └────┬────┘"
        "        ▼"
        "   ┌─────────┐"
        "   │ Decoder │"
        "   └────┬────┘"
        "        ▼"
        "     输出序列"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 139. 自编码器 ══════════════════

_550w_anim_autoencoder() {
    print "  \e[38;5;46m██████  →  ██  →  ██████\e[0m"
    print "  \e[38;5;51m  输入     潜变量    输出\e[0m"
    _550w_pause 300
}

# ══════════════════ 140. GAN ══════════════════

_550w_anim_gan() {
    print "  \e[38;5;214m┌──────┐         ┌──────┐\e[0m"
    print "  \e[38;5;214m│ 生成 │ ──假图─►│ 判别 │\e[0m"
    print "  \e[38;5;214m└──────┘         └───┬──┘\e[0m"
    print "       ▲               │"
    print "       └──── 反馈 ─────┘"
    _550w_pause 300
}

# ══════════════════ 141. 扩散模型 ══════════════════

_550w_anim_diffusion() {
    local -a frames=(
        "  ██████████  清晰"
        "  ▓▓▓▓▓▓▓▓▓▓  加噪"
        "  ▒▒▒▒▒▒▒▒▒▒  更多噪"
        "  ░░░░░░░░░░  纯噪"
    )
    local f
    for f in "${frames[@]}"; do
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "${_550W_C[cyan]}" "$f"
        _550w_pause 200
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 142. 强化学习 ══════════════════

_550w_anim_rl() {
    print "  \e[38;5;46mAgent\e[0m ──动作──► \e[38;5;214mEnvironment\e[0m"
    print "         ◄──奖励──        "
    print "         ◄──状态──        "
    _550w_pause 300
}

# ══════════════════ 143. Q-learning ══════════════════

_550w_anim_qlearning() {
    print "  \e[38;5;%smQ 表更新：\e[0m" "${_550W_C[cyan]}"
    print "  Q(s,a) ← Q(s,a) + α[r + γ·max Q(s',a') - Q(s,a)]"
    _550w_pause 300
}

# ══════════════════ 144. 策略梯度 ══════════════════

_550w_anim_policy_gradient() {
    print "  \e[38;5;%sm策略 π(a|s;θ) 更新\e[0m" "${_550W_C[cyan]}"
    print "  ∇J(θ) = E[∇log π(a|s;θ) · A(s,a)]"
    _550w_pause 300
}

# ══════════════════ 145. 遗传算法 ══════════════════

_550w_anim_genetic() {
    print "  \e[38;5;46m个体1  ██████  fit=0.82\e[0m"
    print "  \e[38;5;46m个体2  ██████  fit=0.91\e[0m"
    print "  \e[38;5;51m个体3  ██████  fit=0.75\e[0m"
    print ""
    _550w_pause 150
    print "  \e[38;5;214m交叉 + 变异...\e[0m"
    _550w_pause 200
    print "  \e[38;5;%sm新一代\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 146. 粒子群 PSO ══════════════════

_550w_anim_pso() {
    local rows=6 cols=30
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<cols; j++ )); do
            if (( RANDOM % 8 == 0 )); then
                printf '\e[38;5;%sm●\e[0m' "${_550W_C[ok]}"
            else
                printf ' '
            fi
        done
        printf '\n'
    done
    _550w_pause 200
}

# ══════════════════ 147. 蚁群 ACO ══════════════════

_550w_anim_aco() {
    local -a art=(
        "  ●━━━━━━━━━━━━━●"
        "  ┃ ╲         ╱ ┃"
        "  ┃   ●━━━━━●   ┃"
        "  ┃ ╱         ╲ ┃"
        "  ●━━━━━━━━━━━━━●"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[amber]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 148. 模拟退火 ══════════════════

_550w_anim_annealing() {
    local temps=(100 80 60 45 30 20 12 8 5 3 2 1)
    local t
    for t in "${temps[@]}"; do
        printf '\r  \e[38;5;%sm温度 T=%3d  接受率 %.2f\e[0m' \
            "${_550W_C[err]}" "$t" "$(awk -v x=$t 'BEGIN{printf "%.2f", x/100}')"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 149. 禁忌搜索 ══════════════════

_550w_anim_tabu() {
    print "  \e[38;5;%sm禁忌表\e[0m" "${_550W_C[err]}"
    print "  ┌────────────────┐"
    print "  │ [S1] [S2] [S3] │"
    print "  └────────────────┘"
    _550w_pause 200
    print "  \e[38;5;%sm邻域搜索中...\e[0m" "${_550W_C[cyan]}"
    _550w_pause 200
}

# ══════════════════ 150. 梯度下降 ══════════════════

_550w_anim_gradient_descent() {
    local steps=8
    local i
    for (( i=1; i<=steps; i++ )); do
        local h=$(( 15 - i * 2 ))
        printf '  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<h; j++ )); do printf ' '; done
        printf '●\n'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    printf '  \e[38;5;%sm━━━━━━━━━━━━━━━━ 全局最优\n\e[0m' "${_550W_C[ok]}"
}

# ══════════════════ 151. 损失曲线 ══════════════════

_550w_anim_loss_curve() {
    local -a losses=(2.5 2.1 1.8 1.4 1.1 0.9 0.7 0.5 0.4 0.3)
    local l
    for l in "${losses[@]}"; do
        local h
        h=$(awk -v x="$l" 'BEGIN{printf "%d", x * 5}')
        printf '  %-5s ' "$l"
        local i
        for (( i=0; i<h; i++ )); do
            printf '\e[38;5;%sm▇' "$(( 196 - h * 10 ))"
        done
        printf '\e[0m\n'
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 152. 准确率 ══════════════════

_550w_anim_accuracy() {
    local accs=(10 30 50 65 78 85 90 93 95 97 98 99)
    local a
    for a in "${accs[@]}"; do
        printf '\r  \e[38;5;%sm准确率: %3d%%  ' "${_550W_C[ok]}" "$a"
        local i
        local blocks=$(( a / 3 ))
        for (( i=0; i<blocks; i++ )); do
            printf '\e[38;5;%sm█' "${_550W_C[ok]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 153. 混淆矩阵 ══════════════════

_550w_anim_confusion_matrix() {
    print "  \e[38;5;%sm混淆矩阵\e[0m" "${_550W_C[cyan]}"
    print "  ┌────┬────┬────┐"
    print "  │ 85 │  3 │  2 │"
    print "  ├────┼────┼────┤"
    print "  │  5 │ 90 │  5 │"
    print "  ├────┼────┼────┤"
    print "  │  2 │  4 │ 94 │"
    print "  └────┴────┴────┘"
    _550w_pause 300
}

# ══════════════════ 154. ROC 曲线 ══════════════════

_550w_anim_roc() {
    print "  \e[38;5;%smTPR\e[0m" "${_550W_C[ok]}"
    print "  1.0 │          ╱────"
    print "  0.8 │       ╱─╯"
    print "  0.6 │     ╱─╯"
    print "  0.4 │   ╱─╯"
    print "  0.2 │ ╱─╯"
    print "  0.0 │╱─────┴─────1.0 FPR"
    _550w_pause 300
}

# ══════════════════ 155. AUC ══════════════════

_550w_anim_auc() {
    print "  \e[38;5;%smAUC = 0.92\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm██████████████████░░ 92%\e[0m" "${_550W_C[ok]}"
    _550w_pause 300
}

# ══════════════════ 156. 超参搜索 ══════════════════

_550w_anim_hpo() {
    print "  \e[38;5;%sm超参数搜索中...\e[0m" "${_550W_C[cyan]}"
    local i
    for (( i=0; i<10; i++ )); do
        printf '\r  \e[38;5;%sm尝试 %d/10  lr=%s  batch=%d\e[0m' \
            "${_550W_C[dim]}" "$i" "$(awk -v x=$((RANDOM%9+1)) 'BEGIN{printf "0.00%d", x}')" $((RANDOM%64+16))
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 157. 早停 ══════════════════

_550w_anim_early_stop() {
    print "  \e[38;5;%smEpoch 1/100  loss=1.5\e[0m" "${_550W_C[dim]}"
    print "  \e[38;5;%smEpoch 10/100 loss=1.1\e[0m" "${_550W_C[dim]}"
    print "  \e[38;5;%smEpoch 30/100 loss=0.6\e[0m" "${_550W_C[dim]}"
    print "  \e[38;5;%smEpoch 45/100 loss=0.5\e[0m" "${_550W_C[dim]}"
    _550w_pause 200
    print "  \e[38;5;%sm⚠ 无改善 5 轮，早停于 Epoch 50\e[0m" "${_550W_C[warn]}"
}

# ══════════════════ 158. 批归一化 BN ══════════════════

_550w_anim_bn() {
    print "  \e[38;5;%smBatch Norm\e[0m" "${_550W_C[cyan]}"
    print "  x → (x - μ) / √(σ² + ε) × γ + β"
    _550w_pause 300
}

# ══════════════════ 159. Dropout ═══════
 
_550w_anim_dropout() {
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  \e[38;5;%sm' "${_550W_C[cyan]}"
        local j
        for (( j=0; j<20; j++ )); do
            if (( RANDOM % 10 < 3 )); then
                printf '\e[38;5;%sm×' "${_550W_C[err]}"
            else
                printf '●'
            fi
        done
        printf '\e[0m  Dropout=0.3'
        _550w_pause 120
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 160. 残差连接 ══════════════════

_550w_anim_residual() {
    print "  \e[38;5;46m     ┌───┐\e[0m"
    print "  \e[38;5;46m  x ─┤ F ├─ + ─►\e[0m"
    print "  \e[38;5;46m     └───┘   ▲\e[0m"
    print "  \e[38;5;46m       └─────┘\e[0m"
    _550w_pause 300
}

# ══════════════════ 161. LayerNorm LN ══════════════════

_550w_anim_layernorm() {
    print "  \e[38;5;%smLayer Norm\e[0m" "${_550W_C[cyan]}"
    print "  对每个样本的特征维度归一化"
    _550w_pause 300
}
              
# ══════════════════ 162. 聚类 ══════════════════

_550w_anim_cluster() {
    local rows=8 cols=30
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<cols; j++ )); do
            if (( RANDOM % 5 == 0 )); then
                printf '\e[38;5;%sm●' "$(( 46 + RANDOM % 4 * 40 ))"
            else
                printf ' '
            fi
        done
        printf '\e[0m\n'
    done
    _550w_pause 200
}

# ══════════════════ 163. K-means ══════════════════

_550w_anim_kmeans() {
    local -a centroids=("◉" "◉" "◉")
    print "  \e[38;5;46m簇 1\e[0m  \e[38;5;51m簇 2\e[0m  \e[38;5;214m簇 3\e[0m"
    local step
    for (( step=0; step<6; step++ )); do
        printf '\r  \e[38;5;%sm迭代 %d\e[0m' "${_550W_C[cyan]}" "$step"
        _550w_pause 150
        (( _550W_SKIP )) && break
    done
    print ""
    print "  \e[38;5;%sm✓ 收敛\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 164. DBSCAN ══════════════════

_550w_anim_dbscan() {
    print "  \e[38;5;%smDBSCAN 参数：eps=0.5, minPts=5\e[0m" "${_550W_C[cyan]}"
    _550w_pause 200
    print "  \e[38;5;%sm● 核心点\e[0m" "${_550W_C[ok]}"
    print "  \e[38;5;%sm◐ 边界点\e[0m" "${_550W_C[warn]}"
    print "  \e[38;5;%sm○ 噪声点\e[0m" "${_550W_C[dim]}"
    _550w_pause 300
}

# ══════════════════ 165. 层次聚类 ══════════════════

_550w_anim_hierarchical() {
    local -a art=(
        "          ┌─────┐"
        "     ┌────┤Root ├────┐"
        "     │    └─────┘    │"
        "  ┌──┴──┐        ┌───┴───┐"
        "  A    B         C     D"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 166. PCA ══════════════════

_550w_anim_pca() {
    print "  \e[38;5;%sm主成分分析\e[0m" "${_550W_C[cyan]}"
    print "  PC1: ████████████  78%"
    print "  PC2: ████          15%"
    print "  PC3: █              5%"
    print "  PC4: ▌              2%"
    _550w_pause 300
}

# ══════════════════ 167. t-SNE ══════════════════

_550w_anim_tsne() {
    local rows=8 cols=30
    local i j
    for (( i=0; i<rows; i++ )); do
        printf '  '
        for (( j=0; j<cols; j++ )); do
            if (( RANDOM % 7 == 0 )); then
                printf '\e[38;5;%sm◆' "$(( 46 + RANDOM % 3 * 60 ))"
            else
                printf ' '
            fi
        done
        printf '\e[0m\n'
    done
    _550w_pause 200
}

# ══════════════════ 168. UMAP ══════════════════

_550w_anim_umap() {
    print "  \e[38;5;%smUMAP 降维 2D 投影\e[0m" "${_550W_C[cyan]}"
    print "  ●●●●  ●●●  ●●●●"
    print "  ●●●●  ●●●  ●●●●"
    print "    ●   ●●●   ●"
    _550w_pause 300
}

# ══════════════════ 169. 降维 ══════════════════

_550w_anim_dim_reduce() {
    print "  \e[38;5;%sm高维 (784) → 低维 (2)\e[0m" "${_550W_C[cyan]}"
    print "  ████████████████"
    print "        ↓"
    print "  ██"
    _550w_pause 300
}

# ══════════════════ 170. 特征选择 ══════════════════

_550w_anim_feature_select() {
    print "  \e[38;5;%sm特征重要性\e[0m" "${_550W_C[cyan]}"
    print "  F1 ████████████ 0.85"
    print "  F2 ██████       0.42"
    print "  F3 ████         0.28"
    print "  F4 █            0.05"
    _550w_pause 300
}

# ══════════════════ 171. 正则化 ══════════════════

_550w_anim_regularization() {
    print "  \e[38;5;%smL1 正则\e[0m  Σ|w|" "${_550W_C[cyan]}"
    print "  \e[38;5;%smL2 正则\e[0m  Σw²" "${_550W_C[cyan]}"
    print "  \e[38;5;%sm弹性网络\e[0m αL1 + (1-α)L2" "${_550W_C[cyan]}"
    _550w_pause 300
}

# ══════════════════ 172. 交叉验证 ══════════════════

_550w_anim_cv() {
    print "  \e[38;5;%sm5 折交叉验证\e[0m" "${_550W_C[cyan]}"
    local i
    for (( i=1; i<=5; i++ )); do
        printf '  Fold %d: ' "$i"
        local j
        for (( j=1; j<=5; j++ )); do
            if (( j == i )); then
                printf '\e[38;5;%sm■\e[0m' "${_550W_C[ok]}"
            else
                printf '\e[38;5;%sm□\e[0m' "${_550W_C[dim]}"
            fi
        done
        print ""
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 173. 网格搜索 ══════════════════

_550w_anim_grid_search() {
    print "  \e[38;5;%sm网格搜索\e[0m" "${_550W_C[cyan]}"
    print "        lr"
    print "        0.001 0.01 0.1"
    print "  bs  16  ·   ·   ·"
    print "      32  ·   ●   ·"
    print "      64  ·   ·   ·"
    _550w_pause 300
}

# ══════════════════ 174. 随机搜索 ══════════════════

_550w_anim_random_search() {
    print "  \e[38;5;%sm随机搜索 20 次\e[0m" "${_550W_C[cyan]}"
    local i
    for (( i=1; i<=10; i++ )); do
        printf '\r  尝试 %2d/20  acc=%.3f' "$i" "$(awk -v x=$((RANDOM%30+70)) 'BEGIN{printf "%.3f", x/100}')"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 175. 贝叶斯优化 ══════════════════

_550w_anim_bayes_opt() {
    print "  \e[38;5;%sm贝叶斯优化\e[0m" "${_550W_C[cyan]}"
    print "  采集函数: EI(x)"
    print "  代理模型: 高斯过程"
    _550w_pause 300
}

# ══════════════════ 176. 数据增强 ══════════════════

_550w_anim_data_augment() {
    print "  \e[38;5;%sm原图\e[0m" "${_550W_C[dim]}"
    print "  ██████"
    _550w_pause 150
    print "  \e[38;5;%sm翻转\e[0m" "${_550W_C[cyan]}"
    print "  ██████"
    _550w_pause 150
    print "  \e[38;5;%sm旋转\e[0m" "${_550W_C[cyan]}"
    print "  ████"
    print "   ██"
    _550w_pause 300
}

# ══════════════════ 177. 迁移学习 ══════════════════

_550w_anim_transfer_learn() {
    print "  \e[38;5;%sm预训练模型\e[0m  ████████████"
    print "        ↓ 冻结底层"
    print "  \e[38;5;%sm微调顶层\e[0m    ████"
    _550w_pause 300
}

# ══════════════════ 178. 集成学习 ══════════════════

_550w_anim_ensemble() {
    print "  \e[38;5;46m模型 1\e[0m  ██████  acc=0.85"
    print "  \e[38;5;51m模型 2\e[0m  ██████  acc=0.87"
    print "  \e[38;5;214m模型 3\e[0m  ██████  acc=0.86"
    print ""
    _550w_pause 150
    print "  \e[1m\e[38;5;%sm集成  acc=0.92\e[0m" "${_550W_C[ok]}"
}

# ══════════════════ 179. 决策树 ══════════════════

_550w_anim_decision_tree() {
    local -a art=(
        "          [F1<0.5]"
        "         ╱        ╲"
        "     [F2<0.3]   [F2<0.7]"
        "      ╱  ╲       ╱  ╲"
        "    A    B      C    D"
    )
    local a
    for a in "${art[@]}"; do
        printf '  \e[38;5;%sm%s\e[0m\n' "${_550W_C[cyan]}" "$a"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 180. 随机森林 ══════════════════

_550w_anim_random_forest() {
    print "  \e[38;5;46m树1\e[0m  \e[38;5;51m树2\e[0m  \e[38;5;214m树3\e[0m  \e[38;5;208m树4\e[0m  \e[38;5;135m树5\e[0m"
    print "   ▼     ▼     ▼     ▼     ▼"
    print "   └─────┴──┬──┴─────┴─────┘"
    print "            ▼"
    print "        投票结果"
    _550w_pause 300
}

# ══════════════════ 181. XGBoost ══════════════════

_550w_anim_xgboost() {
    print "  \e[38;5;%smXGBoost 梯度提升\e[0m" "${_550W_C[cyan]}"
    local i
    for (( i=1; i<=5; i++ )); do
        printf '  树 %d: loss=%.4f\n' "$i" "$(awk -v x=$i 'BEGIN{printf "%.4f", 1.5 / (x * 1.2)}')"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 182. SVM ══════════════════

_550w_anim_svm() {
    print "  \e[38;5;46m●●●  ●●●\e[0m"
    print "  \e[38;5;46m●●●  ●●●\e[0m"
    print "  \e[38;5;%sm════════════\e[0m ← 决策边界" "${_550W_C[ok]}"
    print "  \e[38;5;196m■■■  ■■■\e[0m"
    print "  \e[38;5;196m■■■  ■■■\e[0m"
    _550w_pause 300
}

# ══════════════════ 183. 朴素贝叶斯 ══════════════════

_550w_anim_naive_bayes() {
    print "  \e[38;5;%smP(A|B) = P(B|A)·P(A) / P(B)\e[0m" "${_550W_C[cyan]}"
    _550w_pause 300
}

# ══════════════════ 184. 逻辑回归 ══════════════════

_550w_anim_logistic() {
    print "  \e[38;5;%smSigmoid: σ(z) = 1/(1+e^(-z))\e[0m" "${_550W_C[cyan]}"
    print "  1.0 ────────────"
    print "  0.5 ──────●────"
    print "  0.0 ────────────"
    _550w_pause 300
}

# ══════════════════ 185. 线性回归 ══════════════════

_550w_anim_linear_regression() {
    print "  \e[38;5;%sm数据点 + 拟合线\e[0m" "${_550W_C[cyan]}"
    print "    ·   ·"
    print "  ·   ·   ·"
    print " ───────────── ← y = wx + b"
    print "  ·   ·"
    _550w_pause 300
}

# ══════════════════ 186. 序列标注 ══════════════════

_550w_anim_sequence_label() {
    print "  \e[38;5;%smBIO 标注\e[0m" "${_550W_C[cyan]}"
    print "  我  爱  北  京"
    print "  O  O   B  I"
    _550w_pause 300
}

# ══════════════════ 187. 命名实体 NER ══════════════════

_550w_anim_ner() {
    print "  \e[38;5;%sm识别实体\e[0m" "${_550W_C[cyan]}"
    print "  [PERSON 张三] 在 [ORG 阿里巴巴] 工作"
    _550w_pause 300
}

# ══════════════════ 188. 词向量 ══════════════════

_550w_anim_word_vector() {
    print "  \e[38;5;%sm词向量空间\e[0m" "${_550W_C[cyan]}"
    print "  国王 - 男人 + 女人 = 女王"
    print "  [0.2, -0.5, 1.3, ...]"
    _550w_pause 300
}

# ══════════════════ 189. 语言模型 ══════════════════

_550w_anim_language_model() {
    print "  \e[38;5;%sm下一个词预测\e[0m" "${_550W_C[cyan]}"
    print "  输入：今天天气"
    print "  输出：很好(0.82) 不错(0.71) 晴朗(0.65)"
    _550w_pause 300
}

# ══════════════════ 190. 序列到序列 ══════════════════

_550w_anim_seq2seq() {
    print "  \e[38;5;46m编码器\e[0m → \e[38;5;51m潜变量\e[0m → \e[38;5;214m解码器\e[0m"
    print "  输入序列         输出序列"
    _550w_pause 300
}

# ══════════════════ 191. 评估指标 ══════════════════

_550w_anim_metrics() {
    printf '  %-10s %s\n' "Accuracy" "0.92"
    printf '  %-10s %s\n' "Precision" "0.89"
    printf '  %-10s %s\n' "Recall" "0.91"
    printf '  %-10s %s\n' "F1" "0.90"
    _550w_pause 300
}

# ══════════════════ 192. 学习率调度 ══════════════════

_550w_anim_lr_schedule() {
    local steps=(0.1 0.09 0.08 0.06 0.04 0.02 0.01 0.005 0.001)
    local s
    for s in "${steps[@]}"; do
        local bars
        bars=$(awk -v x="$s" 'BEGIN{printf "%d", x * 100}')
        printf '  %-8s ' "$s"
        local i
        for (( i=0; i<bars; i++ )); do printf '█'; done
        print ""
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 193. 训练循环 ══════════════════

_550w_anim_training_loop() {
    local -a phases=("前向" "损失" "反向" "更新")
    local step
    for (( step=1; step<=3; step++ )); do
        print -P "  %F{${_550W_C[dim]}}Epoch $step/10\e[0m"
        local p
        for p in "${phases[@]}"; do
            printf '    → %s\n' "$p"
            _550w_pause 80
            (( _550W_SKIP )) && break
        done
        (( _550W_SKIP )) && break
    done
}

# ══════════════════ 194. 模型部署 ══════════════════

_550w_anim_deploy() {
    print "  \e[38;5;46m模型\e[0m → \e[38;5;51m序列化\e[0m → \e[38;5;214m服务\e[0m"
    print "  ├─ 导出 ONNX"
    print "  ├─ 量化 INT8"
    print "  ├─ 部署 API"
    print "  └─ ✓ 上线"
    _550w_pause 300
}

# ══════════════════ 195. 推理 ══════════════════

_550w_anim_inference() {
    print "  \e[38;5;%sm推理中...\e[0m" "${_550W_C[cyan]}"
    local i
    for (( i=0; i<5; i++ )); do
        printf '\r  批次 %d/5  延迟 %.0f ms' "$i" "$(awk 'BEGIN{srand(); print rand()*50+10}')"
        _550w_pause 100
        (( _550W_SKIP )) && break
    done
    print ""
}

# ══════════════════ 196. 量化 ══════════════════

_550w_anim_quantize() {
    print "  \e[38;5;%sm模型量化\e[0m" "${_550W_C[cyan]}"
    printf '  %-8s %s\n' "FP32" "████████████ 100%"
    printf '  %-8s %s\n' "FP16" "██████        50%"
    printf '  %-8s %s\n' "INT8" "███           25%"
    printf '  %-8s %s\n' "INT4" "█▌            12%"
    _550w_pause 300
}

# ══════════════════ 197. 知识蒸馏 ══════════════════

_550w_anim_distillation() {
    print "  \e[38;5;46m教师模型\e[0m (大)"
    print "       ↓ 蒸馏"
    print "  \e[38;5;51m学生模型\e[0m (小)"
    print "  准确率 0.92 → 0.89"
    _550w_pause 300
}

# ══════════════════ 198. 联邦学习 ══════════════════

_550w_anim_federated() {
    print "  \e[38;5;46m客户端 1\e[0m  \e[38;5;51m客户端 2\e[0m  \e[38;5;214m客户端 3\e[0m"
    print "      ╲        │        ╱"
    print "       ╲       │       ╱"
    print "        ╲      ▼      ╱"
    print "         集中式聚合"
    _550w_pause 300
}

# ══════════════════ 199. 图神经网络 GNN ══════════════════

_550w_anim_gnn() {
    print "  \e[38;5;46m●───●───●\e[0m"
    print "  \e[38;5;46m│   │   │\e[0m"
    print "  \e[38;5;51m●───●───●\e[0m"
    print "  消息传递 + 聚合"
    _550w_pause 300
}

# ══════════════════ 200. 提示工程 ══════════════════

_550w_anim_prompt_eng() {
    print "  \e[38;5;%sm提示词优化\e[0m" "${_550W_C[cyan]}"
    print "  v1 你是一个助手"
    print "  v2 你是一个专业助手，请严谨回答"
    print "  v3 你是专业助手，回答简洁准确，用要点"
    _550w_pause 300
}

# ══════════════════ 201. 上下文学习 ══════════════════

_550w_anim_in_context() {
    print "  \e[38;5;%smFew-shot 示例\e[0m" "${_550W_C[cyan]}"
    print "  输入: 1+1  输出: 2"
    print "  输入: 2+3  输出: 5"
    print "  输入: 3+4  输出: ?"
    _550w_pause 300
}

# ══════════════════ 202. 思维链 CoT ══════════════════

_550w_anim_cot() {
    print "  \e[38;5;%sm思维链推理\e[0m" "${_550W_C[cyan]}"
    print "  步骤 1: 分析问题"
    print "  步骤 2: 拆解子任务"
    print "  步骤 3: 逐步求解"
    print "  步骤 4: 验证结果"
    _550w_pause 300
}

# ══════════════════ 动画引擎主菜单 ══════════════════

_550w_anim_head() {
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

_550w_anim_row() {
    local num="$1" text="$2"
    printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "$num" "$text"
}

_550w_anim_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

550w-anim() {
    while true; do
        _550w_anim_head "550W 动画引擎"
        print -P "  %F{${_550W_C[dim]}}234 种动画 · 10 个分类%f"
        print ""
        _550w_anim_row "1"  "基础动画    打字/淡入/滑动/缩放/旋转"
        _550w_anim_row "2"  "强调动效    抖动/脉冲/呼吸/闪烁/扫描"
        _550w_anim_row "3"  "故障风      glitch/雪花/撕裂/噪点/VHS"
        _550w_anim_row "4"  "进度旋转    进度条5种/旋转器5种"
        _550w_anim_row "5"  "波形频谱    波浪/频谱/心电图/音频"
        _550w_anim_row "6"  "图表可视化  条形/饼/折线/散点/热力"
        _550w_anim_row "7"  "拓扑网络    5 种拓扑图 + 数据流"
        _550w_anim_row "8"  "编解码      二进制/hex/base64/哈希"
        _550w_anim_row "9"  "密码学      AES/RSA/ECC/量子"
        _550w_anim_row "10" "神经网络    CNN/RNN/Transformer"
        _550w_anim_row "11" "机器学习    K-means/PCA/损失曲线"
        _550w_anim_row "12" "列出全部    所有函数名"
        _550w_anim_row "13" "演示        播放一串动画"
        print ""
        _550w_anim_row "0"  "退出"
        print ""
        print -n "  选择 [0-13]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_anim_menu_basic ;;
            2)  _550w_anim_menu_emphasis ;;
            3)  _550w_anim_menu_glitch ;;
            4)  _550w_anim_menu_progress ;;
            5)  _550w_anim_menu_wave ;;
            6)  _550w_anim_menu_chart ;;
            7)  _550w_anim_menu_topology ;;
            8)  _550w_anim_menu_encode ;;
            9)  _550w_anim_menu_crypto ;;
            10) _550w_anim_menu_nn ;;
            11) _550w_anim_menu_ml ;;
            12) _550w_anim_list_all ;;
            13) _550w_anim_demo ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 分类菜单 ══════════════════

_550w_anim_menu_basic() {
    while true; do
        _550w_anim_head "基础动画"
        _550w_anim_row "1"  "打字机 v1"
        _550w_anim_row "2"  "打字机 v2（光标）"
        _550w_anim_row "3"  "打字机 v3（错字）"
        _550w_anim_row "4"  "淡入"
        _550w_anim_row "5"  "淡出"
        _550w_anim_row "6"  "滑动进入"
        _550w_anim_row "7"  "放大"
        _550w_anim_row "8"  "缩小"
        _550w_anim_row "9"  "旋转"
        _550w_anim_row "10" "翻转"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_typing_v1 "550W 系统启动" ;;
            2) _550w_anim_typing_v2 "550W 系统启动" ;;
            3) _550w_anim_typing_v3 "550W 系统启动" ;;
            4) _550w_anim_fade_in "淡入效果测试" ;;
            5) _550w_anim_fade_out "淡出效果测试" ;;
            6) _550w_anim_slide_in "滑动进入测试" ;;
            7) _550w_anim_zoom_in "放大测试" ;;
            8) _550w_anim_zoom_out "缩小测试" ;;
            9) _550w_anim_rotate "旋转测试" ;;
            10) _550w_anim_flip "翻转测试" ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_emphasis() {
    while true; do
        _550w_anim_head "强调动效"
        _550w_anim_row "1"  "抖动"
        _550w_anim_row "2"  "脉冲"
        _550w_anim_row "3"  "呼吸"
        _550w_anim_row "4"  "闪烁"
        _550w_anim_row "5"  "扫描"
        _550w_anim_row "6"  "擦除"
        _550w_anim_row "7"  "溶解"
        _550w_anim_row "8"  "马赛克"
        _550w_anim_row "9"  "像素化"
        _550w_anim_row "10" "边框流动"
        _550w_anim_row "11" "边框呼吸"
        _550w_anim_row "12" "蚂蚁线"
        _550w_anim_row "13" "光晕"
        _550w_anim_row "14" "高亮"
        _550w_anim_row "15" "聚焦"
        _550w_anim_row "16" "波纹"
        _550w_anim_row "17" "螺旋"
        _550w_anim_row "18" "粒子汇聚"
        _550w_anim_row "19" "粒子扩散"
        _550w_anim_row "20" "帧抖动"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_shake "抖动" ;;
            2) _550w_anim_pulse_text "脉冲" ;;
            3) _550w_anim_breathe_text "呼吸" ;;
            4) _550w_anim_blink "闪烁" ;;
            5) _550w_anim_sweep_text "扫描效果" ;;
            6) _550w_anim_wipe "擦除效果测试" ;;
            7) _550w_anim_dissolve "溶解" ;;
            8) _550w_anim_mosaic "马赛克" ;;
            9) _550w_anim_pixelate "像素化" ;;
            10) _550w_anim_border_flow "边框流动" ;;
            11) _550w_anim_border_breathe "边框呼吸" ;;
            12) _550w_anim_ant_line "蚂蚁线" ;;
            13) _550w_anim_glow "光晕" ;;
            14) _550w_anim_highlight "高亮" 2 ;;
            15) _550w_anim_focus "聚焦" ;;
            16) _550w_anim_ripple "波纹" ;;
            17) _550w_anim_spiral "螺旋" ;;
            18) _550w_anim_particles_gather "汇聚" ;;
            19) _550w_anim_particles_scatter "扩散" ;;
            20) _550w_anim_frame_shake "帧抖" ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_glitch() {
    while true; do
        _550w_anim_head "故障风"
        _550w_anim_row "1"  "glitch v2"
        _550w_anim_row "2"  "glitch v3"
        _550w_anim_row "3"  "雪花"
        _550w_anim_row "4"  "撕裂 v2"
        _550w_anim_row "5"  "扫线偏移"
        _550w_anim_row "6"  "RGB 分离"
        _550w_anim_row "7"  "色块错位"
        _550w_anim_row "8"  "帧抖动"
        _550w_anim_row "9"  "信号丢失"
        _550w_anim_row "10" "数据损坏"
        _550w_anim_row "11" "hex 乱码"
        _550w_anim_row "12" "字符替换"
        _550w_anim_row "13" "屏幕冻结"
        _550w_anim_row "14" "雪花噪点"
        _550w_anim_row "15" "水平条纹"
        _550w_anim_row "16" "垂直条纹"
        _550w_anim_row "17" "干扰波纹"
        _550w_anim_row "18" "磁带信号"
        _550w_anim_row "19" "VHS 风格"
        _550w_anim_row "20" "CRT 弯曲"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_glitch_text_v2 "SYSTEM" ;;
            2) _550w_anim_glitch_v3 "SYSTEM" ;;
            3) _550w_anim_snow ;;
            4) _550w_anim_tear_v2 "ERROR" ;;
            5) _550w_anim_scan_offset "扫描偏移" ;;
            6) _550w_anim_rgb_split "RGB" ;;
            7) _550w_anim_block_shift "色块" ;;
            8) _550w_anim_jitter "抖动" ;;
            9) _550w_anim_signal_lost "信号" ;;
            10) _550w_anim_corrupt "CORRUPT" ;;
            11) _550w_anim_hex_scramble "DATA" ;;
            12) _550w_anim_char_replace "DECODE" ;;
            13) _550w_anim_freeze "FROZEN" ;;
            14) _550w_anim_noise ;;
            15) _550w_anim_h_stripes 3 ;;
            16) _550w_anim_v_stripes 3 30 ;;
            17) _550w_anim_interference "干扰" ;;
            18) _550w_anim_tape "TAPE" ;;
            19) _550w_anim_vhs "PLAYING" ;;
            20) _550w_anim_crt "CRT" ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_progress() {
    while true; do
        _550w_anim_head "进度旋转"
        _550w_anim_row "1"  "进度条 basic"
        _550w_anim_row "2"  "进度条 segmented"
        _550w_anim_row "3"  "进度条 multicolor"
        _550w_anim_row "4"  "进度条 dual"
        _550w_anim_row "5"  "进度条 loop"
        _550w_anim_row "6"  "旋转器 dot"
        _550w_anim_row "7"  "旋转器 braille"
        _550w_anim_row "8"  "旋转器 quarter"
        _550w_anim_row "9"  "旋转器 half"
        _550w_anim_row "10" "旋转器 arrow"
        _550w_anim_row "11" "条形图生长"
        _550w_anim_row "12" "饼图"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-12]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_bar_basic 40 "加载中" ;;
            2) _550w_anim_bar_segmented 10 "进度" ;;
            3) _550w_anim_bar_multicolor 40 ;;
            4) _550w_anim_bar_dual 40 "双向" ;;
            5) _550w_anim_bar_loop 40 "循环" ;;
            6) _550w_anim_spinner_dot "处理中" ;;
            7) _550w_anim_spinner_braille "处理中" ;;
            8) _550w_anim_spinner_quarter "处理中" ;;
            9) _550w_anim_spinner_half "处理中" ;;
            10) _550w_anim_spinner_arrow "处理中" ;;
            11) _550w_anim_bars_grow 15 30 45 60 75 ;;
            12) _550w_anim_pie 30 25 20 15 10 ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_wave() {
    while true; do
        _550w_anim_head "波形频谱"
        _550w_anim_row "1"  "波浪 v2"
        _550w_anim_row "2"  "波浪 v3"
        _550w_anim_row "3"  "频谱 v2"
        _550w_anim_row "4"  "频谱 v3"
        _550w_anim_row "5"  "心电图 v2"
        _550w_anim_row "6"  "心电图 v3"
        _550w_anim_row "7"  "音频可视化"
        _550w_anim_row "8"  "波形堆叠"
        _550w_anim_row "9"  "声波"
        _550w_anim_row "10" "电磁波"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_wave_v2 40 ;;
            2) _550w_anim_wave_v3 40 ;;
            3) _550w_anim_spectrum_v2 30 ;;
            4) _550w_anim_spectrum_v3 30 ;;
            5) _550w_anim_ecg_v2 50 ;;
            6) _550w_anim_ecg_v3 50 ;;
            7) _550w_anim_audio_viz 30 ;;
            8) _550w_anim_wave_stack 30 ;;
            9) _550w_anim_sound ;;
            10) _550w_anim_em_wave 30 ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_chart() {
    while true; do
        _550w_anim_head "图表可视化"
        _550w_anim_row "1"  "条形图 横"
        _550w_anim_row "2"  "条形图 竖"
        _550w_anim_row "3"  "饼图"
        _550w_anim_row "4"  "折线图"
        _550w_anim_row "5"  "散点图"
        _550w_anim_row "6"  "热力图"
        _550w_anim_row "7"  "树图"
        _550w_anim_row "8"  "桑基图"
        _550w_anim_row "9"  "力导向图"
        _550w_anim_row "10" "弦图"
        _550w_anim_row "11" "雷达图"
        _550w_anim_row "12" "甘特图"
        _550w_anim_row "13" "泳道图"
        _550w_anim_row "14" "流程图"
        _550w_anim_row "15" "状态机"
        _550w_anim_row "16" "时序图"
        _550w_anim_row "17" "ER 图"
        _550w_anim_row "18" "网络图"
        _550w_anim_row "19" "树型拓扑"
        _550w_anim_row "20" "环形拓扑"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_chart_bar 15 30 45 60 75 90 ;;
            2) _550w_anim_chart_bar_h 30 60 90 45 75 ;;
            3) _550w_anim_chart_pie 30 25 20 15 10 ;;
            4) _550w_anim_chart_line 10 25 40 30 55 70 45 80 60 90 ;;
            5) _550w_anim_chart_scatter 10 40 ;;
            6) _550w_anim_chart_heatmap 8 24 ;;
            7) _550w_anim_chart_tree ;;
            8) _550w_anim_chart_sankey ;;
            9) _550w_anim_chart_force ;;
            10) _550w_anim_chart_chord ;;
            11) _550w_anim_chart_radar 8 6 9 5 7 4 ;;
            12) _550w_anim_chart_gantt ;;
            13) _550w_anim_chart_swimlane ;;
            14) _550w_anim_chart_flowchart ;;
            15) _550w_anim_chart_state ;;
            16) _550w_anim_chart_sequence ;;
            17) _550w_anim_chart_er ;;
            18) _550w_anim_chart_network ;;
            19) _550w_anim_chart_tree_topology ;;
            20) _550w_anim_chart_ring_topology ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_topology() {
    while true; do
        _550w_anim_head "拓扑网络"
        _550w_anim_row "1"  "拓扑图 星型"
        _550w_anim_row "2"  "拓扑图 环形"
        _550w_anim_row "3"  "拓扑图 网格"
        _550w_anim_row "4"  "拓扑图 树型"
        _550w_anim_row "5"  "拓扑图 混合"
        _550w_anim_row "6"  "节点连线"
        _550w_anim_row "7"  "数据流动"
        _550w_anim_row "8"  "数据包"
        _550w_anim_row "9"  "比特流"
        _550w_anim_row "10" "字节流"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_topology_star ;;
            2) _550w_anim_topology_ring ;;
            3) _550w_anim_topology_mesh ;;
            4) _550w_anim_topology_tree ;;
            5) _550w_anim_topology_mixed ;;
            6) _550w_anim_edges 5 ;;
            7) _550w_anim_flow_v2 30 ;;
            8) _550w_anim_packet_v2 "DATA" ;;
            9) _550w_anim_bitstream 40 ;;
            10) _550w_anim_bytestream 10 ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_encode() {
    while true; do
        _550w_anim_head "编解码"
        _550w_anim_row "1"  "二进制"
        _550w_anim_row "2"  "十六进制"
        _550w_anim_row "3"  "八进制"
        _550w_anim_row "4"  "Base64"
        _550w_anim_row "5"  "编码转换"
        _550w_anim_row "6"  "解码"
        _550w_anim_row "7"  "压缩"
        _550w_anim_row "8"  "解压"
        _550w_anim_row "9"  "哈希"
        _550w_anim_row "10" "MD5"
        _550w_anim_row "11" "随机数"
        _550w_anim_row "12" "熵池"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-12]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_binary_v2 3 40 ;;
            2) _550w_anim_hex_v2 3 16 ;;
            3) _550w_anim_octal ;;
            4) _550w_anim_base64 ;;
            5) _550w_anim_encode "hello" ;;
            6) _550w_anim_decode "aGVsbG8=" ;;
            7) _550w_anim_compress "test data" ;;
            8) _550w_anim_decompress "test data" ;;
            9) _550w_anim_hash 4 ;;
            10) _550w_anim_md5 "file.txt" ;;
            11) _550w_anim_rng ;;
            12) _550w_anim_entropy 30 ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_crypto() {
    while true; do
        _550w_anim_head "密码学"
        _550w_anim_row "1"  "加密"
        _550w_anim_row "2"  "解密"
        _550w_anim_row "3"  "密钥交换"
        _550w_anim_row "4"  "RSA"
        _550w_anim_row "5"  "AES"
        _550w_anim_row "6"  "ECC"
        _550w_anim_row "7"  "数字签名"
        _550w_anim_row "8"  "证书链"
        _550w_anim_row "9"  "TSA 时间戳"
        _550w_anim_row "10" "量子比特"
        _550w_anim_row "11" "量子门"
        _550w_anim_row "12" "量子纠缠"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-12]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_encrypt "plaintext" ;;
            2) _550w_anim_decrypt_text "encrypted" ;;
            3) _550w_anim_key_exchange ;;
            4) _550w_anim_rsa ;;
            5) _550w_anim_aes ;;
            6) _550w_anim_ecc ;;
            7) _550w_anim_signature ;;
            8) _550w_anim_cert_chain ;;
            9) _550w_anim_tsa ;;
            10) _550w_anim_qubit ;;
            11) _550w_anim_quantum_gate ;;
            12) _550w_anim_entangle ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_nn() {
    while true; do
        _550w_anim_head "神经网络"
        _550w_anim_row "1"  "神经网络"
        _550w_anim_row "2"  "前向传播"
        _550w_anim_row "3"  "反向传播"
        _550w_anim_row "4"  "CNN"
        _550w_anim_row "5"  "RNN"
        _550w_anim_row "6"  "注意力机制"
        _550w_anim_row "7"  "Transformer"
        _550w_anim_row "8"  "自编码器"
        _550w_anim_row "9"  "GAN"
        _550w_anim_row "10" "扩散模型"
        _550w_anim_row "11" "强化学习"
        _550w_anim_row "12" "Q-learning"
        _550w_anim_row "13" "策略梯度"
        _550w_anim_row "14" "遗传算法"
        _550w_anim_row "15" "粒子群"
        _550w_anim_row "16" "蚁群"
        _550w_anim_row "17" "模拟退火"
        _550w_anim_row "18" "禁忌搜索"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-18]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_nn ;;
            2) _550w_anim_forward_prop ;;
            3) _550w_anim_backward_prop ;;
            4) _550w_anim_cnn ;;
            5) _550w_anim_rnn ;;
            6) _550w_anim_attention ;;
            7) _550w_anim_transformer ;;
            8) _550w_anim_autoencoder ;;
            9) _550w_anim_gan ;;
            10) _550w_anim_diffusion ;;
            11) _550w_anim_rl ;;
            12) _550w_anim_qlearning ;;
            13) _550w_anim_policy_gradient ;;
            14) _550w_anim_genetic ;;
            15) _550w_anim_pso ;;
            16) _550w_anim_aco ;;
            17) _550w_anim_annealing ;;
            18) _550w_anim_tabu ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

_550w_anim_menu_ml() {
    while true; do
        _550w_anim_head "机器学习"
        _550w_anim_row "1"  "梯度下降"
        _550w_anim_row "2"  "损失曲线"
        _550w_anim_row "3"  "准确率"
        _550w_anim_row "4"  "混淆矩阵"
        _550w_anim_row "5"  "ROC 曲线"
        _550w_anim_row "6"  "AUC"
        _550w_anim_row "7"  "聚类"
        _550w_anim_row "8"  "K-means"
        _550w_anim_row "9"  "DBSCAN"
        _550w_anim_row "10" "层次聚类"
        _550w_anim_row "11" "PCA"
        _550w_anim_row "12" "t-SNE"
        _550w_anim_row "13" "UMAP"
        _550w_anim_row "14" "降维"
        _550w_anim_row "15" "特征选择"
        _550w_anim_row "16" "正则化"
        _550w_anim_row "17" "交叉验证"
        _550w_anim_row "18" "网格搜索"
        _550w_anim_row "19" "随机搜索"
        _550w_anim_row "20" "贝叶斯优化"
        _550w_anim_row "0"  "返回"
        print ""
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1) _550w_anim_gradient_descent ;;
            2) _550w_anim_loss_curve ;;
            3) _550w_anim_accuracy ;;
            4) _550w_anim_confusion_matrix ;;
            5) _550w_anim_roc ;;
            6) _550w_anim_auc ;;
            7) _550w_anim_cluster ;;
            8) _550w_anim_kmeans ;;
            9) _550w_anim_dbscan ;;
            10) _550w_anim_hierarchical ;;
            11) _550w_anim_pca ;;
            12) _550w_anim_tsne ;;
            13) _550w_anim_umap ;;
            14) _550w_anim_dim_reduce ;;
            15) _550w_anim_feature_select ;;
            16) _550w_anim_regularization ;;
            17) _550w_anim_cv ;;
            18) _550w_anim_grid_search ;;
            19) _550w_anim_random_search ;;
            20) _550w_anim_bayes_opt ;;
            0|"") return ;;
        esac
        _550w_anim_pause
    done
}

# ══════════════════ 列出全部 ══════════════════

_550w_anim_list_all() {
    _550w_anim_head "所有动画函数"
    local fn n=0
    for fn in ${(k)functions}; do
        case "$fn" in
            _550w_anim_*)
                (( n++ ))
                printf '  \e[38;5;%sm[%3d]\e[0m %s\n' "${_550w_C[cyan]}" "$n" "$fn"
                ;;
        esac
    done
    print ""
    print -P "  %F{${_550W_C[ok]}}共 $n 个动画函数%f"
    _550w_anim_pause
}

# ══════════════════ 演示 ══════════════════

_550w_anim_demo() {
    _550w_cls
    print ""
    _550w_anim_head "动画演示序列"
    _550w_pause 300

    _550w_anim_typing_v2 "550W 动画引擎 v1.0" 40
    _550w_pause 300
    _550w_anim_slide_in "动画演示开始" "${_550W_C[ok]}"
    _550w_pause 200

    _550w_cls
    _550w_anim_glitch_text_v2 "SYSTEM ONLINE" 8
    _550w_pause 200
    _550w_anim_scan_hv "${_550W_C[cyan]}"
    _550w_pause 200

    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B[1/5] 进度条%b%f"
    print ""
    _550w_anim_bar_basic 40 "演示"
    _550w_pause 300

    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B[2/5] 波形%b%f"
    print ""
    _550w_anim_wave_v2 40
    _550w_pause 300

    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B[3/5] 心电图%b%f"
    print ""
    _550w_anim_ecg_v2 40
    _550w_pause 300

    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B[4/5] 拓扑%b%f"
    print ""
    _550w_anim_topology_star
    _550w_pause 300

    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B[5/5] 神经网络%b%f"
    print ""
    _550w_anim_nn
    _550w_pause 300

    _550w_cls
    print ""
    _550w_anim_glitch_text_v2 "DEMO COMPLETE" 6
    print ""
    print -P "  %F{${_550W_C[ok]}}%B✓ 演示结束%b%f"
    print ""
    _550w_anim_pause
}

# ══════════════════ 加载提示 ══════════════════

# 仅在首次加载时打印（调试用）
# _550w_log debug "anim.zsh 已加载 ($(print -l _550w_anim_* | wc -l) 个动画)"
 
# ══════════════════ [修复] 帧抖动 ══════════════════

_550w_anim_frame_shake() {
    local text="$1"
    local -a offsets=(0 1 2 1 0 -1 -2 -1)
    local i
    for (( i=0; i<16; i++ )); do
        local off="${offsets[$((i % 8 + 1))]}"
        local prefix=""
        if (( off > 0 )); then
            prefix=$(printf '%*s' "$off" '')
        fi
        printf '\r\e[K  %s\e[38;5;%sm%s\e[0m' "$prefix" "${_550W_C[cyan]}" "$text"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  %s\n' "$text"
}

# ══════════════════ 开机动画管理 ══════════════════

typeset -g _550W_BOOT_DIR="${HOME}/.550w/boot_anim"
[[ -d "$_550W_BOOT_DIR" ]] || mkdir -p "$_550W_BOOT_DIR"

_550w_anim_menu_boot() {
    while true; do
        _550w_anim_head "开机动画管理"
        local n=0
        [[ -d "$_550W_BOOT_DIR" ]] && n=$(ls -1 "$_550W_BOOT_DIR"/*.zsh(N) 2>/dev/null | wc -l | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}当前开机动画：$n 个 · 目录 $_550W_BOOT_DIR%f"
        print ""
        _550w_anim_row "1" "加入动画    从动画库选一个"
        _550w_anim_row "2" "删除动画    从开机列表删一个"
        _550w_anim_row "3" "查看列表    当前所有开机动画"
        _550w_anim_row "4" "清空全部    删除所有开机动画"
        print ""
        _550w_anim_row "0" "返回"
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

# 常用动画清单（函数名|说明|参数示例）
typeset -ga _550W_BOOT_CATALOG=(
    "_550w_anim_glitch_v3|glitch 故障文字|SYSTEM 8"
    "_550w_anim_typing_v2|打字机 带光标|BOOT ANIM 40"
    "_550w_anim_typing_v3|打字机 带错字|LOADING 40"
    "_550w_anim_snow|雪花飘落|"
    "_550w_anim_tear_v2|屏幕撕裂|ERROR"
    "_550w_anim_rgb_split|RGB 分离|RGB"
    "_550w_anim_jitter|字符抖动|DATA"
    "_550w_anim_signal_lost|信号丢失|LOST"
    "_550w_anim_corrupt|数据损坏|CORRUPT"
    "_550w_anim_hex_scramble|hex 乱码|DATA"
    "_550w_anim_char_replace|字符替换|DECODE"
    "_550w_anim_vhs|VHS 风格|PLAYING"
    "_550w_anim_bar_basic|进度条 basic|"
    "_550w_anim_bar_multicolor|进度条 彩虹|"
    "_550w_anim_spinner_braille|旋转器 盲文|处理中"
    "_550w_anim_wave_v2|波浪 v2|"
    "_550w_anim_wave_v3|波浪 v3|"
    "_550w_anim_ecg_v2|心电图 v2|"
    "_550w_anim_ecg_v3|心电图 v3|"
    "_550w_anim_spectrum_v2|频谱 v2|"
    "_550w_anim_audio_viz|音频可视化|"
    "_550w_anim_binary_v2|二进制流|"
    "_550w_anim_hex_v2|十六进制流|"
    "_550w_anim_base64|Base64 流|"
    "_550w_anim_hash|哈希 4 行|"
    "_550w_anim_encrypt|加密动画|PLAIN"
    "_550w_anim_rsa|RSA 密钥|"
    "_550w_anim_aes|AES 加密|"
    "_550w_anim_signature|数字签名|"
    "_550w_anim_cert_chain|证书链|"
    "_550w_anim_qubit|量子比特|"
    "_550w_anim_quantum_gate|量子门|"
    "_550w_anim_entangle|量子纠缠|"
    "_550w_anim_cnn|CNN 卷积网络|"
    "_550w_anim_rnn|RNN 循环网络|"
    "_550w_anim_transformer|Transformer|"
    "_550w_anim_gan|GAN 对抗网络|"
    "_550w_anim_diffusion|扩散模型|"
    "_550w_anim_nn|神经网络|"
    "_550w_anim_chart_bar|条形图|15 30 45 60 75"
    "_550w_anim_chart_line|折线图|"
    "_550w_anim_chart_pie|饼图|"
    "_550w_anim_chart_heatmap|热力图|"
    "_550w_anim_topology_star|拓扑 星型|"
    "_550w_anim_topology_ring|拓扑 环形|"
    "_550w_anim_topology_mesh|拓扑 网格|"
    "_550w_anim_data_flow|数据流动|"
    "_550w_anim_packets|数据包|"
    "_550w_anim_bits|比特流|"
    "_550w_anim_gradient_descent|梯度下降|"
    "_550w_anim_loss_curve|损失曲线|"
    "_550w_anim_accuracy|准确率曲线|"
    "_550w_anim_cluster|聚类散点|"
    "_550w_anim_kmeans|K-means|"
    "_550w_anim_pca|PCA 降维|"
    "_550w_anim_tsne|t-SNE 散点|"
    "_550w_anim_ecc|椭圆曲线|"
    "_550w_anim_wavefunction|波函数|"
    "_550w_anim_photon|光子|"
    "_550w_anim_atom|原子|"
    "_550w_anim_em_wave|电磁波|"
    "_550w_anim_resonance|共振|"
)

_550w_anim_boot_add() {
    _550w_anim_head "加入开机动画"
    print -P "  %F{${_550W_C[dim]}}从下列动画里选一个加入开机流程%f"
    print ""
    local i total=${#_550W_BOOT_CATALOG[@]}
    local entry name desc
    for (( i=1; i<=total; i++ )); do
        entry="${_550W_BOOT_CATALOG[$i]}"
        name="${entry%%|*}"
        local rest="${entry#*|}"
        desc="${rest%%|*}"
        printf '  \e[38;5;%sm[%2d]\e[0m %-34s %s\n' \
            "${_550W_C[cyan]}" "$i" "$desc" "$name"
    done
    print ""
    print -P "  %F{${_550W_C[dim]}}[99] 手动输入函数名%f"
    print -P "  %F{${_550W_C[dim]}}[ 0] 取消%f"
    print ""
    print -n "  选择: "
    local c
    read -r c
    [[ -z "$c" || "$c" == "0" ]] && return

    local fn param
    if [[ "$c" == "99" ]]; then
        print -n "  函数名: "
        read -r fn
        [[ -z "$fn" ]] && return
        print -n "  参数（可空，空格分隔）: "
        read -r param
    else
        [[ "$c" =~ '^[0-9]+$' ]] || return
        (( c < 1 || c > total )) && return
        local entry="${_550W_BOOT_CATALOG[$c]}"
        fn="${entry%%|*}"
        local rest="${entry#*|}"
        param="${rest#*|}"
    fi

    # 生成文件名 99_user_NN.zsh
    local nn=1 max=0
    local f
    for f in "$_550W_BOOT_DIR"/99_user_*.zsh(N); do
        local num="${${f:t:r}#99_user_}"
        [[ "$num" =~ '^[0-9]+$' ]] && (( num > max )) && max=$num
    done
    nn=$(( max + 1 ))
    local fname
    fname=$(printf '99_user_%02d.zsh' "$nn")
    local target="$_550W_BOOT_DIR/$fname"

    # 写入文件
    {
        print "# 用户加入的动画"
        print "# 添加时间: $(date '+%Y-%m-%d %H:%M:%S')"
        print ""
        if [[ -n "$param" ]]; then
            print "${fn} ${param}"
        else
            print "${fn}"
        fi
    } > "$target"

    print ""
    print -P "  %F{${_550W_C[ok]}}✓ 已加入: $fname%f"
    print -P "  %F{${_550W_C[dim]}}内容: $(tail -1 "$target")%f"
    print -P "  %F{${_550W_C[dim]}}下次开机自动播放%f"
    sleep 1.5
}

_550w_anim_boot_list() {
    _550w_anim_head "开机动画列表"
    local -a files=("$_550W_BOOT_DIR"/*.zsh(N))
    if (( ${#files[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无开机动画）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
        read -r
        return
    fi
    local f i=0
    for f in "${files[@]}"; do
        (( i++ ))
        local content
        content=$(grep -v '^#' "$f" 2>/dev/null | grep -v '^$' | head -1)
        printf '  \e[38;5;%sm[%2d]\e[0m %-24s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$i" "${f:t}" "${_550W_C[dim]}" "$content"
    done
    print ""
    print -P "  共 ${#files[@]} 个 · 按文件名排序执行"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

_550w_anim_boot_del() {
    _550w_anim_head "删除开机动画"
    local -a files=("$_550W_BOOT_DIR"/*.zsh(N))
    if (( ${#files[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无开机动画可删）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
        read -r
        return
    fi
    local f i=0
    for f in "${files[@]}"; do
        (( i++ ))
        local content
        content=$(grep -v '^#' "$f" 2>/dev/null | grep -v '^$' | head -1)
        printf '  \e[38;5;%sm[%2d]\e[0m %-24s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$i" "${f:t}" "${_550W_C[dim]}" "$content"
    done
    print ""
    print -n "  选择要删除的编号（0 取消）: "
    local c
    read -r c
    [[ -z "$c" || "$c" == "0" ]] && return
    [[ "$c" =~ '^[0-9]+$' ]] || return
    (( c < 1 || c > ${#files[@]} )) && return

    local target="${files[$c]}"
    print ""
    print -P "  %F{${_550W_C[warn]}}将删除: ${target:t}%f"
    print -n "  确认? (y/N): "
    local yn
    read -r yn
    if [[ "$yn" == "y" || "$yn" == "Y" ]]; then
        rm -f "$target"
        print -P "  %F{${_550W_C[ok]}}✓ 已删除: ${target:t}%f"
        sleep 1
    fi
}

_550w_anim_boot_clear() {
    _550w_anim_head "清空开机动画"
    local n=0
    [[ -d "$_550W_BOOT_DIR" ]] && n=$(ls -1 "$_550W_BOOT_DIR"/*.zsh(N) 2>/dev/null | wc -l | tr -d ' ')
    if (( n == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（已经是空的）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
        read -r
        return
    fi
    print -P "  %F{${_550W_C[warn]}}将删除全部 $n 个开机动画文件%f"
    print ""
    print -n "  确认? (y/N): "
    local c
    read -r c
    if [[ "$c" == "y" || "$c" == "Y" ]]; then
        rm -f "$_550W_BOOT_DIR"/*.zsh
        print -P "  %F{${_550W_C[ok]}}✓ 已清空%f"
        sleep 1
    fi
}

# ══════════════════ 覆盖主菜单（加 [14]）══════════════════

550w-anim() {
    while true; do
        _550w_anim_head "550W 动画引擎"
        print -P "  %F{${_550W_C[dim]}}234 种动画 · 14 项菜单%f"
        print ""
        _550w_anim_row "1"  "基础动画    打字/淡入/滑动/缩放/旋转"
        _550w_anim_row "2"  "强调动效    抖动/脉冲/呼吸/闪烁/扫描"
        _550w_anim_row "3"  "故障风      glitch/雪花/撕裂/噪点/VHS"
        _550w_anim_row "4"  "进度旋转    进度条5种/旋转器5种"
        _550w_anim_row "5"  "波形频谱    波浪/频谱/心电图/音频"
        _550w_anim_row "6"  "图表可视化  条形/饼/折线/散点/热力"
        _550w_anim_row "7"  "拓扑网络    5 种拓扑图 + 数据流"
        _550w_anim_row "8"  "编解码      二进制/hex/base64/哈希"
        _550w_anim_row "9"  "密码学      AES/RSA/ECC/量子"
        _550w_anim_row "10" "神经网络    CNN/RNN/Transformer"
        _550w_anim_row "11" "机器学习    K-means/PCA/损失曲线"
        _550w_anim_row "12" "列出全部    所有函数名"
        _550w_anim_row "13" "演示        播放一串动画"
        _550w_anim_row "14" "开机动画    管理开机时播的动画"
        print ""
        _550w_anim_row "0"  "退出"
        print ""
        print -n "  选择 [0-14]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_anim_menu_basic ;;
            2)  _550w_anim_menu_emphasis ;;
            3)  _550w_anim_menu_glitch ;;
            4)  _550w_anim_menu_progress ;;
            5)  _550w_anim_menu_wave ;;
            6)  _550w_anim_menu_chart ;;
            7)  _550w_anim_menu_topology ;;
            8)  _550w_anim_menu_encode ;;
            9)  _550w_anim_menu_crypto ;;
            10) _550w_anim_menu_nn ;;
            11) _550w_anim_menu_ml ;;
            12) _550w_anim_list_all ;;
            13) _550w_anim_demo ;;
            14) _550w_anim_menu_boot ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

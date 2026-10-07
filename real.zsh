# ~/.550w/real.zsh — 550W 真实系统读取 v1.0
# 只读能读到的硬件/系统数据,读不到返回 N/A

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ CPU ══════════════════

_550w_real_cpu_model() {
    local m
    m=$(grep -m1 'model name\|Hardware\|Processor' /proc/cpuinfo 2>/dev/null | cut -d: -f2 | sed 's/^ *//')
    [[ -z "$m" ]] && m=$(grep -m1 '^Processor' /proc/cpuinfo 2>/dev/null | cut -d: -f2 | sed 's/^ *//')
    [[ -z "$m" ]] && m="N/A"
    print -n "${m:0:44}"
}

_550w_real_cpu_cores() {
    local n
    n=$(ls -d /sys/devices/system/cpu/cpu[0-9]* 2>/dev/null | wc -l | tr -d ' ')
    (( n < 1 )) && n=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)
    (( n < 1 )) && n="N/A"
    print -n "$n"
}

_550w_real_cpu_arch() {
    uname -m 2>/dev/null || print -n "N/A"
}

_550w_real_cpu_cur_freq() {
    local f
    f=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)
    if [[ -n "$f" ]]; then
        awk -v x="$f" 'BEGIN{printf "%.0f MHz", x/1000}'
    else
        print -n "N/A"
    fi
}

_550w_real_cpu_min_freq() {
    local f
    f=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 2>/dev/null)
    if [[ -n "$f" ]]; then
        awk -v x="$f" 'BEGIN{printf "%.0f MHz", x/1000}'
    else
        print -n "N/A"
    fi
}

_550w_real_cpu_max_freq() {
    local f
    f=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2>/dev/null)
    if [[ -n "$f" ]]; then
        awk -v x="$f" 'BEGIN{printf "%.0f MHz", x/1000}'
    else
        print -n "N/A"
    fi
}

_550w_real_cpu_governor() {
    local g
    g=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
    [[ -z "$g" ]] && g="N/A"
    print -n "$g"
}

_550w_real_cpu_freq_avail() {
    local list
    list=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies 2>/dev/null)
    if [[ -n "$list" ]]; then
        local n
        n=$(print "$list" | wc -w | tr -d ' ')
        print -n "$n 档"
    else
        print -n "N/A"
    fi
}

# ══════════════════ 温度 ══════════════════

_550w_real_temp_zones() {
    local n
    n=$(ls -d /sys/class/thermal/thermal_zone* 2>/dev/null | wc -l | tr -d ' ')
    (( n < 1 )) && n="N/A"
    print -n "$n"
}

_550w_real_temp_max() {
    local max=0 z t
    for z in /sys/class/thermal/thermal_zone*/temp; do
        [[ -r "$z" ]] || continue
        t=$(cat "$z" 2>/dev/null)
        [[ "$t" =~ '^[0-9]+$' ]] || continue
        (( t > max )) && max=$t
    done
    if (( max > 0 )); then
        awk -v x="$max" 'BEGIN{printf "%.1f°C", x/1000}'
    else
        print -n "N/A"
    fi
}

_550w_real_temp_avg() {
    local sum=0 cnt=0 z t
    for z in /sys/class/thermal/thermal_zone*/temp; do
        [[ -r "$z" ]] || continue
        t=$(cat "$z" 2>/dev/null)
        [[ "$t" =~ '^[0-9]+$' ]] || continue
        (( sum += t ))
        (( cnt++ ))
    done
    if (( cnt > 0 )); then
        awk -v s="$sum" -v c="$cnt" 'BEGIN{printf "%.1f°C", (s/c)/1000}'
    else
        print -n "N/A"
    fi
}

_550w_real_temp_cpu() {
    local z t type dir
    for z in /sys/class/thermal/thermal_zone*/type; do
        [[ -r "$z" ]] || continue
        type=$(cat "$z" 2>/dev/null)
        case "$type" in
            *cpu*|*CPU*|*soc*|*SoC*|*tsens*)
                dir="${z%/type}"
                t=$(cat "$dir/temp" 2>/dev/null)
                if [[ "$t" =~ '^[0-9]+$' ]]; then
                    awk -v x="$t" 'BEGIN{printf "%.1f°C", x/1000}'
                    return
                fi
                ;;
        esac
    done
    print -n "N/A"
}

_550w_real_temp_top3() {
    local -a zones=()
    local z t type
    for z in /sys/class/thermal/thermal_zone*/temp; do
        [[ -r "$z" ]] || continue
        t=$(cat "$z" 2>/dev/null)
        [[ "$t" =~ '^[0-9]+$' ]] || continue
        type=$(cat "${z%/temp}/type" 2>/dev/null)
        zones+=("$t|$type")
    done
    print -l "${zones[@]}" | sort -t'|' -k1 -rn | head -3
}

# ══════════════════ 内存 ══════════════════

_550w_real_mem_total() {
    local kb
    kb=$(grep -m1 '^MemTotal:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$kb" =~ '^[0-9]+$' ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.2f GiB", k/1048576}'
    else
        print -n "N/A"
    fi
}

_550w_real_mem_avail() {
    local kb
    kb=$(grep -m1 '^MemAvailable:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$kb" =~ '^[0-9]+$' ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.2f GiB", k/1048576}'
    else
        print -n "N/A"
    fi
}

_550w_real_mem_free() {
    local kb
    kb=$(grep -m1 '^MemFree:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$kb" =~ '^[0-9]+$' ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.2f GiB", k/1048576}'
    else
        print -n "N/A"
    fi
}

_550w_real_mem_cached() {
    local kb
    kb=$(grep -m1 '^Cached:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$kb" =~ '^[0-9]+$' ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.2f GiB", k/1048576}'
    else
        print -n "N/A"
    fi
}

_550w_real_mem_usage() {
    local total avail
    total=$(grep -m1 '^MemTotal:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    avail=$(grep -m1 '^MemAvailable:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$total" =~ '^[0-9]+$' && "$avail" =~ '^[0-9]+$' && "$total" -gt 0 ]]; then
        awk -v t="$total" -v a="$avail" 'BEGIN{printf "%.1f%%", (t-a)*100/t}'
    else
        print -n "N/A"
    fi
}

_550w_real_mem_buffers() {
    local kb
    kb=$(grep -m1 '^Buffers:' /proc/meminfo 2>/dev/null | awk '{print $2}')
    if [[ "$kb" =~ '^[0-9]+$' ]]; then
        awk -v k="$kb" 'BEGIN{printf "%.2f MiB", k/1024}'
    else
        print -n "N/A"
    fi
}

# ══════════════════ 内核/系统 ══════════════════

_550w_real_kernel() {
    uname -r 2>/dev/null | cut -c1-44 || print -n "N/A"
}

_550w_real_os() {
    uname -s 2>/dev/null || print -n "N/A"
}

_550w_real_hostname() {
    local h
    h=$(uname -n 2>/dev/null)
    [[ -z "$h" ]] && h="$HOST"
    [[ -z "$h" ]] && h="N/A"
    print -n "${h:0:32}"
}

_550w_real_uptime() {
    local secs
    secs=$(awk '{print int($1)}' /proc/uptime 2>/dev/null)
    if [[ "$secs" =~ '^[0-9]+$' ]]; then
        local d=$(( secs / 86400 ))
        local h=$(( (secs % 86400) / 3600 ))
        local m=$(( (secs % 3600) / 60 ))
        printf '%dd %dh %dm' "$d" "$h" "$m"
    else
        print -n "N/A"
    fi
}

_550w_real_uptime_sec() {
    awk '{print int($1)}' /proc/uptime 2>/dev/null || print -n "N/A"
}

_550w_real_shell() {
    print -n "${SHELL:-N/A}"
}

_550w_real_pid() {
    print -n "$$"
}

_550w_real_user() {
    local u
    u=$(id -un 2>/dev/null)
    [[ -z "$u" ]] && u="N/A"
    print -n "$u"
}

_550w_real_uid() {
    local u
    u=$(id -u 2>/dev/null)
    [[ -z "$u" ]] && u="N/A"
    print -n "$u"
}

_550w_real_term() {
    print -n "${TERM:-N/A}"
}

_550w_real_lang() {
    print -n "${LANG:-N/A}"
}

_550w_real_tz() {
    date +%Z 2>/dev/null || print -n "N/A"
}

_550w_real_datetime() {
    date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || print -n "N/A"
}

# ══════════════════ 熵池 ══════════════════

_550w_real_entropy() {
    local v
    v=$(cat /proc/sys/kernel/random/entropy_avail 2>/dev/null)
    if [[ "$v" =~ '^[0-9]+$' ]]; then
        print -n "$v bits"
    else
        print -n "N/A"
    fi
}

_550w_real_random_uuid() {
    cat /proc/sys/kernel/random/uuid 2>/dev/null || print -n "N/A"
}

# ══════════════════ 磁盘 ══════════════════

_550w_real_disk_free() {
    local v
    v=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $4}')
    [[ -z "$v" ]] && v="N/A"
    print -n "$v"
}

_550w_real_disk_used() {
    local v
    v=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $3}')
    [[ -z "$v" ]] && v="N/A"
    print -n "$v"
}

_550w_real_disk_total() {
    local v
    v=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $2}')
    [[ -z "$v" ]] && v="N/A"
    print -n "$v"
}

_550w_real_disk_usage() {
    local v
    v=$(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $5}')
    [[ -z "$v" ]] && v="N/A"
    print -n "$v"
}

_550w_real_mounts() {
    local n
    n=$(wc -l < /proc/mounts 2>/dev/null | tr -d ' ')
    [[ -z "$n" ]] && n="N/A"
    print -n "$n 个挂载点"
}

# ══════════════════ 进程 ══════════════════

_550w_real_proc_count() {
    local n
    n=$(ls -d /proc/[0-9]* 2>/dev/null | wc -l | tr -d ' ')
    (( n < 1 )) && n="N/A"
    print -n "$n"
}

# ══════════════════ 文件系统 ══════════════════

_550w_real_filesystems() {
    local n
    n=$(wc -l < /proc/filesystems 2>/dev/null | tr -d ' ')
    [[ -z "$n" ]] && n="N/A"
    print -n "$n 种"
}

_550w_real_filesystem_types() {
    local types
    types=$(awk '{print $2}' /proc/filesystems 2>/dev/null | grep -v nodev | head -5 | tr '\n' ' ')
    [[ -z "$types" ]] && types="N/A"
    print -n "$types"
}

# ══════════════════ 统一探测 ══════════════════

_550w_real_line() {
    local name="$1" value="$2"
    local color="${_550W_C[ok]}"
    [[ "$value" == "N/A" || -z "$value" ]] && color="${_550W_C[dim]}"
    printf '  \e[38;5;%sm[REAL]\e[0m %-14s \e[38;5;%sm%s\e[0m\n' \
        "${_550W_C[dim]}" "$name" "$color" "$value"
}

_550w_real_probe() {
    print -P "  %F{${_550W_C[cyan]}}%B[CPU]%f"
    _550w_real_line "型号" "$(_550w_real_cpu_model)"
    _550w_real_line "架构" "$(_550w_real_cpu_arch)"
    _550w_real_line "核心" "$(_550w_real_cpu_cores) 核"
    _550w_real_line "当前频率" "$(_550w_real_cpu_cur_freq)"
    _550w_real_line "最小频率" "$(_550w_real_cpu_min_freq)"
    _550w_real_line "最大频率" "$(_550w_real_cpu_max_freq)"
    _550w_real_line "调度器" "$(_550w_real_cpu_governor)"
    _550w_real_line "可用档位" "$(_550w_real_cpu_freq_avail)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B[温度]%f"
    _550w_real_line "传感器数" "$(_550w_real_temp_zones)"
    _550w_real_line "CPU 温度" "$(_550w_real_temp_cpu)"
    _550w_real_line "最高温" "$(_550w_real_temp_max)"
    _550w_real_line "平均温" "$(_550w_real_temp_avg)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B[内存]%f"
    _550w_real_line "总量" "$(_550w_real_mem_total)"
    _550w_real_line "可用" "$(_550w_real_mem_avail)"
    _550w_real_line "空闲" "$(_550w_real_mem_free)"
    _550w_real_line "缓存" "$(_550w_real_mem_cached)"
    _550w_real_line "使用率" "$(_550w_real_mem_usage)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B[系统]%f"
    _550w_real_line "内核" "$(_550w_real_kernel)"
    _550w_real_line "OS" "$(_550w_real_os)"
    _550w_real_line "主机名" "$(_550w_real_hostname)"
    _550w_real_line "运行时长" "$(_550w_real_uptime)"
    _550w_real_line "Shell" "$(_550w_real_shell)"
    _550w_real_line "用户" "$(_550w_real_user)"
    _550w_real_line "终端" "$(_550w_real_term)"
    _550w_real_line "语言" "$(_550w_real_lang)"
    _550w_real_line "时区" "$(_550w_real_tz)"
    _550w_real_line "时间" "$(_550w_real_datetime)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B[磁盘]%f"
    _550w_real_line "总量" "$(_550w_real_disk_total)"
    _550w_real_line "已用" "$(_550w_real_disk_used)"
    _550w_real_line "剩余" "$(_550w_real_disk_free)"
    _550w_real_line "使用率" "$(_550w_real_disk_usage)"
    _550w_real_line "挂载点" "$(_550w_real_mounts)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B[其它]%f"
    _550w_real_line "熵池" "$(_550w_real_entropy)"
    _550w_real_line "进程数" "$(_550w_real_proc_count)"
    _550w_real_line "文件系统" "$(_550w_real_filesystems)"
    _550w_real_line "PID" "$(_550w_real_pid)"
    _550w_real_line "UID" "$(_550w_real_uid)"
}

# ══════════════════ 550w-real 命令 ══════════════════

_550w_real_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

550w-real() {
    while true; do
        _550w_cls
        print -P "  %F{${_550W_C[cyan]}}%B╔══════════════════════════════════════════╗%b%f"
        print -P "  %F{${_550W_C[cyan]}}%B║%f   %F{${_550W_C[bright]}}%B550W 真实系统读取%b%f                  %F{${_550W_C[cyan]}}%B║%f"
        print -P "  %F{${_550W_C[cyan]}}%B╚══════════════════════════════════════════╝%b%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}所有数据均来自真实系统文件%f"
        print ""
        printf '  \e[38;5;%sm[1]\e[0m 完整探测    全部真实数据\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[2]\e[0m CPU         型号/核心/频率\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[3]\e[0m 温度        传感器读数\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[4]\e[0m 内存        总量/可用/使用率\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[5]\e[0m 系统        内核/主机/运行时长\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[6]\e[0m 磁盘        容量/使用率\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[7]\e[0m 温度 top3   最高的三个传感器\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[8]\e[0m 导出        保存到文件\n' "${_550W_C[cyan]}"
        print ""
        printf '  \e[38;5;%sm[0]\e[0m 退出\n' "${_550W_C[dim]}"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_real_probe_all ;;
            2) _550w_real_show_cpu ;;
            3) _550w_real_show_temp ;;
            4) _550w_real_show_mem ;;
            5) _550w_real_show_sys ;;
            6) _550w_real_show_disk ;;
            7) _550w_real_show_top3 ;;
            8) _550w_real_export ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

_550w_real_probe_all() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 完整真实探测 ══%b%f"
    print ""
    _550w_real_probe
    _550w_real_pause
}

_550w_real_show_cpu() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ CPU ══%b%f"
    print ""
    _550w_real_line "型号" "$(_550w_real_cpu_model)"
    _550w_real_line "架构" "$(_550w_real_cpu_arch)"
    _550w_real_line "核心" "$(_550w_real_cpu_cores) 核"
    _550w_real_line "当前频率" "$(_550w_real_cpu_cur_freq)"
    _550w_real_line "最小频率" "$(_550w_real_cpu_min_freq)"
    _550w_real_line "最大频率" "$(_550w_real_cpu_max_freq)"
    _550w_real_line "调度器" "$(_550w_real_cpu_governor)"
    _550w_real_line "可用档位" "$(_550w_real_cpu_freq_avail)"
    _550w_real_pause
}

_550w_real_show_temp() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 温度传感器 ══%b%f"
    print ""
    _550w_real_line "传感器数" "$(_550w_real_temp_zones)"
    _550w_real_line "CPU 温度" "$(_550w_real_temp_cpu)"
    _550w_real_line "最高温" "$(_550w_real_temp_max)"
    _550w_real_line "平均温" "$(_550w_real_temp_avg)"
    _550w_real_pause
}

_550w_real_show_mem() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 内存 ══%b%f"
    print ""
    _550w_real_line "总量" "$(_550w_real_mem_total)"
    _550w_real_line "可用" "$(_550w_real_mem_avail)"
    _550w_real_line "空闲" "$(_550w_real_mem_free)"
    _550w_real_line "缓存" "$(_550w_real_mem_cached)"
    _550w_real_line "缓冲区" "$(_550w_real_mem_buffers)"
    _550w_real_line "使用率" "$(_550w_real_mem_usage)"
    _550w_real_pause
}

_550w_real_show_sys() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 系统 ══%b%f"
    print ""
    _550w_real_line "内核" "$(_550w_real_kernel)"
    _550w_real_line "OS" "$(_550w_real_os)"
    _550w_real_line "主机名" "$(_550w_real_hostname)"
    _550w_real_line "运行时长" "$(_550w_real_uptime)"
    _550w_real_line "Shell" "$(_550w_real_shell)"
    _550w_real_line "用户" "$(_550w_real_user)"
    _550w_real_line "UID" "$(_550w_real_uid)"
    _550w_real_line "PID" "$(_550w_real_pid)"
    _550w_real_line "终端" "$(_550w_real_term)"
    _550w_real_line "语言" "$(_550w_real_lang)"
    _550w_real_line "时区" "$(_550w_real_tz)"
    _550w_real_line "时间" "$(_550w_real_datetime)"
    _550w_real_pause
}

_550w_real_show_disk() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 磁盘 ══%b%f"
    print ""
    _550w_real_line "总量" "$(_550w_real_disk_total)"
    _550w_real_line "已用" "$(_550w_real_disk_used)"
    _550w_real_line "剩余" "$(_550w_real_disk_free)"
    _550w_real_line "使用率" "$(_550w_real_disk_usage)"
    _550w_real_line "挂载点" "$(_550w_real_mounts)"
    _550w_real_line "文件系统" "$(_550w_real_filesystems)"
    _550w_real_line "类型" "$(_550w_real_filesystem_types)"
    _550w_real_pause
}

_550w_real_show_top3() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══ 温度 Top 3 ══%b%f"
    print ""
    local line t type temp
    _550w_real_temp_top3 | while IFS='|' read -r t type; do
        temp=$(awk -v x="$t" 'BEGIN{printf "%.1f°C", x/1000}')
        printf '  \e[38;5;%sm[REAL]\e[0m %-24s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[dim]}" "${type:-(未知)}" "${_550W_C[err]}" "$temp"
    done
    _550w_real_pause
}

_550w_real_export() {
    local dest="${HOME}/.550w/backups/real_$(date +%Y%m%d_%H%M%S).txt"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"
    {
        print "550W 真实系统数据导出"
        print "时间: $(date '+%Y-%m-%d %H:%M:%S')"
        print "═══════════════════════════════"
        print ""
        print "[CPU]"
        print "型号: $(_550w_real_cpu_model)"
        print "架构: $(_550w_real_cpu_arch)"
        print "核心: $(_550w_real_cpu_cores) 核"
        print "当前频率: $(_550w_real_cpu_cur_freq)"
        print "最小频率: $(_550w_real_cpu_min_freq)"
        print "最大频率: $(_550w_real_cpu_max_freq)"
        print "调度器: $(_550w_real_cpu_governor)"
        print "可用档位: $(_550w_real_cpu_freq_avail)"
        print ""
        print "[温度]"
        print "传感器数: $(_550w_real_temp_zones)"
        print "CPU 温度: $(_550w_real_temp_cpu)"
        print "最高温: $(_550w_real_temp_max)"
        print "平均温: $(_550w_real_temp_avg)"
        print ""
        print "[内存]"
        print "总量: $(_550w_real_mem_total)"
        print "可用: $(_550w_real_mem_avail)"
        print "空闲: $(_550w_real_mem_free)"
        print "使用率: $(_550w_real_mem_usage)"
        print ""
        print "[系统]"
        print "内核: $(_550w_real_kernel)"
        print "主机名: $(_550w_real_hostname)"
        print "运行时长: $(_550w_real_uptime)"
        print "Shell: $(_550w_real_shell)"
        print "用户: $(_550w_real_user)"
        print "时区: $(_550w_real_tz)"
        print ""
        print "[磁盘]"
        print "总量: $(_550w_real_disk_total)"
        print "剩余: $(_550w_real_disk_free)"
        print "使用率: $(_550w_real_disk_usage)"
        print "挂载点: $(_550w_real_mounts)"
        print ""
        print "[其它]"
        print "熵池: $(_550w_real_entropy)"
        print "进程数: $(_550w_real_proc_count)"
        print "文件系统: $(_550w_real_filesystems)"
    } > "$dest"
    print -P "  %F{${_550W_C[ok]}}✓ 已导出: ${dest:t}%f"
    sleep 1.5
}

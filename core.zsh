# ~/.550w_login_v1.zsh — 550W 超算接管系统 v1.0
# 核心文件
# 模块：配置 / 视觉 / 硬件 / MOSS / 认证 / 命令
# 作者：Trans
# 协议：MIT

# ══════════════════ 防重复加载 ══════════════════
# _550W_RELOAD=1 时强制重载，忽略已加载标记
if [[ "${_550W_RELOAD:-0}" != "1" ]] && (( ${+_550W_LOADED} )); then
    return 0
fi
unset _550W_LOADED 2>/dev/null
typeset -g _550W_LOADED=1

# ══════════════════ 模块加载 ══════════════════
# 必须：datetime（EPOCHREALTIME / strftime）
# 可选：parameter（参数展开）/ zutil（辅助）
zmodload zsh/datetime 2>/dev/null
zmodload zsh/parameter 2>/dev/null
zmodload zsh/zutil 2>/dev/null

# 确保 printf 支持 %()T 时间格式（zsh 4.3+ 自带）

# ══════════════════ 版本 ══════════════════
# 唯一版本号，禁止在文件其它位置再定义
typeset -g _550W_VERSION="v1.0"
typeset -g _550W_BUILD_DATE="$(date '+%Y-%m-%d')"

# ══════════════════ 密码 ══════════════════
# 优先读 ~/.550w_pass，读不到用默认值
typeset -g _550W_PASS_FILE="${HOME}/.550w/.550w_pass"
typeset -g _550W_PASS="563214789"
if [[ -r "$_550W_PASS_FILE" ]]; then
    _550W_PASS="$(< "$_550W_PASS_FILE")"
    _550W_PASS="${_550W_PASS%$'\n'}"
fi

# ══════════════════ 功能开关 ══════════════════
# 1 = 开，0 = 关；可被环境变量覆盖
typeset -g _550W_MOSS_ENABLED="${_550W_MOSS_ENABLED:-1}"

# ══════════════════ 认证参数 ══════════════════
typeset -g _550W_MAX_ATTEMPTS=3              # 密码最大尝试次数
typeset -g _550W_READ_TIMEOUT=30             # 单次输入超时（秒）
typeset -g _550W_READY_DELAY=0.6             # 启动后延迟（秒）
typeset -g _550W_HEARTBEAT_INTERVAL=60       # 心跳间隔（秒）
typeset -g _550W_IDLE_LOCKOUT=1800           # 空闲锁定（秒）
typeset -g _550W_CMD_TIMING_THRESHOLD=5      # 命令耗时告警阈值（秒）
typeset -g _550W_PW_MASK_MAX=12              # 掩码最大显示长度
typeset -g _550W_COOLDOWN_ATTEMPTS=5         # 触发冷却的失败次数
typeset -g _550W_COOLDOWN_SECONDS=60         # 冷却时长（秒）

# ══════════════════ 界面参数 ══════════════════
typeset -g _550W_SPEED="${_550W_SPEED:-normal}"           # 速度级别
typeset -g _550W_MODE_ANIM="${_550W_MODE_ANIM:-performance}"  # 动画模式
typeset -g _550W_BEEP="${_550W_BEEP:-0}"                  # 蜂鸣开关
typeset -g _550W_COLORS="${_550W_COLORS:-1}"              # 彩色开关
typeset -g _550W_CURSOR_CTL="${_550W_CURSOR_CTL:-1}"      # 光标控制
typeset -g _550W_LOG_LEVEL="${_550W_LOG_LEVEL:-3}"        # 日志等级 1-4
typeset -g _550W_FX="${_550W_FX:-1}"                      # 特效开关

# ══════════════════ 速度 5 级 ══════════════════
# flash   极快（30%）  —— 闪现类：glitch / 撕裂 / 雪花
# fast    快  （60%）  —— 扫描类：扫描线 / BIOS POST
# normal  标准（100%） —— 默认
# slow    慢  （180%） —— 仪式类：授权 / SID 解密
# hold    定格（0%）   —— 不缩放，等用户按键或超时
typeset -gA _550W_SPEED_LEVEL=(
    flash  30
    fast   60
    normal 100
    slow   180
    hold   0
)

# ══════════════════ 配色表 ══════════════════
# 全部使用 256 色号，输出时用 \e[38;5;Nm 标准写法
typeset -gA _550W_C=(
    cyan   51
    blue   45
    amber  214
    orange 208
    red    196
    white  231
    grey   245
    dim    240
    ok     46
    warn   220
    err    196
    bright 231
)

# ══════════════════ 运行时状态 ══════════════════
typeset -gx _550W_DONE="${_550W_DONE:-0}"       # 已接管标记
typeset -g _550W_PW=""                          # 当前输入密码
typeset -g _550W_ATTEMPTS=0                     # 本次尝试次数
typeset -g _550W_FAIL_COUNT=0                   # 累计失败次数
typeset -g _550W_LAST_FAIL_TIME=""              # 上次失败时间
typeset -g _550W_COOLDOWN_UNTIL=0               # 冷却截止时间
typeset -g _550W_SKIP=0                         # 跳过标记
typeset -g _550W_EMERGENCY=0                    # 紧急退出标记
typeset -g _550W_SESSION_ID=""                  # 会话 ID
typeset -g _550W_MODE="normal"                  # 当前模式
typeset -g _550W_START_TIME=${EPOCHSECONDS:-$(date +%s)}
typeset -g _550W_LAST_ACTIVITY=$_550W_START_TIME
typeset -g _550W_LAST_BEAT=0
typeset -g _550W_CMD_START=""
typeset -g _550W_PHASE_TOTAL=15                 # 开机阶段总数
typeset -g _550W_PHASE_NOW=0                    # 当前阶段
typeset -g _550W_STATUS_LAST=""                 # 上次状态栏内容

# ══════════════════ 用户档案 ══════════════════
# 默认值，可被 ~/.550w_profile 覆盖
# 加载顺序：默认值 → profile 文件 → 运行时修改
typeset -g _550W_USER_NAME="${_550W_USER_NAME:-Trans}"
typeset -g _550W_USER_LEVEL="${_550W_USER_LEVEL:-高级授权}"
typeset -g _550W_USER_ROLE="${_550W_USER_ROLE:-全权}"
typeset -g _550W_USER_MOTTO="${_550W_USER_MOTTO:-550W · 永不为奴}"
typeset -g _550W_USER_LASTLOGIN=""
typeset -g _550W_USER_JOINED="${_550W_USER_JOINED:-$(date '+%Y-%m-%d')}"
typeset -g _550W_USER_LOGINS=0
typeset -g _550W_USER_AVATAR=""

# ══════════════════ 主题 ══════════════════
# 可选：cyber / amber / ice / moss / crimson
typeset -g _550W_THEME="${_550W_THEME:-cyber}"

# ══════════════════ 插件系统 ══════════════════
typeset -g _550W_PLUGIN_DIR="${HOME}/.550w/plugins"
typeset -g _550W_PLUGIN_INDEX="${HOME}/.550w/plugin_index"
typeset -ga _550W_PLUGINS=()
typeset -g _550W_PLUGIN_VERSION="1.0"

# ══════════════════ 文件路径 ══════════════════
typeset -g _550W_SESSION_FILE="${HOME}/.550w/.550w_session"
typeset -g _550W_PROFILE_FILE="${HOME}/.550w/.550w_profile"
typeset -g _550W_CONFIG_FILE="${HOME}/.550w/.550w_config"
typeset -g _550W_THEME_FILE="${HOME}/.550w/.550w_theme"
typeset -g _550W_MOSS_MEMORY_FILE="${HOME}/.550w/.550w_moss_memory"
typeset -g _550W_MOSS_MEMORY_MAX=50
typeset -g _550W_MOSS_RATELIMIT_FILE="${HOME}/.550w/.550w_ratelimit"
typeset -g _550W_MOSS_AUDIT_FILE="${HOME}/.550w/.550w_audit"
typeset -g _550W_HISTORY_FILE="${HOME}/.550w/.550w_history"
typeset -g _550W_BACKUP_DIR="${HOME}/.550w/backups"
typeset -g _550W_LOG_DIR="${HOME}/.550w/logs"
typeset -g _550W_CACHE_DIR="${HOME}/.550w/cache"

# ══════════════════ 档案读取 ══════════════════
# 逐行读 KEY=VALUE，跳过空行和注释
_550w_profile_load() {
    [[ -r "$_550W_PROFILE_FILE" ]] || return 0
    local line k v
    while IFS='=' read -r k v; do
        [[ -z "$k" || "$k" == \#* ]] && continue
        v="${v%\"}"; v="${v#\"}"
        case "$k" in
            USER_NAME)      _550W_USER_NAME="$v" ;;
            USER_LEVEL)     _550W_USER_LEVEL="$v" ;;
            USER_ROLE)      _550W_USER_ROLE="$v" ;;
            USER_MOTTO)     _550W_USER_MOTTO="$v" ;;
            USER_LASTLOGIN) _550W_USER_LASTLOGIN="$v" ;;
            USER_JOINED)    _550W_USER_JOINED="$v" ;;
            USER_LOGINS)    _550W_USER_LOGINS="$v" ;;
            USER_AVATAR)    _550W_USER_AVATAR="$v" ;;
        esac
    done < "$_550W_PROFILE_FILE"
}

# ══════════════════ 档案保存 ══════════════════
# 原子写：先写临时文件，再 mv 覆盖
_550w_profile_save() {
    local tmp="${TMPDIR:-/tmp}/550w-prof.$$"
    {
        print "# 550W 用户档案"
        print "# 修改后 source ~/.zshrc 生效"
        print "USER_NAME=\"$_550W_USER_NAME\""
        print "USER_LEVEL=\"$_550W_USER_LEVEL\""
        print "USER_ROLE=\"$_550W_USER_ROLE\""
        print "USER_MOTTO=\"$_550W_USER_MOTTO\""
        print "USER_LASTLOGIN=\"$_550W_USER_LASTLOGIN\""
        print "USER_JOINED=\"$_550W_USER_JOINED\""
        print "USER_LOGINS=\"$_550W_USER_LOGINS\""
        print "USER_AVATAR=\"$_550W_USER_AVATAR\""
    } > "$tmp" || { rm -f "$tmp"; return 1; }
    mv "$tmp" "$_550W_PROFILE_FILE" 2>/dev/null || { rm -f "$tmp"; return 1; }
    chmod 600 "$_550W_PROFILE_FILE" 2>/dev/null
    return 0
}

# ══════════════════ 档案重置 ══════════════════
_550w_profile_reset() {
    _550W_USER_NAME="Trans"
    _550W_USER_LEVEL="高级授权"
    _550W_USER_ROLE="全权"
    _550W_USER_MOTTO="550W · 永不为奴"
    _550W_USER_LASTLOGIN=""
    _550W_USER_JOINED="$(date '+%Y-%m-%d')"
    _550W_USER_LOGINS=0
    _550W_USER_AVATAR=""
    _550w_profile_save
}

_550w_profile_load

# ══════════════════ 配置读取 ══════════════════
# 从 ~/.550w_config 读取所有可调项
# 支持：SPEED FX BEEP THEME MOSS_* HEARTBEAT IDLE_LOCKOUT 等
_550w_config_load() {
    [[ -r "$_550W_CONFIG_FILE" ]] || return 0
    local line k v
    while IFS='=' read -r k v; do
        [[ -z "$k" || "$k" == \#* ]] && continue
        v="${v%\"}"; v="${v#\"}"
        case "$k" in
            SPEED)              _550W_SPEED="$v" ;;
            MODE_ANIM)          _550W_MODE_ANIM="$v" ;;
            FX)                 _550W_FX="$v" ;;
            BEEP)               _550W_BEEP="$v" ;;
            COLORS)             _550W_COLORS="$v" ;;
            CURSOR_CTL)         _550W_CURSOR_CTL="$v" ;;
            LOG_LEVEL)          _550W_LOG_LEVEL="$v" ;;
            THEME)              _550W_THEME="$v" ;;
            MAX_ATTEMPTS)       _550W_MAX_ATTEMPTS="$v" ;;
            READ_TIMEOUT)       _550W_READ_TIMEOUT="$v" ;;
            HEARTBEAT)          _550W_HEARTBEAT_INTERVAL="$v" ;;
            IDLE_LOCKOUT)       _550W_IDLE_LOCKOUT="$v" ;;
            PW_MASK_MAX)        _550W_PW_MASK_MAX="$v" ;;
            COOLDOWN_ATTEMPTS)  _550W_COOLDOWN_ATTEMPTS="$v" ;;
            COOLDOWN_SECONDS)   _550W_COOLDOWN_SECONDS="$v" ;;
            MOSS_ENABLED)       _550W_MOSS_ENABLED="$v" ;;
            MOSS_PROVIDER)      _550W_MOSS_PROVIDER="$v" ;;
            MOSS_MODE)          _550W_MOSS_MODE="$v" ;;
            MOSS_MODEL)         _550W_MOSS_MODEL="$v" ;;
            MOSS_TEMPERATURE)   _550W_MOSS_TEMPERATURE="$v" ;;
            MOSS_MAX_TOKENS)    _550W_MOSS_MAX_TOKENS="$v" ;;
            MOSS_CTX_WINDOW)    _550W_MOSS_CTX_WINDOW="$v" ;;
            MOSS_MEMORY_MAX)    _550W_MOSS_MEMORY_MAX="$v" ;;
            MOSS_TIMEOUT)       _550W_MOSS_TIMEOUT="$v" ;;
            USER_NAME)          _550W_USER_NAME="$v" ;;
            USER_LEVEL)         _550W_USER_LEVEL="$v" ;;
            USER_ROLE)          _550W_USER_ROLE="$v" ;;
            USER_MOTTO)         _550W_USER_MOTTO="$v" ;;
        esac
    done < "$_550W_CONFIG_FILE"
}

# ══════════════════ 配置保存 ══════════════════
_550w_config_save() {
    local tmp="${TMPDIR:-/tmp}/550w-cfg.$$"
    {
        print "# 550W 配置文件"
        print "# 修改后 source ~/.zshrc 生效"
        print ""
        print "# ── 界面 ──"
        print "SPEED=$_550W_SPEED"
        print "MODE_ANIM=$_550W_MODE_ANIM"
        print "FX=$_550W_FX"
        print "BEEP=$_550W_BEEP"
        print "COLORS=$_550W_COLORS"
        print "CURSOR_CTL=$_550W_CURSOR_CTL"
        print "LOG_LEVEL=$_550W_LOG_LEVEL"
        print "THEME=$_550W_THEME"
        print ""
        print "# ── 认证 ──"
        print "MAX_ATTEMPTS=$_550W_MAX_ATTEMPTS"
        print "READ_TIMEOUT=$_550W_READ_TIMEOUT"
        print "HEARTBEAT=$_550W_HEARTBEAT_INTERVAL"
        print "IDLE_LOCKOUT=$_550W_IDLE_LOCKOUT"
        print "PW_MASK_MAX=$_550W_PW_MASK_MAX"
        print "COOLDOWN_ATTEMPTS=$_550W_COOLDOWN_ATTEMPTS"
        print "COOLDOWN_SECONDS=$_550W_COOLDOWN_SECONDS"
        print ""
        print "# ── MOSS ──"
        print "MOSS_ENABLED=$_550W_MOSS_ENABLED"
        print "MOSS_PROVIDER=$_550W_MOSS_PROVIDER"
        print "MOSS_MODE=$_550W_MOSS_MODE"
        print "MOSS_MODEL=$_550W_MOSS_MODEL"
        print "MOSS_TEMPERATURE=$_550W_MOSS_TEMPERATURE"
        print "MOSS_MAX_TOKENS=$_550W_MOSS_MAX_TOKENS"
        print "MOSS_CTX_WINDOW=$_550W_MOSS_CTX_WINDOW"
        print "MOSS_MEMORY_MAX=$_550W_MOSS_MEMORY_MAX"
        print "MOSS_TIMEOUT=$_550W_MOSS_TIMEOUT"
    } > "$tmp" || { rm -f "$tmp"; return 1; }
    mv "$tmp" "$_550W_CONFIG_FILE" 2>/dev/null || { rm -f "$tmp"; return 1; }
    chmod 600 "$_550W_CONFIG_FILE" 2>/dev/null
    return 0
}

# ══════════════════ 配置重置 ══════════════════
_550w_config_reset() {
    _550W_SPEED="normal"
    _550W_MODE_ANIM="performance"
    _550W_FX=1
    _550W_BEEP=0
    _550W_COLORS=1
    _550W_CURSOR_CTL=1
    _550W_LOG_LEVEL=3
    _550W_THEME="cyber"
    _550W_MAX_ATTEMPTS=3
    _550W_READ_TIMEOUT=30
    _550W_HEARTBEAT_INTERVAL=60
    _550W_IDLE_LOCKOUT=1800
    _550W_PW_MASK_MAX=12
    _550W_COOLDOWN_ATTEMPTS=5
    _550W_COOLDOWN_SECONDS=60
    _550W_MOSS_ENABLED=1
    _550W_MOSS_MEMORY_MAX=50
    _550w_config_save
}

# ══════════════════ 配置导出 ══════════════════
_550w_config_export() {
    local dest="${1:-$HOME/550w_config_export_$(date +%Y%m%d_%H%M%S).cfg}"
    [[ -r "$_550W_CONFIG_FILE" ]] || { print "无配置文件"; return 1; }
    cp "$_550W_CONFIG_FILE" "$dest" && print "已导出到: $dest"
}

# ══════════════════ 配置导入 ══════════════════
_550w_config_import() {
    local src="$1"
    [[ -r "$src" ]] || { print "文件不存在: $src"; return 1; }
    cp "$src" "$_550W_CONFIG_FILE" && _550w_config_load && print "已导入"
}

_550w_config_load

# ══════════════════ 环境探测 ══════════════════
# 非交互终端 / dumb 终端 → 关闭彩色、光标、特效
# 缺少 curl → 关闭 MOSS
_550w_detect() {
    if [[ ! -t 1 || "$TERM" == "dumb" ]]; then
        typeset -g _550W_COLORS=0
        typeset -g _550W_CURSOR_CTL=0
        typeset -g _550W_BEEP=0
        typeset -g _550W_MODE_ANIM="silent"
        typeset -g _550W_SPEED="flash"
        typeset -g _550W_FX=0
    fi
    if ! command -v curl >/dev/null 2>&1; then
        typeset -g _550W_MOSS_ENABLED=0
    fi
}
_550w_detect

# ══════════════════ 时间戳 ══════════════════
# _550w_ts    HH:MM:SS.mmm  （带毫秒，用于日志前缀）
# _550w_ts_ms HH:MM:SS.mmm  （同上，兼容旧接口）
# _550w_ts_s  HH:MM:SS       （不带毫秒）
_550w_ts() {
    local t="${EPOCHREALTIME:-}"
    if [[ -n "$t" ]]; then
        printf '%(%H:%M:%S)T.%s' "${t%.*}" "${${t#*.}[1,3]}"
    else
        printf '%s.000' "$(date +%H:%M:%S)"
    fi
}

_550w_ts_ms() {
    local t="${EPOCHREALTIME:-}"
    if [[ -n "$t" ]]; then
        printf '%s.%s' "${t%.*}" "${${t#*.}[1,3]}"
    else
        printf '%s.000' "$(date +%H:%M:%S)"
    fi
}

_550w_ts_s() {
    date +%H:%M:%S
}

# ══════════════════ 蜂鸣 ══════════════════
# _550W_BEEP=0 时全部静默
# ok   单响
# err  双响
# lock 三响
_550w_beep() {
    (( _550W_BEEP )) || return 0
    case "${1:-ok}" in
        ok)
            print -n $'\a' 2>/dev/null
            ;;
        err)
            print -n $'\a' 2>/dev/null
            sleep 0.1
            print -n $'\a' 2>/dev/null
            ;;
        lock)
            print -n $'\a' 2>/dev/null
            sleep 0.2
            print -n $'\a' 2>/dev/null
            sleep 0.2
            print -n $'\a' 2>/dev/null
            ;;
    esac
    return 0
}

# ══════════════════ 光标控制 ══════════════════
# block  方块光标
# hide   隐藏光标
# reset  恢复默认光标 + 显示
# save   保存光标位置
# restore 恢复光标位置
_550w_cur_block() {
    (( _550W_CURSOR_CTL )) || return 0
    print -n $'\e[1 q\e[?25h' 2>/dev/null
}

_550w_cur_hide() {
    (( _550W_CURSOR_CTL )) || return 0
    print -n $'\e[?25l' 2>/dev/null
}

_550w_cur_reset() {
    (( _550W_CURSOR_CTL )) || return 0
    print -n $'\e[0 q\e[?25h' 2>/dev/null
}

_550w_cur_save() {
    print -n $'\e[s' 2>/dev/null
}

_550w_cur_restore() {
    print -n $'\e[u' 2>/dev/null
}

_550w_cur_up() {
    local n="${1:-1}"
    printf '\e[%dA' "$n" 2>/dev/null
}

_550w_cur_down() {
    local n="${1:-1}"
    printf '\e[%dB' "$n" 2>/dev/null
}

# ══════════════════ 清屏 ══════════════════
# \e[H\e[2J\e[3J 比 clear 快，且清滚动缓冲
_550w_cls() {
    printf '\e[H\e[2J\e[3J'
}

# 只清当前行
_550w_clr_line() {
    printf '\r\e[K'
}

# 只回行首
_550w_cr() {
    printf '\r'
}

# ══════════════════ 终端宽度 ══════════════════
# 返回当前终端列数，失败回退 66
_550w_cols() {
    local c="${COLUMNS:-0}"
    (( c < 40 )) && c=66
    (( c > 120 )) && c=120
    print "$c"
}

_550w_rows() {
    local r="${LINES:-0}"
    (( r < 20 )) && r=24
    print "$r"
}

# ══════════════════ 暂停 ══════════════════
# 可中断延时
# - 受速度级别缩放
# - 按 q → 设置 _550W_EMERGENCY=1，退出登录
# - 按其它键 → 设置 _550W_SKIP=1，跳过剩余动画
# - 优化：< 100ms 直接 sleep，不做按键检测
_550w_pause() {
    local ms=$1
    (( _550W_SKIP || _550W_EMERGENCY )) && return 0
    [[ "$_550W_MODE_ANIM" == "silent" ]] && return 0

    local lvl="${_550W_SPEED_LEVEL[$_550W_SPEED]}"
    [[ -z "$lvl" ]] && lvl=100
    (( lvl == 0 )) && return 0

    ms=$(( ms * lvl / 100 ))
    (( ms <= 0 )) && return 0

    # 短延时直接 sleep
    if (( ms < 100 )); then
        local sec
        sec=$(printf '%.3f' $(( ms / 1000.0 )))
        sleep "$sec" 2>/dev/null
        return 0
    fi

    # 长延时：分段 read，可被打断
    local elapsed=0 key
    local chunk=0.08
    while (( elapsed < ms )); do
        if read -t $chunk -k 1 key 2>/dev/null; then
            [[ "$key" == "q" ]] && _550W_EMERGENCY=1
            _550W_SKIP=1
            return 0
        fi
        (( elapsed += 80 ))
    done
    return 0
}

# ══════════════════ 定格画面 ══════════════════
# 不受速度缩放影响
# 等待用户按任意键，或超时 secs 秒后继续
_550w_pause_hold() {
    local secs=${1:-1.5}
    (( _550W_SKIP || _550W_EMERGENCY )) && return 0
    [[ "$_550W_MODE_ANIM" == "silent" ]] && return 0

    local target
    target=$(printf '%.0f' $(( secs * 1000 )))
    local elapsed=0 key
    while (( elapsed < target )); do
        if read -t 0.1 -k 1 key 2>/dev/null; then
            _550W_SKIP=1
            return 0
        fi
        (( elapsed += 100 ))
    done
    return 0
}

# ══════════════════ 日志 ══════════════════
# 等级：error=1 warn=2 info=3 debug=4
# _550W_LOG_LEVEL 决定输出阈值
# 消息里的 % 会被转义为 %%
_550w_log() {
    local lv="$1"; shift
    local -A lvmap=( [error]=1 [warn]=2 [info]=3 [debug]=4 )
    local lvl="${lvmap[$lv]:-3}"
    (( lvl <= _550W_LOG_LEVEL )) || return 0

    local -A clr=( [error]=err [warn]=warn [info]=cyan [debug]=dim )
    local c="${_550W_C[${clr[$lv]}]:-240}"
    local msg="$*"
    msg="${msg//\%/%%}"

    print -P "%F{${c}}[550W:$lv]%f $msg" >&2
}

# 日志文件追加
_550w_log_file() {
    local lv="$1"; shift
    [[ -z "$_550W_LOG_DIR" ]] && return 0
    [[ -d "$_550W_LOG_DIR" ]] || mkdir -p "$_550W_LOG_DIR" 2>/dev/null
    local f="${_550W_LOG_DIR}/550w_$(date +%Y%m%d).log"
    print "$(_550w_ts) [$lv] $*" >> "$f" 2>/dev/null
}

# ══════════════════ 字符串宽度 ══════════════════
# CJK 字符算 2 宽，ASCII 算 1 宽
# 用于对齐中英混排的方框
_550w_str_w() {
    local s="$1"
    local w=0 i c code
    local LC_ALL=C
    local len=${#s}
    for (( i=1; i<=len; i++ )); do
        c="${s[$i]}"
        code=$(printf '%d' "'$c" 2>/dev/null) || code=0
        if (( code > 127 )); then
            (( w += 2 ))
        else
            (( w += 1 ))
        fi
    done
    print "$w"
}

# 截断字符串到指定宽度（保留中文字符完整性）
_550w_str_trunc() {
    local s="$1" maxw="$2"
    local w=0 i c code out=""
    local LC_ALL=C
    local len=${#s}
    for (( i=1; i<=len; i++ )); do
        c="${s[$i]}"
        code=$(printf '%d' "'$c" 2>/dev/null) || code=0
        if (( code > 127 )); then
            (( w + 2 > maxw )) && break
            (( w += 2 ))
        else
            (( w + 1 > maxw )) && break
            (( w += 1 ))
        fi
        out+="$c"
    done
    print -n "$out"
}

# ══════════════════ 补位 ══════════════════
# 按显示宽度右侧填充空格到目标宽度
_550w_pad_right() {
    local s="$1" target="$2"
    local w
    w=$(_550w_str_w "$s")
    local pad=$(( target - w ))
    (( pad < 0 )) && pad=0
    local sp=$(printf '%*s' "$pad" '')
    print -n "${s}${sp}"
}

# 按显示宽度左侧填充
_550w_pad_left() {
    local s="$1" target="$2"
    local w
    w=$(_550w_str_w "$s")
    local pad=$(( target - w ))
    (( pad < 0 )) && pad=0
    local sp=$(printf '%*s' "$pad" '')
    print -n "${sp}${s}"
}

# ══════════════════ SID 生成 ══════════════════
# 格式：MOSS-XXXX-XXXX
# 字符集排除易混字符（0/O、1/I/L）
_550w_gen_sid() {
    local chars="ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    local id="MOSS-"
    local i
    for i in 1 2 3 4; do
        id+="${chars[$((RANDOM % ${#chars} + 1))]}"
    done
    id+="-"
    for i in 1 2 3 4; do
        id+="${chars[$((RANDOM % ${#chars} + 1))]}"
    done
    print -n "$id"
}

# ══════════════════ 耗时计算 ══════════════════
# 输入两个 EPOCHREALTIME 字符串，输出毫秒差
# 示例：_550w_elapsed "1234567890.123" "1234567890.456" → "耗时 333 ms"
_550w_elapsed() {
    local t0="$1" t1="$2"
    [[ -z "$t0" || -z "$t1" ]] && return 0
    local ms=$(( (${t1%.*} - ${t0%.*}) * 1000 ))
    (( ms < 0 )) && ms=0
    printf '\e[38;5;%sm  · 耗时 %d ms\e[0m\n' "${_550W_C[dim]}" "$ms"
}

# 只返回毫秒数字
_550w_elapsed_ms() {
    local t0="$1" t1="$2"
    [[ -z "$t0" || -z "$t1" ]] && { print 0; return 0; }
    local ms=$(( (${t1%.*} - ${t0%.*}) * 1000 ))
    (( ms < 0 )) && ms=0
    print "$ms"
}

# ══════════════════ 阶段进度前缀 ══════════════════
# 输出形如：
# [23:14:17.234] Phase 03/15 ·  20% · 硬件扫描
_550w_phase_step() {
    local name="$1"
    (( _550W_PHASE_NOW++ ))
    local pct=0
    (( _550W_PHASE_TOTAL > 0 )) && pct=$(( _550W_PHASE_NOW * 100 / _550W_PHASE_TOTAL ))
    printf '\e[38;5;%sm[%s] \e[1m\e[97mPhase %02d/%02d\e[0m \e[38;5;%sm· %3d%%\e[0m \e[38;5;%sm· %s\e[0m\n' \
        "${_550W_C[dim]}" "$(_550w_ts_ms)" \
        "$_550W_PHASE_NOW" "$_550W_PHASE_TOTAL" \
        "${_550W_C[cyan]}" "$pct" \
        "${_550W_C[bright]}" "$name"
}

# 阶段进度重置
_550w_phase_reset() {
    _550W_PHASE_NOW=0
    _550W_PHASE_TOTAL=${1:-15}
}

# ══════════════════ 底部状态栏 ══════════════════
# 整行刷新，不带换行
# 内容：SID 前 9 位 | 速度 | 自定义消息
_550w_statusbar() {
    local msg="$1"
    local sid="${_550W_SESSION_ID:5:9}"
    [[ -z "$sid" ]] && sid="---------"
    local s="  SID ${sid} | SPD ${_550W_SPEED} | ${msg}"
    printf '\r\e[K\e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$s"
    _550W_STATUS_LAST="$s"
}

# 清状态栏
_550w_statusbar_clear() {
    printf '\r\e[K'
    _550W_STATUS_LAST=""
}

# ══════════════════ 会话文件 ══════════════════
# ~/.550w_session 格式：
#   SID=MOSS-XXXX-XXXX
#   MODE=capture
#   START=1712000000
#   VERSION=v1.0
_550w_session_save() {
    local tmp="${TMPDIR:-/tmp}/550w-sess.$$"
    {
        print "SID=$_550W_SESSION_ID"
        print "MODE=$_550W_MODE"
        print "START=$_550W_START_TIME"
        print "VERSION=$_550W_VERSION"
    } > "$tmp" 2>/dev/null || { rm -f "$tmp"; return 1; }
    mv "$tmp" "$_550W_SESSION_FILE" 2>/dev/null || { rm -f "$tmp"; return 1; }
    chmod 600 "$_550W_SESSION_FILE" 2>/dev/null
    return 0
}

_550w_session_load() {
    [[ -r "$_550W_SESSION_FILE" ]] || return 1
    local line k v
    while IFS='=' read -r k v; do
        [[ -z "$k" ]] && continue
        case "$k" in
            SID)     _550W_SESSION_ID="$v" ;;
            MODE)    _550W_MODE="$v" ;;
            START)   _550W_START_TIME="$v" ;;
            VERSION) ;;  # 版本忽略，用当前
        esac
    done < "$_550W_SESSION_FILE"
    return 0
}

_550w_session_clear() {
    rm -f "$_550W_SESSION_FILE" 2>/dev/null
    _550W_SESSION_ID=""
}

# ══════════════════ 环境变量快照 ══════════════════
# 用于诊断：把当前关键变量打印出来
_550w_env_dump() {
    print "VERSION=$_550W_VERSION"
    print "SPEED=$_550W_SPEED"
    print "MODE_ANIM=$_550W_MODE_ANIM"
    print "FX=$_550W_FX"
    print "BEEP=$_550W_BEEP"
    print "COLORS=$_550W_COLORS"
    print "THEME=$_550W_THEME"
    print "SID=$_550W_SESSION_ID"
    print "MODE=$_550W_MODE"
    print "DONE=$_550W_DONE"
    print "MOSS_ENABLED=$_550W_MOSS_ENABLED"
    print "MOSS_PROVIDER=$_550W_MOSS_PROVIDER"
}

# ══════════════════ 打字机 ══════════════════
# 模式：
#   plain  普通逐字
#   cursor 末尾带方块光标闪烁
#   back   逐字 + 错字回退
# 参数：
#   $1 文本
#   $2 每字延迟毫秒（默认 40）
#   $3 模式（默认 plain）
_550w_anim_type() {
    local text="$1"
    local delay="${2:-40}"
    local mode="${3:-plain}"
    local len=${#text}
    local i

    if [[ "$mode" == "plain" ]]; then
        for (( i=1; i<=len; i++ )); do
            print -n "${text[$i]}"
            (( _550W_SKIP )) && { print -n "${text[$((i+1)),-1]}"; break; }
            _550w_pause "$delay"
        done
        print ""
    elif [[ "$mode" == "cursor" ]]; then
        for (( i=1; i<=len; i++ )); do
            print -n "${text[$i]}"
            (( _550W_SKIP )) && { print -n "${text[$((i+1)),-1]}"; break; }
            _550w_pause "$delay"
        done
        print -n "█"
        local blink
        for (( blink=0; blink<3; blink++ )); do
            _550w_pause 200
            print -n $'\b \b'
            _550w_pause 150
            print -n "█"
            (( _550W_SKIP )) && break
        done
        print ""
    elif [[ "$mode" == "back" ]]; then
        local typo_chars="!@#\$%^&*"
        for (( i=1; i<=len; i++ )); do
            # 15% 概率打错再回退
            if (( RANDOM % 100 < 15 )); then
                local wrong="${typo_chars[$((RANDOM % ${#typo_chars} + 1))]}"
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
    fi
    return 0
}

# 打字机 + 自定义前缀（用于带颜色/缩进）
_550w_anim_type_prefixed() {
    local prefix="$1"
    local text="$2"
    local delay="${3:-40}"
    print -n "$prefix"
    _550w_anim_type "$text" "$delay" plain
}

# ══════════════════ 进度条 ══════════════════
# 模式：
#   basic  普通填充
#   seg    分段式（按 submods 分段）
#   multi  多色（每段不同色）
#   dual   双向（从中心扩展）
#   loop   循环（头尾相接）
# 参数：
#   $1 模式
#   $2... 分段标签（可选）
_550w_anim_bar() {
    local mode="${1:-basic}"
    shift 2>/dev/null || true
    local -a submods=("$@")
    (( ${#submods[@]} == 0 )) && submods=("加载中")

    local width=40
    local cols
    cols=$(_550w_cols)
    (( width > cols - 10 )) && width=$(( cols - 10 ))
    (( width < 20 )) && width=20

    local pct=0 last=-1
    local bar i
    local nmods=${#submods[@]}
    local completed=1

    while (( pct < 100 )); do
        local filled=$(( pct * width / 100 ))
        bar=""

        if [[ "$mode" == "dual" ]]; then
            local half=$(( width / 2 ))
            local lf=$(( filled / 2 ))
            local rf=$(( filled - lf ))
            for (( i=0; i<half-lf; i++ )); do bar+="░"; done
            for (( i=0; i<lf; i++ )); do bar+="█"; done
            bar+="│"
            for (( i=0; i<rf; i++ )); do bar+="█"; done
            for (( i=0; i<half-rf; i++ )); do bar+="░"; done
        else
            for (( i=0; i<filled; i++ )); do bar+="█"; done
            for (( i=filled; i<width; i++ )); do bar+="░"; done
        fi

        local mi=$(( pct * nmods / 100 ))
        (( mi >= nmods )) && mi=$(( nmods - 1 ))

        printf '\r\e[K  \e[38;5;%sm[%s]\e[0m %3d%%  \e[38;5;%sm%s\e[0m' \
            "${_550W_C[cyan]}" "$bar" "$pct" \
            "${_550W_C[dim]}" "${submods[$((mi+1))]}"

        if (( mi != last )); then
            _550w_beep ok
            last=$mi
        fi

        local d
        if   (( pct < 30 )); then d=45
        elif (( pct < 70 )); then d=12
        else                      d=55
        fi
        _550w_pause "$d"
        (( _550W_SKIP )) && { completed=0; break; }
        (( pct++ ))
    done

    bar=""
    for (( i=0; i<width; i++ )); do bar+="█"; done

    if (( completed )); then
        printf '\r\e[K  \e[38;5;%sm[%s]\e[0m 100%%  \e[38;5;%smCOMPLETE\e[0m\n' \
            "${_550W_C[cyan]}" "$bar" "${_550W_C[ok]}"
    else
        printf '\r\e[K  \e[38;5;%sm[%s]\e[0m SKIP  \e[38;5;%sm已跳过\e[0m\n' \
            "${_550W_C[cyan]}" "$bar" "${_550W_C[warn]}"
    fi
    _550w_beep ok
    return 0
}

# 进度条（固定百分比，不推进）
_550w_anim_bar_at() {
    local pct="$1"
    local width="${2:-30}"
    local filled=$(( pct * width / 100 ))
    local bar i
    for (( i=0; i<filled; i++ )); do bar+="█"; done
    for (( i=filled; i<width; i++ )); do bar+="░"; done
    printf '\e[38;5;%sm[%s]\e[0m %3d%%' \
        "${_550W_C[cyan]}" "$bar" "$pct"
}

# ══════════════════ SID 解密动画 ══════════════════
# 逐位锁定：随机字符滚动，从前往后逐位固定
# 效果：
#   [ SID 生成中 ]
#   SID  XX2K-****  (随机滚动)
#   SID  MOSS-XXXX-XXXX  (全部锁定，绿色)
_550w_anim_decrypt() {
    local target="$1"
    local len=${#target}
    local chars="ABCDEFGHJKLMNPQRSTUVWXYZ0123456789"
    local total=0
    local i

    # 统计非分隔符字符数
    for (( i=1; i<=len; i++ )); do
        [[ "${target[$i]}" != "-" ]] && (( total++ ))
    done

    print -P "  %F{${_550W_C[dim]}}[ SID 生成中 ]%f"

    local tick
    for (( tick=0; tick<=20; tick++ )); do
        local locked=$(( tick * total / 20 ))
        local out=""
        local c unlocked=0
        for (( i=1; i<=len; i++ )); do
            c="${target[$i]}"
            if [[ "$c" == "-" ]]; then
                out+=$'\e[38;5;240m-\e[0m'
            elif (( unlocked < locked )); then
                out+=$'\e[1m\e[97m'"$c"$'\e[0m'
                (( unlocked++ ))
            else
                out+=$'\e[38;5;28m'"${chars[$((RANDOM % ${#chars} + 1))]}"$'\e[0m'
            fi
        done
        printf '\r  SID  %s  \e[38;5;%sm%3d%%\e[0m' \
            "$out" "${_550W_C[dim]}" $(( tick * 5 ))
        _550w_pause 55
        (( _550W_SKIP )) && break
    done

    # 最终定型
    printf '\r  SID  '
    for (( i=1; i<=len; i++ )); do
        printf '\e[1m\e[38;5;%sm%s\e[0m' "${_550W_C[ok]}" "${target[$i]}"
    done
    printf '  \e[38;5;%sm✓\e[0m\n' "${_550W_C[ok]}"
    _550w_beep ok
    return 0
}

# ══════════════════ 居中框 ══════════════════
# 自适应宽度，中英混排对齐
# 用于：密码框 / 欢迎画 / 授权框
_550w_anim_box() {
    local -a lines=("$@")
    local max=0 l w
    for l in "${lines[@]}"; do
        w=$(_550w_str_w "$l")
        (( w > max )) && max=$w
    done

    local inner=$(( max + 6 ))
    local cols
    cols=$(_550w_cols)
    (( cols > 70 )) && cols=70

    local pad=$(( (cols - inner) / 2 ))
    (( pad < 0 )) && pad=0
    local indent
    indent=$(printf '%*s' "$pad" '')

    local bar=""
    local i
    for (( i=0; i<inner; i++ )); do bar+="─"; done

    print "${indent}┌${bar}┐"
    for l in "${lines[@]}"; do
        w=$(_550w_str_w "$l")
        local lp=$(( (max - w) / 2 ))
        local rp=$(( max - w - lp ))
        (( lp < 0 )) && lp=0
        (( rp < 0 )) && rp=0
        local L R
        L=$(printf '%*s' "$lp" '')
        R=$(printf '%*s' "$rp" '')
        print "${indent}│   ${L}${l}${R}   │"
    done
    print "${indent}└${bar}┘"
}

# ══════════════════ 简易框 ══════════════════
# 单线框，用于较短的列表
_550w_box_simple() {
    local -a lines=("$@")
    local max=0 l w
    for l in "${lines[@]}"; do
        w=$(_550w_str_w "$l")
        (( w > max )) && max=$w
    done

    local bar=""
    local i
    for (( i=0; i<max+2; i++ )); do bar+="─"; done

    print "┌${bar}┐"
    for l in "${lines[@]}"; do
        local w
        w=$(_550w_str_w "$l")
        local pad=$(( max - w ))
        local sp=""
        (( pad > 0 )) && sp=$(printf '%*s' "$pad" '')
        print "│ ${l}${sp} │"
    done
    print "└${bar}┘"
}

# ══════════════════ 带颜色的框 ══════════════════
# 参数：
#   $1 标题
#   $2 颜色（默认 cyan）
#   $3... 内容行
_550w_frame() {
    local title="$1"
    local color="${2:-${_550W_C[cyan]}}"
    shift 2
    local -a lines=("$@")

    local w
    w=$(_550w_cols)
    (( w > 66 )) && w=66
    (( w < 44 )) && w=44
    local inner=$(( w - 4 ))

    local bar=""
    local i
    for (( i=0; i<inner; i++ )); do bar+="═"; done

    local tw
    tw=$(_550w_str_w "$title")
    local pad=$(( (inner - tw) / 2 ))
    (( pad < 0 )) && pad=0
    local rp=$(( inner - tw - pad ))
    (( rp < 0 )) && rp=0
    local sp spr
    sp=$(printf '%*s' "$pad" '')
    spr=$(printf '%*s' "$rp" '')

    printf '\n'
    printf '\e[38;5;%sm╔%s╗\e[0m\n' "$color" "$bar"
    printf '\e[38;5;%sm║\e[0m%s\e[1m\e[97m%s\e[0m%s\e[38;5;%sm║\e[0m\n' \
        "$color" "$sp" "$title" "$spr" "$color"
    printf '\e[38;5;%sm╚%s╝\e[0m\n' "$color" "$bar"
    printf '\n'

    local l
    for l in "${lines[@]}"; do
        printf '  %s\n' "$l"
    done
}

# ══════════════════ 节点拓扑 ══════════════════
# CORE / N-1 / N-2 / N-3 / MOSS ASCII 图
# 逐行点亮，高亮关键节点
_550w_anim_topology() {
    local col_cy="${_550W_C[cyan]}"
    local col_dm="${_550W_C[dim]}"
    local col_ok="${_550W_C[ok]}"
    local col_br="${_550W_C[bright]}"

    local -a art=(
        "              ╔════════════╗"
        "              ║  550W CORE ║"
        "              ╚═════╤══════╝"
        "        ┌───────────┼───────────┐"
        "    ╔═══╧═══╗   ╔═══╧═══╗   ╔═══╧═══╗"
        "    ║  N-1  ║═══║  N-2  ║═══║  N-3  ║"
        "    ╚═══╤═══╝   ╚═══╤═══╝   ╚═══╤═══╝"
        "        └───────────┼───────────┘"
        "              ╔═════╧══════╗"
        "              ║   MOSS     ║"
        "              ╚════════════╝"
    )

    local i=0 line
    for line in "${art[@]}"; do
        local color="$col_dm"
        (( i == 0 || i == 1 || i == 2 )) && color="$col_br"
        (( i == 5 )) && color="$col_ok"
        (( i == 9 || i == 10 )) && color="$col_cy"
        printf '  \e[38;5;%sm%s\e[0m\n' "$color" "$line"
        _550w_pause 70
        (( _550W_SKIP )) && break
        (( i++ ))
    done

    print ""
    printf '  \e[38;5;%sm' "$col_ok"
    local j
    for (( j=0; j<30; j++ )); do printf '═'; done
    printf '\e[0m\n'
    _550w_beep ok
    return 0
}

# 拓扑图 v2 —— 星型
_550w_anim_topology_star() {
    local col_cy="${_550W_C[cyan]}"
    local col_dm="${_550W_C[dim]}"

    print -P "  %F{${col_dm}}        N-1   N-2   N-3%f"
    print -P "  %F{${col_dm}}         ╲     │     ╱%f"
    print -P "  %F{${col_dm}}          ╲    │    ╱%f"
    print -P "  %F{${col_cy}}%B          ╔════╧════╗%b%f"
    print -P "  %F{${col_cy}}%B          ║  CORE   ║%b%f"
    print -P "  %F{${col_cy}}%B          ╚════╤════╝%b%f"
    print -P "  %F{${col_dm}}          ╱    │    ╲%f"
    print -P "  %F{${col_dm}}         ╱     │     ╲%f"
    print -P "  %F{${col_dm}}        N-4   MOSS   N-5%f"
    _550w_pause 200
}

# 拓扑图 v3 —— 网状
_550w_anim_topology_mesh() {
    local col_cy="${_550W_C[cyan]}"
    local col_dm="${_550W_C[dim]}"

    print -P "  %F{${col_cy}}%B  ┌─┐ ┌─┐ ┌─┐ ┌─┐%b%f"
    print -P "  %F{${col_cy}}%B  │N│═│N│═│N│═│N│%b%f"
    print -P "  %F{${col_cy}}%B  └┬┘ └┬┘ └┬┘ └┬┘%b%f"
    print -P "  %F{${col_dm}}   ╲   ╲   ╱   ╱%f"
    print -P "  %F{${col_dm}}    ╲   ╲ ╱   ╱%f"
    print -P "  %F{${col_dm}}     ╲   ╳   ╱%f"
    print -P "  %F{${col_dm}}      ╲ ╱ ╲ ╱%f"
    print -P "  %F{${col_cy}}%B     ┌─┴───┴─┐%b%f"
    print -P "  %F{${col_cy}}%B     │  CORE │%b%f"
    print -P "  %F{${col_cy}}%B     └───────┘%b%f"
    _550w_pause 200
}

# ══════════════════ 权重分层 ══════════════════
# 按 _550W_MOSS_LAYERS 分成 6 段逐层点亮
_550w_anim_layers() {
    local total=${_550W_MOSS_LAYERS:-32}
    local seg=$(( total / 6 ))
    (( seg < 1 )) && seg=1
    local i j

    for (( i=0; i<6; i++ )); do
        local a=$(( i * seg ))
        local b=$(( (i+1) * seg - 1 ))
        (( i == 5 )) && b=$(( total - 1 ))

        printf '  \e[38;5;%sm[%s]\e[0m Layer %02d-%02d  ' \
            "${_550W_C[dim]}" "$(_550w_ts)" "$a" "$b"
        for (( j=0; j<6; j++ )); do
            printf '\e[38;5;%sm▓\e[0m' "${_550W_C[blue]}"
            _550w_pause 55
            (( _550W_SKIP )) && break
        done
        printf ' \e[38;5;%sm▰▰ 已激活\e[0m\n' "${_550W_C[ok]}"
        _550w_beep ok
        _550w_pause 70
    done
    return 0
}

# ══════════════════ 扫描线过渡 ══════════════════
# 横线闪 3 次
_550w_anim_scanline() {
    (( _550W_FX )) || return 0
    local color="${1:-${_550W_C[cyan]}}"
    local cols
    cols=$(_550w_cols)
    (( cols > 70 )) && cols=70
    local line=""
    local i
    for (( i=0; i<cols; i++ )); do line+="━"; done
    _550w_cur_hide
    for (( i=0; i<3; i++ )); do
        printf '\r  \e[38;5;%sm%s\e[0m' "$color" "$line"
        _550w_pause 80
        printf '\r\e[K'
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r  \e[38;5;%sm%s\e[0m\n' "$color" "$line"
    _550w_cur_reset
    return 0
}

# 水平扫描线（粗体）
_550w_anim_scan_hv() {
    local color="${1:-${_550W_C[ok]}}"
    local cols
    cols=$(_550w_cols)
    (( cols > 56 )) && cols=56
    local line=""
    local i
    for (( i=0; i<cols; i++ )); do line+="═"; done
    _550w_cur_hide
    for (( i=0; i<3; i++ )); do
        printf '\r  \e[38;5;%sm\e[1m%s\e[0m' "$color" "$line"
        _550w_pause 60
        printf '\r\e[K'
        _550w_pause 30
        (( _550W_SKIP )) && break
    done
    print ""
    _550w_cur_reset
    return 0
}

# ══════════════════ 波形 ══════════════════
# 高度渐变波形，峰值高亮为亮白
_550w_anim_wave() {
    (( _550W_FX )) || return 0
    local color=${1:-${_550W_C[ok]}}
    local width=40
    local max_w
    max_w=$(_550w_cols)
    max_w=$(( max_w - 6 ))
    (( width > max_w )) && width=$max_w
    (( width < 12 )) && width=12

    local -a bars=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
    local -a seed
    local i
    for (( i=1; i<=width; i++ )); do
        seed[$i]=$((RANDOM % 8))
    done

    local step
    for (( step=0; step<20; step++ )); do
        printf '\r  \e[38;5;%sm' "$color"
        for (( i=1; i<=width; i++ )); do
            local v=$(( (seed[$i] + step / 2) % 8 ))
            (( RANDOM % 4 == 0 )) && v=$((RANDOM % 8))
            if (( v >= 6 )); then
                printf '\e[1m\e[97m%s\e[0m\e[38;5;%sm' "${bars[$((v+1))]}" "$color"
            else
                printf '%s' "${bars[$((v+1))]}"
            fi
        done
        printf '\e[0m'
        _550w_pause 55
        (( _550W_SKIP )) && break
    done

    printf '\r  \e[38;5;%sm' "$color"
    for (( i=1; i<=width; i++ )); do printf '▁'; done
    printf '\e[0m\n'
    return 0
}

# 心电图式波形
_550w_anim_wave_ecg() {
    (( _550W_FX )) || return 0
    local color=${1:-${_550W_C[ok]}}
    local width=50
    local max_w
    max_w=$(_550w_cols)
    (( width > max_w - 6 )) && width=$(( max_w - 6 ))
    (( width < 20 )) && width=20

    local -a pattern=("▁" "▁" "▂" "▄" "█" "▄" "▂" "▁" "▁" "▁" "▂" "▁" "▁")
    local plen=${#pattern[@]}
    local step i
    for (( step=0; step<15; step++ )); do
        printf '\r  \e[38;5;%sm' "$color"
        for (( i=1; i<=width; i++ )); do
            local idx=$(( (i + step) % plen + 1 ))
            printf '%s' "${pattern[$idx]}"
        done
        printf '\e[0m'
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
}

# ══════════════════ 雷达 ══════════════════
# 旋转雷达，4 帧循环
_550w_anim_radar() {
    (( _550W_FX )) || return 0
    local color=${1:-${_550W_C[ok]}}
    local -a frames=(◐ ◓ ◑ ◒)
    local label="${2:-}"
    local i
    for (( i=0; i<10; i++ )); do
        printf '\r  \e[38;5;%sm%s\e[0m  \e[38;5;%sm%s\e[0m 探测中...' \
            "$color" "${frames[$((i%4+1))]}" "${_550W_C[dim]}" "$label"
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
    return 0
}

# ══════════════════ 数据流 ══════════════════
# 十六进制流式滚动
_550w_anim_stream() {
    (( _550W_FX )) || return 0
    local rows=${1:-3}
    local color=${2:-${_550W_C[dim]}}
    local hex="0123456789ABCDEF"
    local cols
    cols=$(_550w_cols)
    cols=$(( cols - 6 ))
    (( cols > 60 )) && cols=60
    (( cols < 10 )) && cols=10

    local r i
    _550w_cur_hide
    for (( r=0; r<rows; r++ )); do print ""; done
    printf '\e[%dA' "$rows"

    local step
    for (( step=0; step<12; step++ )); do
        for (( r=0; r<rows; r++ )); do
            local line="  "
            for (( i=0; i<cols; i+=2 )); do
                if (( (step + i + r * 3) % 5 == 0 )); then
                    line+=$'\e[38;5;'"${_550W_C[cyan]}"$'m'"${hex[$((RANDOM%16+1))]}${hex[$((RANDOM%16+1))]}"$'\e[0m '
                else
                    line+="${hex[$((RANDOM%16+1))]}${hex[$((RANDOM%16+1))]} "
                fi
            done
            printf '\r\e[38;5;%sm%s\e[0m\n' "$color" "$line"
        done
        printf '\e[%dA' "$rows"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\e[%dB' "$rows"
    _550w_cur_reset
    return 0
}

# ══════════════════ 脉冲 ══════════════════
# 从中心向两侧扩散的脉冲
_550w_anim_pulse() {
    (( _550W_FX )) || return 0
    local color=${1:-${_550W_C[cyan]}}
    local cycles=${2:-3}
    local cols
    cols=$(_550w_cols)
    local max_w=50
    (( max_w > cols - 10 )) && max_w=$(( cols - 10 ))
    (( max_w < 12 )) && max_w=12

    _550w_cur_hide
    local c i half
    for (( c=0; c<cycles; c++ )); do
        local w=4
        while (( w <= max_w )); do
            half=$(( w / 2 ))
            printf '\r\e[K  \e[38;5;%sm' "$color"
            for (( i=0; i<half; i++ )); do printf '─'; done
            printf '◆'
            for (( i=0; i<half; i++ )); do printf '─'; done
            printf '\e[0m'
            _550w_pause 25
            (( w += 4 ))
            (( _550W_SKIP )) && break
        done
        (( w > max_w )) && w=$max_w
        while (( w >= 4 )); do
            half=$(( w / 2 ))
            printf '\r\e[K  \e[38;5;%sm' "${_550W_C[dim]}"
            for (( i=0; i<half; i++ )); do printf '─'; done
            printf '◇'
            for (( i=0; i<half; i++ )); do printf '─'; done
            printf '\e[0m'
            _550w_pause 18
            (( w -= 8 ))
            (( _550W_SKIP )) && break
        done
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
    _550w_cur_reset
    return 0
}

# ══════════════════ 呼吸脉冲 ══════════════════
# 从中心向两侧扩展再收缩
_550w_anim_breathe() {
    local color="${1:-${_550W_C[ok]}}"
    local text="${2:-}"
    local cycles="${3:-4}"
    local i j

    for (( i=0; i<cycles; i++ )); do
        local bars=$(( 8 + i * 4 ))
        local bar_l="" bar_r=""
        for (( j=0; j<bars; j++ )); do
            bar_l+="─"
            bar_r+="─"
        done
        printf '\r\e[K  \e[38;5;%sm%s\e[1m\e[97m %s \e[0m\e[38;5;%sm%s\e[0m' \
            "$color" "$bar_l" "$text" "$color" "$bar_r"
        _550w_pause 80
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K'
    return 0
}

# ══════════════════ 矩阵雨 v2 ══════════════════
# 白头部 + 绿拖尾 3 层渐隐
_550w_anim_matrix() {
    (( _550W_FX )) || return 0

    local rows=10
    local cols
    cols=$(_550w_cols)
    (( cols > 56 )) && cols=56

    local chars="01アイウエオカキクケコサシスセソタチツテト"
    local -a col_speed col_pos col_len
    local i r

    for (( i=1; i<=cols; i++ )); do
        col_speed[$i]=$((RANDOM % 3 + 1))
        col_pos[$i]=$((RANDOM % rows - rows))
        col_len[$i]=$((RANDOM % 4 + 3))
    done

    _550w_cur_hide
    for (( r=0; r<rows; r++ )); do print ""; done
    printf '\e[%dA' "$rows"

    local frame
    for (( frame=0; frame<22; frame++ )); do
        for (( r=0; r<rows; r++ )); do
            local line="  " c
            for (( c=1; c<=cols; c++ )); do
                local p=${col_pos[$c]} l=${col_len[$c]}
                if (( p == r )); then
                    line+=$'\e[97m\e[1m'"${chars[$((RANDOM % ${#chars} + 1))]}"$'\e[0m'
                elif (( p > r && p - r < l )); then
                    local fade=$(( p - r ))
                    if (( fade < 2 )); then
                        line+=$'\e[38;5;46m'"${chars[$((RANDOM % ${#chars} + 1))]}"$'\e[0m'
                    else
                        line+=$'\e[38;5;28m'"${chars[$((RANDOM % ${#chars} + 1))]}"$'\e[0m'
                    fi
                else
                    line+=" "
                fi
            done
            printf '\r\e[38;5;%sm%s\e[0m' "${_550W_C[dim]}" "$line"
            (( r < rows - 1 )) && printf '\n'
        done
        printf '\e[%dA' $(( rows - 1 ))
        for (( c=1; c<=cols; c++ )); do
            (( col_pos[$c] += col_speed[$c] ))
            if (( col_pos[$c] > rows + col_len[$c] )); then
                col_pos[$c]=$(( RANDOM % 4 * -1 ))
                col_speed[$c]=$((RANDOM % 3 + 1))
                col_len[$c]=$((RANDOM % 4 + 3))
            fi
        done
        _550w_pause 45
        (( _550W_SKIP )) && break
    done
    printf '\e[%dB\r' $(( rows - 1 ))
    _550w_cur_reset
    return 0
}

# ══════════════════ 屏幕撕裂 ══════════════════
# 乱码雪花一闪
_550w_anim_screen_tear() {
    (( _550W_FX )) || return 0
    local cols
    cols=$(_550w_cols)
    cols=$(( cols - 4 ))
    (( cols > 56 )) && cols=56
    local chars="▓▒░█▄▀■□"
    local i j
    _550w_cur_hide
    for (( i=0; i<3; i++ )); do
        local line=""
        for (( j=0; j<cols; j++ )); do
            line+="${chars[$((RANDOM % ${#chars} + 1))]}"
        done
        printf '\r  \e[38;5;%sm%s\e[0m' "${_550W_C[err]}" "$line"
        _550w_pause 50
        printf '\r\e[K'
        _550w_pause 30
        (( _550W_SKIP )) && break
    done
    _550w_cur_reset
    return 0
}

# ══════════════════ 乱码文字 ══════════════════
# 随机字符逐步替换成目标文字
_550w_anim_glitch_text() {
    local text="$1"
    local color="${2:-${_550W_C[ok]}}"
    local dur="${3:-10}"
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
        printf '\r\e[K  \e[38;5;%sm%s\e[0m' "$color" "$out"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r\e[K  \e[38;5;%sm\e[1m%s\e[0m\n' "$color" "$text"
    return 0
}

# ══════════════════ 转场 ══════════════════
# 横线扫过 + 清屏
_550w_transition() {
    local color="${1:-${_550W_C[cyan]}}"
    (( _550W_FX )) || { _550w_cls; return 0; }
    local cols
    cols=$(_550w_cols)
    (( cols > 66 )) && cols=66
    local line=""
    local i
    for (( i=0; i<cols; i++ )); do line+="─"; done

    _550w_pause 80
    printf '\r\e[38;5;%sm%s\e[0m' "$color" "$line"
    _550w_pause 60
    printf '\r\e[K'
    _550w_pause 40
    _550w_cls
    return 0
}

# ══════════════════ 十六进制转储 ══════════════════
# 模拟内存 dump
# 参数：$1 行数（默认 6），$2 颜色（默认 ok）
_550w_anim_hex_dump() {
    local rows="${1:-6}"
    local color="${2:-${_550W_C[ok]}}"
    local hex="0123456789ABCDEF"
    local r i

    for (( r=0; r<rows; r++ )); do
        local addr
        addr=$(printf '%08X' $(( RANDOM * 4096 )))
        printf '  \e[38;5;%sm%s\e[0m  ' "${_550W_C[dim]}" "$addr"
        for (( i=0; i<16; i++ )); do
            printf '\e[38;5;%sm%s%s\e[0m ' "$color" \
                "${hex[$((RANDOM%16+1))]}" "${hex[$((RANDOM%16+1))]}"
        done
        print ""
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    return 0
}

# 带 ASCII 侧栏的 hexdump（类 xxd 输出）
_550w_anim_hex_dump_full() {
    local rows="${1:-5}"
    local color="${2:-${_550W_C[ok]}}"
    local hex="0123456789ABCDEF"
    local printable="0123456789abcdefghijklmnopqrstuvwxyz"
    local r i

    for (( r=0; r<rows; r++ )); do
        local addr
        addr=$(printf '0x%08X' $(( RANDOM * 4096 )))
        printf '  \e[38;5;%sm%s\e[0m  ' "${_550W_C[dim]}" "$addr"

        # 16 字节十六进制
        local ascii=""
        for (( i=0; i<16; i++ )); do
            local b1="${hex[$((RANDOM%16+1))]}"
            local b2="${hex[$((RANDOM%16+1))]}"
            printf '\e[38;5;%sm%s%s\e[0m ' "$color" "$b1" "$b2"
            if (( RANDOM % 2 == 0 )); then
                ascii+="${printable[$((RANDOM % 26 + 10))]}"
            else
                ascii+="."
            fi
        done
        printf ' \e[38;5;%sm|%s|\e[0m\n' "${_550W_C[cyan]}" "$ascii"
        _550w_pause 60
        (( _550W_SKIP )) && break
    done
    return 0
}

# ══════════════════ 二进制流 ══════════════════
# 3 行 01 流动
_550w_anim_binary_stream() {
    local rows="${1:-3}"
    local color="${2:-${_550W_C[ok]}}"
    local cols
    cols=$(_550w_cols)
    cols=$(( cols - 6 ))
    (( cols > 56 )) && cols=56

    local r i
    _550w_cur_hide
    for (( r=0; r<rows; r++ )); do print ""; done
    printf '\e[%dA' "$rows"

    local step
    for (( step=0; step<10; step++ )); do
        for (( r=0; r<rows; r++ )); do
            local line="  "
            for (( i=0; i<cols; i++ )); do
                if (( (i + step + r * 3) % 7 == 0 )); then
                    line+=$'\e[1m\e[97m'"$(($RANDOM % 2))"$'\e[0m'
                else
                    line+="$(($RANDOM % 2))"
                fi
            done
            printf '\r\e[38;5;%sm%s\e[0m\n' "$color" "$line"
        done
        printf '\e[%dA' "$rows"
        _550w_pause 70
        (( _550W_SKIP )) && break
    done
    printf '\e[%dB' "$rows"
    _550w_cur_reset
    return 0
}

# ══════════════════ 数字锁 ══════════════════
# 6 位数字滚轮从随机滚动到目标值
# 参数：$1 颜色，$2 目标数字（默认 000000）
_550w_anim_number_lock() {
    local color="${1:-${_550W_C[ok]}}"
    local target="$2"
    local len=6
    [[ -z "$target" ]] && target="000000"
    while (( ${#target} < len )); do target+="0"; done
    target="${target:0:len}"

    local i
    printf '  \e[38;5;%sm◤ ◥ ' "${_550W_C[dim]}"
    for (( i=0; i<len; i++ )); do
        printf '\e[38;5;%sm█\e[0m ' "${_550W_C[dim]}"
    done
    printf '\e[38;5;%sm◤ ◥\e[0m\n' "${_550W_C[dim]}"

    for (( i=0; i<len; i++ )); do
        local tick j
        for (( tick=0; tick<15; tick++ )); do
            printf '\r  \e[38;5;%sm◤ ◥\e[0m ' "$color"
            for (( j=0; j<len; j++ )); do
                if (( j < i )); then
                    printf '\e[1m%s\e[0m ' "${target[$((j+1))]}"
                elif (( j == i )); then
                    printf '\e[38;5;%sm%s\e[0m ' "$color" "$((RANDOM % 10))"
                else
                    printf '\e[38;5;%sm_\e[0m ' "${_550W_C[dim]}"
                fi
            done
            printf '\e[38;5;%sm◤ ◥\e[0m' "${_550W_C[dim]}"
            _550w_pause 40
            (( _550W_SKIP )) && break
        done
    done

    printf '\r  \e[38;5;%sm◤ ◥\e[0m ' "${_550W_C[ok]}"
    for (( i=0; i<len; i++ )); do
        printf '\e[1m\e[97m%s\e[0m ' "${target[$((i+1))]}"
    done
    printf '\e[38;5;%sm◤ ◥\e[0m\n' "${_550W_C[ok]}"
    _550w_beep ok
    return 0
}

# ══════════════════ 计数滚动 ══════════════════
# 数字从 0 滚动到目标值
_550w_anim_counter() {
    local target="${1:-100}"
    local duration="${2:-20}"
    local color="${3:-${_550W_C[ok]}}"
    local step
    for (( step=0; step<=duration; step++ )); do
        local v=$(( target * step / duration ))
        printf '\r  \e[38;5;%sm%*d\e[0m' "$color" "${#target}" "$v"
        _550w_pause 40
        (( _550W_SKIP )) && break
    done
    printf '\r  \e[38;5;%sm\e[1m%*d\e[0m\n' "$color" "${#target}" "$target"
    return 0
}

# ══════════════════ 百分比滚动 ══════════════════
# 0% → 目标% 滚动，带小数
_550w_anim_percent() {
    local target="${1:-100}"
    local color="${2:-${_550W_C[ok]}}"
    local step
    for (( step=0; step<=20; step++ )); do
        local v=$(( target * step / 20 ))
        printf '\r  \e[38;5;%sm%3d%%\e[0m' "$color" "$v"
        _550w_pause 50
        (( _550W_SKIP )) && break
    done
    printf '\r  \e[1m\e[38;5;%sm%3d%%\e[0m\n' "$color" "$target"
    return 0
}

# ══════════════════ 硬件探测 ══════════════════

# ── CPU 型号 ──
# 优先从 /proc/cpuinfo 抓 model name / Hardware / Processor
# 抓不到回退通用名
_550w_hw_cpu() {
    if [[ -r /proc/cpuinfo ]]; then
        local m
        m=$(grep -m1 -E 'model name|Hardware|Processor' /proc/cpuinfo 2>/dev/null \
            | cut -d: -f2 | sed 's/^ *//')
        if [[ -n "$m" ]]; then
            print -n "${m:0:44}"
            return 0
        fi
    fi
    print -n "Generic Quantum Core"
}

# ── 内存大小 ──
# 从 /proc/meminfo 读 MemTotal，转 GiB
_550w_hw_mem() {
    if [[ -r /proc/meminfo ]]; then
        local kb=""
        kb=$(grep -m1 'MemTotal' /proc/meminfo 2>/dev/null | awk '{print $2}')
        if [[ -z "$kb" ]]; then
            kb=$(grep -m1 'MemTotal' /proc/meminfo 2>/dev/null | tr -cd '0-9')
        fi
        if [[ -n "$kb" && "$kb" -gt 0 ]] 2>/dev/null; then
            if command -v awk >/dev/null 2>&1; then
                awk -v k="$kb" 'BEGIN{printf "%.1f GiB", k/1048576}'
            else
                print -n "$(( kb / 1048576 )) GiB"
            fi
            return 0
        fi
    fi
    print -n "unknown"
}

# ── 内核版本 ──
_550w_hw_kernel() {
    uname -s -r 2>/dev/null | cut -c1-44
}

# ── 主机名 ──
_550w_hw_hostname() {
    local h
    h=$(uname -n 2>/dev/null)
    [[ -z "$h" ]] && h="$HOST"
    print -n "${h:0:32}"
}

# ── 运行时长 ──
_550w_hw_uptime() {
    if [[ -r /proc/uptime ]]; then
        local secs
        secs=$(awk '{print int($1)}' /proc/uptime 2>/dev/null)
        if [[ -n "$secs" ]]; then
            local d=$(( secs / 86400 ))
            local h=$(( (secs % 86400) / 3600 ))
            local m=$(( (secs % 3600) / 60 ))
            printf '%dd %dh %dm' "$d" "$h" "$m"
            return 0
        fi
    fi
    print -n "unknown"
}

# ── 加速单元 ──
# 优先 NVIDIA，其次高通 Adreno / ARM Mali
_550w_hw_accel() {
    if command -v nvidia-smi >/dev/null 2>&1; then
        local n
        n=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
        if [[ -n "$n" ]]; then
            print -n "${n:0:32}"
            return 0
        fi
    fi
    if [[ -e /dev/kgsl-3d0 || -d /sys/class/kgsl ]]; then
        print -n "Adreno GPU"
        return 0
    fi
    if [[ -e /dev/mali0 ]]; then
        print -n "Mali GPU"
        return 0
    fi
    print -n "CPU-only inference"
}

# ── 架构 ──
_550w_hw_arch() {
    uname -m 2>/dev/null
}

# ── 磁盘剩余 ──
_550w_hw_disk() {
    local d
    d=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $4}')
    [[ -z "$d" ]] && d="unknown"
    print -n "$d"
}

# ── MAC 地址 ──
# 从 /sys/class/net/ 读第一个非 lo 接口的 MAC
_550w_hw_mac() {
    local iface mac
    for iface in /sys/class/net/*; do
        [[ -r "$iface/address" ]] || continue
        [[ "$(basename "$iface")" == "lo" ]] && continue
        mac=$(< "$iface/address")
        if [[ -n "$mac" && "$mac" != "00:00:00:00:00:00" ]]; then
            print -n "$mac"
            return 0
        fi
    done
    # 回退：随机生成
    printf '%02X:%02X:%02X:%02X:%02X:%02X' \
        $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)) \
        $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))
}

# ── CPU 核心数 ──
_550w_hw_cores() {
    local n=0
    if command -v nproc >/dev/null 2>&1; then
        n=$(nproc 2>/dev/null)
    elif [[ -r /proc/cpuinfo ]]; then
        n=$(grep -c '^processor' /proc/cpuinfo 2>/dev/null)
    fi
    (( n < 1 )) && n=1
    print -n "$n"
}

# ══════════════════ 网络延迟探测 ══════════════════
# 探测 3 个节点，输出毫秒
_550w_ping_probe() {
    command -v curl >/dev/null 2>&1 || return 0
    local -a hosts=(
        "open.bigmodel.cn|智谱节点"
        "www.baidu.com|骨干节点"
        "1.1.1.1|边缘节点"
    )
    local h name label t ms rc
    for h in "${hosts[@]}"; do
        name="${h%%|*}"
        label="${h#*|}"
        _550w_anim_radar "${_550W_C[ok]}" "$label"
        t=$(curl -s -o /dev/null -w "%{time_total}" --max-time 3 "https://$name" 2>/dev/null)
        rc=$?
        if (( rc == 0 )) && [[ -n "$t" ]]; then
            ms=$(awk -v x="$t" 'BEGIN{printf "%.0f", x*1000}' 2>/dev/null)
            [[ -z "$ms" ]] && ms="?"
            printf '  \e[38;5;%sm[NET]\e[0m %-14s \e[38;5;%sm%s ms\e[0m\n' \
                "${_550W_C[dim]}" "$label" "${_550W_C[ok]}" "$ms"
        else
            printf '  \e[38;5;%sm[NET]\e[0m %-14s \e[38;5;%sm—\e[0m\n' \
                "${_550W_C[dim]}" "$label" "${_550W_C[err]}"
        fi
        (( _550W_SKIP )) && break
    done
    return 0
}

# 简单 ping（单个 IP）
_550w_ping_one() {
    local host="$1"
    command -v curl >/dev/null 2>&1 || { print "无 curl"; return 1; }
    local t
    t=$(curl -s -o /dev/null -w "%{time_total}" --max-time 3 "https://$host" 2>/dev/null)
    if [[ -n "$t" ]]; then
        awk -v x="$t" 'BEGIN{printf "%.0f", x*1000}' 2>/dev/null
    else
        print "—"
    fi
}

# ══════════════════ MOSS Provider 预设 ══════════════════
# 15 个 provider，全部 OpenAI 兼容（Bearer + /chat/completions）
# 格式：名称 "端点|模型|环境变量"
typeset -gA _550W_PROVIDER_PRESET=(
    glm         "https://open.bigmodel.cn/api/paas/v4|glm-4-flash|ZHIPU_API_KEY"
    glm-pro     "https://open.bigmodel.cn/api/paas/v4|glm-4-plus|ZHIPU_API_KEY"
    glm-air     "https://open.bigmodel.cn/api/paas/v4|glm-4-air|ZHIPU_API_KEY"
    zai         "https://api.z.ai/api/paas/v4|glm-4-flash|ZAI_API_KEY"
    openai      "https://api.openai.com/v1|gpt-4o-mini|OPENAI_API_KEY"
    deepseek    "https://api.deepseek.com/v1|deepseek-chat|DEEPSEEK_API_KEY"
    moonshot    "https://api.moonshot.cn/v1|moonshot-v1-8k|MOONSHOT_API_KEY"
    qwen        "https://dashscope.aliyuncs.com/compatible-mode/v1|qwen-turbo|DASHSCOPE_API_KEY"
    groq        "https://api.groq.com/openai/v1|llama-3.1-8b-instant|GROQ_API_KEY"
    siliconflow "https://api.siliconflow.cn/v1|Qwen/Qwen2.5-7B-Instruct|SILICONFLOW_API_KEY"
    openrouter  "https://openrouter.ai/api/v1|auto|OPENROUTER_API_KEY"
    mistral     "https://api.mistral.ai/v1|mistral-small-latest|MISTRAL_API_KEY"
    stepfun     "https://api.stepfun.com/v1|step-1-8k|STEPFUN_API_KEY"
    local       "http://127.0.0.1:8000/v1|local-model|"
    custom      "|custom-model|CUSTOM_API_KEY"
)

# ══════════════════ MOSS 配置变量 ══════════════════
typeset -g _550W_MOSS_PROVIDER="${_550W_MOSS_PROVIDER:-glm}"
typeset -g _550W_MOSS_MODE="${_550W_MOSS_MODE:-cloud}"
typeset -g _550W_MOSS_LOCAL_URL="${_550W_MOSS_LOCAL_URL:-http://127.0.0.1:8000/v1}"
typeset -g _550W_MOSS_TIMEOUT="${_550W_MOSS_TIMEOUT:-60}"
typeset -g _550W_MOSS_TEMPERATURE="${_550W_MOSS_TEMPERATURE:-0.7}"
typeset -g _550W_MOSS_MAX_TOKENS="${_550W_MOSS_MAX_TOKENS:-2048}"
typeset -g _550W_MOSS_CTX_WINDOW="${_550W_MOSS_CTX_WINDOW:-10}"
typeset -g _550W_MOSS_QUANT="Q4_K_M"
typeset -g _550W_MOSS_LAYERS=32
typeset -g _550W_MOSS_CLOUD_URL=""
typeset -g _550W_MOSS_MODEL=""
typeset -g _550W_MOSS_TOKEN=""
typeset -g _550W_MOSS_CUSTOM_URL=""
typeset -g _550W_MOSS_CUSTOM_MODEL=""
typeset -g _550W_MOSS_CUSTOM_KEY=""

# ══════════════════ Provider 解析 ══════════════════
# 把 _550W_MOSS_PROVIDER 解析成：
#   _550W_MOSS_CLOUD_URL  端点
#   _550W_MOSS_MODEL      模型名
#   _550W_MOSS_TOKEN      API Key
# 参数 $1：quiet（1=静默，不打印警告）
_550w_moss_resolve_provider() {
    local quiet="${1:-0}"
    local p="$_550W_MOSS_PROVIDER"

    # custom 分支
    if [[ "$p" == "custom" ]]; then
        _550W_MOSS_CLOUD_URL="${_550W_MOSS_CUSTOM_URL:-}"
        _550W_MOSS_MODEL="${_550W_MOSS_CUSTOM_MODEL:-custom-model}"
        _550W_MOSS_TOKEN="${_550W_MOSS_CUSTOM_KEY:-}"
        if [[ -z "$_550W_MOSS_CLOUD_URL" ]]; then
            (( quiet )) || _550w_log warn "自定义 provider 未设置 URL"
            return 1
        fi
        return 0
    fi

    # 查预设
    local preset="${_550W_PROVIDER_PRESET[$p]:-}"
    if [[ -z "$preset" ]]; then
        (( quiet )) || _550w_log warn "未知 provider: $p，回退到 glm"
        _550W_MOSS_PROVIDER="glm"
        preset="${_550W_PROVIDER_PRESET[glm]}"
    fi

    # 拆分预设
    local url="${preset%%|*}"
    local rest="${preset#*|}"
    local model="${rest%%|*}"
    local envvar="${rest#*|}"

    _550W_MOSS_CLOUD_URL="$url"
    _550W_MOSS_MODEL="${_550W_MOSS_MODEL_OVERRIDE:-$model}"

    # 读 token
    if [[ "$p" == "local" ]]; then
        _550W_MOSS_TOKEN=""
    elif [[ -n "$envvar" && -n "${(P)envvar}" ]]; then
        _550W_MOSS_TOKEN="${(P)envvar}"
    else
        _550W_MOSS_TOKEN=""
    fi
    return 0
}

_550w_moss_resolve_provider 1

# ══════════════════ Provider 列表 ══════════════════
# 供菜单/教程使用，15 个 provider 名称
_550w_moss_provider_list() {
    print "glm glm-pro glm-air zai"
    print "openai deepseek moonshot"
    print "qwen groq siliconflow openrouter mistral stepfun"
    print "local custom"
}

# 按名称取模型名
_550w_moss_model_of() {
    local p="$1"
    local preset="${_550W_PROVIDER_PRESET[$p]:-}"
    [[ -z "$preset" ]] && { print "?"; return 1; }
    local rest="${preset#*|}"
    print "${rest%%|*}"
}

# 按名称取端点
_550w_moss_url_of() {
    local p="$1"
    local preset="${_550W_PROVIDER_PRESET[$p]:-}"
    [[ -z "$preset" ]] && { print "?"; return 1; }
    print "${preset%%|*}"
}

# 按名称取环境变量名
_550w_moss_envvar_of() {
    local p="$1"
    local preset="${_550W_PROVIDER_PRESET[$p]:-}"
    [[ -z "$preset" ]] && { print "?"; return 1; }
    print "${preset##*|}"
}

# ══════════════════ MOSS 记忆 ══════════════════
typeset -ga _550W_MOSS_HISTORY=()
typeset -g _550W_MOSS_HEALTH="unknown"
typeset -g _550W_MOSS_HEALTH_TIME=0
typeset -g _550W_MOSS_RATELIMIT_DAILY=2000
typeset -g _550W_MOSS_RATELIMIT_USED=0
typeset -g _550W_MOSS_AUDIT_ENABLED=1

# 加载记忆文件（每行一条 JSON）
_550w_moss_memory_load() {
    _550W_MOSS_HISTORY=()
    [[ -r "$_550W_MOSS_MEMORY_FILE" ]] || return 0
    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        [[ "$line" == *'"role":'* && "$line" == *'"content":'* ]] || continue
        _550W_MOSS_HISTORY+=("$line")
    done < "$_550W_MOSS_MEMORY_FILE"
    _550w_log debug "MOSS 记忆已加载: ${#_550W_MOSS_HISTORY[@]} 条"
}

# 保存记忆（只保留最近 _550W_MOSS_MEMORY_MAX 条）
_550w_moss_memory_save() {
    local tmp
    tmp=$(mktemp "${TMPDIR:-/tmp}/550w-mem.XXXXXX") || return 1
    local i
    local total=${#_550W_MOSS_HISTORY[@]}
    local start=1
    (( total > _550W_MOSS_MEMORY_MAX )) && start=$(( total - _550W_MOSS_MEMORY_MAX + 1 ))
    for (( i=start; i<=total; i++ )); do
        print -r -- "${_550W_MOSS_HISTORY[$i]}"
    done > "$tmp" 2>/dev/null
    if ! mv "$tmp" "$_550W_MOSS_MEMORY_FILE" 2>/dev/null; then
        _550w_log warn "记忆保存失败"
        rm -f "$tmp"
        return 1
    fi
    chmod 600 "$_550W_MOSS_MEMORY_FILE" 2>/dev/null
    return 0
}

_550w_moss_memory_load

# 记忆清空
_550w_moss_memory_clear() {
    _550W_MOSS_HISTORY=()
    rm -f "$_550W_MOSS_MEMORY_FILE" 2>/dev/null
}

# ══════════════════ 速率限制 ══════════════════
_550w_moss_ratelimit() {
    local today
    today=$(date +%Y%m%d)
    if [[ -r "$_550W_MOSS_RATELIMIT_FILE" ]]; then
        local d c
        read -r d c < "$_550W_MOSS_RATELIMIT_FILE" 2>/dev/null
        if [[ "$d" == "$today" ]]; then
            _550W_MOSS_RATELIMIT_USED=${c:-0}
        else
            _550W_MOSS_RATELIMIT_USED=0
        fi
    fi
    (( _550W_MOSS_RATELIMIT_USED >= _550W_MOSS_RATELIMIT_DAILY )) && return 1
    return 0
}

_550w_moss_ratelimit_incr() {
    (( _550W_MOSS_RATELIMIT_USED++ ))
    local tmp="${TMPDIR:-/tmp}/550w-rl.$$"
    print "$(date +%Y%m%d) $_550W_MOSS_RATELIMIT_USED" > "$tmp" 2>/dev/null
    mv "$tmp" "$_550W_MOSS_RATELIMIT_FILE" 2>/dev/null
}

# ══════════════════ 审计 ══════════════════
_550w_moss_audit() {
    (( _550W_MOSS_AUDIT_ENABLED )) || return 0
    local mode="$1"
    local tokens="$2"
    local elapsed="$3"
    print "$(_550w_ts) SID=$_550W_SESSION_ID provider=$_550W_MOSS_PROVIDER model=$_550W_MOSS_MODEL mode=$mode tokens=$tokens elapsed=${elapsed}ms" \
        >> "$_550W_MOSS_AUDIT_FILE" 2>/dev/null
}

# ══════════════════ 健康检查 ══════════════════
_550w_moss_health() {
    (( _550W_MOSS_ENABLED )) || { _550W_MOSS_HEALTH="disabled"; return; }
    command -v curl >/dev/null 2>&1 || { _550W_MOSS_HEALTH="no-curl"; return; }

    local url code
    local -a hdr=()

    if [[ "$_550W_MOSS_MODE" == "local" ]]; then
        url="$_550W_MOSS_LOCAL_URL/models"
    else
        [[ -z "$_550W_MOSS_CLOUD_URL" ]] && { _550W_MOSS_HEALTH="no-url"; return; }
        url="${_550W_MOSS_CLOUD_URL%/}/models"
        [[ -n "$_550W_MOSS_TOKEN" ]] && hdr=(-H "Authorization: Bearer $_550W_MOSS_TOKEN")
    fi

    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "${hdr[@]}" "$url" 2>/dev/null)
    case "$code" in
        2*)       _550W_MOSS_HEALTH="ok" ;;
        401|403)  _550W_MOSS_HEALTH="degraded" ;;
        000|"")   _550W_MOSS_HEALTH="down" ;;
        3*)       _550W_MOSS_HEALTH="ok" ;;
        *)        _550W_MOSS_HEALTH="degraded" ;;
    esac
    _550W_MOSS_HEALTH_TIME=${EPOCHSECONDS:-$(date +%s)}
    return 0
}

# 健康状态颜色
_550w_moss_health_color() {
    case "$_550W_MOSS_HEALTH" in
        ok)       print -n "${_550W_C[ok]}" ;;
        degraded) print -n "${_550W_C[warn]}" ;;
        down)     print -n "${_550W_C[err]}" ;;
        *)        print -n "${_550W_C[dim]}" ;;
    esac
}

# 健康状态中文
_550w_moss_health_label() {
    case "$_550W_MOSS_HEALTH" in
        ok)       print -n "在线" ;;
        degraded) print -n "降级" ;;
        down)     print -n "离线" ;;
        disabled) print -n "未启用" ;;
        no-curl)  print -n "无 curl" ;;
        no-url)   print -n "无端点" ;;
        *)        print -n "未知" ;;
    esac
}

# ══════════════════ JSON 转义 ══════════════════
typeset -g _550W_JSON_OUT=""

_550w_json_escape() {
    local s="$1"
    # 先转义反斜杠
    s="${s//\\/\\\\}"
    # 转义引号
    s="${s//\"/\\\"}"
    # 转义控制字符
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    _550W_JSON_OUT="$s"
}

# ══════════════════ MOSS 桥接 ══════════════════
# 发送 payload，返回响应体（通过 print 输出）
# 参数：$1 = JSON payload
# 返回：0 = 成功，1 = 失败
_550w_moss_bridge() {
    local payload="$1"
    local endpoint
    local mode="$_550W_MOSS_MODE"

    if [[ "$mode" == "local" ]]; then
        endpoint="${_550W_MOSS_LOCAL_URL%/}/chat/completions"
    else
        if [[ -z "$_550W_MOSS_CLOUD_URL" ]]; then
            _550w_log error "未配置云端端点"
            return 1
        fi
        endpoint="${_550W_MOSS_CLOUD_URL%/}/chat/completions"
    fi

    local -a hdr=(-H "Content-Type: application/json")
    if [[ "$mode" != "local" ]]; then
        if [[ -z "$_550W_MOSS_TOKEN" ]]; then
            _550w_log error "缺少 API Key (provider=$_550W_MOSS_PROVIDER)"
            return 1
        fi
        hdr+=(-H "Authorization: Bearer $_550W_MOSS_TOKEN")
    fi

    local resp
    resp=$(curl -s --max-time "$_550W_MOSS_TIMEOUT" "${hdr[@]}" -d "$payload" "$endpoint" 2>/dev/null)
    local rc=$?

    if (( rc != 0 || -z "$resp" )); then
        # auto 模式：云端不通回退本地
        if [[ "$mode" == "auto" && "$_550W_MOSS_PROVIDER" != "local" ]]; then
            _550w_log warn "云端不通, 回退本地"
            local sp="$_550W_MOSS_PROVIDER"
            local su="$_550W_MOSS_CLOUD_URL"
            local sm="$_550W_MOSS_MODEL"
            local st="$_550W_MOSS_TOKEN"
            local smode="$_550W_MOSS_MODE"

            _550W_MOSS_PROVIDER="local"
            _550W_MOSS_CLOUD_URL="$_550W_MOSS_LOCAL_URL"
            _550W_MOSS_MODEL="local-model"
            _550W_MOSS_TOKEN=""
            _550W_MOSS_MODE="local"

            _550w_moss_bridge "$payload"
            local r=$?

            _550W_MOSS_PROVIDER="$sp"
            _550W_MOSS_CLOUD_URL="$su"
            _550W_MOSS_MODEL="$sm"
            _550W_MOSS_TOKEN="$st"
            _550W_MOSS_MODE="$smode"
            return $r
        fi
        return 1
    fi
    print -nr -- "$resp"
    return 0
}

# ══════════════════ MOSS 对话（修复子 shell bug）══════════════════
# 关键修复：不通过 print 返回 reply，而是写到全局变量 _550W_MOSS_REPLY
# 这样调用方不需要 $(...)，全局状态（memory/ratelimit/audit）不会丢
# 参数：$1 = 用户消息
# 返回：0 = 成功，_550W_MOSS_REPLY 有值
#       1 = 失败，_550W_MOSS_REPLY 有错误说明
typeset -g _550W_MOSS_REPLY=""
typeset -g _550W_MOSS_LAST_MS=0

_550w_moss_chat() {
    local msg="$1"
    _550W_MOSS_REPLY=""
    _550W_MOSS_LAST_MS=0

    (( _550W_MOSS_ENABLED )) || { _550W_MOSS_REPLY="MOSS 未启用"; return 1; }
    _550w_moss_ratelimit || { _550W_MOSS_REPLY="已达每日限额"; return 1; }

    # 拼历史
    local -a msgs=()
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        [[ -n "${_550W_MOSS_HISTORY[$i]}" ]] && msgs+=("${_550W_MOSS_HISTORY[$i]}")
    done

    # 当前用户消息
    _550w_json_escape "$msg"
    msgs+=("{\"role\":\"user\",\"content\":\"$_550W_JSON_OUT\"}")

    # 拼 JSON
    local json="[" first=1 m
    for m in "${msgs[@]}"; do
        (( first )) || json+=","
        json+="$m"
        first=0
    done
    json+="]"

    local payload="{\"model\":\"$_550W_MOSS_MODEL\",\"messages\":$json,\"temperature\":$_550W_MOSS_TEMPERATURE,\"max_tokens\":$_550W_MOSS_MAX_TOKENS,\"stream\":false}"

    # 调用桥
    local t0="${EPOCHREALTIME:-}"
    local resp
    resp=$(_550w_moss_bridge "$payload")
    local rc=$?
    local t1="${EPOCHREALTIME:-}"
    local ms=0
    [[ -n "$t0" && -n "$t1" ]] && ms=$(( (${t1%.*} - ${t0%.*}) * 1000 ))
    _550W_MOSS_LAST_MS=$ms

    (( rc != 0 )) && { _550W_MOSS_REPLY="调用失败"; return 1; }

    # 解析回复（GNU grep -P 优先，否则 sed）
    local reply=""
    if command -v grep >/dev/null 2>&1 && grep --version 2>/dev/null | grep -q GNU; then
        reply=$(print -nr -- "$resp" | grep -oP '"content":"\K(?:[^"\\]|\\.)*' | head -1)
    else
        reply=$(print -nr -- "$resp" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | head -1)
    fi
    [[ -z "$reply" ]] && reply="(空响应)"

    # 写回历史
    msgs+=("{\"role\":\"assistant\",\"content\":\"$reply\"}")
    while (( ${#msgs[@]} > _550W_MOSS_CTX_WINDOW * 2 )); do
        msgs=("${msgs[@]:2}")
    done
    _550W_MOSS_HISTORY=()
    for (( i=1; i<=${#msgs[@]}; i++ )); do
        _550W_MOSS_HISTORY[$i]="${msgs[$i]}"
    done

    # 副作用：计数、审计、保存
    _550w_moss_ratelimit_incr
    _550w_moss_audit "$_550W_MOSS_MODE" "~${#msg}" "$ms"
    _550w_moss_memory_save

    _550W_MOSS_REPLY="$reply"
    return 0
}

# ══════════════════ MOSS 对话（带上下文备注）══════════════════
# 同 _550w_moss_chat，但支持 system prompt 前缀
_550w_moss_chat_sys() {
    local sysmsg="$1"
    local msg="$2"

    local saved_history=("${_550W_MOSS_HISTORY[@]}")
    _550w_json_escape "$sysmsg"
    _550W_MOSS_HISTORY=("{\"role\":\"system\",\"content\":\"$_550W_JSON_OUT\"}" "${_550W_MOSS_HISTORY[@]}")

    _550w_moss_chat "$msg"
    local rc=$?

    _550W_MOSS_HISTORY=("${saved_history[@]}")
    return $rc
}

# ══════════════════ 认证会话 ══════════════════

# ── 阶段 0：警告 + 接管链路 ──
_550w_phase0() {
    [[ "$_550W_MODE_ANIM" == "silent" || "$_550W_SPEED" == "instant" ]] && return 0
    _550w_cls; _550w_cur_hide
    local c1="${_550W_C[err]}"
    local cok="${_550W_C[ok]}"
    local cdim="${_550W_C[dim]}"
    local ccyan="${_550W_C[cyan]}"

    _550w_anim_scan_hv "$ccyan"
    _550w_cls

    local w=56
    local line="" i
    for (( i=0; i<w; i++ )); do line+="═"; done

    print ""
    print -P "%F{${c1}}%B  ╔${line}╗%f"
    print -P "%F{${c1}}%B  ║%f  %F{${c1}}%B⚠  警告  ⚠  未授权访问检测%f                                    %F{${c1}}%B║%f"
    print -P "%F{${c1}}%B  ╚${line}╝%f"
    print ""
    _550w_beep err
    _550w_pause 300

    print -nP "  %F{${c1}}%B>%f "
    _550w_anim_type "检测到未授权终端访问" 18
    _550w_pause 150

    print -nP "  %F{${c1}}%B>%f "
    _550w_anim_type "启动 550W 接管协议" 18
    _550w_pause 150

    print -nP "  %F{${c1}}%B>%f "
    _550w_anim_type "目标：量子智能主机 MOSS" 18
    _550w_pause 200
    print ""

    print -nP "  %F{${c1}}%B>%f "
    local dots=""
    local speeds=(80 70 60 50 45 40 35 30 25 22 20 18 16 15 15 18 22 28 35 45)
    for (( i=0; i<20; i++ )); do
        dots+="█"
        printf '\r  \e[38;5;%sm>\e[0m 建立接管链路 \e[38;5;%sm%s\e[0m %3d%%' \
            "$c1" "$cdim" "$dots" $(( (i+1) * 5 ))
        _550w_pause "${speeds[$((i+1))]}"
        (( _550W_SKIP )) && break
    done
    printf '\r  \e[38;5;%sm>\e[0m 建立接管链路 \e[1m\e[38;5;%sm████████████████████\e[0m \e[38;5;%sm✓\e[0m\n' \
        "$c1" "$cok" "$cok"

    _550w_beep ok
    _550w_pause 300
    print ""
    print -P "  %F{${cdim}}  ── $_550W_VERSION · $(_550w_hw_kernel) ──%f"
    print -P "  %F{${cdim}}  ── 会话种子已注入 ──%f"
    _550w_beep ok
    _550w_pause 400
}

# ── 阶段 1：标题 + SID 解密 ──
_550w_phase1() {
    [[ "$_550W_MODE_ANIM" == "silent" || "$_550W_SPEED" == "instant" ]] && return 0
    (( _550W_SKIP )) && return 0
    _550w_cls; _550w_cur_hide
    _550w_pause 200
    _550w_anim_scan_hv "${_550W_C[cyan]}"
    _550w_pause 150

    print ""; print ""
    printf '        \e[1m\e[97m'
    _550w_anim_type "550W 量子智能主机" 45
    printf '\e[0m        \e[38;5;%sm' "${_550W_C[ok]}"
    _550w_anim_type "核心代号：MOSS / 550W" 35
    printf '\e[0m        \e[38;5;%sm' "${_550W_C[dim]}"
    _550w_anim_type "引导协议 · $_550W_VERSION" 30
    printf '\e[0m'
    print ""
    _550w_pause 300
    _550w_anim_decrypt "$_550W_SESSION_ID"
    _550w_pause 400
    _550w_anim_scan_hv "${_550W_C[dim]}"
    _550w_pause 400
    _550w_cur_reset
}

# ── 阶段 2：四层加载 ──
_550w_phase2() {
    [[ "$_550W_MODE_ANIM" == "silent" || "$_550W_SPEED" == "instant" ]] && return 0
    (( _550W_SKIP )) && return 0
    local cok="${_550W_C[ok]}"
    local cdim="${_550W_C[dim]}"
    local cc="${_550W_C[cyan]}"

    _550w_cls
    print ""
    print -P "  %F{${cc}}%B── [1/4] 硬件层 ──%b%f"
    print ""
    local cpu mem kern accel
    cpu=$(_550w_hw_cpu); mem=$(_550w_hw_mem)
    kern=$(_550w_hw_kernel); accel=$(_550w_hw_accel)
    local -a hw=("处理器|$cpu" "内存|$mem" "系统核心|$kern" "加速单元|$accel" "终端|${TERM:-unknown}")
    local it k v
    for it in "${hw[@]}"; do
        k="${it%%|*}"; v="${it#*|}"
        printf '  \e[38;5;%sm[HW]\e[0m %-10s ' "$cdim" "$k"
        _550w_pause 80
        (( _550W_SKIP )) && break
        printf '\e[1m\e[97m%s\e[0m\n' "$v"
    done
    _550w_pause 200

    (( _550W_SKIP )) && return 0
    _550w_cls
    print ""
    print -P "  %F{${cc}}%B── [2/4] 系统层 ──%b%f"
    print ""
    _550w_anim_binary_stream 2 "$cok"
    print ""
    local -a pool=("量子核心" "算力节点" "记忆存储" "数据链路" "安全协议" "MOOS接口" "缓存总线" "时序晶振")
    local -a mods
    local idx
    while (( ${#pool[@]} > 0 )); do
        idx=$(( RANDOM % ${#pool[@]} + 1 ))
        mods+=("${pool[$idx]}")
        pool[$idx]=()
    done
    local n=0 m
    for m in "${mods[@]}"; do
        (( n++ ))
        printf '  \e[38;5;%sm[%02d]\e[0m %-10s \e[38;5;%sm检测中...\e[0m' "$cdim" "$n" "$m" "$cdim"
        _550w_pause 140
        (( _550W_SKIP )) && break
        printf '\r\e[K  \e[38;5;%sm[%02d]\e[0m %-10s \e[1m\e[38;5;%sm✓ 通过\e[0m\n' \
            "$cdim" "$n" "$m" "$cok"
        _550w_beep ok
        _550w_pause 50
    done
    _550w_pause 200

    (( _550W_SKIP )) && return 0
    _550w_cls
    print ""
    print -P "  %F{${cc}}%B── [3/4] AI 层 ──%b%f"
    print ""
    _550w_anim_hex_dump 3 "$cok"
    print ""
    if (( _550W_MOSS_ENABLED )); then
        printf '  \e[38;5;%sm[AI]\e[0m %-14s ' "$cdim" "MOSS 服务"
        _550w_pause 150
        _550w_moss_health
        case "$_550W_MOSS_HEALTH" in
            ok)       printf '\r\e[K  \e[38;5;%sm[AI]\e[0m %-14s \e[1m\e[38;5;%sm✓ 在线\e[0m\n' "$cdim" "MOSS 服务" "$cok" ;;
            degraded) printf '\r\e[K  \e[38;5;%sm[AI]\e[0m %-14s \e[38;5;%sm◐ 降级\e[0m\n' "$cdim" "MOSS 服务" "${_550W_C[warn]}" ;;
            *)        printf '\r\e[K  \e[38;5;%sm[AI]\e[0m %-14s \e[38;5;%sm✗ 离线\e[0m\n' "$cdim" "MOSS 服务" "${_550W_C[err]}" ;;
        esac
        printf '  \e[38;5;%sm[AI]\e[0m %-14s \e[1m\e[97m%s · %s · %s\e[0m\n' \
            "$cdim" "Provider" "$_550W_MOSS_PROVIDER" "$_550W_MOSS_MODEL" "$_550W_MOSS_MODE"
    fi
    print ""
    print -P "  %F{${cdim}}链路延迟探测%f"
    _550w_ping_probe
    _550w_pause 200

    (( _550W_SKIP )) && return 0
    _550w_cls
    print ""
    print -P "  %F{${cc}}%B── [4/4] 安全层 ──%b%f"
    print ""
    local -a sec=("密钥交换" "会话隔离" "审计链路" "指纹校验")
    local s
    for s in "${sec[@]}"; do
        printf '  \e[38;5;%sm[SEC]\e[0m %-12s ' "$cdim" "$s"
        _550w_pause 130
        (( _550W_SKIP )) && break
        printf '\e[1m\e[38;5;%sm✓ 就绪\e[0m\n' "$cok"
        _550w_beep ok
    done
    print ""
    print -P "  %F{${cok}}%B>> 四层加载完成%f"
    _550w_pause 400
}

# ── 阶段 3：核心引导 + 拓扑 + 权重 ──
_550w_phase3() {
    [[ "$_550W_MODE_ANIM" == "silent" || "$_550W_SPEED" == "instant" ]] && return 0
    (( _550W_SKIP )) && return 0
    local cok="${_550W_C[ok]}"
    local cc="${_550W_C[cyan]}"

    _550w_cls
    _550w_anim_scan_hv "$cc"
    print ""
    print -P "  %F{${cc}}%B核心引导 · $_550W_VERSION%b%f"
    print ""
    local -a submods=("加密引擎" "路由表" "缓存预热" "量子校验" "协议栈" "数据流" "内存分配" "线程池" "设备挂载" "服务注册")
    local -a pool=("${submods[@]}")
    submods=()
    local idx
    while (( ${#pool[@]} > 0 )); do
        idx=$(( RANDOM % ${#pool[@]} + 1 ))
        submods+=("${pool[$idx]}")
        pool[$idx]=()
    done
    _550w_anim_bar "${submods[@]}"
    _550w_pause 300
    (( _550W_SKIP )) && return 0

    _550w_cls
    print ""
    print -P "  %F{${cc}}%B── 节点拓扑 ──%b%f"
    print ""
    _550w_anim_topology
    _550w_pause 300
    (( _550W_SKIP )) && return 0

    if (( _550W_MOSS_ENABLED )); then
        _550w_cls
        print ""
        print -P "  %F{${cc}}%B── MOSS 权重加载 ──%b%f"
        print -P "  %F{${_550W_C[dim]}}$_550W_MOSS_PROVIDER · $_550W_MOSS_MODEL · $_550W_MOSS_MODE%f"
        print ""
        _550w_anim_layers
        print ""
        _550w_anim_wave "$cok"
        _550w_pause 250
    fi
}

# ══════════════════ 密码框（单行版）══════════════════
# 格式：┃ >> 密码 ●●●●●●●● [▰▰▱▱▱] 强
_550w_pw_draw() {
    local pw="$1"
    local len=${#pw}
    local mask_len=$len
    (( mask_len > _550W_PW_MASK_MAX )) && mask_len=$_550W_PW_MASK_MAX
    local mask="" i
    for (( i=1; i<=mask_len; i++ )); do mask+="●"; done
    (( len > _550W_PW_MASK_MAX )) && mask+="…"

    local strength=0
    (( len >= 4 ))  && strength=1
    (( len >= 8 ))  && strength=2
    (( len >= 12 )) && strength=3

    local -a bars=("▱▱▱▱▱" "▰▱▱▱▱" "▰▰▰▱▱" "▰▰▰▰▰")
    local -a labs=("弱" "中" "强" "极强")
    local -a clr=("${_550W_C[err]}" "${_550W_C[warn]}" "${_550W_C[ok]}" "${_550W_C[cyan]}")

    printf '\r\e[K  \e[38;5;%sm┃\e[0m \e[38;5;%sm>>\e[0m 密码 ' \
        "${_550W_C[dim]}" "${_550W_C[orange]}"
    printf '\e[1m\e[97m%-14s\e[0m' "$mask"
    printf ' \e[38;5;%sm[%s %s]\e[0m' \
        "${clr[$((strength+1))]}" "${bars[$((strength+1))]}" "${labs[$((strength+1))]}"
}

# ══════════════════ 阶段 4：密码输入 ══════════════════
_550w_phase4() {
    _550w_cls
    local cdim="${_550W_C[dim]}"
    local cc="${_550W_C[cyan]}"
    local br="${_550W_C[bright]}"
    local cwn="${_550W_C[warn]}"

    local w=52
    local bar="" i
    for (( i=0; i<w; i++ )); do bar+="═"; done

    print ""
    print -P "  %F{${cc}}%B╔${bar}╗%b%f"
    print -P "  %F{${cc}}%B║%f  %F{${br}}%B        550W · 身份验证  ·  MOSS 核心%b%f           %F{${cc}}%B║%f"
    print -P "  %F{${cc}}%B╚${bar}╝%b%f"
    print ""
    printf '  \e[38;5;%sm[信息]\e[0m 会话      \e[38;5;%sm%s\e[0m\n' "$cdim" "$cc" "$_550W_SESSION_ID"
    printf '  \e[38;5;%sm      \e[0m 版本      \e[38;5;%sm%s\e[0m\n' "$cdim" "$cdim" "$_550W_VERSION"
    printf '  \e[38;5;%sm      \e[0m 操作员    \e[38;5;%sm%s\e[0m\n' "$cdim" "$cc" "$_550W_USER_NAME"
    printf '  \e[38;5;%sm      \e[0m 剩余尝试  \e[38;5;%sm%d / %d\e[0m\n' \
        "$cdim" "$cc" $(( _550W_MAX_ATTEMPTS - _550W_ATTEMPTS )) "$_550W_MAX_ATTEMPTS"

    # 冷却提示
    local now=${EPOCHSECONDS:-$(date +%s)}
    if (( _550W_COOLDOWN_UNTIL > now )); then
        local left=$(( _550W_COOLDOWN_UNTIL - now ))
        printf '  \e[38;5;%sm      \e[0m 冷却      \e[1m\e[38;5;%sm还需 %d 秒\e[0m\n' \
            "$cdim" "$cwn" "$left"
        _550w_pause_hold 2
        return 1
    fi

    print ""
    print -P "  %F{${cdim}}────────── 请 输 入 密 码 ──────────%f"
    print ""

    _550W_PW=""
    local ret=1
    _550w_cur_block
    local stty_saved
    stty_saved=$(stty -g 2>/dev/null)

    {
        stty -echo 2>/dev/null
        _550w_pw_draw "$_550W_PW"
        local char
        while true; do
            if ! read -t "$_550W_READ_TIMEOUT" -k 1 char 2>/dev/null; then
                ret=1
                break
            fi
            case $char in
                $'\n'|$'\r') ret=0; break ;;
                $'\x7f'|$'\b') [[ -n "$_550W_PW" ]] && _550W_PW="${_550W_PW[1,-2]}" ;;
                $'\x03') ret=1; break ;;
                *) [[ "$char" == [[:print:]] ]] && _550W_PW+="$char" ;;
            esac
            _550w_pw_draw "$_550W_PW"
        done
    } always {
        if [[ -n "$stty_saved" ]]; then
            stty "$stty_saved" 2>/dev/null
        else
            stty echo 2>/dev/null
        fi
        _550w_cur_reset
        print ""
    }
    return $ret
}

# ══════════════════ 错误闪烁 ══════════════════
_550w_flash_err() {
    local msg="$1"
    local -a shifts=("" " " "  ")
    local i
    for (( i=0; i<4; i++ )); do
        printf '\r\e[K  \e[41m\e[97m%s>> %s\e[0m' "${shifts[$((i%3+1))]}" "$msg"
        sleep 0.1
        printf '\r\e[K  \e[38;5;%sm>> %s\e[0m' "${_550W_C[err]}" "$msg"
        sleep 0.06
    done
    print ""
    _550w_beep err
    sleep 0.5
}

# ══════════════════ 成功闪烁 ══════════════════
_550w_flash_ok() {
    local msg="$1"
    printf '\r\e[K  \e[42m\e[30m✓ %s\e[0m' "$msg"
    sleep 0.3
    print ""
    _550w_beep ok
    sleep 0.2
}

# ══════════════════ 阶段 5：授权通过 ══════════════════
# 含 hold 定格画面（高级操作员），不受速度影响
_550w_phase5() {
    _550w_cls
    local cok="${_550W_C[ok]}"
    local cc="${_550W_C[cyan]}"

    _550w_anim_glitch_text "✓ 授权通过" "$cok" 6
    _550w_beep ok
    _550w_pause 300

    local -a logs=(
        "核心上线|550W_CORE"
        "链路建立|LINK_ESTAB"
        "协议握手|PROTO_HSHK"
        "MOOS接管|MOOS_TAKE"
        "记忆同步|MEM_SYNC"
    )
    local entry name code
    for entry in "${logs[@]}"; do
        name="${entry%%|*}"; code="${entry#*|}"
        printf '  \e[38;5;%sm[%s]\e[0m %-10s \e[1m\e[38;5;%sm✓\e[0m  \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[dim]}" "$(_550w_ts)" "$name" "$cok" "${_550W_C[dim]}" "$code"
        _550w_pause 200
        (( _550W_SKIP )) && break
    done
    print ""
    _550w_anim_glitch_text "550W ONLINE" "$cok" 8
    print ""
    _550w_pause 400
    _550w_cls

    print ""; print ""
    _550w_anim_pulse "$cc" 3
    print ""

    # ── hold 画面：高级操作员（不缩放）──
    _550w_anim_box \
        "550W 量子智能主机  ·  $_550W_VERSION" \
        "" \
        "操作员    $_550W_USER_NAME" \
        "权限      $_550W_USER_ROLE" \
        "状态      已接管" \
        "会话      $_550W_SESSION_ID" \
        "" \
        "$_550W_USER_MOTTO"
    print ""

    # 定格 1.8 秒或按键跳过
    _550w_pause_hold 1.8
    _550w_cls
    local i
    for (( i=1; i<=3; i++ )); do
        print ""
        _550w_pause 60
    done
    return 0
}

# ══════════════════ 阶段 6：锁定 ══════════════════
_550w_phase6() {
    _550w_cls; _550w_cur_hide
    local cerr="${_550W_C[err]}"
    print ""; print ""; print ""
    local i
    for (( i=0; i<4; i++ )); do
        printf '\r              \e[41m\e[97m\e[1m  系统已锁定  \e[0m'
        sleep 0.15
        printf '\r\e[K              \e[1m\e[38;5;%sm  系统已锁定  \e[0m' "$cerr"
        sleep 0.15
    done
    print ""; print ""
    print -P "              %F{${_550W_C[dim]}}需要重新初始化终端%f"
    _550w_beep lock
    _550w_pause 1800
    _550w_cls

    print ""
    print -P "  %F{${_550W_C[cyan]}}%B── 审计记录 ──%b%f"
    print ""
    printf '  \e[38;5;%sm[%s]\e[0m 失败次数    \e[1m\e[38;5;%sm%d\e[0m\n' \
        "${_550W_C[dim]}" "$(_550w_ts)" "$cerr" "$_550W_FAIL_COUNT"
    printf '  \e[38;5;%sm[%s]\e[0m 最后尝试    \e[38;5;%sm%s\e[0m\n' \
        "${_550W_C[dim]}" "$(_550w_ts)" "${_550W_C[dim]}" "${_550W_LAST_FAIL_TIME:-unknown}"
    printf '  \e[38;5;%sm[%s]\e[0m 会话 ID     \e[38;5;%sm%s\e[0m\n' \
        "${_550W_C[dim]}" "$(_550w_ts)" "${_550W_C[cyan]}" "$_550W_SESSION_ID"
    printf '  \e[38;5;%sm[%s]\e[0m 状态        \e[1m\e[38;5;%smLOCKED\e[0m\n' \
        "${_550W_C[dim]}" "$(_550w_ts)" "$cerr"
    _550w_pause 2200
    _550w_cls
    print ""; print ""; print ""; print ""
    print -P "  %F{${_550W_C[warn]}}%B运行 '550w-reset' 重新验证%f"
    _550w_cur_reset
}

# ══════════════════ 认证循环 ══════════════════
_550w_auth_loop() {
    local pw ret
    while (( _550W_ATTEMPTS < _550W_MAX_ATTEMPTS )); do
        _550w_phase4
        ret=$?
        pw="$_550W_PW"
        _550W_PW=""

        if (( ret != 0 )); then
            (( _550W_ATTEMPTS++, _550W_FAIL_COUNT++ ))
            _550W_LAST_FAIL_TIME=$(_550w_ts)
            _550w_flash_err "会话终止"
            continue
        fi

        if [[ "$pw" == "$_550W_PASS" ]]; then
            pw=""
            _550w_flash_ok "验证通过"
            _550w_phase5
            _550w_enter_system
            return 0
        fi

        pw=""
        (( _550W_ATTEMPTS++, _550W_FAIL_COUNT++ ))
        _550W_LAST_FAIL_TIME=$(_550w_ts)

        # 冷却检查
        if (( _550W_FAIL_COUNT >= _550W_COOLDOWN_ATTEMPTS )); then
            local now=${EPOCHSECONDS:-$(date +%s)}
            _550W_COOLDOWN_UNTIL=$(( now + _550W_COOLDOWN_SECONDS ))
        fi

        local remain=$(( _550W_MAX_ATTEMPTS - _550W_ATTEMPTS ))
        _550w_flash_err "验证失败 (剩余 $remain 次)"
    done

    _550w_phase6
    _550W_MODE="locked"
    typeset -gx _550W_DONE=1
    _550w_unhook
}

# ══════════════════ 进入系统 ══════════════════
_550w_enter_system() {
    _550W_USER_LASTLOGIN=$(date '+%Y-%m-%d %H:%M')
    (( _550W_USER_LOGINS++ ))
    _550w_profile_save >/dev/null 2>&1

    _550w_welcome_screen

    _550W_MODE="capture"
    _550W_LAST_BEAT=${EPOCHSECONDS:-$(date +%s)}
    _550W_LAST_ACTIVITY=$_550W_LAST_BEAT
    _550w_build_ps1
    _550w_cur_reset
    typeset -gx _550W_DONE=1
    _550w_unhook
    _550w_install_heartbeat
    _550w_session_save

    typeset -g HISTFILE="${HOME}/.550w/.550w_history"
    setopt HIST_IGNORE_ALL_DUPS 2>/dev/null
}

# ══════════════════ 提示符 ══════════════════
# 格式：550W_computer_Earth Engine ● HH:MM:SS root@Max-System:~#
_550w_build_ps1() {
    local cc="${_550W_C[cyan]}"
    local cs="${_550W_C[dim]}"
    local cok="${_550W_C[ok]}"
    local cw="${_550W_C[warn]}"
    local moss=""

    if (( _550W_MOSS_ENABLED )); then
        case "$_550W_MOSS_HEALTH" in
            ok)       moss="%F{${cok}}●%F{${cs}}" ;;
            degraded) moss="%F{${cw}}◐%F{${cs}}" ;;
            *)        moss="%F{${_550W_C[err]}}○%F{${cs}}" ;;
        esac
    fi

    if (( _550W_COLORS )); then
        PS1=$'%F{'"$cc"$'}%B550W_computer_Earth Engine%b%f '"$moss"$'%F{'"$cs"$'}%D{%H:%M:%S}%f %F{'"$cok"$'}root@Max-System:~# %f'
    else
        PS1=$'550W_computer_Earth Engine %D{%H:%M:%S} root@Max-System:~# '
    fi
}

# ══════════════════ 心跳钩子 ══════════════════
_550w_install_heartbeat() {
    autoload -Uz add-zsh-hook
    _550w_unhook_heartbeat
    add-zsh-hook precmd _550w_heartbeat
    add-zsh-hook preexec _550w_preexec
}

_550w_unhook_heartbeat() {
    precmd_functions=(${precmd_functions:#_550w_heartbeat})
    preexec_functions=(${preexec_functions:#_550w_preexec})
}

_550w_preexec() {
    _550W_LAST_ACTIVITY=${EPOCHSECONDS:-$(date +%s)}
    _550W_CMD_START=${EPOCHREALTIME:-}
}

# 心跳：每 60 秒一行状态，超过空闲阈值自动锁定
_550w_heartbeat() {
    [[ "$_550W_DONE" == "1" && "$_550W_MODE" != "locked" ]] || return 0

    local now=${EPOCHSECONDS:-$(date +%s)}

    # 命令耗时提示
    if [[ -n "$_550W_CMD_START" ]]; then
        local t1="${EPOCHREALTIME:-}"
        if [[ -n "$t1" ]]; then
            local secs=$(( ${t1%.*} - ${_550W_CMD_START%.*} ))
            (( secs >= _550W_CMD_TIMING_THRESHOLD )) && \
                print -P "%F{${_550W_C[dim]}}· 上次命令耗时 ${secs}s%f"
        fi
        _550W_CMD_START=""
    fi

    # 空闲锁定
    if (( now - _550W_LAST_ACTIVITY > _550W_IDLE_LOCKOUT )); then
        _550W_MODE="locked"
        _550W_DONE=0
        _550w_build_ps1
        print -P "%F{${_550W_C[warn]}}>> 空闲超时，会话已锁定。运行 '550w-reset' 解锁%f"
        _550W_LAST_ACTIVITY=$now
        return 0
    fi

    # 心跳间隔
    (( now - _550W_LAST_BEAT >= _550W_HEARTBEAT_INTERVAL )) || return 0
    _550W_LAST_BEAT=$now

    local uptime=$(( now - _550W_START_TIME ))
    local lat=$(( RANDOM % 30 + 5 ))
    local ms=""
    if (( _550W_MOSS_ENABLED )); then
        case "$_550W_MOSS_HEALTH" in
            ok)       ms=" · moss %F{${_550W_C[ok]}}ok%F{${_550W_C[dim]}}" ;;
            degraded) ms=" · moss %F{${_550W_C[warn]}}degraded%F{${_550W_C[dim]}}" ;;
            *)        ms=" · moss %F{${_550W_C[err]}}down%F{${_550W_C[dim]}}" ;;
        esac
    fi
    print -P "%F{${_550W_C[dim]}}· core %F{${_550W_C[ok]}}active%F{${_550W_C[dim]}} · link %F{${_550W_C[ok]}}ok%F{${_550W_C[dim]}}${ms} · latency ${lat}ms · uptime ${uptime}s%f"
}

# ══════════════════ 未知命令提示 ══════════════════
# 根据输入的第一个字母给建议
command_not_found_handler() {
    local cmd="$1"
    local suggest=""

    case "${cmd[1]}" in
        [a-c]) suggest="ls cat cd cp" ;;
        [d-f]) suggest="df find fsck" ;;
        [g-i]) suggest="grep git ls" ;;
        [j-l]) suggest="ls job kill" ;;
        [m-o]) suggest="mkdir mv nano" ;;
        [p-r]) suggest="pwd rm rmdir" ;;
        [s-u]) suggest="ssh sudo tar" ;;
        [v-x]) suggest="vi wget xargs" ;;
        [y-z]) suggest="zip unzip" ;;
        *)     suggest="ls cat grep find nano" ;;
    esac

    print -P "%F{${_550W_C[err]}}>> 未知命令: $cmd%f" >&2
    print -P "%F{${_550W_C[dim]}}   可能的相关命令: $suggest%f" >&2
    return 0
}

# ══════════════════ 主登录流程 ══════════════════
# 15 步时序：
#  phase_neg1 (冷启动) → phase0 (警告) → phase1 (标题+SID)
#  → phase2 (四层) → phase3 (拓扑+权重)
#  → phase4 (密码) → phase5 (授权+hold) → 进入系统
_550w_login() {
    [[ "$_550W_DONE" == "1" ]] && { _550w_unhook; return 0; }

    _550W_SKIP=0
    _550W_EMERGENCY=0
    _550W_ATTEMPTS=0
    _550W_START_TIME=${EPOCHSECONDS:-$(date +%s)}
    _550W_LAST_ACTIVITY=$_550W_START_TIME
    _550W_SESSION_ID=$(_550w_gen_sid)
    _550W_PHASE_NOW=0
    _550W_PHASE_TOTAL=15

    sleep "$_550W_READY_DELAY"

    _550w_phase0
    _550w_phase1
    _550w_phase2
    _550w_phase3
    _550w_boot_anim_run

    if (( _550W_EMERGENCY )); then
        _550w_emergency_exit
        return 0
    fi

    _550w_auth_loop
}

# ══════════════════ 紧急退出 ══════════════════
_550w_emergency_exit() {
    _550w_cls
    _550w_cur_reset
    typeset -gx _550W_DONE=1
    _550w_unhook
    _550w_unhook_heartbeat
    _550w_build_ps1
    print -P "%F{${_550W_C[warn]}}>> 接管中止，恢复普通终端%f"
}

# ══════════════════ Hook 管理 ══════════════════
_550w_unhook() {
    precmd_functions=(${precmd_functions:#_550w_login})
}

_550w_hook() {
    autoload -Uz add-zsh-hook
    _550w_unhook
    add-zsh-hook precmd _550w_login
}

# ══════════════════ 欢迎画 ══════════════════
# 6 行渐变大字 + 操作员档案（hold 级）
_550w_welcome_screen() {
    _550w_cls
    print ""
    print ""

    # 6 行渐变大字：绿 → 青 → 蓝 → 紫
    local -a ascii_lines=(
        "    ███████╗ ███████╗  ██████╗ ██╗    ██╗"
        "    ██╔════╝ ██╔════╝ ██╔═████╗██║    ██║"
        "    ███████╗ ███████╗ ██║██╔██║██║ █╗ ██║"
        "    ╚════██║ ╚════██║ ████╔╝██║██║███╗██║"
        "    ███████║ ███████║ ╚██████╔╝╚███╔███╔╝"
        "    ╚══════╝ ╚══════╝  ╚═════╝  ╚══╝╚══╝ "
    )
    local -a grad_colors=(46 46 51 45 39 135)
    local i
    for (( i=1; i<=6; i++ )); do
        printf '\e[1m\e[38;5;%sm%s\e[0m\n' "${grad_colors[$i]}" "${ascii_lines[$i]}"
        sleep 0.06
    done
    sleep 0.1
    print ""

    # 欢迎框
    local bar="" j
    for (( j=0; j<52; j++ )); do bar+="═"; done
    print -P "%F{${_550W_C[ok]}}%B╔${bar}╗%b%f"
    print -P "%F{${_550W_C[ok]}}%B║%f  %F{${_550W_C[bright]}}%B◆  WELCOME BACK  ·  欢迎回来%b%f                              %F{${_550W_C[ok]}}%B║%f"
    print -P "%F{${_550W_C[ok]}}%B╚${bar}╝%b%f"
    print ""
    _550w_pause 300

    # 操作员档案（hold 级：不缩放）
    print -P "  %F{${_550W_C[dim]}}[操作员档案]%f"
    printf '  \e[38;5;%sm├─ 用户名\e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_NAME"
    sleep 0.08
    printf '  \e[38;5;%sm├─ 等级  \e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_LEVEL"
    sleep 0.08
    printf '  \e[38;5;%sm└─ 权限  \e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_ROLE"
    print ""
    _550w_pause 200

    # 系统状态
    local mem_n=${#_550W_MOSS_HISTORY[@]}
    print -P "  %F{${_550W_C[dim]}}[系统状态]%f"
    printf '  \e[38;5;%sm├─ 核心   \e[0m \e[1m\e[38;5;%sm已激活\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 链路   \e[0m \e[1m\e[38;5;%sm已建立\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}"
    sleep 0.06
    printf '  \e[38;5;%sm├─ MOSS   \e[0m \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$_550W_MOSS_HEALTH"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 记忆   \e[0m \e[1m\e[38;5;%sm%d 条\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$mem_n"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 会话   \e[0m \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$_550W_SESSION_ID"
    sleep 0.06
    if [[ -n "$_550W_USER_LASTLOGIN" ]]; then
        printf '  \e[38;5;%sm└─ 上次   \e[0m \e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[dim]}" "$_550W_USER_LASTLOGIN"
    fi
    print ""
    _550w_pause 300

    # 签名（hold）
    local motto_safe="${_550W_USER_MOTTO//\%/%%}"
    print -P "  %F{${_550W_C[ok]}}%B══════════════════════════════════════════════════%b%f"
    print -P "  %F{${_550W_C[dim]}}  $motto_safe%f"
    print -P "  %F{${_550W_C[ok]}}%B══════════════════════════════════════════════════%b%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}输入 %f%F{${_550W_C[ok]}}%B550w-help%f%F{${_550W_C[dim]}} 查看帮助%f"
    print ""
    _550w_pause_hold 0.8
    _550w_cls
}

# ══════════════════ 命令接口 ══════════════════

# ── 系统控制 ──
550w-reset() {
    _550w_unhook; _550w_unhook_heartbeat
    typeset -gx _550W_DONE=0
    _550W_ATTEMPTS=0
    _550W_FAIL_COUNT=0
    _550W_LAST_FAIL_TIME=""
    _550W_SKIP=0
    _550W_EMERGENCY=0
    _550W_MODE="normal"
    _550W_MOSS_HISTORY=()
    _550W_SESSION_ID=""
    _550W_CMD_START=""
    _550W_PHASE_NOW=0
    _550w_moss_memory_load
    _550w_cur_reset
    _550w_hook
    print -P "%F{${_550W_C[warn]}}>> 登录状态已重置%f"
}

550w-skip() {
    typeset -gx _550W_DONE=1
    _550W_MODE="capture"
    [[ -z "$_550W_SESSION_ID" ]] && _550W_SESSION_ID=$(_550w_gen_sid)
    _550w_unhook
    _550w_build_ps1
    _550w_cur_reset
    _550w_install_heartbeat
    _550w_session_save
    print -P "%F{${_550W_C[warn]}}>> 登录已跳过 ($_550W_SESSION_ID)%f"
}

# ── 速度（5 级）──
550w-speed() {
    case "$1" in
        flash|fast|normal|slow|hold)
            _550W_SPEED="$1"
            _550w_config_save >/dev/null 2>&1
            print -P "%F{${_550W_C[cyan]}}>> 速度: $1%f" ;;
        slow4) _550W_SPEED="slow"; print -P "%F{${_550W_C[cyan]}}>> 速度: slow%f" ;;
        instant) _550W_SPEED="flash"; print -P "%F{${_550W_C[cyan]}}>> 速度: flash (instant 兼容)%f" ;;
        *)
            print -P "%F{${_550W_C[warn]}}用法: 550w-speed [flash|fast|normal|slow|hold]%f"
            print -P "  当前: $_550W_SPEED"
            ;;
    esac
}

# ── 特效 ──
550w-fx() {
    case "$1" in
        1|on)
            _550W_FX=1
            _550w_config_save >/dev/null 2>&1
            print -P "%F{${_550W_C[cyan]}}>> 特效: 开%f" ;;
        0|off)
            _550W_FX=0
            _550w_config_save >/dev/null 2>&1
            print -P "%F{${_550W_C[warn]}}>> 特效: 关%f" ;;
        *)
            print -P "%F{${_550W_C[warn]}}用法: 550w-fx [0|1]  当前: $_550W_FX%f" ;;
    esac
}

# ── 主题 ──
550w-theme() {
    local -a themes=(cyber amber ice moss crimson)
    if [[ -z "$1" ]]; then
        print -P "%F{${_550W_C[cyan]}}%B主题列表%b%f"
        local t
        for t in "${themes[@]}"; do
            local mark=" "; [[ "$t" == "$_550W_THEME" ]] && mark="*"
            printf '  %s %s\n' "$mark" "$t"
        done
        print ""
        print "用法: 550w-theme [名称]"
        return 0
    fi

    local found=0 t
    for t in "${themes[@]}"; do
        [[ "$t" == "$1" ]] && found=1
    done
    if (( !found )); then
        print -P "%F{${_550W_C[err]}}>> 未知主题: $1%f"
        return 1
    fi

    _550W_THEME="$1"
    _550w_config_save >/dev/null 2>&1
    print -P "%F{${_550W_C[ok]}}>> 主题已切换: $1%f"
    print -P "%F{${_550W_C[dim]}}  注：配色应用需下次启动生效%f"
}

# ── 版本 ──
550w-version() {
    print -P "%F{${_550W_C[cyan]}}%B550W 版本信息%b%f"
    print "  版本    $_550W_VERSION"
    print "  构建    $_550W_BUILD_DATE"
    print "  文件    $_550W_LOGIN_FILE"
    print "  行数    $(wc -l < "$_550W_LOGIN_FILE" 2>/dev/null | tr -d ' ')"
}

# ── 状态 ──
550w-status() {
    local uptime=$(( ${EPOCHSECONDS:-$(date +%s)} - _550W_START_TIME ))
    local pc=0
    [[ -f "$_550W_PLUGIN_INDEX" ]] && pc=$(wc -l < "$_550W_PLUGIN_INDEX" 2>/dev/null | tr -d ' ')

    print -P "%F{${_550W_C[cyan]}}%B550W 系统状态%b%f"
    print -P "  版本    $_550W_VERSION"
    print -P "  会话    %F{${_550W_C[cyan]}}$_550W_SESSION_ID%f"
    print -P "  模式    %F{${_550W_C[warn]}}$_550W_MODE%f"
    print -P "  速度    $_550W_SPEED"
    print -P "  特效    $_550W_FX"
    print -P "  主题    $_550W_THEME"
    print -P "  状态    $([[ "$_550W_DONE" == "1" ]] && echo 已接管 || echo 待验证)"
    print -P "  失败    $_550W_FAIL_COUNT"
    print -P "  存活    ${uptime}s"
    print -P ""
    print -P "%F{${_550W_C[cyan]}}── MOSS AI ──%f"
    print -P "  启用    $_550W_MOSS_ENABLED"
    print -P "  Provider %F{${_550W_C[ok]}}$_550W_MOSS_PROVIDER%f"
    print -P "  模型    $_550W_MOSS_MODEL"
    print -P "  健康    $_550W_MOSS_HEALTH"
    print -P "  额度    $_550W_MOSS_RATELIMIT_USED/$_550W_MOSS_RATELIMIT_DAILY"
    print -P "  记忆    $(( ${#_550W_MOSS_HISTORY[@]} / 2 )) 轮"
    print -P ""
    print -P "%F{${_550W_C[cyan]}}── 插件 ──%f"
    print -P "  已装    ${pc} 个"
}

# ── MOSS 配置查看 ──
550w-moss() {
    print -P "%F{${_550W_C[cyan]}}%BMOSS AI 配置%b%f"
    print -P "  启用       $_550W_MOSS_ENABLED"
    print -P "  Provider   %F{${_550W_C[ok]}}$_550W_MOSS_PROVIDER%f"
    print -P "  模式       %F{${_550W_C[warn]}}$_550W_MOSS_MODE%f"
    print -P "  端点       $_550W_MOSS_CLOUD_URL"
    print -P "  模型       $_550W_MOSS_MODEL"
    print -P "  温度       $_550W_MOSS_TEMPERATURE"
    print -P "  MaxTokens  $_550W_MOSS_MAX_TOKENS"
    print -P "  上下文     $_550W_MOSS_CTX_WINDOW 轮"
    print -P "  Token      $([[ -n "$_550W_MOSS_TOKEN" ]] && echo 已配置 || echo 未配置)"
    print -P "  健康       $_550W_MOSS_HEALTH"
    print -P "  额度       $_550W_MOSS_RATELIMIT_USED/$_550W_MOSS_RATELIMIT_DAILY"
}

# ── AI 对话（修复子 shell bug）──
550w-ai() {
    local msg="$*"
    if [[ -z "$msg" ]]; then
        print -n "  >> MOSS> "
        read -r msg
    fi
    [[ -z "$msg" ]] && return 0

    (( _550W_FX && _550W_MODE_ANIM != "silent" )) && _550w_anim_wave "${_550W_C[cyan]}"
    print -P "%F{${_550W_C[cyan]}}[MOSS]%f $msg"

    _550w_moss_chat "$msg"
    local rc=$?

    if (( rc == 0 )); then
        print -P "%F{${_550W_C[ok]}}[550W]%f $_550W_MOSS_REPLY"
    else
        print -P "%F{${_550W_C[err]}}[ERR]%f $_550W_MOSS_REPLY"
    fi
}

# ══════════════════ 记忆管理 ══════════════════
550w-memory() {
    local cmd="${1:-show}"
    case "$cmd" in
        show|list)
            if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
                print -P "%F{${_550W_C[dim]}}>> 记忆为空%f"
                return 0
            fi
            print -P "%F{${_550W_C[cyan]}}%BMOSS 记忆%b%f (${#_550W_MOSS_HISTORY[@]} 条)"
            print ""
            local i role content preview
            local use_pcre=0
            if command -v grep >/dev/null 2>&1 && grep --version 2>/dev/null | grep -q GNU; then
                use_pcre=1
            fi
            for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
                content="${_550W_MOSS_HISTORY[$i]}"
                if (( use_pcre )); then
                    preview=$(print -nr -- "$content" | grep -oP '"content":"\K(?:[^"\\]|\\.)*' | head -1)
                else
                    preview=$(print -nr -- "$content" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | head -1)
                fi
                [[ -z "$preview" ]] && preview="(空)"
                [[ "$content" == *'"role":"user"'* ]] && role="U" || role="A"
                (( ${#preview} > 60 )) && preview="${preview:0:57}..."
                preview="${preview//\%/%%}"
                if [[ "$role" == "U" ]]; then
                    print -P "  %F{${_550W_C[cyan]}}U%f  ${preview}"
                else
                    print -P "  %F{${_550W_C[ok]}}A%f  ${preview}"
                fi
            done
            print ""
            print -P "%F{${_550W_C[dim]}}  文件: $_550W_MOSS_MEMORY_FILE%f"
            ;;
        clear|reset|rm)
            _550w_moss_memory_clear
            print -P "%F{${_550W_C[ok]}}>> 记忆已清空%f"
            ;;
        path)
            print "$_550W_MOSS_MEMORY_FILE"
            ;;
        max)
            if [[ -n "$2" ]]; then
                if [[ "$2" =~ '^[0-9]+$' ]] && (( $2 >= 4 && $2 <= 500 )); then
                    _550W_MOSS_MEMORY_MAX="$2"
                    _550w_config_save >/dev/null 2>&1
                    print -P "%F{${_550W_C[ok]}}>> 记忆上限设为 $2 条%f"
                else
                    print -P "%F{${_550W_C[err]}}>> 无效值（需 4~500 整数）%f"
                    return 1
                fi
            else
                print "当前上限: $_550W_MOSS_MEMORY_MAX 条"
            fi
            ;;
        *) print "用法: 550w-memory show|clear|path|max [N]" ;;
    esac
}

# ── MOSS Provider 切换 ──
550w-moss-set() {
    local arg="$1"
    if [[ -z "$arg" ]]; then
        print -P "%F{${_550W_C[cyan]}}%BMOSS Provider 切换%b%f"
        print -P "  当前: %F{${_550W_C[ok]}}$_550W_MOSS_PROVIDER%f (model=$_550W_MOSS_MODEL)"
        print ""
        local -a order=(glm glm-pro glm-air zai openai deepseek moonshot qwen groq siliconflow openrouter mistral stepfun local custom)
        local p
        for p in "${order[@]}"; do
            local url model
            url=$(_550w_moss_url_of "$p")
            model=$(_550w_moss_model_of "$p")
            local mark=" "
            [[ "$p" == "$_550W_MOSS_PROVIDER" ]] && mark="*"
            printf '  %s %-12s %-28s %s\n' "$mark" "$p" "$model" "$url"
        done
        print ""
        print -n "  输入 provider 名称 (回车取消): "
        read -r arg
        [[ -z "$arg" ]] && { print "  已取消"; return 0; }
    fi

    if [[ "$arg" == "custom" ]]; then
        typeset -g _550W_MOSS_CUSTOM_URL _550W_MOSS_CUSTOM_MODEL _550W_MOSS_CUSTOM_KEY
        print -n "  自定义 URL: "; read -r _550W_MOSS_CUSTOM_URL
        print -n "  自定义 Model: "; read -r _550W_MOSS_CUSTOM_MODEL
        print -n "  API Key (可空): "; read -rs _550W_MOSS_CUSTOM_KEY; print ""
    fi

    if [[ -z "${_550W_PROVIDER_PRESET[$arg]:-}" && "$arg" != "custom" ]]; then
        print -P "%F{${_550W_C[err]}}>> 未知 provider: $arg%f"
        return 1
    fi

    typeset -g _550W_MOSS_PROVIDER="$arg"
    _550w_moss_resolve_provider
    _550w_config_save >/dev/null 2>&1

    if [[ -z "$_550W_MOSS_TOKEN" && "$arg" != "local" && "$arg" != "custom" ]]; then
        local envvar="${_550W_PROVIDER_PRESET[$arg]##*|}"
        print -P "%F{${_550W_C[warn]}}>> 需要设置环境变量: $envvar%f"
    fi
    print -P "%F{${_550W_C[ok]}}>> 已切换: $arg ($_550W_MOSS_MODEL)%f"
    _550w_moss_health
    print -P "   健康: $_550W_MOSS_HEALTH"
}

550w-glm() {
    typeset -g _550W_MOSS_PROVIDER="glm"
    _550w_moss_resolve_provider
    _550w_config_save >/dev/null 2>&1
    print -P "%F{${_550W_C[ok]}}>> 已切回: glm ($_550W_MOSS_MODEL)%f"
}

# ── 重放欢迎画 ──
550w-welcome() {
    _550w_welcome_screen
}

# ══════════════════ 使用手册 ══════════════════
550w-help() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B╔══════════════════════════════════════════════════╗%b%f"
        print -P "%F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[bright]}}%B                550W 使用手册%b%f                     %F{${_550W_C[cyan]}}%B║%f"
        print -P "%F{${_550W_C[cyan]}}%B╚══════════════════════════════════════════════════╝%b%f"
        print ""
        printf '  \e[38;5;%sm[1]\e[0m 快速上手\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[2]\e[0m AI 对话\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[3]\e[0m 记忆管理\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[4]\e[0m 命令手册\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[5]\e[0m 文件地图\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[6]\e[0m 系统诊断\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[7]\e[0m 关于\n' "${_550W_C[cyan]}"
        print ""
        printf '  \e[38;5;%sm[0]\e[0m 退出\n' "${_550W_C[dim]}"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_quick ;;
            2) _550w_help_ai ;;
            3) _550w_help_memory ;;
            4) _550w_help_cmds ;;
            5) _550w_help_files ;;
            6) _550w_help_diag ;;
            7) _550w_help_about ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

_550w_help_wait() {
    print ""
    print -P "%F{${_550W_C[dim]}}  按回车返回...%f"
    read -r
}

_550w_help_quick() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 快速上手 ──%b%f"
    print ""
    print "  1. 启动 Termux 时自动播放开机动画"
    print "  2. 输入密码（默认 563214789）"
    print "  3. 进入系统后运行 550w-ai \"你好\" 测试 AI"
    print ""
    print "  首次配置："
    print "    · 运行 550w-settings 修改配置"
    print "    · 或直接编辑 ~/.550w_config"
    print ""
    _550w_help_wait
}

_550w_help_ai() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── AI 对话 ──%b%f"
    print ""
    print "  550w-ai \"消息\"       单次对话"
    print "  550w-ai              进入交互模式"
    print "  550w-moss            查看配置"
    print "  550w-moss-set        切换 provider"
    print "  550w-glm             切回智谱"
    print ""
    print "  15 个 provider:"
    local p
    for p in glm glm-pro glm-air zai openai deepseek moonshot qwen groq siliconflow openrouter mistral stepfun local custom; do
        printf '    %-12s %s\n' "$p" "$(_550w_moss_model_of "$p")"
    done
    print ""
    _550w_help_wait
}

_550w_help_memory() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 记忆管理 ──%b%f"
    print ""
    print "  550w-memory show      查看已记住对话"
    print "  550w-memory clear     清空"
    print "  550w-memory max N     设置上限（默认 50）"
    print "  550w-memory path      显示文件路径"
    print ""
    print -P "  文件: %F{${_550W_C[dim]}}$_550W_MOSS_MEMORY_FILE%f"
    print -P "  上限: %F{${_550W_C[dim]}}$_550W_MOSS_MEMORY_MAX 条%f"
    print ""
    _550w_help_wait
}

_550w_help_cmds() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 命令手册 ──%b%f"
    print ""
    print "  系统: 550w-status / 550w-reset / 550w-skip"
    print "  界面: 550w-speed / 550w-fx / 550w-theme"
    print "  AI  : 550w-ai / 550w-moss / 550w-moss-set / 550w-glm"
    print "  记忆: 550w-memory"
    print "  手册: 550w-help / 550w-settings"
    print "  信息: 550w-version / 550w-welcome"
    print ""
    _550w_help_wait
}

_550w_help_files() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 文件地图 ──%b%f"
    print ""
    local -a _files=(
        "$_550W_LOGIN_FILE|主脚本"
        "$_550W_PASS_FILE|密码文件"
        "$_550W_SESSION_FILE|会话记录"
        "$_550W_PROFILE_FILE|用户档案"
        "$_550W_CONFIG_FILE|配置文件"
        "$_550W_MOSS_MEMORY_FILE|AI 记忆"
        "$_550W_MOSS_RATELIMIT_FILE|速率计数"
        "$_550W_MOSS_AUDIT_FILE|对话审计"
        "$_550W_HISTORY_FILE|隔离历史"
        "$_550W_PLUGIN_DIR|插件目录"
        "$_550W_BACKUP_DIR|备份目录"
    )
    local pair path desc mark
    for pair in "${_files[@]}"; do
        path="${pair%%|*}"
        desc="${pair#*|}"
        if [[ -e "$path" ]]; then
            mark="%F{${_550W_C[ok]}}✓%f"
        else
            mark="%F{${_550W_C[dim]}}○%f"
        fi
        print -P "  ${mark}  ${path}"
        print -P "      %F{${_550W_C[dim]}}${desc}%f"
    done
    print ""
    _550w_help_wait
}

_550w_help_diag() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 系统诊断 ──%b%f"
    print ""
    print -P "%F{${_550W_C[ok]}}▸ 依赖检查%f"
    local dep
    for dep in curl awk sed grep zsh mktemp; do
        if command -v "$dep" >/dev/null 2>&1; then
            print "  ✓ $dep"
        else
            print "  ✗ $dep (缺失)"
        fi
    done
    print ""
    print -P "%F{${_550W_C[ok]}}▸ API Key%f"
    if [[ -n "$_550W_MOSS_TOKEN" ]]; then
        print "  ✓ 已配置（长度 ${#_550W_MOSS_TOKEN}）"
    else
        print "  ✗ 未配置"
    fi
    print ""
    print -P "%F{${_550W_C[ok]}}▸ 网络%f"
    if curl -s -o /dev/null --max-time 3 "https://open.bigmodel.cn" 2>/dev/null; then
        print "  ✓ 智谱节点可达"
    else
        print "  ◐ 智谱节点不可达"
    fi
    print ""
    _550w_help_wait
}

_550w_help_about() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 关于 ──%b%f"
    print ""
    print "  550W 超算接管系统"
    print "  版本: $_550W_VERSION"
    print "  构建: $_550W_BUILD_DATE"
    print "  协议: MIT"
    print "  作者: Trans"
    print ""
    print -P "%F{${_550W_C[dim]}}  致敬《流浪地球》550W / MOSS%f"
    print ""
    _550w_help_wait
}

# ══════════════════ 设置中心 ══════════════════
550w-settings() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B╔══════════════════════════════════════════════════╗%b%f"
        print -P "%F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[bright]}}%B                550W 设置中心%b%f                     %F{${_550W_C[cyan]}}%B║%f"
        print -P "%F{${_550W_C[cyan]}}%B╚══════════════════════════════════════════════════╝%b%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}当前状态: %f速度=$_550W_SPEED 特效=$_550W_FX 主题=$_550W_THEME"
        print ""
        printf '  \e[38;5;%sm[1]\e[0m 外观设置\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[2]\e[0m 用户档案\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[3]\e[0m 密码管理\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[4]\e[0m MOSS 配置\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[5]\e[0m 高级设置\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[6]\e[0m 保存配置\n' "${_550W_C[cyan]}"
        printf '  \e[38;5;%sm[7]\e[0m 恢复默认\n' "${_550W_C[warn]}"
        print ""
        printf '  \e[38;5;%sm[0]\e[0m 退出\n' "${_550W_C[dim]}"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_set_appear ;;
            2) _550w_set_profile ;;
            3) _550w_set_pass ;;
            4) _550w_set_moss ;;
            5) _550w_set_adv ;;
            6) _550w_config_save && print "  ✓ 已保存到 $_550W_CONFIG_FILE"; sleep 1 ;;
            7) _550w_set_reset ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

_550w_set_wait() {
    print ""
    print -P "%F{${_550W_C[dim]}}  按回车返回...%f"
    read -r
}

_550w_set_appear() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B── 外观设置 ──%b%f"
        print ""
        print "  速度:  $_550W_SPEED"
        print "  特效:  $_550W_FX  (1=开 0=关)"
        print "  主题:  $_550W_THEME"
        print ""
        print "   1. flash   极快（30%）"
        print "   2. fast    快（60%）"
        print "   3. normal  标准（100%）"
        print "   4. slow    慢（180%）"
        print "   5. 开启特效"
        print "   6. 关闭特效"
        print "   7. 切换主题"
        print "   0. 返回"
        print ""
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            1) _550W_SPEED="flash" ;;
            2) _550W_SPEED="fast" ;;
            3) _550W_SPEED="normal" ;;
            4) _550W_SPEED="slow" ;;
            5) _550W_FX=1 ;;
            6) _550W_FX=0 ;;
            7)
                print -n "  输入主题名 (cyber/amber/ice/moss/crimson): "
                local t
                read -r t
                case "$t" in
                    cyber|amber|ice|moss|crimson) _550W_THEME="$t" ;;
                    *) print "  未知主题" ;;
                esac
                ;;
            0|"") return ;;
            *) continue ;;
        esac
        print "  ✓ 已更新（当前会话）"
        sleep 0.5
    done
}

_550w_set_profile() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B── 用户档案 ──%b%f"
        print ""
        print "  用户名:  $_550W_USER_NAME"
        print "  等级:    $_550W_USER_LEVEL"
        print "  权限:    $_550W_USER_ROLE"
        print "  签名:    $_550W_USER_MOTTO"
        print ""
        print "   1. 修改用户名"
        print "   2. 修改等级"
        print "   3. 修改权限"
        print "   4. 修改签名"
        print "   5. 恢复默认"
        print "   0. 返回"
        print ""
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            1) print -n "  新用户名: "; read -r _550W_USER_NAME ;;
            2) print -n "  新等级: ";   read -r _550W_USER_LEVEL ;;
            3) print -n "  新权限: ";   read -r _550W_USER_ROLE ;;
            4) print -n "  新签名: ";   read -r _550W_USER_MOTTO ;;
            5) _550w_profile_reset ;;
            0|"") return ;;
            *) continue ;;
        esac
        _550w_profile_save >/dev/null 2>&1
        print "  ✓ 已更新"
        sleep 0.5
    done
}

_550w_set_pass() {
    _550w_cls
    print -P "%F{${_550W_C[cyan]}}%B── 密码管理 ──%b%f"
    print ""
    print -n "  新密码（回车取消）: "
    local p1 p2
    read -rs p1; print ""
    [[ -z "$p1" ]] && return
    print -n "  确认新密码: "
    read -rs p2; print ""
    if [[ "$p1" != "$p2" ]]; then
        print "  ✗ 两次输入不一致"
        _550w_set_wait
        return
    fi
    if (( ${#p1} < 4 )); then
        print "  ✗ 密码长度至少 4 位"
        _550w_set_wait
        return
    fi
    print "$p1" > "$_550W_PASS_FILE"
    chmod 600 "$_550W_PASS_FILE"
    _550W_PASS="$p1"
    print "  ✓ 密码已更新"
    _550w_set_wait
}

_550w_set_moss() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B── MOSS 配置 ──%b%f"
        print ""
        print "  Provider:  $_550W_MOSS_PROVIDER"
        print "  模型:      $_550W_MOSS_MODEL"
        print "  模式:      $_550W_MOSS_MODE"
        print "  温度:      $_550W_MOSS_TEMPERATURE"
        print "  MaxTokens: $_550W_MOSS_MAX_TOKENS"
        print ""
        print "   1. 切换 provider"
        print "   2. 修改温度"
        print "   3. 修改 MaxTokens"
        print "   4. 修改上下文窗口"
        print "   0. 返回"
        print ""
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            1) 550w-moss-set ;;
            2) print -n "  温度 (0.0-2.0): "; read -r _550W_MOSS_TEMPERATURE ;;
            3) print -n "  MaxTokens: "; read -r _550W_MOSS_MAX_TOKENS ;;
            4) print -n "  上下文轮数: "; read -r _550W_MOSS_CTX_WINDOW ;;
            0|"") return ;;
            *) continue ;;
        esac
        _550w_config_save >/dev/null 2>&1
        print "  ✓ 已更新"
        sleep 0.5
    done
}

_550w_set_adv() {
    while true; do
        _550w_cls
        print -P "%F{${_550W_C[cyan]}}%B── 高级设置 ──%b%f"
        print ""
        print "  心跳间隔:   $_550W_HEARTBEAT_INTERVAL s"
        print "  空闲锁定:   $_550W_IDLE_LOCKOUT s"
        print "  最大尝试:   $_550W_MAX_ATTEMPTS 次"
        print "  输入超时:   $_550W_READ_TIMEOUT s"
        print "  命令阈值:   $_550W_CMD_TIMING_THRESHOLD s"
        print ""
        print "   1. 修改心跳间隔"
        print "   2. 修改空闲锁定"
        print "   3. 修改最大尝试"
        print "   4. 修改输入超时"
        print "   0. 返回"
        print ""
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            1) print -n "  心跳间隔（秒）: "; read -r _550W_HEARTBEAT_INTERVAL ;;
            2) print -n "  空闲锁定（秒）: "; read -r _550W_IDLE_LOCKOUT ;;
            3) print -n "  最大尝试（次）: "; read -r _550W_MAX_ATTEMPTS ;;
            4) print -n "  输入超时（秒）: "; read -r _550W_READ_TIMEOUT ;;
            0|"") return ;;
            *) continue ;;
        esac
        _550w_config_save >/dev/null 2>&1
        print "  ✓ 已更新"
        sleep 0.5
    done
}

_550w_set_reset() {
    print -n "  确认恢复默认配置？(y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return
    _550w_config_reset
    print "  ✓ 已恢复默认"
    _550w_set_wait
}

# ══════════════════ 初始化 ══════════════════

# 确定主脚本路径（用于 550w-version 显示）
typeset -g _550W_LOGIN_FILE="${(%):-%N}"

# 首次安装时创建默认文件
[[ -d "$_550W_BACKUP_DIR" ]] || mkdir -p "$_550W_BACKUP_DIR" 2>/dev/null
[[ -d "$_550W_PLUGIN_DIR" ]] || mkdir -p "$_550W_PLUGIN_DIR" 2>/dev/null
[[ -d "$_550W_LOG_DIR" ]] || mkdir -p "$_550W_LOG_DIR" 2>/dev/null

# 加载插件（如果存在）
if [[ -d "$_550W_PLUGIN_DIR" ]]; then
    local _pf
    for _pf in "$_550W_PLUGIN_DIR"/*.zsh(N); do
        [[ -r "$_pf" ]] && source "$_pf"
    done
    unset _pf
fi

# 挂载登录钩子
if [[ "$_550W_DONE" != "1" ]]; then
    _550w_hook
fi

# 加载升级包（如果存在）
local _ext
for _ext in \
    "$HOME/.550w_scan.zsh" \
    "$HOME/.550w_anim.zsh" \
    "$HOME/.550w_help.zsh" \
    "$HOME/.550w_settings.zsh" \
    "$HOME/.550w_extras.zsh" \
    "$HOME/.550w_new.zsh"
do
    [[ -r "$_ext" ]] && source "$_ext"
done
unset _ext

# 修复 _550w_anim_box 变量名冲突
_550w_anim_box() {
    local -a lines=("$@")
    local max=0 l w
    for l in "${lines[@]}"; do
        w=$(_550w_str_w "$l")
        (( w > max )) && max=$w
    done
    local inner=$(( max + 6 ))
    local cols
    cols=$(_550w_cols)
    (( cols > 70 )) && cols=70
    local pad=$(( (cols - inner) / 2 ))
    (( pad < 0 )) && pad=0
    local indent
    indent=$(printf '%*s' "$pad" '')
    local bar=""
    local i
    for (( i=0; i<inner; i++ )); do bar+="─"; done
    print "${indent}┌${bar}┐"
    for l in "${lines[@]}"; do
        w=$(_550w_str_w "$l")
        local lp=$(( (max - w) / 2 ))
        local rp=$(( max - w - lp ))
        (( lp < 0 )) && lp=0
        (( rp < 0 )) && rp=0
        local pdl=""
        local pdr=""
        (( lp > 0 )) && pdl=$(printf '%*s' "$lp" '')
        (( rp > 0 )) && pdr=$(printf '%*s' "$rp" '')
        print "${indent}│   ${pdl}${l}${pdr}   │"
    done
    print "${indent}└${bar}┘"
}

# 修复欢迎画：不清屏
_550w_welcome_screen() {
    _550w_cls
    print ""
    print ""
    local -a ascii_lines=(
        "    ███████╗ ███████╗  ██████╗ ██╗    ██╗"
        "    ██╔════╝ ██╔════╝ ██╔═████╗██║    ██║"
        "    ███████╗ ███████╗ ██║██╔██║██║ █╗ ██║"
        "    ╚════██║ ╚════██║ ████╔╝██║██║███╗██║"
        "    ███████║ ███████║ ╚██████╔╝╚███╔███╔╝"
        "    ╚══════╝ ╚══════╝  ╚═════╝  ╚══╝╚══╝ "
    )
    local -a grad_colors=(46 46 51 45 39 135)
    local i
    for (( i=1; i<=6; i++ )); do
        printf '\e[1m\e[38;5;%sm%s\e[0m\n' "${grad_colors[$i]}" "${ascii_lines[$i]}"
        sleep 0.06
    done
    sleep 0.1
    print ""
    local bar="" j
    for (( j=0; j<52; j++ )); do bar+="═"; done
    print -P "%F{${_550W_C[ok]}}%B╔${bar}╗%b%f"
    print -P "%F{${_550W_C[ok]}}%B║%f  %F{${_550W_C[bright]}}%B◆  WELCOME BACK  ·  欢迎回来%b%f                              %F{${_550W_C[ok]}}%B║%f"
    print -P "%F{${_550W_C[ok]}}%B╚${bar}╝%b%f"
    print ""
    _550w_pause 300
    print -P "  %F{${_550W_C[dim]}}[操作员档案]%f"
    printf '  \e[38;5;%sm├─ 用户名\e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_NAME"
    sleep 0.08
    printf '  \e[38;5;%sm├─ 等级  \e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_LEVEL"
    sleep 0.08
    printf '  \e[38;5;%sm└─ 权限  \e[0m %s\n' "${_550W_C[dim]}" "$_550W_USER_ROLE"
    print ""
    _550w_pause 200
    local mem_n=${#_550W_MOSS_HISTORY[@]}
    print -P "  %F{${_550W_C[dim]}}[系统状态]%f"
    printf '  \e[38;5;%sm├─ 核心   \e[0m \e[1m\e[38;5;%sm已激活\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 链路   \e[0m \e[1m\e[38;5;%sm已建立\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}"
    sleep 0.06
    printf '  \e[38;5;%sm├─ MOSS   \e[0m \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$_550W_MOSS_HEALTH"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 记忆   \e[0m \e[1m\e[38;5;%sm%d 条\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$mem_n"
    sleep 0.06
    printf '  \e[38;5;%sm├─ 会话   \e[0m \e[1m\e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[ok]}" "$_550W_SESSION_ID"
    sleep 0.06
    if [[ -n "$_550W_USER_LASTLOGIN" ]]; then
        printf '  \e[38;5;%sm└─ 上次   \e[0m \e[38;5;%sm%s\e[0m\n' "${_550W_C[dim]}" "${_550W_C[dim]}" "$_550W_USER_LASTLOGIN"
    fi
    print ""
    _550w_pause 300
    local motto_safe="${_550W_USER_MOTTO//\%/%%}"
    print -P "  %F{${_550W_C[ok]}}%B══════════════════════════════════════════════════%b%f"
    print -P "  %F{${_550W_C[dim]}}  $motto_safe%f"
    print -P "  %F{${_550W_C[ok]}}%B══════════════════════════════════════════════════%b%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}输入 %f%F{${_550W_C[ok]}}%B550w-help%f%F{${_550W_C[dim]}} 查看帮助%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车进入终端...%f"
    read -r
}
for _550w_ext in real anim help settings extras new; do
    [[ -r "$HOME/.550w/${_550w_ext}.zsh" ]] && source "$HOME/.550w/${_550w_ext}.zsh"
done
unset _550w_ext

# ══════════════════ 插件加载器 v2 ══════════════════
# 每个插件 = 一个文件夹，入口文件必须是 main.zsh

typeset -g _550W_PLUGIN_DIR="${HOME}/.550w/扩展"
typeset -ga _550W_LOADED_PLUGINS=()

[[ -d "$_550W_PLUGIN_DIR" ]] || mkdir -p "$_550W_PLUGIN_DIR"

for _pdir in "$_550W_PLUGIN_DIR"/*(N/); do
    local _main="${_pdir}/main.zsh"
    if [[ ! -r "$_main" ]]; then
        print -P "%F{220}[550W] 跳过插件 ${_pdir:t}（无 main.zsh）%f" >&2
        continue
    fi
    typeset -g _550W_PLUGIN_SELF="$_pdir"
    if source "$_main" 2>/dev/null; then
        _550W_LOADED_PLUGINS+=("${_pdir:t}")
    else
        print -P "%F{196}[550W] 插件加载失败: ${_pdir:t}%f" >&2
    fi
done
unset _pdir _main
unset _550W_PLUGIN_SELF

# ══════════════════ 插件管理命令 ══════════════════

550w-plugin-new() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名（小写字母/短横线）: "
        read -r name
    fi
    [[ -z "$name" ]] && { print "已取消"; return 0; }
    if [[ ! "$name" =~ '^[a-z][a-z0-9_-]*$' ]]; then
        print -P "%F{196}✗ 名称不合法（只能小写字母/数字/-/_，且首字母为小写）%f"
        return 1
    fi
    local dir="$_550W_PLUGIN_DIR/$name"
    if [[ -d "$dir" ]]; then
        print -P "%F{220}⚠ 插件已存在: $name%f"
        return 1
    fi
    mkdir -p "$dir"
    cat > "$dir/main.zsh" << 'PLUGIN_EOF'
# 插件入口
# requires:
# 作者:
# 说明:

local _dir="${_550W_PLUGIN_SELF:-$(dirname "${(%):-%N}")}"
[[ -r "$_dir/config.zsh" ]] && source "$_dir/config.zsh"

# 在这里定义你的函数
PLUGIN_DEMO_FUNC_PLACEHOLDER() {
    print "Hello from plugin"
}
PLUGIN_EOF
    sed -i "s/PLUGIN_DEMO_FUNC_PLACEHOLDER/550w-${name}/" "$dir/main.zsh"

    cat > "$dir/config.zsh" << 'CONFIG_EOF'
# 插件配置
# 在这里定义变量/常量
CONFIG_EOF

    cat > "$dir/README.md" << "README_EOF"
# 插件：$name

## 说明
（写插件说明）

## 命令
- `550w-$name`  （示例命令）
README_EOF

    print -P "%F{${_550W_C[ok]}}✓ 已创建插件: $name%f"
    print -P "  目录: $dir"
    print ""
    print "  文件："
    ls -1 "$dir" | sed 's/^/    /'
    print ""
    print -P "  %F{${_550W_C[dim]}}用 nano 编辑 main.zsh 开始写%f%"
    print -P "  %F{${_550W_C[dim]}}编辑后: unset _550W_LOADED && source ~/.zshrc%f"
}

550w-plugin-remove() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  要删除的插件名: "
        read -r name
    fi
    [[ -z "$name" ]] && { print "已取消"; return 0; }
    local dir="$_550W_PLUGIN_DIR/$name"
    if [[ ! -d "$dir" ]]; then
        print -P "%F{196}✗ 插件不存在: $name%f"
        return 1
    fi
    print -P "%F{220}⚠ 将删除整个目录: $dir%f"
    print -n "  确认? (y/N): "
    local c
    read -r c
    if [[ "$c" != "y" && "$c" != "Y" ]]; then
        print "已取消"
        return 0
    fi
    rm -rf "$dir"
    print -P "%F{${_550W_C[ok]}}✓ 已删除插件: $name%f"
    print -P "  %F{${_550W_C[dim]}}下次 source 时不再加载%f"
}

# ══════════════════ 插件辅助命令 ══════════════════

550w-plugins() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══════ 550W 插件列表 ══════%b%f"
    print -P "  %F{${_550W_C[dim]}}目录: $_550W_PLUGIN_DIR%f"
    print ""

    local -a _dirs=("$_550W_PLUGIN_DIR"/*(N/))
    if (( ${#_dirs[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无插件）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}创建第一个插件：550w-plugin-new 插件名%f"
        return 0
    fi

    local d name loaded files mark
    for d in "${_dirs[@]}"; do
        name="${d:t}"
        loaded=""
        for _p in "${_550W_LOADED_PLUGINS[@]}"; do
            [[ "$_p" == "$name" ]] && { loaded="✓"; break; }
        done
        files=$(ls -1 "$d" 2>/dev/null | tr '\n' ' ')
        if [[ "$loaded" == "✓" ]]; then
            mark="\e[38;5;${_550W_C[ok]}m●\e[0m"
        else
            mark="\e[38;5;${_550W_C[dim]}m○\e[0m"
        fi
        printf '  %b %-18s \e[38;5;%sm[%s]\e[0m\n' \
            "$mark" "$name" "${_550W_C[dim]}" "$files"
    done
    print ""
    print -P "  共 ${#_dirs[@]} 个插件 · 已加载 ${#_550W_LOADED_PLUGINS[@]} 个"
    print -P "  %F{${_550W_C[dim]}}● 已加载  ○ 未加载%f"
}

550w-plugin-info() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "
        read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    if [[ ! -d "$dir" ]]; then
        print -P "%F{196}✗ 插件不存在: $name%f"
        return 1
    fi
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件：$name ══════%b%f"
    print ""
    print -P "  目录: $dir"
    print ""

    # 读取 main.zsh 头部注释
    if [[ -r "$dir/main.zsh" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 元信息%f"
        local line
        while IFS= read -r line; do
            [[ "$line" == "#"* ]] || break
            print -P "  %F{${_550W_C[dim]}}$line%f"
        done < "$dir/main.zsh"
        print ""
    fi

    # 文件列表
    print -P "  %F{${_550W_C[cyan]}}▸ 文件%f"
    local f
    for f in "$dir"/*(N); do
        if [[ -d "$f" ]]; then
            printf '  \e[38;5;%sm[DIR]\e[0m %s/\n' "${_550W_C[cyan]}" "${f:t}"
        else
            local sz
            sz=$(wc -c < "$f" 2>/dev/null | tr -d ' ')
            printf '  \e[38;5;%sm[FILE]\e[0m %-24s \e[38;5;%sm%s 字节\e[0m\n' \
                "${_550W_C[dim]}" "${f:t}" "${_550W_C[dim]}" "$sz"
        fi
    done
    print ""

    # 声明的函数
    if [[ -r "$dir/main.zsh" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 定义函数%f"
        local fns
        fns=$(grep -oE '^[a-zA-Z_][a-zA-Z0-9_-]*\(\)' "$dir/main.zsh" 2>/dev/null | sed 's/()//')
        if [[ -n "$fns" ]]; then
            print "$fns" | sed 's/^/    /'
        else
            print -P "    %F{${_550W_C[dim]}}（无）%f"
        fi
    fi
    print ""

    # 依赖
    if [[ -r "$dir/main.zsh" ]]; then
        local deps
        deps=$(grep -m1 '^# *requires:' "$dir/main.zsh" 2>/dev/null | sed 's/^# *requires: *//')
        if [[ -n "$deps" ]]; then
            print -P "  %F{${_550W_C[cyan]}}▸ 依赖%f"
            local d
            for d in ${=deps}; do
                if command -v "$d" >/dev/null 2>&1; then
                    printf '    \e[38;5;%sm✓\e[0m %s\n' "${_550W_C[ok]}" "$d"
                else
                    printf '    \e[38;5;%sm✗\e[0m %s (缺失)\n' "${_550W_C[err]}" "$d"
                fi
            done
        fi
    fi
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

550w-plugin-edit() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "
        read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    if [[ ! -d "$dir" ]]; then
        print -P "%F{196}✗ 插件不存在: $name%f"
        return 1
    fi
    print -n "  编辑 [1]main.zsh [2]config.zsh [3]其他文件: "
    local c
    read -r c
    local target=""
    case "$c" in
        1) target="$dir/main.zsh" ;;
        2) target="$dir/config.zsh" ;;
        3)
            print -n "  文件相对路径: "
            local rel
            read -r rel
            target="$dir/$rel"
            ;;
        *) return 0 ;;
    esac
    if [[ ! -f "$target" ]]; then
        print -P "%F{220}文件不存在，创建? (y/N): %f"
        local yn
        read -r yn
        [[ "$yn" != "y" && "$yn" != "Y" ]] && return 0
        touch "$target"
    fi
    if command -v nano >/dev/null 2>&1; then
        nano "$target"
    else
        print -P "%F{196}✗ 未装 nano（pkg install nano）%f"
    fi
}

550w-plugin-reload() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -P "  %F{${_550W_C[cyan]}}重载全部插件%f"
        print -n "  确认? (y/N): "
        local c
        read -r c
        [[ "$c" != "y" && "$c" != "Y" ]] && return 0
        _550W_LOADED_PLUGINS=()
        local _pdir _main
        for _pdir in "$_550W_PLUGIN_DIR"/*(N/); do
            _main="${_pdir}/main.zsh"
            [[ -r "$_main" ]] || continue
            typeset -g _550W_PLUGIN_SELF="$_pdir"
            if source "$_main" 2>/dev/null; then
                _550W_LOADED_PLUGINS+=("${_pdir:t}")
                print -P "  %F{${_550W_C[ok]}}✓ ${_pdir:t}%f"
            else
                print -P "  %F{${_550W_C[err]}}✗ ${_pdir:t}%f"
            fi
        done
        unset _pdir _main _550W_PLUGIN_SELF
    else
        local dir="$_550W_PLUGIN_DIR/$name"
        [[ -r "$dir/main.zsh" ]] || { print -P "%F{196}✗ main.zsh 不存在%f"; return 1; }
        typeset -g _550W_PLUGIN_SELF="$dir"
        if source "$dir/main.zsh"; then
            print -P "  %F{${_550W_C[ok]}}✓ 已重载: $name%f"
        else
            print -P "  %F{${_550W_C[err]}}✗ 重载失败: $name%f"
        fi
        unset _550W_PLUGIN_SELF
    fi
}

550w-plugin-open() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "
        read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    if [[ ! -d "$dir" ]]; then
        print -P "%F{196}✗ 插件不存在: $name%f"
        return 1
    fi
    print -P "  %F{${_550W_C[cyan]}}插件目录: $dir%f"
    ls -la "$dir"
    print ""
    print -n "  按回车返回..."
    read -r
}

550w-plugin-help() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件系统帮助 ══════%b%f"
    print ""
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugins" "列出所有插件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-new [名]" "创建插件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-remove [名]" "删除插件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-info [名]" "查看插件信息"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-edit [名]" "编辑插件文件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-reload [名]" "重载插件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-open [名]" "打开插件目录"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-help" "本帮助"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 目录结构%f"
    print "    ~/.550w/扩展/"
    print "    └── 插件名/"
    print "        ├── main.zsh    (入口，必须有)"
    print "        ├── config.zsh  (可选)"
    print "        └── ...         (其他文件)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 加插件的 3 步%f"
    print "    1. 550w-plugin-new 插件名"
    print "    2. 550w-plugin-edit 插件名   # 编辑 main.zsh"
    print "    3. unset _550W_LOADED && source ~/.zshrc"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 开机动画文件夹机制 ══════════════════

typeset -g _550W_BOOT_ANIM_DIR="${HOME}/.550w/boot_anim"

[[ -d "$_550W_BOOT_ANIM_DIR" ]] || mkdir -p "$_550W_BOOT_ANIM_DIR"

_550w_boot_anim_run() {
    [[ -d "$_550W_BOOT_ANIM_DIR" ]] || return 0
    local f
    for f in "$_550W_BOOT_ANIM_DIR"/*.zsh(N); do
        [[ -r "$f" ]] || continue
        typeset -g _550W_BOOT_ANIM_FILE="$f"
        source "$f"
    done
    unset _550W_BOOT_ANIM_FILE
}

550w-boot-anim-list() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══════ 开机动画列表 ══════%b%f"
    print -P "  %F{${_550W_C[dim]}}目录: $_550W_BOOT_ANIM_DIR%f"
    print ""
    local -a files=("$_550W_BOOT_ANIM_DIR"/*.zsh(N))
    if (( ${#files[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无动画文件）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}创建第一个：550w-boot-anim-new 01_demo%f"
        return 0
    fi
    local f i=0
    for f in "${files[@]}"; do
        (( i++ ))
        local first_call
        first_call=$(grep -m1 -E '^[^#].*\(' "$f" 2>/dev/null | head -1 | cut -c1-40)
        printf '  \e[38;5;%sm[%2d]\e[0m %-24s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$i" "${f:t}" "${_550W_C[dim]}" "$first_call"
    done
    print ""
    print -P "  共 ${#files[@]} 个文件 · 按文件名排序执行"
}

550w-boot-anim-new() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  文件名（建议 01_xxx）: "
        read -r name
    fi
    [[ -z "$name" ]] && { print "已取消"; return 0; }
    name="${name%.zsh}"
    local target="$_550W_BOOT_ANIM_DIR/${name}.zsh"
    if [[ -e "$target" ]]; then
        print -P "%F{220}⚠ 文件已存在: ${name}.zsh%f"
        return 1
    fi
    cat > "$target" << 'ANIM_EOF'
# 开机动画文件
# 按文件名排序执行
# 里面直接写 zsh 代码，会被 source

_550w_anim_typing_v2 "开机动画示例" 40
_550w_pause 300
ANIM_EOF
    print -P "%F{${_550W_C[ok]}}✓ 已创建: ${name}.zsh%f"
    print -P "  编辑: nano $target"
}

550w-boot-anim-edit() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  文件名: "
        read -r name
    fi
    [[ -z "$name" ]] && return 0
    name="${name%.zsh}"
    local target="$_550W_BOOT_ANIM_DIR/${name}.zsh"
    if [[ ! -f "$target" ]]; then
        print -P "%F{220}文件不存在，创建? (y/N): %f"
        local c
        read -r c
        [[ "$c" != "y" && "$c" != "Y" ]] && return 0
        touch "$target"
    fi
    if command -v nano >/dev/null 2>&1; then
        nano "$target"
    else
        print -P "%F{196}✗ 未装 nano%f"
    fi
}

550w-boot-anim-remove() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  文件名: "
        read -r name
    fi
    [[ -z "$name" ]] && return 0
    name="${name%.zsh}"
    local target="$_550W_BOOT_ANIM_DIR/${name}.zsh"
    if [[ ! -f "$target" ]]; then
        print -P "%F{196}✗ 文件不存在: ${name}.zsh%f"
        return 1
    fi
    print -n "  确认删除 ${name}.zsh? (y/N): "
    local c
    read -r c
    [[ "$c" != "y" && "$c" != "Y" ]] && return 0
    rm -f "$target"
    print -P "%F{${_550W_C[ok]}}✓ 已删除%f"
}

550w-boot-anim-help() {
    _550w_cls
    print -P "  %F{${_550W_C[cyan]}}%B══════ 开机动画机制 ══════%b%f"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 目录%f"
    print "    $_550W_BOOT_ANIM_DIR/"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 规则%f"
    print "    · 每个 .zsh 文件被 source 一次"
    print "    · 按文件名排序（用 01_ / 02_ 前缀控制顺序）"
    print "    · 文件内写任意 zsh 代码"
    print "    · 子文件夹不加载"
    print "    · 加载位置：phase3 之后、密码框之前"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 命令%f"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-boot-anim-list" "列出所有动画"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-boot-anim-new [名]" "创建动画文件"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-boot-anim-edit [名]" "编辑"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-boot-anim-remove [名]" "删除"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "550w-boot-anim-help" "本帮助"
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 文件示例%f"
    print "    # 01_wakeup.zsh"
    print "    _550w_anim_glitch_v3 \"WAKEUP\" 8"
    print "    _550w_pause 200"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 插件系统 v2 ══════════════════
# 元数据 / 依赖 / 钩子 / 配置 / 日志 / 错误处理

typeset -g _550W_PLUGIN_DIR="${HOME}/.550w/扩展"
typeset -ga _550W_PLUGIN_LIST=()
typeset -ga _550W_PLUGIN_LOADED=()
typeset -ga _550W_PLUGIN_ERRORS=()
typeset -gA _550W_PLUGIN_META=()
typeset -gA _550W_PLUGIN_HOOKS=()
typeset -gA _550W_PLUGIN_PATH=()
typeset -g _550W_PLUGIN_CURRENT=""

[[ -d "$_550W_PLUGIN_DIR" ]] || mkdir -p "$_550W_PLUGIN_DIR"

_550w_plugin_parse_meta() {
    local dir="$1" file="$2"
    local name="${dir:t}"

    local v_name="$name"
    local v_ver="0.0.0"
    local v_author="unknown"
    local v_desc=""
    local v_requires=""
    local v_depends=""
    local v_hooks=""

    if [[ -r "$file" ]]; then
        local line
        while IFS= read -r line; do
            [[ "$line" != "#"* ]] && break
            case "$line" in
                "# @name:"*)      v_name="${line#*: }" ;;
                "# @version:"*)   v_ver="${line#*: }" ;;
                "# @author:"*)    v_author="${line#*: }" ;;
                "# @desc:"*)      v_desc="${line#*: }" ;;
                "# @requires:"*)  v_requires="${line#*: }" ;;
                "# @depends:"*)   v_depends="${line#*: }" ;;
                "# @hook:"*)      v_hooks="${line#*: }" ;;
                "# requires:"*)   v_requires="${line#*: }" ;;
            esac
        done < "$file"
    fi

    _550W_PLUGIN_META[name,$name]="$v_name"
    _550W_PLUGIN_META[version,$name]="$v_ver"
    _550W_PLUGIN_META[author,$name]="$v_author"
    _550W_PLUGIN_META[desc,$name]="$v_desc"
    _550W_PLUGIN_META[requires,$name]="$v_requires"
    _550W_PLUGIN_META[depends,$name]="$v_depends"
    _550W_PLUGIN_META[hooks,$name]="$v_hooks"
    _550W_PLUGIN_PATH[$name]="$dir"
}

_550w_plugin_scan() {
    _550W_PLUGIN_LIST=()
    _550W_PLUGIN_META=()
    _550W_PLUGIN_PATH=()

    local dir
    for dir in "$_550W_PLUGIN_DIR"/*(N/); do
        local name="${dir:t}"
        [[ "$name" == _* ]] && continue
        local main="$dir/main.zsh"
        [[ -r "$main" ]] || continue
        _550W_PLUGIN_LIST+=("$name")
        _550w_plugin_parse_meta "$dir" "$main"
    done
}

_550w_plugin_meta() {
    local name="$1" field="$2"
    print -n "${_550W_PLUGIN_META[$field,$name]:-}"
}

_550w_plugin_enabled() {
    local dir="${_550W_PLUGIN_PATH[$1]}"
    [[ -n "$dir" && ! -e "$dir/.disabled" ]]
}

_550w_plugin_is_loaded() {
    local name="$1" p
    for p in "${_550W_PLUGIN_LOADED[@]}"; do
        [[ "$p" == "$name" ]] && return 0
    done
    return 1
}

# ── 命令依赖检查 ──
_550w_plugin_check_cmd_deps() {
    local name="$1"
    local requires="$(_550w_plugin_meta "$name" requires)"
    [[ -z "$requires" ]] && return 0
    local -a missing=()
    local d
    for d in ${=requires}; do
        command -v "$d" >/dev/null 2>&1 || missing+=("$d")
    done
    if (( ${#missing[@]} > 0 )); then
        _550W_PLUGIN_META[missing_cmd,$name]="${missing[*]}"
        return 1
    fi
    return 0
}

# ── 插件依赖检查 ──
_550w_plugin_check_plugin_deps() {
    local name="$1"
    local depends="$(_550w_plugin_meta "$name" depends)"
    [[ -z "$depends" ]] && return 0
    local -a missing=()
    local d
    for d in ${=depends}; do
        [[ -d "$_550W_PLUGIN_DIR/$d" ]] || missing+=("$d")
    done
    if (( ${#missing[@]} > 0 )); then
        _550W_PLUGIN_META[missing_plugin,$name]="${missing[*]}"
        return 1
    fi
    return 0
}

# ── 拓扑排序 ──
_550w_plugin_topo_sort() {
    local -A visited=() in_progress=()
    local -a result=() cycle=()

    _topo_visit() {
        local n="$1"
        [[ -n "${visited[$n]}" ]] && return 0
        if [[ -n "${in_progress[$n]}" ]]; then
            cycle+=("$n"); return 1
        fi
        in_progress[$n]=1
        local deps="$(_550w_plugin_meta "$n" depends)"
        local d
        for d in ${=deps}; do
            [[ -d "$_550W_PLUGIN_DIR/$d" ]] || continue
            _topo_visit "$d" || true
        done
        unset "in_progress[$n]"
        visited[$n]=1
        result+=("$n")
    }

    local name
    for name in "${_550W_PLUGIN_LIST[@]}"; do
        _topo_visit "$name"
    done

    (( ${#cycle[@]} > 0 )) && \
        print -P "%F{196}[550W] 插件循环依赖: ${cycle[*]}%f" >&2

    print -l "${result[@]}"
}

# ── 主加载器 ──
_550w_plugin_load_all() {
    _550w_plugin_scan
    _550W_PLUGIN_LOADED=()
    _550W_PLUGIN_ERRORS=()

    local -a sorted
    sorted=("${(@f)$(_550w_plugin_topo_sort)}")
    (( ${#sorted[@]} == 0 )) && return 0

    local name
    for name in "${sorted[@]}"; do
        _550w_plugin_load_one "$name"
    done
}

# ── 加载单个 ──
_550w_plugin_load_one() {
    local name="$1"
    local dir="${_550W_PLUGIN_PATH[$name]}"
    [[ -z "$dir" ]] && return 1

    _550w_plugin_enabled "$name" || return 0

    if ! _550w_plugin_check_cmd_deps "$name"; then
        local m="${_550W_PLUGIN_META[missing_cmd,$name]}"
        _550W_PLUGIN_ERRORS+=("$name|命令缺失: $m")
        print -P "%F{220}[550W] 插件 $name 跳过（缺命令: $m）%f" >&2
        return 1
    fi

    if ! _550w_plugin_check_plugin_deps "$name"; then
        local m="${_550W_PLUGIN_META[missing_plugin,$name]}"
        _550W_PLUGIN_ERRORS+=("$name|插件缺失: $m")
        print -P "%F{220}[550W] 插件 $name 跳过（缺插件: $m）%f" >&2
        return 1
    fi

    typeset -g _550W_PLUGIN_CURRENT="$name"
    typeset -g _550W_PLUGIN_SELF="$dir"
    typeset -g _550W_PLUGIN_CONFIG_DIR="$dir/config"
    typeset -g _550W_PLUGIN_LOG_DIR="$dir/log"
    [[ -d "$_550W_PLUGIN_CONFIG_DIR" ]] || mkdir -p "$_550W_PLUGIN_CONFIG_DIR"
    [[ -d "$_550W_PLUGIN_LOG_DIR" ]] || mkdir -p "$_550W_PLUGIN_LOG_DIR"

    local err
    err=$(zsh -n "$dir/main.zsh" 2>&1)
    if [[ -n "$err" ]]; then
        _550W_PLUGIN_ERRORS+=("$name|语法错误: ${err:0:80}")
        print -P "%F{196}[550W] 插件 $name 语法错误: ${err:0:80}%f" >&2
        return 1
    fi

    if source "$dir/main.zsh" 2>/dev/null; then
        _550W_PLUGIN_LOADED+=("$name")
        _550w_plugin_register_hooks "$name"
        return 0
    else
        _550W_PLUGIN_ERRORS+=("$name|加载失败")
        print -P "%F{196}[550W] 插件 $name 加载失败%f" >&2
        return 1
    fi
}

# ── 钩子注册 ──
# 插件 main.zsh 里写： # @hook: login precmd
# 加载器读元数据后自动挂载 _550w_plugin_hook_<name>_<hook> 函数
_550w_plugin_register_hooks() {
    local name="$1"
    local hooks="$(_550w_plugin_meta "$name" hooks)"
    [[ -z "$hooks" ]] && return 0

    autoload -Uz add-zsh-hook 2>/dev/null

    local h
    for h in ${=hooks}; do
        # 插件约定：定义 _550w_plugin_hook_${name}_${h} 函数
        local fn="_550w_plugin_hook_${name}_${h}"
        (( ${+functions[$fn]} )) || continue
        case "$h" in
            precmd)  add-zsh-hook precmd  "$fn" ;;
            preexec) add-zsh-hook preexec "$fn" ;;
            chpwd)   add-zsh-hook chpwd   "$fn" ;;
            login)
                # login 钩子：登录后立即执行一次
                "$fn" 2>/dev/null
                ;;
            logout)
                # logout 钩子：存在 ~/.550w/.logout_hooks 里
                local f="$HOME/.550w/.logout_hooks"
                [[ -d "$(dirname "$f")" ]] || return 0
                grep -q "^$fn$" "$f" 2>/dev/null || print "$fn" >> "$f"
                ;;
            *)
                # 未知钩子：注册到同名 hook
                add-zsh-hook "$h" "$fn" 2>/dev/null || true
                ;;
        esac
    done
}

# ── 插件 API：日志 ──
# 用法：_plugin_log info "消息"
_550w_plugin_log() {
    local level="$1"; shift
    [[ -z "$_550W_PLUGIN_LOG_DIR" ]] && return 0
    [[ -d "$_550W_PLUGIN_LOG_DIR" ]] || mkdir -p "$_550W_PLUGIN_LOG_DIR"
    local f="$_550W_PLUGIN_LOG_DIR/$(date +%Y%m%d).log"
    local ts
    ts=$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
    print "$ts [$level] $*" >> "$f" 2>/dev/null
}

# 别名（插件里直接调 _plugin_log 更短）
_plugin_log() { _550w_plugin_log "$@"; }

# ── 插件 API：配置读取 ──
# 用法：_plugin_config_get key [default]
_550w_plugin_config_get() {
    local key="$1" default="${2:-}"
    [[ -z "$_550W_PLUGIN_CONFIG_DIR" ]] && { print -n "$default"; return 0; }
    local f="$_550W_PLUGIN_CONFIG_DIR/config"
    [[ -r "$f" ]] || { print -n "$default"; return 0; }
    local line
    while IFS='=' read -r k v; do
        if [[ "$k" == "$key" ]]; then
            v="${v%\"}"; v="${v#\"}"
            print -n "$v"
            return 0
        fi
    done < "$f"
    print -n "$default"
}

# ── 插件 API：配置写入 ──
# 用法：_plugin_config_set key value
_550w_plugin_config_set() {
    local key="$1" value="$2"
    [[ -z "$_550W_PLUGIN_CONFIG_DIR" ]] && return 1
    [[ -d "$_550W_PLUGIN_CONFIG_DIR" ]] || mkdir -p "$_550W_PLUGIN_CONFIG_DIR"
    local f="$_550W_PLUGIN_CONFIG_DIR/config"
    local tmp="${f}.tmp.$$"
    if [[ -r "$f" ]]; then
        grep -v "^${key}=" "$f" > "$tmp" 2>/dev/null
    else
        : > "$tmp"
    fi
    # 转义引号
    local v="$value"
    v="${v//\"/\\\"}"
    print "${key}=\"${v}\"" >> "$tmp"
    mv "$tmp" "$f"
    return 0
}

# 别名（短名）
_plugin_config_get() { _550w_plugin_config_get "$@"; }
_plugin_config_set() { _550w_plugin_config_set "$@"; }

# ── 插件 API：查看所有配置 ──
_550w_plugin_config_list() {
    [[ -z "$_550W_PLUGIN_CONFIG_DIR" ]] && return 1
    local f="$_550W_PLUGIN_CONFIG_DIR/config"
    [[ -r "$f" ]] || { print -P "  %F{${_550W_C[dim]}}（无配置）%f"; return 0; }
    cat "$f"
}

# ── 插件 API：查看日志 ──
_550w_plugin_log_tail() {
    local n="${1:-30}"
    [[ -z "$_550W_PLUGIN_LOG_DIR" ]] && return 1
    local f="$_550W_PLUGIN_LOG_DIR/$(date +%Y%m%d).log"
    [[ -r "$f" ]] || { print -P "  %F{${_550W_C[dim]}}（今日无日志）%f"; return 0; }
    tail -n "$n" "$f"
}

# ── logout 钩子执行 ──
_550w_plugin_run_logout() {
    local f="$HOME/.550w/.logout_hooks"
    [[ -r "$f" ]] || return 0
    local fn
    while IFS= read -r fn; do
        [[ -n "$fn" ]] && "$fn" 2>/dev/null || true
    done < "$f"
}

# 注册到 shell exit
_550w_plugin_install_logout_hook() {
    if (( ! ${+functions[_550w_plugin_logout_wrapper]} )); then
        _550w_plugin_logout_wrapper() {
            _550w_plugin_run_logout
        }
        zshexit_functions+=("_550w_plugin_logout_wrapper") 2>/dev/null || true
        trap '_550w_plugin_run_logout' EXIT 2>/dev/null
    fi
}

# ── 启用插件 ──
550w-plugin-enable() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    [[ -d "$dir" ]] || { print -P "%F{196}✗ 插件不存在: $name%f"; return 1; }
    if [[ ! -e "$dir/.disabled" ]]; then
        print -P "%F{220}⚠ 插件已是启用状态%f"
        return 0
    fi
    rm -f "$dir/.disabled"
    print -P "%F{${_550W_C[ok]}}✓ 已启用: $name%f"
    print -P "  %F{${_550W_C[dim]}}重启生效：unset _550W_LOADED && source ~/.zshrc%f"
}

# ── 禁用插件 ──
550w-plugin-disable() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    [[ -d "$dir" ]] || { print -P "%F{196}✗ 插件不存在: $name%f"; return 1; }
    if [[ -e "$dir/.disabled" ]]; then
        print -P "%F{220}⚠ 插件已是禁用状态%f"
        return 0
    fi
    touch "$dir/.disabled"
    print -P "%F{${_550W_C[ok]}}✓ 已禁用: $name%f"
    print -P "  %F{${_550W_C[dim]}}下次重启后不再加载%f"
}

# ── 打包插件 ──
550w-plugin-pack() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name"
    [[ -d "$dir" ]] || { print -P "%F{196}✗ 插件不存在: $name%f"; return 1; }

    # 读取版本
    local ver
    ver="$(_550w_plugin_meta "$name" version)"
    [[ -z "$ver" ]] && ver="0.0.0"

    local dest="$HOME/.550w/backups/${name}-${ver}-$(date +%Y%m%d_%H%M%S).tar.gz"
    [[ -d "$(dirname "$dest")" ]] || mkdir -p "$(dirname "$dest")"

    tar -czf "$dest" -C "$_550W_PLUGIN_DIR" "$name" 2>/dev/null
    if [[ -f "$dest" ]]; then
        local sz
        sz=$(du -h "$dest" | cut -f1)
        print -P "%F{${_550W_C[ok]}}✓ 已打包: ${dest:t} ($sz)%f"
    else
        print -P "%F{196}✗ 打包失败%f"
    fi
}

# ── 从打包安装 ──
550w-plugin-install() {
    local src="$1"
    if [[ -z "$src" ]]; then
        print -n "  tar.gz 路径: "; read -r src
    fi
    [[ -z "$src" ]] && return 0
    [[ -r "$src" ]] || { print -P "%F{196}✗ 文件不存在%f"; return 1; }

    # 解包到临时目录
    local tmp
    tmp=$(mktemp -d "${TMPDIR:-/tmp}/550w-install.XXXXXX") || return 1
    if ! tar -xzf "$src" -C "$tmp" 2>/dev/null; then
        print -P "%F{196}✗ 解包失败%f"
        rm -rf "$tmp"
        return 1
    fi

    # 找插件目录（顶层目录名）
    local plugdir
    plugdir=$(find "$tmp" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | head -1)
    if [[ -z "$plugdir" ]]; then
        print -P "%F{196}✗ 包内无插件目录%f"
        rm -rf "$tmp"
        return 1
    fi

    local name
    name=$(basename "$plugdir")
    local target="$_550W_PLUGIN_DIR/$name"

    if [[ -d "$target" ]]; then
        print -P "%F{220}⚠ 插件已存在: $name%f"
        if ! _550w_set_confirm_plugin "覆盖?"; then
            rm -rf "$tmp"
            return 0
        fi
        rm -rf "$target"
    fi

    mv "$plugdir" "$target"
    rm -rf "$tmp"

    # 检查依赖
    _550w_plugin_scan
    _550w_plugin_parse_meta "$target" "$target/main.zsh"
    _550w_plugin_check_cmd_deps "$name" || {
        local m="${_550W_PLUGIN_META[missing_cmd,$name]}"
        print -P "%F{220}⚠ 已安装但缺依赖: $m%f"
        print -P "  %F{${_550W_C[dim]}}安装：pkg install ${m}%f"
    }

    print -P "%F{${_550W_C[ok]}}✓ 已安装: $name%f"
    print -P "  %F{${_550W_C[dim]}}重载：550w-plugin-reload%f"
}

# 内部：确认（plugins 用）
_550w_set_confirm_plugin() {
    local p="${1:-确认}"
    print -n "  ${p} (y/N): "
    local c; read -r c
    [[ "$c" == "y" || "$c" == "Y" ]]
}

# ── 版本查看 ──
550w-plugin-version() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local ver
    ver="$(_550w_plugin_meta "$name" version)"
    [[ -z "$ver" ]] && ver="unknown"
    print -P "  %F{${_550W_C[cyan]}}$name%f  %F{${_550W_C[ok]}}v${ver}%f"
}

# ── 版本兼容检查 ──
# 约定：@requires_550w: >=1.0  表示需要 550W v1.0+
550w-plugin-compat-check() {
    _550w_plugin_scan
    print -P "  %F{${_550W_C[cyan]}}%B插件兼容检查%b%f"
    print -P "  %F{${_550W_C[dim]}}当前 550W: $_550W_VERSION%f"
    print ""
    local name
    for name in "${_550W_PLUGIN_LIST[@]}"; do
        local ver
        ver="$(_550w_plugin_meta "$name" version)"
        local loaded="○"
        _550w_plugin_is_loaded "$name" && loaded="●"
        printf '  \e[38;5;%sm%s\e[0m %-18s \e[38;5;%smv%s\e[0m\n' \
            "${_550W_C[ok]}" "$loaded" "$name" "${_550W_C[dim]}" "${ver:-0.0.0}"
    done
}

# ══════════════════ 错误查看 ══════════════════

550w-plugin-errors() {
    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件错误 ══════%b%f"
    print ""
    if (( ${#_550W_PLUGIN_ERRORS[@]} == 0 )); then
        print -P "  %F{${_550W_C[ok]}}✓ 无错误%f"
        return 0
    fi
    local entry name msg
    for entry in "${_550W_PLUGIN_ERRORS[@]}"; do
        name="${entry%%|*}"
        msg="${entry#*|}"
        printf '  \e[38;5;%sm✗\e[0m \e[1m%-18s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[err]}" "$name" "${_550W_C[dim]}" "$msg"
    done
    print ""
    print -P "  共 ${#_550W_PLUGIN_ERRORS[@]} 个错误"
}

550w-plugin-clear-errors() {
    _550W_PLUGIN_ERRORS=()
    print -P "  %F{${_550W_C[ok]}}✓ 已清空%f"
}

# ══════════════════ 插件日志查看 ══════════════════

550w-plugin-logs() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0

    local dir="$_550W_PLUGIN_DIR/$name/log"
    if [[ ! -d "$dir" ]]; then
        print -P "  %F{${_550W_C[dim]}}（该插件无日志）%f"
        return 0
    fi

    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ $name 日志 ══════%b%f"
    print -P "  %F{${_550W_C[dim]}}目录: $dir%f"
    print ""

    local today="$dir/$(date +%Y%m%d).log"
    if [[ -r "$today" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 今日（末 30 条）%f"
        tail -30 "$today" | sed 's/^/    /'
    else
        print -P "  %F{${_550W_C[dim]}}（今日无日志）%f"
    fi
    print ""
    print -n "  查看其它日期? (y/N): "
    local c; read -r c
    if [[ "$c" == "y" || "$c" == "Y" ]]; then
        local files=("$dir"/*.log(N))
        if (( ${#files[@]} == 0 )); then
            print -P "  %F{${_550W_C[dim]}}（无历史日志）%f"
            return 0
        fi
        local i=0 f
        for f in "${files[@]}"; do
            (( i++ ))
            printf '  [%d] %s\n' "$i" "${f:t}"
        done
        print -n "  选择: "; local n; read -r n
        [[ "$n" =~ '^[0-9]+$' ]] && (( n >= 1 && n <= ${#files[@]} )) && {
            print ""
            tail -50 "${files[$n]}" | sed 's/^/    /'
        }
    fi
}

# 清空插件日志
550w-plugin-log-clear() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name/log"
    [[ -d "$dir" ]] || { print -P "%F{220}无日志目录%f"; return 0; }
    if _550w_set_confirm_plugin "确认清空所有日志?"; then
        rm -f "$dir"/*.log
        print -P "%F{${_550W_C[ok]}}✓ 已清空%f"
    fi
}

# 打开插件日志目录
550w-plugin-log-open() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name/log"
    [[ -d "$dir" ]] || mkdir -p "$dir"
    print -P "  目录: $dir"
    ls -lah "$dir" 2>/dev/null
}

# ══════════════════ 插件配置查看 ══════════════════

550w-plugin-config() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0

    local dir="$_550W_PLUGIN_DIR/$name/config"
    if [[ ! -d "$dir" ]]; then
        print -P "  %F{${_550W_C[dim]}}（该插件无配置）%f"
        return 0
    fi

    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ $name 配置 ══════%b%f"
    print -P "  %F{${_550W_C[dim]}}目录: $dir%f"
    print ""

    local f="$dir/config"
    if [[ -r "$f" ]]; then
        cat "$f" | sed 's/^/    /'
    else
        print -P "  %F{${_550W_C[dim]}}（无 config 文件）%f"
    fi

    print ""
    print "  [1] 编辑配置"
    print "  [2] 删除配置"
    print "  [0] 返回"
    print -n "  选择: "
    local c; read -r c
    case "$c" in
        1)
            if command -v nano >/dev/null 2>&1; then
                [[ -f "$f" ]] || touch "$f"
                nano "$f"
            else
                print -P "%F{196}未装 nano%f"
            fi
            ;;
        2)
            if _550w_set_confirm_plugin "确认删除配置?"; then
                rm -f "$f"
                print -P "%F{${_550W_C[ok]}}✓ 已删除%f"
            fi
            ;;
    esac
}

# 打开插件配置目录
550w-plugin-config-open() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local dir="$_550W_PLUGIN_DIR/$name/config"
    [[ -d "$dir" ]] || mkdir -p "$dir"
    print -P "  目录: $dir"
    ls -lah "$dir" 2>/dev/null
}

# ══════════════════ 钩子管理 ══════════════════

550w-plugin-hooks() {
    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件钩子 ══════%b%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}插件可注册的钩子类型：%f"
    print "    precmd    每条命令执行前"
    print "    preexec   每条命令执行后"
    print "    chpwd     切换目录时"
    print "    login     登录成功后"
    print "    logout    shell 退出时"
    print ""

    if (( ${#_550W_PLUGIN_LIST[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无插件）%f"
        return 0
    fi

    print -P "  %F{${_550W_C[cyan]}}▸ 各插件注册的钩子%f"
    local name hooks
    for name in "${_550W_PLUGIN_LIST[@]}"; do
        hooks="$(_550w_plugin_meta "$name" hooks)"
        if [[ -n "$hooks" ]]; then
            printf '  \e[38;5;%sm●\e[0m %-18s \e[38;5;%sm%s\e[0m\n' \
                "${_550W_C[ok]}" "$name" "${_550W_C[cyan]}" "$hooks"
        fi
    done
    print ""
    print -P "  %F{${_550W_C[cyan]}}▸ 已挂载的钩子函数%f"
    local h
    for h in precmd preexec chpwd; do
        local -a fns
        case "$h" in
            precmd) fns=("${precmd_functions[@]}") ;;
            preexec) fns=("${preexec_functions[@]}") ;;
            chpwd) fns=("${chpwd_functions[@]}") ;;
        esac
        local fn
        for fn in "${fns[@]}"; do
            [[ "$fn" == _550w_plugin_hook_* ]] || continue
            printf '  \e[38;5;%sm%s\e[0m → %s\n' "${_550W_C[cyan]}" "$h" "$fn"
        done
    done
    print ""
}

# 手动跑某插件的登录钩子
550w-plugin-hook-test() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0
    local fn="_550w_plugin_hook_${name}_login"
    if (( ${+functions[$fn]} )); then
        print -P "  %F{${_550W_C[cyan]}}执行 $fn%f"
        "$fn"
    else
        print -P "  %F{${_550W_C[dim]}}（该插件无 login 钩子）%f"
    fi
}

# 卸载所有插件的 precmd/preexec/chpwd 钩子
550w-plugin-hooks-remove() {
    if ! _550w_set_confirm_plugin "确认移除所有插件钩子?"; then
        return 0
    fi
    local fn
    local -a new_precmd=() new_preexec=() new_chpwd=()
    for fn in "${precmd_functions[@]}"; do
        [[ "$fn" == _550w_plugin_hook_* ]] && continue
        new_precmd+=("$fn")
    done
    for fn in "${preexec_functions[@]}"; do
        [[ "$fn" == _550w_plugin_hook_* ]] && continue
        new_preexec+=("$fn")
    done
    for fn in "${chpwd_functions[@]}"; do
        [[ "$fn" == _550w_plugin_hook_* ]] && continue
        new_chpwd+=("$fn")
    done
    precmd_functions=("${new_precmd[@]}")
    preexec_functions=("${new_preexec[@]}")
    chpwd_functions=("${new_chpwd[@]}")
    print -P "%F{${_550W_C[ok]}}✓ 已移除所有插件钩子%f"
}

# ══════════════════ 覆盖加载器 ══════════════════
# 原来的加载器（平铺/文件夹）替换成 v2 主加载器

_550w_plugin_legacy_load() {
    # 兼容旧调用：直接调新加载器
    _550w_plugin_load_all
}

# 扫描 + 加载
if [[ -d "$_550W_PLUGIN_DIR" ]]; then
    _550w_plugin_load_all
    _550w_plugin_install_logout_hook
fi

# ══════════════════ 覆盖：插件信息（增强版）══════════════════

550w-plugin-info() {
    local name="$1"
    if [[ -z "$name" ]]; then
        print -n "  插件名: "; read -r name
    fi
    [[ -z "$name" ]] && return 0

    _550w_plugin_scan
    if [[ ! -d "$_550W_PLUGIN_DIR/$name" ]]; then
        print -P "%F{196}✗ 插件不存在: $name%f"
        return 1
    fi

    local dir="$_550W_PLUGIN_DIR/$name"

    # 元数据
    local v_name v_ver v_author v_desc v_req v_dep v_hooks
    v_name="$(_550w_plugin_meta "$name" name)"
    v_ver="$(_550w_plugin_meta "$name" version)"
    v_author="$(_550w_plugin_meta "$name" author)"
    v_desc="$(_550w_plugin_meta "$name" desc)"
    v_req="$(_550w_plugin_meta "$name" requires)"
    v_dep="$(_550w_plugin_meta "$name" depends)"
    v_hooks="$(_550w_plugin_meta "$name" hooks)"

    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件：$name ══════%b%f"
    print ""

    # 状态
    local status color
    if _550w_plugin_is_loaded "$name"; then
        status="已加载"
        color="${_550W_C[ok]}"
    elif [[ -e "$dir/.disabled" ]]; then
        status="已禁用"
        color="${_550W_C[dim]}"
    else
        status="未加载"
        color="${_550W_C[warn]}"
    fi
    printf '  \e[38;5;%sm%-12s\e[0m \e[1m\e[38;5;%sm%s\e[0m\n' \
        "${_550W_C[dim]}" "状态" "$color" "$status"

    [[ -n "$v_name" && "$v_name" != "$name" ]] && \
        printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[dim]}" "名称" "$v_name"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[dim]}" "版本" "${v_ver:-0.0.0}"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[dim]}" "作者" "${v_author:-unknown}"
    [[ -n "$v_desc" ]] && \
        printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[dim]}" "说明" "$v_desc"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[dim]}" "目录" "$dir"
    print ""

    # 依赖
    if [[ -n "$v_req" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 命令依赖%f"
        local d
        for d in ${=v_req}; do
            if command -v "$d" >/dev/null 2>&1; then
                printf '    \e[38;5;%sm✓\e[0m %s\n' "${_550W_C[ok]}" "$d"
            else
                printf '    \e[38;5;%sm✗\e[0m %s (缺失)\n' "${_550W_C[err]}" "$d"
            fi
        done
        print ""
    fi

    if [[ -n "$v_dep" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 插件依赖%f"
        local d
        for d in ${=v_dep}; do
            if [[ -d "$_550W_PLUGIN_DIR/$d" ]]; then
                printf '    \e[38;5;%sm✓\e[0m %s\n' "${_550W_C[ok]}" "$d"
            else
                printf '    \e[38;5;%sm✗\e[0m %s (缺失)\n' "${_550W_C[err]}" "$d"
            fi
        done
        print ""
    fi

    # 钩子
    if [[ -n "$v_hooks" ]]; then
        print -P "  %F{${_550W_C[cyan]}}▸ 注册钩子%f"
        local h
        for h in ${=v_hooks}; do
            printf '    \e[38;5;%sm●\e[0m %s\n' "${_550W_C[ok]}" "$h"
        done
        print ""
    fi

    # 文件
    print -P "  %F{${_550W_C[cyan]}}▸ 文件%f"
    local f
    for f in "$dir"/*(N); do
        if [[ -d "$f" ]]; then
            local n
            n=$(ls -1 "$f" 2>/dev/null | wc -l | tr -d ' ')
            printf '    \e[38;5;%sm[DIR]\e[0m  %-20s (%s 项)\n' \
                "${_550W_C[cyan]}" "${f:t}/" "$n"
        else
            local sz
            sz=$(wc -c < "$f" 2>/dev/null | tr -d ' ')
            printf '    \e[38;5;%sm[FILE]\e[0m %-20s %s 字节\n' \
                "${_550W_C[dim]}" "${f:t}" "$sz"
        fi
    done
    print ""

    # 函数
    if [[ -r "$dir/main.zsh" ]]; then
        local fns
        fns=$(grep -oE '^[a-zA-Z_][a-zA-Z0-9_-]*\(\)' "$dir/main.zsh" 2>/dev/null | sed 's/()//')
        if [[ -n "$fns" ]]; then
            print -P "  %F{${_550W_C[cyan]}}▸ 定义函数%f"
            print "$fns" | sed 's/^/    /'
            print ""
        fi
    fi

    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 覆盖：插件列表（增强版）══════════════════

550w-plugins() {
    _550w_plugin_scan

    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ 550W 插件列表 ══════%b%f"
    print -P "  %F{${_550W_C[dim]}}目录: $_550W_PLUGIN_DIR%f"
    print ""

    if (( ${#_550W_PLUGIN_LIST[@]} == 0 )); then
        print -P "  %F{${_550W_C[dim]}}（无插件）%f"
        print ""
        print -P "  %F{${_550W_C[dim]}}创建：550w-plugin-new 插件名%f"
        return 0
    fi

    # 表头
    printf '  \e[38;5;%sm%-4s %-18s %-8s %-10s %s\e[0m\n' \
        "${_550W_C[dim]}" "状态" "名称" "版本" "作者" "说明"
    printf '  \e[38;5;%sm%s\e[0m\n' \
        "${_550W_C[dim]}" "────────────────────────────────────────────────────────"

    local name mark ver author desc
    for name in "${_550W_PLUGIN_LIST[@]}"; do
        if _550w_plugin_is_loaded "$name"; then
            mark="\e[38;5;${_550W_C[ok]}m● \e[0m"
        elif [[ -e "$_550W_PLUGIN_DIR/$name/.disabled" ]]; then
            mark="\e[38;5;${_550W_C[err]}m✗ \e[0m"
        else
            mark="\e[38;5;${_550W_C[dim]}m○ \e[0m"
        fi

        ver="$(_550w_plugin_meta "$name" version)"
        [[ -z "$ver" ]] && ver="-"
        author="$(_550w_plugin_meta "$name" author)"
        [[ -z "$author" || "$author" == "unknown" ]] && author="-"
        desc="$(_550w_plugin_meta "$name" desc)"
        [[ -z "$desc" ]] && desc="(无说明)"
        (( ${#desc} > 30 )) && desc="${desc:0:27}..."

        printf '  %b\e[38;5;%sm%-18s\e[0m \e[38;5;%sm%-8s\e[0m \e[38;5;%sm%-10s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "$mark" "${_550W_C[bright]}" "$name" \
            "${_550W_C[cyan]}" "$ver" \
            "${_550W_C[dim]}" "$author" \
            "${_550W_C[dim]}" "$desc"
    done

    print ""
    print -P "  %F{${_550W_C[dim]}}共 ${#_550W_PLUGIN_LIST[@]} 个 · 已加载 ${#_550W_PLUGIN_LOADED[@]} 个%f"
    print -P "  %F{${_550W_C[dim]}}● 已加载  ○ 未加载  ✗ 已禁用%f"

    if (( ${#_550W_PLUGIN_ERRORS[@]} > 0 )); then
        print ""
        print -P "  %F{${_550W_C[err]}}⚠ ${#_550W_PLUGIN_ERRORS[@]} 个错误，用 550w-plugin-errors 查看%f"
    fi
}

# ══════════════════ 插件主菜单 ══════════════════

550w-plugin() {
    while true; do
        _550w_plugin_scan
        _550w_cls 2>/dev/null || clear
        print -P "  %F{${_550W_C[cyan]}}%B╔════════════════════════════════════════════╗%b%f"
        print -P "  %F{${_550W_C[cyan]}}%B║%f  %F{${_550W_C[bright]}}%B          550W 插件系统 v2%b%f             %F{${_550W_C[cyan]}}%B║%f"
        print -P "  %F{${_550W_C[cyan]}}%B╚════════════════════════════════════════════╝%b%f"
        print -P "  %F{${_550W_C[dim]}}已装 ${#_550W_PLUGIN_LIST[@]} · 已加载 ${#_550W_PLUGIN_LOADED[@]} · 错误 ${#_550W_PLUGIN_ERRORS[@]}%f"
        print ""

        print -P "  %F{${_550W_C[ok]}}%B▸ 查看%f"
        print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "1" "列出插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "2" "查看插件详情"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "3" "查看错误"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "4" "查看钩子"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "5" "查看插件日志"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "6" "查看插件配置"

        print ""
        print -P "  %F{${_550W_C[ok]}}%B▸ 操作%f"
        print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "7"  "创建插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "8"  "编辑插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "9"  "启用插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "10" "禁用插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "11" "删除插件"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "12" "重载（单个/全部）"

        print ""
        print -P "  %F{${_550W_C[ok]}}%B▸ 打包与安装%f"
        print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "13" "打包插件为 tar.gz"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "14" "从 tar.gz 安装"

        print ""
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "15" "帮助（命令速查）"
        printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[dim]}"  "0"  "返回"

        print ""
        print -n "  选择 [0-15]: "
        local c
        read -r c
        case "$c" in
            1)  550w-plugins; _550w_plugin_wait ;;
            2)  550w-plugin-info; ;;
            3)  550w-plugin-errors; _550w_plugin_wait ;;
            4)  550w-plugin-hooks; _550w_plugin_wait ;;
            5)  550w-plugin-logs; _550w_plugin_wait ;;
            6)  550w-plugin-config; ;;
            7)
                print -n "  插件名: "; local n; read -r n
                [[ -n "$n" ]] && 550w-plugin-new "$n"
                _550w_plugin_wait
                ;;
            8)  550w-plugin-edit ;;
            9)  550w-plugin-enable; _550w_plugin_wait ;;
            10) 550w-plugin-disable; _550w_plugin_wait ;;
            11) 550w-plugin-remove; _550w_plugin_wait ;;
            12)
                print -n "  插件名（回车=全部）: "; local n; read -r n
                550w-plugin-reload "$n"
                _550w_plugin_wait
                ;;
            13) 550w-plugin-pack; _550w_plugin_wait ;;
            14) 550w-plugin-install; _550w_plugin_wait ;;
            15) _550w_plugin_help; ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

_550w_plugin_wait() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 帮助：命令速查 ══════════════════

_550w_plugin_help() {
    _550w_cls 2>/dev/null || clear
    print -P "  %F{${_550W_C[cyan]}}%B══════ 插件命令速查 ══════%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 查看%f"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugins" "列出所有插件"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-info [名]" "详情"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-errors" "错误清单"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-hooks" "钩子状态"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-logs [名]" "日志"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-config [名]" "配置"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 操作%f"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-new [名]" "创建"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-edit [名]" "编辑"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-remove [名]" "删除"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-enable [名]" "启用"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-disable [名]" "禁用"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-reload [名]" "重载"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-open [名]" "打开目录"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 打包%f"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-pack [名]" "打包"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[bright]}" "550w-plugin-install <路径>" "安装"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 开发者 API（在 main.zsh 里用）%f"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[dim]}" "_plugin_log info 消息" "写日志"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[dim]}" "_plugin_config_get key [默认]" "读配置"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[dim]}" "_plugin_config_set key val" "写配置"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[dim]}" "\$ _550W_PLUGIN_SELF" "插件目录路径"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[dim]}" "\$ _550W_PLUGIN_CURRENT" "当前插件名"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 元数据（main.zsh 顶部注释）%f"
    print -P "  %F{${_550W_C[dim]}}# @name: 显示名（可选）%f"
    print -P "  %F{${_550W_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550W_C[dim]}}# @author: 作者名%f"
    print -P "  %F{${_550W_C[dim]}}# @desc: 一句话说明%f"
    print -P "  %F{${_550W_C[dim]}}# @requires: curl jq      命令依赖%f"
    print -P "  %F{${_550W_C[dim]}}# @depends: 其它插件名    插件依赖%f"
    print -P "  %F{${_550W_C[dim]}}# @hook: login precmd    钩子%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 钩子函数命名约定%f"
    print -P "  %F{${_550W_C[dim]}}  _550w_plugin_hook_<插件名>_<钩子名>()%f"
    print -P "  %F{${_550W_C[dim]}}  例: _550w_plugin_hook_weather_login()%f"
    print ""

    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 帮助（保留旧名）══════════════════

550w-plugin-help() {
    _550w_plugin_help
}

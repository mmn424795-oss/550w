# ~/.550w/help.zsh — 550W 使用手册 v2.0
# 10 大章 · 60 命令 · 20 教程 · 50 FAQ

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ 辅助函数 ══════════════════

_550w_help_head() {
    _550w_cls
    local title="$1"
    local sub="${2:-}"
    local w=60
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

_550w_help_row() {
    local num="$1" text="$2" desc="${3:-}"
    if [[ -n "$desc" ]]; then
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%-22s\e[0m \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text" "${_550W_C[dim]}" "$desc"
    else
        printf '  \e[38;5;%sm[%2s]\e[0m \e[1m%s\e[0m\n' \
            "${_550W_C[cyan]}" "$num" "$text"
    fi
}

_550w_help_sub() {
    local text="$1"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ ${text}%b%f"
    print -P "  %F{${_550W_C[dim]}}──────────────────────────────────────%f"
}

_550w_help_chapter() {
    local num="$1" title="$2"
    print ""
    print -P "  %F{${_550W_C[cyan]}}%B╭─────────────────────────────────────╮%b%f"
    print -P "  %F{${_550W_C[cyan]}}%B│%f  %F{${_550W_C[ok]}}%B第 $num 章%b%f · %F{${_550W_C[bright]}}%B$title%b%f"
    print -P "  %F{${_550W_C[cyan]}}%B╰─────────────────────────────────────╯%b%f"
    print ""
}

_550w_help_step() {
    local num="$1" title="$2"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▶ 步骤 $num：$title%b%f"
    print -P "  %F{${_550W_C[dim]}}──────────────────────────────────%f"
}

_550w_help_cmd() {
    print -P "  %F{${_550W_C[cyan]}}命令：%f"
    print -P "  %F{${_550W_C[bright]}}  $*%f"
}

_550w_help_expect() {
    print -P "  %F{${_550W_C[ok]}}期望结果：%f"
    while (( $# > 0 )); do
        print -P "  %F{${_550W_C[dim]}}  · $1%f"
        shift
    done
}

_550w_help_note() {
    print -P "  %F{${_550W_C[amber]}}%B⚠ 注意%b%f  $*"
}

_550w_help_tip() {
    print -P "  %F{${_550W_C[ok]}}%B💡 提示%b%f  $*"
}

_550w_help_warn() {
    print -P "  %F{${_550W_C[err]}}%B✗ 警告%b%f  $*"
}

_550w_help_info() {
    print -P "  %F{${_550W_C[dim]}}$*%f"
}

_550w_help_divider() {
    print ""
    print -P "  %F{${_550W_C[dim]}}──────────────────────────────────────%f"
    print ""
}

_550w_help_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

_550w_help_goal() {
    local text="${1//\%/%%}"
    print -P "  %F{${_550W_C[warn]}}%B▎本章目标%b%f"
    print -P "  %F{${_550W_C[dim]}}  $text%f"
    print ""
}

_550w_help_pre() {
    local text="${1//\%/%%}"
    print -P "  %F{${_550W_C[cyan]}}%B▎前置条件%b%f"
    print -P "  %F{${_550W_C[dim]}}  $text%f"
    print ""
}

_550w_help_cost() {
    local time="$1" diff="$2"
    print -P "  %F{${_550W_C[cyan]}}%B▎预计耗时%b%f $time   %F{${_550W_C[cyan]}}%B▎难度%b%f $diff"
    print ""
}

# ══════════════════ 主菜单 ══════════════════

550w-help() {
    while true; do
        _550w_help_head "550W 使用手册" "v2.0 · 10 大章 · 60 命令 · 20 教程 · 50 FAQ"
        print -P "  %F{${_550W_C[dim]}}版本 $_550W_VERSION  ·  用户 $_550W_USER_NAME  ·  会话 ${_550W_SESSION_ID:5:9}%f"
        print ""

        _550w_help_sub "入门"
        _550w_help_row "1"  "快速上手"        "30 秒跑起来"
        _550w_help_row "2"  "命令索引"        "60+ 命令完整手册"

        _550w_help_sub "教程"
        _550w_help_row "3"  "分步教程"        "20 步，从零到精通"
        _550w_help_row "4"  "应用场景"        "15 个真实任务"

        _550w_help_sub "深度"
        _550w_help_row "5"  "插件专章"        "20 节 + 5 个完整示例"
        _550w_help_row "6"  "动画专章"        "234 个动画函数指南"
        _550w_help_row "7"  "开机专章"        "开机 15 步详解"

        _550w_help_sub "参考"
        _550w_help_row "8"  "开发者指南"      "API / 扩展 / 调试"
        _550w_help_row "9"  "FAQ"             "50 个常见问题"
        _550w_help_row "10" "关于"            "版本/变更/许可"

        print ""
        _550w_help_row "0"  "退出"
        _550w_help_divider
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_help_menu_quick ;;
            2)  _550w_help_menu_cmds ;;
            3)  _550w_help_menu_tutorial ;;
            4)  _550w_help_menu_scenario ;;
            5)  _550w_help_menu_plugin ;;
            6)  _550w_help_menu_anim ;;
            7)  _550w_help_menu_boot ;;
            8)  _550w_help_menu_dev ;;
            9)  _550w_help_menu_faq ;;
            10) _550w_help_menu_about ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

_550w_help_menu_quick()    { _550w_help_head "快速上手"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_cmds()     { _550w_help_head "命令索引"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_tutorial() { _550w_help_head "分步教程"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_scenario() { _550w_help_head "应用场景"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_plugin()   { _550w_help_head "插件专章"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_anim()     { _550w_help_head "动画专章"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_boot()     { _550w_help_head "开机专章"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_dev()      { _550w_help_head "开发者指南"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_faq()      { _550w_help_head "FAQ"; _550w_help_info "待下一段填充"; _550w_help_pause }
_550w_help_menu_about()    { _550w_help_head "关于"; _550w_help_info "待下一段填充"; _550w_help_pause }
# ══════════════════ 快速上手 ══════════════════

_550w_help_menu_quick() {
    while true; do
        _550w_help_head "快速上手" "5 分钟跑起来"
        print ""

        _550w_help_row "1"  "第一次启动"   "从打开 Termux 到进系统"
        _550w_help_row "2"  "认识界面"     "提示符、心跳、状态"
        _550w_help_row "3"  "最常用命令"   "10 个必学命令"
        _550w_help_row "4"  "第一次对话"   "配 AI 并对话"
        _550w_help_row "5"  "出问题怎么办" "应急步骤"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_quick_start ;;
            2) _550w_help_quick_ui ;;
            3) _550w_help_quick_cmds ;;
            4) _550w_help_quick_ai ;;
            5) _550w_help_quick_emergency ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ── 1. 第一次启动 ──

_550w_help_quick_start() {
    _550w_help_head "第一次启动" "从打开到进系统"
    _550w_help_goal "打开 Termux → 看动画 → 输密码 → 进入 550W 系统"
    _550w_help_pre "已安装 Termux;已装好 550W(~\\.550w/core.zsh 存在)"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    _550w_help_step "1" "打开 Termux"
    print "  手机桌面点 Termux 图标。"
    print "  打开后立刻会看到:"
    print "    1) 黑屏脉冲(◆ 呼吸)"
    print "    2) 矩阵雨下落"
    print "    3) BIOS POST 自检(12 项)"
    print "    4) 硬件扫描"
    print "    5) 端口扫描 + 接管进度"
    print "    6) 网络嗅探 + 加密握手"
    print "    7) 内核自检(20 项)"
    print "    8) AI 引擎自检 + 评分"
    print "    9) SID 字符解密"
    print "   10) 密码框弹出"
    print ""
    _550w_help_tip "不想看完可以按任意键跳过,按 q 紧急退出"

    _550w_help_step "2" "输入密码"
    print "  在密码框输入密码, 默认是:"
    _550w_help_cmd "563214789"
    print "  输完按回车。"
    _550w_help_expect "密码正确 → 播授权动画 + 欢迎画" "密码错误 → 红屏闪烁 + 重试(共 3 次)"

    _550w_help_step "3" "进入系统"
    print "  通过后显示:"
    print "    · 6 行渐变大字 550W"
    print "    · 操作员档案"
    print "    · 系统状态"
    print "    · 签名"
    _550w_help_note "欢迎画会停住, 按回车进入终端"

    _550w_help_step "4" "看到提示符"
    print "  最终你会看到:"
    print -P "  %F{${_550W_C[ok]}}550W_computer_Earth Engine ● 19:30:45 root@Max-System:~#%f"
    print "  分解:"
    print "    550W_computer_Earth Engine  系统标识"
    print "    ●                            MOSS 健康圆点"
    print "    19:30:45                     当前时间"
    print "    root@Max-System             用户名@主机"
    print "    ~#                           当前目录 + 提示符"
    print ""

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你已经进入 550W 系统"
    print ""
    print "  下一步: 学'认识界面' 或 '最常用命令'"
    _550w_help_pause
}

# ── 2. 认识界面 ──

_550w_help_quick_ui() {
    _550w_help_head "认识界面" "看懂提示符和状态信息"
    _550w_help_goal "理解提示符每部分的含义, 知道信息从哪来"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "提示符结构"
    print "  完整提示符长这样:"
    print -P "  %F{${_550W_C[ok]}}550W_computer_Earth Engine%b%f %F{${_550W_C[ok]}}●%f %F{${_550W_C[dim]}}19:30:45%f %F{${_550W_C[ok]}}root@Max-System:~#%f"
    print ""
    print "  每部分含义:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[cyan]}" "550W_computer_Earth Engine" "系统标识(固定)"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[cyan]}" "● / ◐ / ○" "MOSS 状态(在线/降级/离线)"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[cyan]}" "19:30:45" "当前时间(每秒更新)"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[cyan]}" "root@Max-System" "用户@主机(固定)"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[cyan]}" "~#" "当前目录 + 提示符"

    _550w_help_step "2" "心跳信息"
    print "  每 60 秒会自动打印一行:"
    print -P "  %F{${_550W_C[dim]}}· core active · link ok · moss ok · latency 15ms · uptime 300s%f"
    print ""
    print "  字段:"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550W_C[ok]}" "core" "核心状态"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550W_C[ok]}" "link" "链路状态"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550W_C[ok]}" "moss" "AI 服务状态"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550W_C[ok]}" "latency" "随机延迟(装饰)"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550W_C[ok]}" "uptime" "本次会话已开秒数"

    _550w_help_step "3" "状态栏查看"
    print "  任何时候想看完整状态:"
    _550w_help_cmd "550w-status"
    print "  会显示:"
    print "    · 版本 / 会话 / 模式 / 速度 / 特效 / 主题"
    print "    · MOSS 启用 / Provider / 模型 / 健康 / 额度"
    print "    · 记忆轮数"
    print "    · 插件数量"

    _550w_help_step "4" "提示符自定义"
    print "  觉得提示符不对? 改:"
    _550w_help_cmd "550w-settings → 2"
    print "  可以开关:"
    print "    · SID 显示"
    print "    · 模式显示"
    print "    · MOSS 显示"
    print "    · 时间显示"
    print "    · 样式(full/minimal/plain)"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你能看懂界面所有信息了"
    _550w_help_pause
}

# ── 3. 最常用命令 ──

_550w_help_quick_cmds() {
    _550w_help_head "最常用命令" "10 个必学"
    _550w_help_goal "记住 10 个命令就能日常用"
    _550w_help_cost "5 分钟" "★☆☆☆☆"

    print -P "  %F{${_550W_C[ok]}}%B▸ 1. 550w-help%b%f"
    print "  打开本手册"
    _550w_help_cmd "550w-help"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 2. 550w-settings%b%f"
    print "  打开设置中心(13 大类 110 项)"
    _550w_help_cmd "550w-settings"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 3. 550w-status%b%f"
    print "  查看系统状态"
    _550w_help_cmd "550w-status"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 4. 550w-ai%b%f"
    print "  和 MOSS AI 对话"
    _550w_help_cmd '550w-ai "你好"'
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 5. 550w-moss-set%b%f"
    print "  切换 AI 服务商(15 个)"
    _550w_help_cmd "550w-moss-set"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 6. 550w-plugin%b%f"
    print "  插件系统主菜单"
    _550w_help_cmd "550w-plugin"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 7. 550w-anim%b%f"
    print "  动画库(234 个函数)"
    _550w_help_cmd "550w-anim"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 8. 550w-real%b%f"
    print "  真实系统数据(CPU/内存/温度)"
    _550w_help_cmd "550w-real"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 9. 550w-reset%b%f"
    print "  重置登录状态"
    _550w_help_cmd "550w-reset"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B▸ 10. 550w-extras%b%f"
    print "  外围工具(备份/日志/数据/插件/主题)"
    _550w_help_cmd "550w-extras"
    print ""

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  这 10 个够日常用了"
    _550w_help_tip "命令忘了? 直接敲 550w-help 回来查"
    _550w_help_pause
}

# ── 4. 第一次对话 ──

_550w_help_quick_ai() {
    _550w_help_head "第一次对话" "从零配 AI"
    _550w_help_goal "5 分钟内让 AI 回复你第一条消息"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "拿 API Key"
    print "  550W 用智谱 GLM 作为出厂 AI。"
    print ""
    print "  a) 手机浏览器打开: https://open.bigmodel.cn"
    print "  b) 右上角注册(手机号)"
    print "  c) 完成实名认证(个人认证, 1 分钟)"
    print "  d) 左侧菜单 → API Keys"
    print "  e) 点'新建 API Key', 复制生成的密钥"
    print ""
    print "  密钥形如:"
    print -P "  %F{${_550W_C[dim]}}aec8bdf745584ab2a8e060155a4.XXXXXXXXXX%f"
    _550w_help_warn "API Key 只显示一次! 务必先保存"

    _550w_help_step "2" "配置 Key"
    print "  方式 A(推荐): 用设置界面"
    _550w_help_cmd "550w-settings → 6 → 12"
    print "  然后粘贴 Key。"
    print ""
    print "  方式 B: 手动写 ~/.zshrc"
    _550w_help_cmd 'echo "export ZHIPU_API_KEY=\"你的Key\"" >> ~/.zshrc'
    _550w_help_cmd "source ~/.zshrc"

    _550w_help_step "3" "测试对话"
    _550w_help_cmd '550w-ai "你好"'
    _550w_help_expect "MOSS 回复一句话" "或者: ✗ 缺少 API Key"

    _550w_help_step "4" "切换 Provider(可选)"
    print "  不满足智谱? 换成 deepseek:"
    _550w_help_cmd "550w-moss-set deepseek"
    print "  先设环境变量:"
    _550w_help_cmd 'export DEEPSEEK_API_KEY="sk-xxx"'
    print ""
    print "  15 个 provider 一览:"
    print "    glm / glm-pro / glm-air / zai"
    print "    openai / deepseek / moonshot"
    print "    qwen / groq / siliconflow / openrouter / mistral / stepfun"
    print "    local / custom"

    _550w_help_step "5" "多轮对话"
    print "  记忆会自动保存:"
    _550w_help_cmd '550w-ai "我叫小明"'
    _550w_help_cmd '550w-ai "我叫什么"'
    print "  第二次会回答'小明'"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你能和 AI 对话了"
    _550w_help_pause
}

# ── 5. 出问题怎么办 ──

_550w_help_quick_emergency() {
    _550w_help_head "出问题怎么办" "应急步骤"
    _550w_help_goal "系统卡住/报错时的紧急处理"
    _550w_help_cost "2 分钟" "★★☆☆☆"

    _550w_help_step "1" "开机卡住"
    print "  动画播到一半卡了:"
    print "    · 按任意键跳过"
    print "    · 按 q 紧急退出(不登录进终端)"

    _550w_help_step "2" "密码忘了"
    _550w_help_cmd "550w-settings → 4 → 2"
    print "  或者手动重置:"
    _550w_help_cmd 'echo "563214789" > ~/.550w/.550w_pass'

    _550w_help_step "3" "命令找不到"
    print "  command not found? 试试:"
    _550w_help_cmd "unset _550W_LOADED"
    _550w_help_cmd "source ~/.zshrc"
    print "  还不行就:"
    _550w_help_cmd "exec zsh"

    _550w_help_step "4" "终端白屏/乱码"
    _550w_help_cmd "reset"
    print "  或者关掉 Termux 重开"

    _550w_help_step "5" "AI 不回复"
    _550w_help_cmd "550w-moss"
    print "  看配置对不对。健康状态:"
    _550w_help_cmd "550w-settings → 6 → 13"

    _550w_help_step "6" "彻底重置(最后手段)"
    _550w_help_warn "会删掉所有数据"
    _550w_help_cmd "rm -rf ~/.550w"
    _550w_help_cmd "source ~/.zshrc"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  遇到问题别慌, 先试上面几步"
    _550w_help_pause
}
# ══════════════════ 命令索引 · 主菜单 ══════════════════

_550w_help_menu_cmds() {
    while true; do
        _550w_help_head "命令索引" "60+ 命令 · 完整手册"
        print ""

        _550w_help_sub "系统控制"
        _550w_help_row "1"  "系统类"   "8 命令:status/reset/..."

        _550w_help_sub "AI 对话"
        _550w_help_row "2"  "AI 类"    "5 命令:ai/moss/memory"

        _550w_help_sub "菜单入口"
        _550w_help_row "3"  "菜单类"   "8 命令:help/settings/plugin"

        _550w_help_sub "数据与工具"
        _550w_help_row "4"  "数据类"   "备份/日志/导入导出"

        _550w_help_sub "其它"
        _550w_help_row "5"  "全部命令" "一屏列出所有"
        _550w_help_row "6"  "搜索命令" "按关键词找"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_cmd_sys_menu ;;
            2) _550w_help_cmd_ai_menu ;;
            3) _550w_help_cmd_menu_menu ;;
            4) _550w_help_cmd_data_menu ;;
            5) _550w_help_cmd_all ;;
            6) _550w_help_cmd_search ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_cmd_sys_menu() {
    while true; do
        _550w_help_head "系统控制命令" "8 个"
        print ""
        _550w_help_row "1" "550w-status"  "查看系统完整状态"
        _550w_help_row "2" "550w-reset"   "重置登录状态"
        _550w_help_row "3" "550w-skip"    "跳过登录直接进"
        _550w_help_row "4" "550w-version" "版本信息"
        _550w_help_row "5" "550w-speed"   "切换动画速度"
        _550w_help_row "6" "550w-fx"      "开关特效"
        _550w_help_row "7" "550w-theme"   "切换主题"
        _550w_help_row "8" "550w-welcome" "重放欢迎画"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_show_status ;;
            2) _550w_help_show_reset ;;
            3) _550w_help_show_skip ;;
            4) _550w_help_show_version ;;
            5) _550w_help_show_speed ;;
            6) _550w_help_show_fx ;;
            7) _550w_help_show_theme ;;
            8) _550w_help_show_welcome ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 550w-status ══════════════════

_550w_help_show_status() {
    _550w_help_head "命令详情" "550w-status"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-status ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    查看系统完整状态。"
    print "    显示版本、会话、模式、速度、特效、主题、MOSS 配置、记忆、插件数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-status"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-status"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    在终端打印一段文本, 包括:"
    print "      · 版本 / 会话 / 模式 / 速度 / 特效 / 主题"
    print "      · 状态(已接管/待验证) / 失败次数 / 存活时间"
    print "      · MOSS 启用 / Provider / 模型 / 健康 / 额度 / 记忆轮数"
    print "      · 插件数量"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。任何时候都能跑。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-moss      查看 MOSS 详细配置"
    print "    550w-real      查看真实硬件数据"
    print "    550w-settings  修改配置"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ command not found"
    print "      原因: 核心未加载"
    print "      解决: unset _550W_LOADED && source ~/.zshrc"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-status()"
    print ""
    _550w_help_pause
}

# ══════════════════ 2. 550w-reset ══════════════════

_550w_help_show_reset() {
    _550w_help_head "命令详情" "550w-reset"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-reset ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    重置登录状态。"
    print "    清除当前会话标记, 下次敲命令会重新弹密码框。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-reset"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-reset"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    打印 '登录状态已重置'"
    print "    然后重新播开机动画(等几秒)"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-skip      跳过登录(不重播动画)"
    print "    550w-status    查看状态"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ 重置后没反应"
    print "      原因: _550W_DONE 标记没清"
    print "      解决: 关掉 Termux 重开"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-reset()"
    print ""
    _550w_help_pause
}

# ══════════════════ 3. 550w-skip ══════════════════

_550w_help_show_skip() {
    _550w_help_head "命令详情" "550w-skip"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-skip ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    跳过登录。"
    print "    直接进入系统, 不再播动画、不弹密码框。"
    print "    用于: 临时进来跑个命令、脚本调用、调试。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-skip"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-skip"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    打印 '登录已跳过 (MOSS-XXXX-XXXX)'"
    print "    PS1 立即变成已接管样式"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-reset     重置登录"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    (该命令不会出错)"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-skip()"
    print ""
    _550w_help_pause
}

# ══════════════════ 4. 550w-version ══════════════════

_550w_help_show_version() {
    _550w_help_head "命令详情" "550w-version"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-version ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    显示 550W 版本信息: 版本号、构建日期、主脚本路径、行数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-version"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-version"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    版本  测试版 v6.1"
    print "    构建  YYYY-MM-DD"
    print "    文件  /data/data/com.termux/files/home/.550w/core.zsh"
    print "    行数  NNNN"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-status    查看运行状态"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-version()"
    print ""
    _550w_help_pause
}

# ══════════════════ 5. 550w-speed ══════════════════

_550w_help_show_speed() {
    _550w_help_head "命令详情" "550w-speed"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-speed ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    切换动画播放速度。"
    print "    影响: 开机动画、菜单转场、打字机、进度条等所有定时动画。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制 / 外观"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-speed [档位]%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    档位      可选值:"
    print "      flash   30%  极快(闪现类)"
    print "      fast    60%  快"
    print "      normal 100%  标准"
    print "      slow   180%  慢"
    print "      hold     0%  定格(不缩放)"
    print "    (无参数)  显示用法帮助"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-speed fast"
    _550w_help_cmd "550w-speed slow"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    速度: fast"
    print "    同时写入 ~/.550w/.550w_config (持久化)"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-fx        开关特效"
    print "    550w-settings → 1 → 1  图形化设置"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ 无效档位"
    print "      原因: 拼写错误"
    print "      解决: 只用 flash/fast/normal/slow/hold"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-speed()"
    print ""
    _550w_help_pause
}

# ══════════════════ 6. 550w-fx ══════════════════

_550w_help_show_fx() {
    _550w_help_head "命令详情" "550w-fx"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-fx ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    开关高级视觉特效。"
    print "    关闭后: 矩阵雨/扫描线/撕裂/闪屏等效果不再播放。"
    print "    提速明显, 低端机/录屏/快速操作时建议关。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制 / 外观"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-fx [0|1]%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    0 | off   关闭特效"
    print "    1 | on    开启特效"
    print "    (无参数)  显示用法"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-fx 0"
    _550w_help_cmd "550w-fx on"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    特效: 关"
    print "    同时写入配置文件"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-speed     调速度"
    print "    550w-settings → 1 → 2  图形化设置"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-fx()"
    print ""
    _550w_help_pause
}

# ══════════════════ 7. 550w-theme ══════════════════

_550w_help_show_theme() {
    _550w_help_head "命令详情" "550w-theme"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-theme ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    切换配色主题。"
    print "    内置 5 套: cyber / amber / ice / moss / crimson"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制 / 外观"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-theme [名称]%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    名称      可选:"
    print "      cyber    经典青蓝(默认)"
    print "      amber    琥珀暖色"
    print "      ice      冰蓝冷色"
    print "      moss     深绿"
    print "      crimson  猩红"
    print "    (无参数)  列出所有主题"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-theme ice"
    _550w_help_cmd "550w-theme"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    主题已切换: ice"
    print "    注: 部分主题下次启动生效"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-settings → 3     主题管理"
    print "    550w-settings → 1 → 10 主色调"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ 未知主题"
    print "      原因: 名字拼错"
    print "      解决: 只用 cyber/amber/ice/moss/crimson"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-theme()"
    print ""
    _550w_help_pause
}

# ══════════════════ 8. 550w-welcome ══════════════════

_550w_help_show_welcome() {
    _550w_help_head "命令详情" "550w-welcome"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-welcome ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    重放欢迎画。"
    print "    显示: 6 行渐变大字 + 操作员档案 + 系统状态 + 签名"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    系统控制"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-welcome"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-welcome"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    清屏后依次显示:"
    print "      1) 6 行渐变 550W 大字"
    print "      2) 欢迎框"
    print "      3) 操作员档案(用户名/等级/权限)"
    print "      4) 系统状态(核心/链路/MOSS/记忆/会话)"
    print "      5) 签名"
    print "      6) 提示'按回车进入终端'"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-settings → 5    改用户档案"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → _550w_welcome_screen()"
    print ""
    _550w_help_pause
}
# ══════════════════ 命令索引 · AI 对话 ══════════════════

_550w_help_cmd_ai_menu() {
    while true; do
        _550w_help_head "AI 对话命令" "5 个"
        print ""
        _550w_help_row "1" "550w-ai"       "与 MOSS 对话"
        _550w_help_row "2" "550w-moss"     "查看 MOSS 配置"
        _550w_help_row "3" "550w-moss-set" "切换 Provider"
        _550w_help_row "4" "550w-glm"      "一键切回智谱 GLM"
        _550w_help_row "5" "550w-memory"   "记忆管理"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_show_ai ;;
            2) _550w_help_show_moss ;;
            3) _550w_help_show_moss_set ;;
            4) _550w_help_show_glm ;;
            5) _550w_help_show_memory ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 550w-ai ══════════════════

_550w_help_show_ai() {
    _550w_help_head "命令详情" "550w-ai"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-ai ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    与 MOSS 对话。"
    print "    支持单次问答、多轮上下文、交互模式、管道输入。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    AI 对话"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-ai \"消息\"%f"
    print -P "  %F{${_550W_C[bright]}}  550w-ai             进入交互模式%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    消息        要问的内容"
    print "      · 中英文都行"
    print "      · 用引号包住(含空格时)"
    print "      · 最长 4096 字符"
    print "      · 含 % 不用转义"
    print "    (无参数)    进入交互模式, 一行一条"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    print "    单次对话:"
    _550w_help_cmd '550w-ai "今天天气如何"'
    print "    多轮对话:"
    _550w_help_cmd '550w-ai "我叫小明"'
    _550w_help_cmd '550w-ai "我叫什么"   # 会回答"小明"'
    print "    交互模式:"
    _550w_help_cmd "550w-ai"
    print "    管道输入:"
    _550w_help_cmd '550w-ai "$(cat file.txt)"'
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    打印 MOSS 回复到终端。"
    print "    同时自动保存到记忆文件。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    · _550W_MOSS_ENABLED=1"
    print "    · API Key 已配置"
    print "    · 网络可访问 provider"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-moss      查看配置"
    print "    550w-moss-set  切 Provider"
    print "    550w-memory    管理记忆"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ MOSS 未启用"
    print "      解决: 550w-settings → 6 → 1"
    print "    ✗ 缺少 API Key"
    print "      解决: 550w-settings → 6 → 12"
    print "    ✗ 已达每日限额"
    print "      解决: 550w-settings → 6 → 9"
    print "    ✗ 调用失败"
    print "      解决: 550w-settings → 6 → 13 检查健康"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-ai()"
    print ""
    _550w_help_pause
}

# ══════════════════ 2. 550w-moss ══════════════════

_550w_help_show_moss() {
    _550w_help_head "命令详情" "550w-moss"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-moss ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    查看 MOSS AI 完整配置。"
    print "    显示: 启用/Provider/模式/端点/模型/温度/MaxTokens/Token/健康/额度。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    AI 对话"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-moss"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-moss"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    一段配置信息, 包括:"
    print "      启用      1"
    print "      Provider  glm"
    print "      模式      cloud"
    print "      端点      https://open.bigmodel.cn/api/paas/v4"
    print "      模型      glm-4-flash"
    print "      温度      0.7"
    print "      MaxTokens 2048"
    print "      Token     已配置/未配置"
    print "      健康      ok/degraded/down"
    print "      额度      3/2000"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-moss-set   切换 Provider"
    print "    550w-status     完整状态"
    print "    550w-settings → 6  MOSS 配置界面"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-moss()"
    print ""
    _550w_help_pause
}

# ══════════════════ 3. 550w-moss-set ══════════════════

_550w_help_show_moss_set() {
    _550w_help_head "命令详情" "550w-moss-set"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-moss-set ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    切换 MOSS 使用的 AI 服务商(Provider)。"
    print "    15 个可选: glm/glm-pro/glm-air/zai/openai/deepseek/moonshot/"
    print "              qwen/groq/siliconflow/openrouter/mistral/stepfun/"
    print "              local/custom"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    AI 对话"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-moss-set [名称]%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    名称        15 个 Provider 之一"
    print "    (无参数)    弹菜单选择"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-moss-set"
    _550w_help_cmd "550w-moss-set deepseek"
    _550w_help_cmd "550w-moss-set qwen"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    已切换: deepseek (deepseek-chat)"
    print "    同时写入配置文件"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    切到新 Provider 前, 需先设置对应的环境变量:"
    print "      glm/glm-pro/glm-air  → ZHIPU_API_KEY"
    print "      zai                  → ZAI_API_KEY"
    print "      openai               → OPENAI_API_KEY"
    print "      deepseek             → DEEPSEEK_API_KEY"
    print "      moonshot             → MOONSHOT_API_KEY"
    print "      qwen                 → DASHSCOPE_API_KEY"
    print "      groq                 → GROQ_API_KEY"
    print "      siliconflow          → SILICONFLOW_API_KEY"
    print "      openrouter           → OPENROUTER_API_KEY"
    print "      mistral              → MISTRAL_API_KEY"
    print "      stepfun              → STEPFUN_API_KEY"
    print "      local                本地 Ollama(无需 Key)"
    print "      custom               手动填 URL/模型/Key"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-glm        一键切回智谱"
    print "    550w-moss       查看当前配置"
    print "    550w-settings → 6 → 2  图形化切换"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ 未知 provider"
    print "      解决: 只用上面 15 个名字"
    print "    ✗ 切换后仍报'缺少 API Key'"
    print "      解决: 检查对应环境变量是否 export"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-moss-set()"
    print ""
    _550w_help_pause
}

# ══════════════════ 4. 550w-glm ══════════════════

_550w_help_show_glm() {
    _550w_help_head "命令详情" "550w-glm"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-glm ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    一键切回智谱 GLM。"
    print "    等价于 '550w-moss-set glm', 但更短。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    AI 对话"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-glm"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-glm"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    已切回: glm (glm-4-flash)"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    ZHIPU_API_KEY 已设置"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-moss-set     任意切换"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-glm()"
    print ""
    _550w_help_pause
}

# ══════════════════ 5. 550w-memory ══════════════════

_550w_help_show_memory() {
    _550w_help_head "命令详情" "550w-memory"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-memory ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    管理 MOSS 的对话记忆。"
    print "    支持: 查看/清空/设置上限/查看文件路径"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    AI 对话 / 记忆"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    print -P "  %F{${_550W_C[bright]}}  550w-memory show        查看记忆%f"
    print -P "  %F{${_550W_C[bright]}}  550w-memory clear       清空记忆%f"
    print -P "  %F{${_550W_C[bright]}}  550w-memory max N       设置上限%f"
    print -P "  %F{${_550W_C[bright]}}  550w-memory path        查看文件路径%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    子命令      show / clear / max / path"
    print "    max 的 N    4 ~ 500 的整数"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-memory show"
    _550w_help_cmd "550w-memory clear"
    _550w_help_cmd "550w-memory max 100"
    _550w_help_cmd "550w-memory path"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    show: U/A 前缀列出所有消息"
    print "    clear: '记忆已清空'"
    print "    max:   '记忆上限设为 100 条'"
    print "    path:  /data/data/com.termux/files/home/.550w/.550w_moss_memory"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-settings → 6 → 8   图形化设置"
    print "    550w-extras → 11 → 4    导出记忆"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【常见错误】%f"
    print "    ✗ 无效值(需 ≥4)"
    print "      解决: max 参数 ≥ 4"
    print "    ✗ 记忆为空"
    print "      原因: 还没对话过"
    print "      解决: 先 550w-ai \"你好\""
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-memory()"
    print ""
    _550w_help_pause
}
# ══════════════════ 命令索引 · 菜单入口 ══════════════════

_550w_help_cmd_menu_menu() {
    while true; do
        _550w_help_head "菜单入口命令" "8 个"
        print ""
        _550w_help_row "1" "550w-help"            "使用手册(本手册)"
        _550w_help_row "2" "550w-settings"        "设置中心"
        _550w_help_row "3" "550w-plugin"          "插件系统"
        _550w_help_row "4" "550w-anim"            "动画引擎"
        _550w_help_row "5" "550w-real"            "真实系统数据"
        _550w_help_row "6" "550w-extras"          "外围工具"
        _550w_help_row "7" "550w-new"             "新加功能"
        _550w_help_row "8" "550w-boot-anim-list"  "开机动画列表"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_show_help ;;
            2) _550w_help_show_settings ;;
            3) _550w_help_show_plugin ;;
            4) _550w_help_show_anim ;;
            5) _550w_help_show_real ;;
            6) _550w_help_show_extras ;;
            7) _550w_help_show_new ;;
            8) _550w_help_show_boot_anim ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 550w-help ══════════════════

_550w_help_show_help() {
    _550w_help_head "命令详情" "550w-help"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-help ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开 550W 使用手册(本手册)。"
    print "    10 大章 · 60 命令 · 20 教程 · 50 FAQ"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-help"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-help"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    显示主菜单, 可以进 10 个子页:"
    print "      [1] 快速上手"
    print "      [2] 命令索引"
    print "      [3] 分步教程"
    print "      [4] 应用场景"
    print "      [5] 插件专章"
    print "      [6] 动画专章"
    print "      [7] 开机专章"
    print "      [8] 开发者指南"
    print "      [9] FAQ"
    print "      [10] 关于"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-plugin-help   插件帮助(命令速查)"
    print "    550w-extras → 11   FAQ/术语/更新"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    help.zsh → 550w-help()"
    print ""
    _550w_help_pause
}

# ══════════════════ 2. 550w-settings ══════════════════

_550w_help_show_settings() {
    _550w_help_head "命令详情" "550w-settings"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-settings ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开设置中心。"
    print "    13 大类 110 项, 几乎所有可调项都在这里。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口 / 设置"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-settings"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-settings"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    主菜单 14 项, 分 4 个区:"
    print "      界面外观: 1 外观 / 2 提示符 / 3 主题"
    print "      身份安全: 4 认证 / 5 档案"
    print "      AI 扩展:  6 MOSS / 7 插件 / 8 开机动画"
    print "      数据维护: 9 备份 / 10 日志 / 11 数据 / 12 高级"
    print "      其它:     13 总览 / 14 关于"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-status    查看状态"
    print "    550w-help      本手册"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    settings.zsh → 550w-settings()"
    print ""
    _550w_help_pause
}

# ══════════════════ 3. 550w-plugin ══════════════════

_550w_help_show_plugin() {
    _550w_help_head "命令详情" "550w-plugin"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-plugin ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开插件系统主菜单。"
    print "    16 项: 列出/详情/错误/钩子/日志/配置/创建/编辑/启用/禁用/"
    print "          删除/重载/打包/安装/帮助"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口 / 插件"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-plugin"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-plugin"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    插件系统主菜单, 见本手册'插件专章'"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-plugin-new [名]      创建"
    print "    550w-plugin-info [名]     详情"
    print "    550w-plugins              简表"
    print "    550w-plugin-help          命令速查"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-plugin()"
    print ""
    _550w_help_pause
}

# ══════════════════ 4. 550w-anim ══════════════════

_550w_help_show_anim() {
    _550w_help_head "命令详情" "550w-anim"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-anim ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开动画引擎主菜单。"
    print "    234 个动画函数, 分 14 项菜单。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口 / 动画"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-anim"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-anim"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    14 项菜单:"
    print "      [1] 基础动画      [8]  编解码"
    print "      [2] 强调动效      [9]  密码学"
    print "      [3] 故障风        [10] 神经网络"
    print "      [4] 进度旋转      [11] 机器学习"
    print "      [5] 波形频谱      [12] 列出全部"
    print "      [6] 图表可视化    [13] 演示"
    print "      [7] 拓扑网络      [14] 开机动画"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-anim → 14   开机动画管理"
    print "    550w-help → 6    动画专章"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    anim.zsh → 550w-anim()"
    print ""
    _550w_help_pause
}

# ══════════════════ 5. 550w-real ══════════════════

_550w_help_show_real() {
    _550w_help_head "命令详情" "550w-real"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-real ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开真实系统数据读取。"
    print "    所有数据来自真实系统文件, 不是假的。"
    print "    (替代旧的 550w-scan)"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口 / 系统"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-real"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-real"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    9 项菜单:"
    print "      [1] 完整探测      [6] 磁盘"
    print "      [2] CPU           [7] 温度 top3"
    print "      [3] 温度          [8] 导出"
    print "      [4] 内存          [0] 返回"
    print "      [5] 系统"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。所有数据用系统文件读取。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-status    系统状态(550W 内部)"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    real.zsh → 550w-real()"
    print ""
    _550w_help_pause
}

# ══════════════════ 6. 550w-extras ══════════════════

_550w_help_show_extras() {
    _550w_help_head "命令详情" "550w-extras"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-extras ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开外围工具菜单。"
    print "    11 组: 快捷键/别名/会话/PS1/统计/备份/日志/插件/主题/数据/帮助"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-extras"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-extras"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    11 项菜单(部分与 550w-settings 重叠)"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-settings  首选(13 类统一)"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    extras.zsh → 550w-extras()"
    print ""
    _550w_help_pause
}

# ══════════════════ 7. 550w-new ══════════════════

_550w_help_show_new() {
    _550w_help_head "命令详情" "550w-new"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-new ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    打开新加功能菜单。"
    print "    54 项: 对话增强/提示词/模型对比/文本处理/代码/文件/"
    print "           生活工具/安全/开发工具"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-new"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-new"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    10 项菜单:"
    print "      [1]  对话增强   [6]  代码工具"
    print "      [2]  对话分析   [7]  文件阅读"
    print "      [3]  提示词库   [8]  生活工具"
    print "      [4]  模型对比   [9]  安全工具"
    print "      [5]  文本处理   [10] 开发工具"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-ai        AI 对话基础"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    new.zsh → 550w-new()"
    print ""
    _550w_help_pause
}

# ══════════════════ 8. 550w-boot-anim-list ══════════════════

_550w_help_show_boot_anim() {
    _550w_help_head "命令详情" "550w-boot-anim-list"
    print ""
    print -P "  %F{${_550W_C[bright]}}%B━━━ 550w-boot-anim-list ━━━%b%f"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【用途】%f"
    print "    列出当前所有的开机动画文件。"
    print "    显示每个文件的名称、第一条调用、大小。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【分类】%f"
    print "    菜单入口 / 开机动画"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【语法】%f"
    _550w_help_cmd "550w-boot-anim-list"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【参数】%f"
    print "    无参数。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【示例】%f"
    _550w_help_cmd "550w-boot-anim-list"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【返回】%f"
    print "    列出 ~/.550w/boot_anim/ 里所有 .zsh 文件:"
    print "      [ 1] 00_demo.zsh        _550w_anim_typing_v2"
    print "      [ 2] 99_user_01.zsh     _550w_anim_glitch_v3"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【依赖】%f"
    print "    无。"
    print ""

    print -P "  %F{${_550W_C[ok]}}%B【相关命令】%f"
    print "    550w-anim → 14        开机动画管理"
    print "    550w-settings → 8     图形化"
    print "    550w-boot-anim-new [名]    创建"
    print "    550w-boot-anim-remove [名] 删除"
    print ""

    print -P "  %F{${_550W_C[dim]}}【源码位置】%f"
    print "    core.zsh → 550w-boot-anim-list()"
    print ""
    _550w_help_pause
}
# ══════════════════ 命令索引 · 数据工具 ══════════════════

_550w_help_cmd_data_menu() {
    while true; do
        _550w_help_head "数据工具命令" "备份/日志/导入导出/插件/动画"
        print ""
        _550w_help_row "1" "备份类"   "550w-ex-backup-*"
        _550w_help_row "2" "日志类"   "550w-ex-log-*"
        _550w_help_row "3" "数据类"   "550w-ex-data-*"
        _550w_help_row "4" "插件类"   "550w-plugin-*"
        _550w_help_row "5" "开机动画" "550w-boot-anim-*"
        _550w_help_row "6" "设置中心" "550w-settings 13 大类"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_cmd_backup_list ;;
            2) _550w_help_cmd_log_list ;;
            3) _550w_help_cmd_data_list ;;
            4) _550w_help_cmd_plugin_list ;;
            5) _550w_help_cmd_bootanim_list ;;
            6) _550w_help_cmd_settings_list ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 备份类 ══════════════════

_550w_help_cmd_backup_list() {
    _550w_help_head "备份类命令" "8 个"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 直接用命令%f"
    printf '  %-30s %s\n' "550w-ex-bak-quick"    "立即备份(tar.gz)"
    printf '  %-30s %s\n' "550w-ex-bak-copy"     "不压缩备份(cp)"
    printf '  %-30s %s\n' "550w-ex-bak-encrypt"  "加密备份"
    printf '  %-30s %s\n' "550w-ex-bak-restore"  "从备份恢复"
    printf '  %-30s %s\n' "550w-ex-bak-list"     "列出备份"
    printf '  %-30s %s\n' "550w-ex-bak-clean"    "清理旧备份"
    printf '  %-30s %s\n' "550w-ex-bak-verify"   "校验备份"
    printf '  %-30s %s\n' "550w-ex-bak-auto"     "自动备份开关"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 或走菜单%f"
    print "    550w-settings → 9"
    print "    550w-extras → 6"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 日志类 ══════════════════

_550w_help_cmd_log_list() {
    _550w_help_head "日志类命令" "7 个"
    print ""
    printf '  %-30s %s\n' "550w-ex-log-today"   "查看今日"
    printf '  %-30s %s\n' "550w-ex-log-list"    "列出文件"
    printf '  %-30s %s\n' "550w-ex-log-search"  "搜索日志"
    printf '  %-30s %s\n' "550w-ex-log-clean"   "清理过期"
    printf '  %-30s %s\n' "550w-ex-log-rotate"  "轮转日志"
    printf '  %-30s %s\n' "550w-ex-log-clear"   "清空全部"
    printf '  %-30s %s\n' "550w-ex-log-export"  "导出日志"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 或走菜单%f"
    print "    550w-settings → 10"
    print "    550w-extras → 7"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 数据类 ══════════════════

_550w_help_cmd_data_list() {
    _550w_help_head "数据导入导出" "8 个"
    print ""
    printf '  %-30s %s\n' "550w-ex-data-export-all"      "导出全部"
    printf '  %-30s %s\n' "550w-ex-data-export-config"   "导出配置"
    printf '  %-30s %s\n' "550w-ex-data-export-profile"  "导出档案"
    printf '  %-30s %s\n' "550w-ex-data-export-memory"   "导出记忆"
    printf '  %-30s %s\n' "550w-ex-data-import-config"   "导入配置"
    printf '  %-30s %s\n' "550w-ex-data-import-profile"  "导入档案"
    printf '  %-30s %s\n' "550w-ex-data-import-memory"   "导入记忆"
    printf '  %-30s %s\n' "550w-ex-data-sync"            "跨设备同步"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 或走菜单%f"
    print "    550w-settings → 11"
    print "    550w-extras → 10"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 插件类 ══════════════════

_550w_help_cmd_plugin_list() {
    _550w_help_head "插件类命令" "15 个"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 查看%f"
    printf '  %-32s %s\n' "550w-plugins"           "列出全部"
    printf '  %-32s %s\n' "550w-plugin"            "主菜单"
    printf '  %-32s %s\n' "550w-plugin-info [名]"   "详情"
    printf '  %-32s %s\n' "550w-plugin-errors"     "错误清单"
    printf '  %-32s %s\n' "550w-plugin-hooks"      "钩子状态"
    printf '  %-32s %s\n' "550w-plugin-logs [名]"  "日志"
    printf '  %-32s %s\n' "550w-plugin-config [名]" "配置"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 操作%f"
    printf '  %-32s %s\n' "550w-plugin-new [名]"    "创建"
    printf '  %-32s %s\n' "550w-plugin-edit [名]"   "编辑"
    printf '  %-32s %s\n' "550w-plugin-remove [名]" "删除"
    printf '  %-32s %s\n' "550w-plugin-enable [名]" "启用"
    printf '  %-32s %s\n' "550w-plugin-disable [名]" "禁用"
    printf '  %-32s %s\n' "550w-plugin-reload [名]" "重载"
    printf '  %-32s %s\n' "550w-plugin-open [名]"   "打开目录"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B▸ 打包%f"
    printf '  %-32s %s\n' "550w-plugin-pack [名]"    "打包"
    printf '  %-32s %s\n' "550w-plugin-install <路径>" "安装"
    print ""
    print -P "  %F{${_550W_C[dim]}}详见'插件专章'(主菜单→5)%f"
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 开机动画类 ══════════════════

_550w_help_cmd_bootanim_list() {
    _550w_help_head "开机动画类命令" "6 个"
    print ""
    printf '  %-32s %s\n' "550w-boot-anim-list"     "列出所有"
    printf '  %-32s %s\n' "550w-boot-anim-new [名]"  "创建"
    printf '  %-32s %s\n' "550w-boot-anim-edit [名]" "编辑"
    printf '  %-32s %s\n' "550w-boot-anim-remove [名]" "删除"
    printf '  %-32s %s\n' "550w-boot-anim-help"     "帮助"
    printf '  %-32s %s\n' "550w-anim → 14"          "菜单管理"
    print ""
    print -P "  %F{${_550W_C[dim]}}目录: ~/.550w/boot_anim/%f"
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 设置中心概览 ══════════════════

_550w_help_cmd_settings_list() {
    _550w_help_head "设置中心" "13 大类 110 项"
    print ""
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "1"  "外观设置"     "速度/特效/颜色/字体/主题"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550w_C[cyan]}" "2"  "提示符"       "PS1 显示内容"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "3"  "主题管理"     "5 内置 + 自定义"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "4"  "认证"         "密码/超时/冷却"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "5"  "用户档案"     "用户名/等级/权限"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "6"  "MOSS 配置"    "Provider/模型/温度"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "7"  "插件管理"     "创建/编辑/删除"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "8"  "开机动画"     "加入/删除"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "9"  "备份"         "创建/恢复"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "10" "日志"         "查看/清理"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "11" "数据导入导出" "配置/档案/记忆"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "12" "高级设置"     "心跳/阈值/保留"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "13" "配置总览"     "所有当前值"
    printf '  \e[38;5;%sm[%2s]\e[0m %-20s %s\n' "${_550W_C[cyan]}" "14" "关于与重置"   "版本/恢复默认"
    print ""
    print -P "  %F{${_550W_C[dim]}}启动: 550w-settings%f"
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 全部命令一览 ══════════════════

_550w_help_cmd_all() {
    _550w_help_head "全部命令" "一屏列出"
    local fn n=0
    for fn in ${(k)functions}; do
        case "$fn" in
            550w-*)
                (( n++ ))
                printf '  \e[38;5;%sm[%3d]\e[0m %s\n' \
                    "${_550W_C[cyan]}" "$n" "$fn"
                ;;
        esac
    done
    print ""
    print -P "  %F{${_550W_C[ok]}}共 $n 个命令%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

# ══════════════════ 搜索命令 ══════════════════

_550w_help_cmd_search() {
    _550w_help_head "搜索命令"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}匹配: %f"
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
    (( found )) || print -P "  %F{${_550W_C[dim]}}（无匹配）%f"
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}
# ══════════════════ 分步教程 · 主菜单 ══════════════════

_550w_help_menu_tutorial() {
    while true; do
        _550w_help_head "分步教程" "20 步 · 从零到精通"
        print ""

        _550w_help_sub "入门(1~5)"
        _550w_help_row "1"  "第 01 步"   "第一次使用"
        _550w_help_row "2"  "第 02 步"   "改密码"
        _550w_help_row "3"  "第 03 步"   "配 AI 对话"
        _550w_help_row "4"  "第 04 步"   "AI 进阶"
        _550w_help_row "5"  "第 05 步"   "换主题"

        _550w_help_sub "进阶(6~10)"
        _550w_help_row "6"  "第 06 步"   "改提示符"
        _550w_help_row "7"  "第 07 步"   "用户档案"
        _550w_help_row "8"  "第 08 步"   "备份与恢复"
        _550w_help_row "9"  "第 09 步"   "日志查看"
        _550w_help_row "10" "第 10 步"   "数据迁移"

        _550w_help_sub "高级(11~15)"
        _550w_help_row "11" "第 11 步"   "快捷键"
        _550w_help_row "12" "第 12 步"   "性能优化"
        _550w_help_row "13" "第 13 步"   "插件入门"
        _550w_help_row "14" "第 14 步"   "写第一个插件"
        _550w_help_row "15" "第 15 步"   "插件进阶"

        _550w_help_sub "实战(16~20)"
        _550w_help_row "16" "第 16 步"   "插件实战(天气)"
        _550w_help_row "17" "第 17 步"   "开机动画"
        _550w_help_row "18" "第 18 步"   "自定义动画"
        _550w_help_row "19" "第 19 步"   "高级技巧"
        _550w_help_row "20" "第 20 步"   "排错大典"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_help_tut01 ;;
            2)  _550w_help_tut02 ;;
            3)  _550w_help_tut03 ;;
            4)  _550w_help_tut04 ;;
            5)  _550w_help_tut05 ;;
            6)  _550w_help_tut06 ;;
            7)  _550w_help_tut07 ;;
            8)  _550w_help_tut08 ;;
            9)  _550w_help_tut09 ;;
            10) _550w_help_tut10 ;;
            11) _550w_help_tut11 ;;
            12) _550w_help_tut12 ;;
            13) _550w_help_tut13 ;;
            14) _550w_help_tut14 ;;
            15) _550w_help_tut15 ;;
            16) _550w_help_tut16 ;;
            17) _550w_help_tut17 ;;
            18) _550w_help_tut18 ;;
            19) _550w_help_tut19 ;;
            20) _550w_help_tut20 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 第 01 步 · 第一次使用 ══════════════════

_550w_help_tut01() {
    _550w_help_head "第 01 步 · 第一次使用"
    _550w_help_goal "从打开 Termux 到敲出第一条命令, 全程 1 分钟"
    _550w_help_pre "已装 Termux; 已装好 550W"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    _550w_help_step "1" "打开 Termux"
    print "  桌面点 Termux 图标。"
    print "  你会立刻看到一串动画:"
    print "    ① 黑屏脉冲(中心 ● 呼吸)"
    print "    ② 矩阵雨(绿色字符下落)"
    print "    ③ 警告框(⚠ 未授权访问)"
    print "    ④ BIOS POST(12 项自检)"
    print "    ⑤ 硬件深扫(CPU/内存/GPU)"
    print "    ⑥ 端口扫描 + 撕裂"
    print "    ⑦ 网络嗅探 + 加密握手"
    print "    ⑧ 内核自检(20 项)"
    print "    ⑨ AI 引擎自检 + 评分"
    print "    ⑩ SID 字符解密"
    print "    ⑪ 密码框弹出"
    _550w_help_tip "不想看完按任意键跳过; 想退出按 q"

    _550w_help_step "2" "输密码"
    print "  密码框出现后输入:"
    _550w_help_cmd "563214789"
    _550w_help_note "这是默认密码。第一次进来后建议改(见第 02 步)"

    _550w_help_step "3" "看欢迎画"
    print "  密码正确后会显示欢迎画:"
    print "    · 6 行渐变'550W'大字"
    print "    · 操作员档案"
    print "    · 系统状态"
    print "    · 签名"
    print "  按回车进入终端。"

    _550w_help_step "4" "看到提示符"
    print "  最终显示的提示符:"
    print -P "  %F{${_550W_C[ok]}}550W_computer_Earth Engine ● 19:30:45 root@Max-System:~#%f"
    print "  这就是你可以敲命令的地方。"

    _550w_help_step "5" "敲第一条命令"
    print "  试试最简单的:"
    _550w_help_cmd "550w-status"
    _550w_help_expect "打印一大段系统状态信息" "出现版本/会话/MOSS 等字段"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你已经会进入系统了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 02 步 · 改密码"
    _550w_help_pause
}

# ══════════════════ 第 02 步 · 改密码 ══════════════════

_550w_help_tut02() {
    _550w_help_head "第 02 步 · 改密码"
    _550w_help_goal "把默认密码改成自己的, 并知道忘了怎么办"
    _550w_help_pre "已能进系统"
    _550w_help_cost "2 分钟" "★☆☆☆☆"

    _550w_help_step "1" "认识密码文件"
    print "  密码存在这里:"
    print -P "  %F{${_550W_C[dim]}}$_550W_PASS_FILE%f"
    print "  权限 600(仅自己可读)。"
    print "  密码明文存储 —— 方便你查看, 但别分享这个文件。"

    _550w_help_step "2" "改密码(推荐方式)"
    _550w_help_cmd "550w-settings → 4 → 1"
    print "  按提示输入两次。"
    _550w_help_expect "两次一致 → '密码已更新'" "两次不一致 → '两次输入不一致'"
    print "  最小长度默认 4 位, 可在 4 → 3 里改。"

    _550w_help_step "3" "改密码(命令行方式)"
    _550w_help_cmd 'echo "我的新密码" > ~/.550w/.550w_pass'
    _550w_help_cmd "chmod 600 ~/.550w/.550w_pass"
    _550w_help_note "这种方式不会校验长度和强度"

    _550w_help_step "4" "忘了密码怎么办"
    print "  方式 A(推荐): 设置中心重置"
    _550w_help_cmd "550w-settings → 4 → 2"
    _550w_help_expect "密码重置为 563214789"
    print ""
    print "  方式 B: 命令行"
    _550w_help_cmd 'echo "563214789" > ~/.550w/.550w_pass'
    print ""

    _550w_help_step "5" "调节安全参数"
    print "  4 → 4 ~ 4 → 9 可以改:"
    print "    · 最小长度      (默认 4)"
    print "    · 掩码长度      (显示多少 ●)"
    print "    · 最大尝试      (几次失败锁定)"
    print "    · 冷却触发次数  (累计失败几次冷却)"
    print "    · 冷却秒数      (冷却时长)"
    print "    · 输入超时      (等密码几秒)"
    print "    · 空闲锁定      (无操作多久自动锁定)"

    _550w_help_step "6" "密码强度"
    print "  密码框实时显示强度:"
    printf '  \e[38;5;%s m%-8s\e[0m %s\n' "196" "弱" "长度 < 4"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "220" "中" "长度 4~7"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "46" "强" "长度 8~11"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "51" "极强" "长度 ≥ 12"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你会管理密码了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 03 步 · 配 AI 对话"
    _550w_help_pause
}

# ══════════════════ 第 03 步 · 配 AI 对话 ══════════════════

_550w_help_tut03() {
    _550w_help_head "第 03 步 · 配 AI 对话"
    _550w_help_goal "5 分钟内让 AI 回复你第一条消息"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "拿智谱 API Key"
    print "  550W 出厂用智谱 GLM 作为 AI 引擎。"
    print ""
    print "  a) 浏览器打开: https://open.bigmodel.cn"
    print "  b) 右上角'注册/登录'(手机号)"
    print "  c) 完成实名认证(个人认证, 1 分钟)"
    print "  d) 左侧菜单 → API Keys"
    print "  e) 新建 API Key, 复制"
    print ""
    print "  密钥形如:"
    print -P "  %F{${_550W_C[dim]}}aec8bdf745584ab2a8e060155a4.XXXXXXXXXX%f"
    _550w_help_warn "API Key 只显示一次! 立刻保存"

    _550w_help_step "2" "配置 Key(方式 A)"
    print "  用设置界面:"
    _550w_help_cmd "550w-settings → 6 → 12"
    print "  按提示粘贴 Key。"
    print "  会问是否写入 ~/.zshrc(推荐选 y)。"

    _550w_help_step "3" "配置 Key(方式 B)"
    print "  手动:"
    _550w_help_cmd 'echo "export ZHIPU_API_KEY=\"你的Key\"" >> ~/.zshrc'
    _550w_help_cmd "source ~/.zshrc"

    _550w_help_step "4" "测试对话"
    _550w_help_cmd '550w-ai "你好"'
    _550w_help_expect "MOSS 回复一句话" "或者 '✗ 缺少 API Key'"
    print ""
    print "  如果失败, 检查:"
    print "    · Key 是否粘贴完整(无空格/换行)"
    print "    · 是否执行了 source ~/.zshrc"
    print "    · 智谱账号是否实名"
    print "    · 能否访问 open.bigmodel.cn"

    _550w_help_step "5" "多轮对话"
    _550w_help_cmd '550w-ai "我叫小明"'
    _550w_help_cmd '550w-ai "我叫什么"'
    _550w_help_expect "第二次回答'小明'"
    print "  上下文由记忆机制维持。"

    _550w_help_step "6" "切换到其它 Provider"
    print "  15 个 Provider, 常用的:"
    print "    glm          智谱(默认)"
    print "    deepseek     DeepSeek"
    print "    qwen         通义千问"
    print "    moonshot     月之暗面"
    print "    openai       GPT-4o-mini"
    print ""
    print "  切法:"
    _550w_help_cmd "550w-moss-set deepseek"
    print "  切换前要先 export DEEPSEEK_API_KEY"
    print ""
    print "  一键回智谱:"
    _550w_help_cmd "550w-glm"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你能和 AI 对话了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 04 步 · AI 进阶"
    _550w_help_pause
}
# ══════════════════ 第 04 步 · AI 进阶 ══════════════════

_550w_help_tut04() {
    _550w_help_head "第 04 步 · AI 进阶"
    _550w_help_goal "掌握上下文、记忆、导出、切换模型"
    _550w_help_pre "已完成第 03 步, AI 能对话"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "理解上下文窗口"
    print "  MOSS 记住最近 N 轮对话。"
    print "  默认 N=10 轮(20 条消息)。"
    print "  超过自动丢弃最旧的。"
    print ""
    print "  改法:"
    _550w_help_cmd "550w-settings → 6 → 7"
    print "  范围 1~50。"
    _550w_help_note "轮数越多, 每次消耗的 Token 越多, 成本越高"

    _550w_help_step "2" "持久化记忆"
    print "  关掉 Termux 下次打开还记得。"
    print "  记忆文件:"
    print -P "  %F{${_550W_C[dim]}}$_550W_MOSS_MEMORY_FILE%f"
    print ""
    print "  查看:"
    _550w_help_cmd "550w-memory show"
    print "  清空:"
    _550w_help_cmd "550w-memory clear"
    print "  改上限:"
    _550w_help_cmd "550w-memory max 100"

    _550w_help_step "3" "管道输入"
    print "  把文件内容喂给 AI:"
    _550w_help_cmd '550w-ai "$(cat file.txt)"'
    print "  或者:"
    _550w_help_cmd 'content=$(cat file.txt); 550w-ai "$content"'

    _550w_help_step "4" "切换模型"
    print "  想换 provider 时:"
    _550w_help_cmd "550w-moss-set"
    print "  会列出 15 个。"
    print ""
    print "  常用预设:"
    print "    glm          便宜快速"
    print "    glm-pro      更强"
    print "    deepseek     代码能力强"
    print "    qwen         中文好"
    print "    moonshot     长文本"
    print "    local        本地 Ollama"

    _550w_help_step "5" "导出对话"
    print "  方式 A: 用 550w-new"
    _550w_help_cmd "550w-new → 2 → 5     导出为 MD"
    _550w_help_cmd "550w-new → 2 → 6     导出为 JSON"
    print ""
    print "  方式 B: 直接看记忆文件"
    _550w_help_cmd 'cat ~/.550w/.550w_moss_memory'

    _550w_help_step "6" "调节生成参数"
    print "  6 → 5  温度(0.0 严谨 / 0.7 默认 / 1.5 发散)"
    print "  6 → 6  MaxTokens(单次最多生成多少)"
    print "  6 → 10 请求超时(网络慢时加长)"

    _550w_help_step "7" "对话增强功能"
    print "  550w-new 里有 54 项增强:"
    print "    · 对话分支/标签/搜索/收藏"
    print "    · 提示词库/变量/角色预设"
    print "    · 模型对比/多模型投票"
    print "    · 自动摘要/关键词/翻译"
    print "    · 代码高亮/公式渲染/图表"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  AI 用得溜了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 05 步 · 换主题"
    _550w_help_pause
}

# ══════════════════ 第 05 步 · 换主题 ══════════════════

_550w_help_tut05() {
    _550w_help_head "第 05 步 · 换主题"
    _550w_help_goal "掌握 5 套内置主题 + 自定义配色"
    _550w_help_pre "已能进系统"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "5 套内置主题"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "51"  "cyber"   "经典青蓝(默认)"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "214" "amber"   "琥珀暖色"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "45"  "ice"     "冰蓝冷色"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "34"  "moss"    "深绿"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "196" "crimson" "猩红"

    _550w_help_step "2" "切换主题"
    print "  命令行:"
    _550w_help_cmd "550w-theme ice"
    print "  或菜单:"
    _550w_help_cmd "550w-settings → 3"
    _550w_help_expect "'已切换: ice(下次启动生效)'"

    _550w_help_step "3" "预览配色"
    _550w_help_cmd "550w-settings → 3 → 8"
    print "  显示 8 个色块, 预览当前主题所有颜色。"

    _550w_help_step "4" "改主色调/强调色/背景色"
    _550w_help_cmd "550w-settings → 1 → 10/11/12"
    print "  进入选择色板, 12 种预设或输入色号 0~255。"

    _550w_help_step "5" "创建自定义主题"
    _550w_help_cmd "550w-settings → 3 → 6"
    print -n "  输入主题名: "
    print "  mytheme"
    print ""
    print "  生成文件:"
    print -P "  %F{${_550W_C[dim]}}~/.550w/themes/mytheme.theme%f"
    print "  然后编辑:"
    _550w_help_cmd "550w-settings → 3 → 7"

    _550w_help_step "6" "主题文件内容"
    print "  格式(key=色号):"
    print -P "  %F{${_550W_C[dim]}}_550W_C[cyan]=51%f"
    print -P "  %F{${_550W_C[dim]}}_550W_C[ok]=46%f"
    print -P "  %F{${_550W_C[dim]}}_550W_C[err]=196%f"
    print -P "  %F{${_550W_C[dim]}}...%f"
    print ""
    print "  改完 source ~/.zshrc 生效。"

    _550w_help_step "7" "导出/导入"
    _550w_help_cmd "550w-settings → 3 → 9    导出"
    _550w_help_cmd "550w-settings → 3 → 10   导入"
    print "  导出到 ~/.550w/backups/。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  界面颜色你说了算"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 06 步 · 改提示符"
    _550w_help_pause
}

# ══════════════════ 第 06 步 · 改提示符 ══════════════════

_550w_help_tut06() {
    _550w_help_head "第 06 步 · 改提示符"
    _550w_help_goal "自定义 shell 提示符"
    _550w_help_pre "已能进系统"
    _550w_help_cost "3 分钟" "★★☆☆☆"

    _550w_help_step "1" "认识当前提示符"
    print -P "  %F{${_550W_C[ok]}}550W_computer_Earth Engine ● 19:30:45 root@Max-System:~#%f"
    print ""
    print "  分解:"
    print "    550W_computer_Earth Engine   系统标识"
    print "    ●                            MOSS 健康圆点"
    print "    19:30:45                     时间"
    print "    root@Max-System             用户@主机"
    print "    ~#                           目录+提示"

    _550w_help_step "2" "开关显示内容"
    _550w_help_cmd "550w-settings → 2"
    print "  可调 4 个开关:"
    print "    · 显示 SID    会话 ID"
    print "    · 显示模式    capture/normal/locked"
    print "    · 显示 MOSS   健康圆点"
    print "    · 显示时间    HH:MM:SS"

    _550w_help_step "3" "样式模式"
    print "  full      完整(默认)"
    print "  minimal   简洁(只时间)"
    print "  plain     纯文本(无颜色)"
    _550w_help_cmd "550w-settings → 2 → 1"

    _550w_help_step "4" "应用 vs 重启"
    print "  在 550w-settings → 2 里:"
    print "    · 改任何开关 → 立即生效"
    print "    · 6 应用     → 手动重建 PS1"
    print "    · 8 恢复默认 → 回到 full"

    _550w_help_step "5" "MOSS 圆点含义"
    printf '  \e[38;5;%sm●\e[0m 在线(绿色)\n' "${_550W_C[ok]}"
    printf '  \e[38;5;%sm◐\e[0m 降级(黄色)\n' "${_550W_C[warn]}"
    printf '  \e[38;5;%sm○\e[0m 离线(红色)\n' "${_550W_C[err]}"
    print ""
    print "  想让圆点消失? 关掉'显示 MOSS'。"

    _550w_help_step "6" "完全自定义 PS1(高级)"
    print "  编辑 core.zsh 里的 _550w_build_ps1() 函数。"
    _550w_help_note "改错了可能 PS1 显示异常, 备份后再改"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  提示符你能改了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 07 步 · 用户档案"
    _550w_help_pause
}

# ══════════════════ 第 07 步 · 用户档案 ══════════════════

_550w_help_tut07() {
    _550w_help_head "第 07 步 · 用户档案"
    _550w_help_goal "改欢迎画里显示的个人信息"
    _550w_help_pre "已能进系统"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "认识档案字段"
    print "  7 个字段:"
    print "    · 用户名     默认 Trans"
    print "    · 等级       默认 高级授权"
    print "    · 权限       默认 全权"
    print "    · 签名       默认 550W · 永不为奴"
    print "    · 头像符号   默认空(1 字符)"
    print "    · 加入时间   自动记"
    print "    · 登录次数   自动累加"

    _550w_help_step "2" "在设置里改"
    _550w_help_cmd "550w-settings → 5"
    print "  进入后:"
    print "    [1] 改用户名"
    print "    [2] 改等级"
    print "    [3] 改权限"
    print "    [4] 改签名"
    print "    [5] 改头像符号"
    print "    [9] 完整查看"

    _550w_help_step "3" "改完什么时候生效"
    print "  保存后立即写入 $_550W_PROFILE_FILE"
    print "  显示位置下次刷新:"
    print "    · 欢迎画    下次登录"
    print "    · 密码框    下次登录"
    print "    · 授权方框  下次登录"
    print ""
    print "  想立刻看到:"
    _550w_help_cmd "550w-welcome"

    _550w_help_step "4" "手动编辑档案文件"
    print "  文件路径:"
    print -P "  %F{${_550W_C[dim]}}$_550W_PROFILE_FILE%f"
    print ""
    print "  格式:"
    print -P "  %F{${_550w_C[dim]}}USER_NAME=\"Trans\"%f"
    print -P "  %F{${_550W_C[dim]}}USER_LEVEL=\"高级授权\"%f"
    print -P "  %F{${_550W_C[dim]}}...%f"
    print ""
    print "  改完 source 或重新登录生效。"

    _550w_help_step "5" "导出/恢复默认"
    _550w_help_cmd "550w-settings → 5 → 10   导出"
    _550w_help_cmd "550w-settings → 5 → 11   恢复默认"

    _550w_help_step "6" "改头像符号"
    print "  支持任意 1 个字符, 例如:"
    print "    ★ ⚡ ◆ ✦ ♛ ☰ ⌘"
    _550w_help_cmd "550w-settings → 5 → 5"
    print "  会在欢迎画顶部显示。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  欢迎画可以个性化"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 08 步 · 备份与恢复"
    _550w_help_pause
}
# ══════════════════ 第 08 步 · 备份与恢复 ══════════════════

_550w_help_tut08() {
    _550w_help_head "第 08 步 · 备份与恢复"
    _550w_help_goal "学会备份你的 550W, 手残也能救回来"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "为什么要备份"
    print "  550W 的所有数据(密码/档案/配置/记忆/插件)都在:"
    print -P "  %F{${_550W_C[dim]}}~/.550w/%f"
    print ""
    print "  一旦:"
    print "    · 改配置改坏"
    print "    · 手滑删文件"
    print "    · 想换手机"
    print "    · 想试新功能但不确定"
    print "  备份能救你。"

    _550w_help_step "2" "立即备份(菜单)"
    _550w_help_cmd "550w-settings → 9 → 1"
    print "  会在 ~/.550w/backups/ 生成:"
    print -P "  %F{${_550W_C[dim]}}backup_20261007_143022.tar.gz%f"
    print ""
    _550w_help_expect "'✓ 已备份: backup_xxx.tar.gz (xxx K)'"

    _550w_help_step "3" "立即备份(命令行)"
    _550w_help_cmd "550w-ex-bak-quick"
    print "  等价的 tar 命令:"
    _550w_help_cmd 'tar -czf ~/.550w/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz -C ~ .550w'

    _550w_help_step "4" "不压缩备份"
    print "  如果你想直接看备份内容:"
    _550w_help_cmd "550w-settings → 9 → 2"
    print "  会生成一个目录(cp -r), 可以进目录翻文件。"

    _550w_help_step "5" "加密备份"
    print "  含敏感信息时:"
    _550w_help_cmd "550w-settings → 9 → 3"
    print "  输入密码, 生成 .tar.gz.enc。"
    _550w_help_note "依赖 openssl。没装的话会存成普通 tar.gz"

    _550w_help_step "6" "从备份恢复"
    _550w_help_cmd "550w-settings → 9 → 4"
    print "  流程:"
    print "    ① 列出所有备份文件"
    print "    ② 你选一个"
    print "    ③ 先自动备份当前状态(防丢)"
    print "    ④ 覆盖恢复"
    _550w_help_warn "会覆盖 ~/.550w/ 全部内容"
    print ""
    print "  恢复后需重新加载:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"

    _550w_help_step "7" "清理旧备份"
    _550w_help_cmd "550w-settings → 9 → 6"
    print "  保留最新 N 个(默认 10), 其余删除。"
    print "  改 N: 550w-settings → 12 → 6"

    _550w_help_step "8" "自动备份"
    _550w_help_cmd "550w-settings → 9 → 8"
    print "  开启后每次登录自动备份。"
    print "  改保留数: 12 → 6"
    print "  改压缩:   12 → 7"

    _550w_help_step "9" "校验备份完整性"
    _550w_help_cmd "550w-settings → 9 → 7"
    print "  选一个 tar.gz, 会验证是否能解包。"
    _550w_help_expect "'✓ 校验通过' 或 '✗ 文件损坏'"

    _550w_help_step "10" "手动恢复(万一菜单坏了)"
    _550w_help_cmd 'cd ~; tar -xzf ~/.550w/backups/backup_xxx.tar.gz'
    print "  这会解出一个 .550w 目录。"
    print "  然后:"
    _550w_help_cmd 'mv ~/.550w ~/.550w.old && mv ~/.550w .550w'

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你会备份了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 09 步 · 日志查看"
    _550w_help_pause
}

# ══════════════════ 第 09 步 · 日志查看 ══════════════════

_550w_help_tut09() {
    _550w_help_head "第 09 步 · 日志查看"
    _550w_help_goal "出问题知道去哪看日志"
    _550w_help_pre "已能进系统"
    _550w_help_cost "4 分钟" "★★☆☆☆"

    _550w_help_step "1" "三种日志"
    print "  550W 有三类日志:"
    print ""
    print -P "  %F{${_550W_C[cyan]}}1) 命令日志%f"
    print "     路径: ~/.550w/logs/550w_YYYYMMDD.log"
    print "     内容: 每条命令的执行记录"
    print ""
    print -P "  %F{${_550W_C[cyan]}}2) 对话审计%f"
    print "     路径: ~/.550w/.550w_audit"
    print "     内容: 每次 AI 调用的 provider/model/耗时"
    print ""
    print -P "  %F{${_550W_C[cyan]}}3) 命令统计%f"
    print "     路径: ~/.550w/extras/stats.log"
    print "     内容: 命令调用次数/耗时排行"

    _550w_help_step "2" "查看今日日志"
    _550w_help_cmd "550w-settings → 10 → 1"
    print "  显示今天最后 60 条。"
    print ""
    print "  或直接:"
    _550w_help_cmd 'tail -30 ~/.550w/logs/550w_$(date +%Y%m%d).log'

    _550w_help_step "3" "搜索日志"
    _550w_help_cmd "550w-settings → 10 → 3"
    print "  输入关键词, 会搜索所有日志文件。"
    print "  显示: 文件名 + 匹配数 + 前 5 条"
    print ""
    print "  命令行:"
    _550w_help_cmd 'grep 关键词 ~/.550w/logs/*.log'

    _550w_help_step "4" "查看审计日志"
    _550w_help_cmd 'tail -20 ~/.550w/.550w_audit'
    print "  格式:"
    print -P "  %F{${_550W_C[dim]}}23:14:17 SID=MOSS-XXXX provider=glm model=glm-4-flash mode=cloud tokens=~15 elapsed=1234ms%f"
    print ""
    print "  字段: 时间/SID/provider/模型/模式/token数/耗时"

    _550w_help_step "5" "查看统计"
    _550w_help_cmd "550w-extras → 5 → 2"
    print "  显示调用次数 Top 20。"
    _550w_help_cmd "550w-extras → 5 → 3"
    print "  显示慢命令 Top 20。"

    _550w_help_step "6" "清理日志"
    print "  清理过期(超保留天数):"
    _550w_help_cmd "550w-settings → 10 → 4"
    print ""
    print "  清空全部:"
    _550w_help_cmd "550w-settings → 10 → 6"
    print ""
    print "  轮转(超大小切分):"
    _550w_help_cmd "550w-settings → 10 → 5"

    _550w_help_step "7" "改日志等级"
    _550w_help_cmd "550w-settings → 1 → 18"
    print "  1 = error    只错误"
    print "  2 = warn     警告+"
    print "  3 = info     信息+(默认)"
    print "  4 = debug    全部(调试用)"

    _550w_help_step "8" "导出日志"
    _550w_help_cmd "550w-settings → 10 → 7"
    print "  打包成 tar.gz 到 ~/.550w/backups/。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  日志你能看了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 10 步 · 数据迁移"
    _550w_help_pause
}

# ══════════════════ 第 10 步 · 数据迁移 ══════════════════

_550w_help_tut10() {
    _550w_help_head "第 10 步 · 数据迁移"
    _550w_help_goal "换手机 / 分享给朋友"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "迁移前先备份"
    _550w_help_cmd "550w-settings → 9 → 1"
    print "  保险起见。"

    _550w_help_step "2" "整机迁移(推荐)"
    print "  打包所有数据:"
    _550w_help_cmd "550w-settings → 11 → 1"
    print ""
    print "  生成:"
    print -P "  %F{${_550W_C[dim]}}~/.550w/backups/export_all_YYYYMMDD_HHMMSS.tar.gz%f"
    print ""
    print "  传到新手机:"
    print "    · 用蓝牙/USB/网盘"
    print "    · 或把它放到共享存储"
    print ""
    print "  新手机解包:"
    _550w_help_cmd 'cd ~; tar -xzf export_all_xxx.tar.gz'
    print "  会还原整个 .550w。"

    _550w_help_step "3" "只导配置"
    _550w_help_cmd "550w-settings → 11 → 2"
    print "  生成 config_xxx.cfg"
    print "  目标机器: 11 → 5 导入"

    _550w_help_step "4" "只导档案"
    _550w_help_cmd "550w-settings → 11 → 3"
    print "  生成 profile_xxx.cfg"
    print "  目标机器: 11 → 6 导入"

    _550w_help_step "5" "只导 AI 记忆"
    _550w_help_cmd "550w-settings → 11 → 4"
    print "  生成 memory_xxx.jsonl"
    print "  目标机器: 11 → 7 导入"
    print "  会在新机器恢复所有对话历史。"

    _550w_help_step "6" "生成同步包"
    _550w_help_cmd "550w-settings → 11 → 8"
    print "  包含: 配置 + 档案 + 记忆"
    print "  不含: 插件/主题/备份(文件太大)"
    print ""
    print "  适合'只想同步个人信息, 插件各机器自己装'。"

    _550w_help_step "7" "分享插件给别人"
    print "  打包插件:"
    _550w_help_cmd "550w-plugin-pack 插件名"
    print "  生成 ~/.550w/backups/插件名-版本-时间.tar.gz"
    print ""
    print "  对方安装:"
    _550w_help_cmd "550w-plugin-install /path/to/插件.tar.gz"

    _550w_help_step "8" "分享主题给别人"
    _550w_help_cmd "550w-settings → 3 → 9"
    print "  生成 theme_xxx.theme"
    print "  对方: 3 → 10 导入"

    _550w_help_step "9" "跨设备注意事项"
    print "  · 路径会变(用户名/家目录不同)"
    print "  · API Key 环境变量不会自动迁移"
    print "  · 需在新设备重新 export"
    print "  · 或写入 ~/.zshrc 一起带"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你会搬家了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 11 步 · 快捷键"
    _550w_help_pause
}

# ══════════════════ 第 11 步 · 快捷键 ══════════════════

_550w_help_tut11() {
    _550w_help_head "第 11 步 · 快捷键"
    _550w_help_goal "掌握 zsh/Termux 快捷键, 效率翻倍"
    _550w_help_pre "已能进系统"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "zsh 内建 Ctrl 组合键"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+A" "光标到行首"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+E" "光标到行尾"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+B" "光标左移一位"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+F" "光标右移一位"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+W" "删光标前一个词"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+U" "删光标到行首"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+K" "删光标到行尾"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+Y" "粘贴(配合 U/K)"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+L" "清屏"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+R" "反搜历史"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+C" "中断命令"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+D" "退出 shell"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+Z" "挂起后台"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+P" "上一条命令"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Ctrl+N" "下一条命令"

    _550w_help_step "2" "Tab 补全"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Tab" "命令/文件补全"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Tab Tab" "列出所有候选"
    print ""
    print "  例:"
    print "    输入 550w- 然后按 Tab"
    print "    会列出所有 550w-* 命令"

    _550w_help_step "3" "方向键"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "↑ / ↓" "上下翻历史"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "← / →" "光标左右"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550W_C[ok]}" "Home/End" "行首/行尾"

    _550w_help_step "4" "Termux 特有手势"
    print "  · 音量上键 + Q    → 显示/隐藏键盘"
    print "  · 音量上键 + K    → 打开/关闭额外按键"
    print "  · 长按屏幕        → 弹出菜单(粘贴/选择)"
    print "  · 双指缩放        → 调整字号"

    _550w_help_step "5" "550W 自定义键"
    print "  · 开机动画时按任意键  → 跳过"
    print "  · 开机动画时按 q      → 紧急退出"
    print "  · 密码框按 Ctrl+C     → 中止"
    print "  · 欢迎画按回车        → 进入终端"

    _550w_help_step "6" "Alt 组合键"
    print "  Termux 下 Alt 键不可靠, 已不绑定。"
    print "  想绑定? 需改 Termux 配置。"
    _550w_help_note "屏幕下方工具栏可自定义快捷键"

    _550w_help_step "7" "查看当前绑定"
    _550w_help_cmd "bindkey | head -40"
    print "  显示所有键绑定。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  效率翻倍"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 12 步 · 性能优化"
    _550w_help_pause
}
# ══════════════════ 第 12 步 · 性能优化 ══════════════════

_550w_help_tut12() {
    _550w_help_head "第 12 步 · 性能优化"
    _550w_help_goal "让 550W 跑得更快更省电"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "关特效"
    print "  最大提速方式。"
    _550w_help_cmd "550w-fx 0"
    print "  关掉: 矩阵雨/扫描线/撕裂/闪屏等"
    print "  重开:"
    _550w_help_cmd "550w-fx 1"

    _550w_help_step "2" "加速开机"
    _550w_help_cmd "550w-speed flash"
    print "  动画只播 30% 时长。"
    print ""
    print "  想要瞬间进系统:"
    _550w_help_cmd "550w-speed instant   # 兼容旧值, 等于 flash"

    _550w_help_step "3" "静默模式"
    _550w_help_cmd "550w-settings → 1 → 3"
    print "  选 silent 后几乎无动画。"
    _550w_help_note "开机依然会执行扫描, 但不播放视觉"

    _550w_help_step "4" "关心跳"
    print "  心跳每 60 秒打印一行状态。"
    print "  想更长间隔:"
    _550w_help_cmd "550w-settings → 12 → 1"
    print "  范围 10~3600 秒。"

    _550w_help_step "5" "关统计"
    _550w_help_cmd "550w-settings → 12 → 3"
    print "  选 0 后不再记录命令调用。"
    print "  可省一点 IO。"

    _550w_help_step "6" "清理日志"
    _550w_help_cmd "550w-settings → 10 → 4"
    print "  清理过期日志, 释放空间。"
    print "  改保留天数: 12 → 5"

    _550w_help_step "7" "清理备份"
    _550w_help_cmd "550w-settings → 9 → 6"
    print "  超保留数的删除。"
    print "  改保留数: 12 → 6"

    _550w_help_step "8" "清理旧会话"
    _550w_help_cmd "550w-extras → 3 → 4"
    print "  删除不用的会话记录。"

    _550w_help_step "9" "MOSS 加速"
    print "  · 温度降到 0.3(更快收敛)"
    print "  · MaxTokens 降到 512(单次更短)"
    print "  · 上下文窗口降到 5 轮"
    print "  · 换 groq(极快) 或 qwen-turbo(便宜快)"
    print ""
    _550w_help_cmd "550w-settings → 6 → 5/6/7"

    _550w_help_step "10" "整体速度对比"
    print "  全默认(特效+slow):     开机 15 秒"
    print "  关特效(normal):          开机 8 秒"
    print "  关特效+fast:             开机 5 秒"
    print "  关特效+flash:            开机 3 秒"
    print "  silent+instant:          开机 1 秒"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  跑得快了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 13 步 · 插件入门"
    _550w_help_pause
}

# ══════════════════ 第 13 步 · 插件入门 ══════════════════

_550w_help_tut13() {
    _550w_help_head "第 13 步 · 插件入门"
    _550w_help_goal "装/看/启/禁/删插件"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "什么是插件"
    print "  插件 = 一个文件夹, 里面装你的自定义功能。"
    print ""
    print "  目录:"
    print -P "  %F{${_550W_C[dim]}}~/.550w/扩展/%f"
    print ""
    print "  结构:"
    print "    扩展/"
    print "    ├── weather/        插件1"
    print "    │   ├── main.zsh    入口(必须有)"
    print "    │   ├── config.zsh  配置(可选)"
    print "    │   └── log/        日志(自动建)"
    print "    └── tools/          插件2"
    print "        └── main.zsh"

    _550w_help_step "2" "列出插件"
    _550w_help_cmd "550w-plugins"
    print "  显示: 状态 名称 版本 作者 说明"
    print ""
    print "  ● 已加载   ○ 未加载   ✗ 已禁用"

    _550w_help_step "3" "打开插件菜单"
    _550w_help_cmd "550w-plugin"
    print "  16 项菜单, 所有操作入口。"

    _550w_help_step "4" "创建插件"
    _550w_help_cmd "550w-plugin-new hello"
    print "  会生成:"
    print "    ~/.550w/扩展/hello/"
    print "    ├── main.zsh"
    print "    ├── config.zsh"
    print "    └── README.md"
    print ""
    print "  main.zsh 里自带一个 550w-hello 函数。"

    _550w_help_step "5" "加载插件"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print "  加载后测试:"
    _550w_help_cmd "550w-hello"
    _550w_help_expect "'Hello from plugin'"

    _550w_help_step "6" "查看详情"
    _550w_help_cmd "550w-plugin-info hello"
    print "  显示: 名称/版本/作者/说明/目录/依赖/钩子/文件/函数"

    _550w_help_step "7" "编辑插件"
    _550w_help_cmd "550w-plugin-edit hello"
    print "  选 1(main.zsh) 或 2(config.zsh) 或 3(其他)"

    _550w_help_step "8" "重载插件(不重启 shell)"
    _550w_help_cmd "550w-plugin-reload hello"
    print "  单个重载。"
    print "  全部重载:"
    _550w_help_cmd "550w-plugin-reload"

    _550w_help_step "9" "禁用插件"
    _550w_help_cmd "550w-plugin-disable hello"
    print "  会创建 .disabled 标记文件。"
    print "  下次 source 时不再加载。"

    _550w_help_step "10" "启用插件"
    _550w_help_cmd "550w-plugin-enable hello"
    print "  删除 .disabled。"

    _550w_help_step "11" "删除插件"
    _550w_help_cmd "550w-plugin-remove hello"
    print "  会问确认, 然后整个文件夹删除。"
    _550w_help_warn "删了就找不回, 除非有备份"

    _550w_help_step "12" "查看错误"
    _550w_help_cmd "550w-plugin-errors"
    print "  列出加载失败的插件 + 原因。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  插件基础会了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 14 步 · 写第一个插件"
    _550w_help_pause
}

# ══════════════════ 第 14 步 · 写第一个插件 ══════════════════

_550w_help_tut14() {
    _550w_help_head "第 14 步 · 写第一个插件"
    _550w_help_goal "从零写一个 hello 插件, 20 行"
    _550w_help_pre "完成第 13 步"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "创建骨架"
    _550w_help_cmd "550w-plugin-new hello"
    print "  生成 3 个文件。"

    _550w_help_step "2" "编辑 main.zsh"
    _550w_help_cmd "nano ~/.550w/扩展/hello/main.zsh"
    print ""
    print "  改成这样:"
    print -P "  %F{${_550W_C[dim]}}# 我的第一个插件%f"
    print -P "  %F{${_550W_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550W_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550W_C[dim]}}# @desc: 打个招呼%f"
    print -P "  %F{${_550W_C[dim]}}%f"
    print -P "  %F{${_550W_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550W_C[dim]}}    print \"Hello, \$1!\"%f"
    print -P "  %F{${_550W_C[dim]}}}%f"

    _550w_help_step "3" "理解每行"
    print "  # @version: 1.0.0   版本号"
    print "  # @author: Trans    作者"
    print "  # @desc: xxx        一句话说明"
    print "  550w-hello() { }    函数定义"
    print "  \$1                  第一个参数"

    _550w_help_step "4" "保存并重载"
    print "  nano 保存: Ctrl+O 回车 Ctrl+X"
    print ""
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_expect "'✓ 已重载: hello'"

    _550w_help_step "5" "测试"
    _550w_help_cmd "550w-hello 世界"
    _550w_help_expect "Hello, 世界!"

    _550w_help_step "6" "加第二个函数"
    print "  继续编辑 main.zsh, 加:"
    print -P "  %F{${_550W_C[dim]}}550w-bye() {%f"
    print -P "  %F{${_550W_C[dim]}}    print \"Bye, \$1\"%f"
    print -P "  %F{${_550W_C[dim]}}}%f"
    print ""
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_cmd "550w-bye 张三"
    _550w_help_expect "Bye, 张三"

    _550w_help_step "7" "用配置文件"
    print "  编辑 config.zsh:"
    print -P "  %F{${_550W_C[dim]}}typeset -g HELLO_GREETING=\"你好\"%f"
    print ""
    print "  修改 main.zsh 的 hello 函数:"
    print -P "  %F{${_550W_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550W_C[dim]}}    print \"\$HELLO_GREETING, \$1!\"%f"
    print -P "  %F{${_550W_C[dim]}}}%f"
    print ""
    print "  注意 main.zsh 顶部要 source config.zsh:"
    print -P "  %F{${_550W_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"

    _550w_help_step "8" "用日志 API"
    print "  在函数里写日志:"
    print -P "  %F{${_550W_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550W_C[dim]}}    _plugin_log info \"hello 被调用: \$1\"%f"
    print -P "  %F{${_550W_C[dim]}}    print \"Hello, \$1!\"%f"
    print -P "  %F{${_550W_C[dim]}}}%f"
    print ""
    print "  查看日志:"
    _550w_help_cmd "550w-plugin-logs hello"

    _550w_help_step "9" "用配置 API"
    print "  读写插件配置:"
    print -P "  %F{${_550W_C[dim]}}_plugin_config_set mykey \"myvalue\"%f"
    print -P "  %F{${_550W_C[dim]}}local v=\$(_plugin_config_get mykey \"默认值\")%f"
    print -P "  %F{${_550W_C[dim]}}print \"配置: \$v\"%f"
    print ""
    print "  配置文件位置:"
    print -P "  %F{${_550W_C[dim]}}~/.550w/扩展/hello/config/config%f"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你会写插件了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 15 步 · 插件进阶"
    _550w_help_pause
}

# ══════════════════ 第 15 步 · 插件进阶 ══════════════════

_550w_help_tut15() {
    _550w_help_head "第 15 步 · 插件进阶"
    _550w_help_goal "元数据 / 依赖 / 钩子 / 打包"
    _550w_help_pre "完成第 14 步"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "完整元数据"
    print "  main.zsh 顶部注释:"
    print -P "  %F{${_550W_C[dim]}}# @name: 显示名%f"
    print -P "  %F{${_550W_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550W_C[dim]}}# @author: 作者%f"
    print -P "  %F{${_550W_C[dim]}}# @desc: 一句话说明%f"
    print -P "  %F{${_550W_C[dim]}}# @requires: curl jq%f"
    print -P "  %F{${_550W_C[dim]}}# @depends: 其它插件%f"
    print -P "  %F{${_550W_C[dim]}}# @hook: login precmd%f"

    _550w_help_step "2" "命令依赖"
    print "  # @requires: curl jq"
    print "  加载时检查 curl/jq 是否已装。"
    print "  缺 → 跳过加载 + 警告。"

    _550w_help_step "3" "插件依赖"
    print "  # @depends: tools net"
    print "  加载前先加载 tools 和 net 插件。"
    print "  缺 → 跳过 + 警告。"
    _550w_help_note "不要写循环依赖(A→B→A)"

    _550w_help_step "4" "钩子机制"
    print "  钩子类型:"
    print "    precmd    每条命令前"
    print "    preexec   每条命令后"
    print "    chpwd     切换目录"
    print "    login     登录后"
    print "    logout    退出时"
    print ""
    print "  注册方式: main.zsh 顶部写 # @hook: login"
    print "  然后定义函数:"
    print -P "  %F{${_550W_C[dim]}}_550w_plugin_hook_你的插件名_login() {%f"
    print -P "  %F{${_550W_C[dim]}}    _plugin_log info \"登录了\"%f"
    print -P "  %F{${_550W_C[dim]}}}%f"

    _550w_help_step "5" "完整示例: welcome 插件"
    print -P "  %F{${_550W_C[dim]}}# @name: welcome%f"
    print -P "  %F{${_550W_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550W_C[dim]}}# @desc: 登录时打印欢迎语%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print -P "  %F{${_550W_C[dim]}}%f"
    print -P "  %F{${_550W_C[dim]}}_550w_plugin_hook_welcome_login() {%f"
    print -P "  %F{${_550W_C[dim]}}    print \"\"%f"
    print -P "  %F{${_550W_C[dim]}}    print \"👋 欢迎回来, \$_550W_USER_NAME\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"welcome 已执行\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "6" "打包分享"
    _550w_help_cmd "550w-plugin-pack welcome"
    print "  生成 tar.gz。"
    print "  对方:"
    _550w_help_cmd "550w-plugin-install /path/welcome-1.0.0-xxx.tar.gz"

    _550w_help_step "7" "调试插件"
    print "  ① 看错误:"
    _550w_help_cmd "550w-plugin-errors"
    print "  ② 看日志:"
    _550w_help_cmd "550w-plugin-logs 插件名"
    print "  ③ 语法检查:"
    _550w_help_cmd "zsh -n ~/.550w/扩展/插件名/main.zsh"
    print "  ④ 单插件重载:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print "  ⑤ 手动 source:"
    _550w_help_cmd "source ~/.550w/扩展/插件名/main.zsh"

    _550w_help_step "8" "最佳实践"
    print "  · 函数名以 550w- 开头, 避免冲突"
    print "  · 元数据写在顶部, 一行一个"
    print "  · 用 _plugin_log 记录关键动作"
    print "  · 用 _plugin_config_* 存取配置"
    print "  · 用 \$_550W_PLUGIN_SELF 引用自身目录"
    print "  · 不要 source core.zsh, 会自动加载"
    print "  · 测试完先 550w-plugin-reload 再分享"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  插件进阶会了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 16 步 · 插件实战(天气)"
    _550w_help_pause
}
# ══════════════════ 第 16 步 · 插件实战(天气) ══════════════════

_550w_help_tut16() {
    _550w_help_head "第 16 步 · 插件实战(天气)"
    _550w_help_goal "写一个真正能用的天气插件"
    _550w_help_pre "完成第 15 步"
    _550w_help_cost "10 分钟" "★★★☆☆"

    _550w_help_step "1" "思路"
    print "  调用 MOSS 让 AI 回答天气。"
    print "  依赖: curl(通过 _550w_moss_chat 内部调)"
    print "  不需要自己写 HTTP 请求。"

    _550w_help_step "2" "创建骨架"
    _550w_help_cmd "550w-plugin-new weather"

    _550w_help_step "3" "编辑 main.zsh"
    print "  改成这样:"
    print -P "  %F{${_550W_C[dim]}}# @name: weather%f"
    print -P "  %F{${_550W_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550W_C[dim]}}# @desc: 查询天气(AI)%f"
    print -P "  %F{${_550W_C[dim]}}# @requires: curl%f"
    print -P "  %F{${_550W_C[dim]}}%f"
    print -P "  %F{${_550W_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550W_C[dim]}}%f"
    print -P "  %F{${_550W_C[dim]}}550w-weather() {%f"
    print -P "  %F{${_550W_C[dim]}}    local city=\"\${1:-\$WEATHER_DEFAULT_CITY}\"%f"
    print -P "  %F{${_550W_C[dim]}}    _plugin_log info \"查询: \$city\"%f"
    print -P "  %F{${_550W_C[dim]}}    print \"🌤  查询 \$city 天气...\"%f"
    print -P "  %F{${_550W_C[dim]}}    _550w_moss_chat \"用一句话说 \$city 今天的天气\"%f"
    print -P "  %F{${_550W_C[dim]}}    if [[ -n \"\$_550W_MOSS_REPLY\" ]]; then%f"
    print -P "  %F{${_550W_C[dim]}}        print \"\$city: \$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550W_C[dim]}}    else%f"
    print -P "  %F{${_550W_C[dim]}}        print \"查询失败\"%f"
    print -P "  %F{${_550W_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550W_C[dim]}}%f"
    print -P "  %F{${_550W_C[dim]}}550w-weather-set() {%f"
    print -P "  %F{${_550W_C[dim]}}    _plugin_config_set DEFAULT_CITY \"\$1\"%f"
    print -P "  %F{${_550W_C[dim]}}    print \"默认城市: \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "4" "编辑 config.zsh"
    print "  内容:"
    print -P "  %F{${_550W_C[dim]}}typeset -g WEATHER_DEFAULT_CITY=\"北京\"%f"

    _550w_help_step "5" "重载测试"
    _550w_help_cmd "550w-plugin-reload weather"
    _550w_help_cmd "550w-weather"
    _550w_help_cmd "550w-weather 上海"
    _550w_help_cmd "550w-weather-set 广州"

    _550w_help_step "6" "查看日志"
    _550w_help_cmd "550w-plugin-logs weather"
    print "  每次调用都会被记录。"

    _550w_help_step "7" "打包分享"
    _550w_help_cmd "550w-plugin-pack weather"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你写了第一个真插件"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 17 步 · 开机动画"
    _550w_help_pause
}

# ══════════════════ 第 17 步 · 开机动画 ══════════════════

_550w_help_tut17() {
    _550w_help_head "第 17 步 · 开机动画"
    _550w_help_goal "从 234 个动画里挑几个加到开机流程"
    _550w_help_pre "已能进系统"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "机制说明"
    print "  开机流程 = 15 步 (core.zsh 里写死)"
    print "  在 第 4 步(拓扑+权重) 之后, 会跑"
    print -P "  %F{${_550W_C[dim]}}~/.550w/boot_anim/*.zsh 所有文件%f"
    print ""
    print "  按文件名排序, 一个文件一段动画。"

    _550w_help_step "2" "打开管理菜单"
    _550w_help_cmd "550w-anim → 14"
    print "  菜单 4 项:"
    print "    [1] 加入动画"
    print "    [2] 删除动画"
    print "    [3] 查看列表"
    print "    [4] 清空全部"

    _550w_help_step "3" "加入动画(菜单方式)"
    _550w_help_cmd "550w-anim → 14 → 1"
    print "  列出 62 个预设动画。"
    print "  每项: 描述 + 函数名。"
    print ""
    print "  比如选:"
    print "    20  波浪 v2       _550w_anim_wave_v2"
    print ""
    print "  会写到 ~/.550w/boot_anim/99_user_01.zsh"

    _550w_help_step "4" "删除动画"
    _550w_help_cmd "550w-anim → 14 → 2"
    print "  列出当前所有开机动画文件。"
    print "  选一个删除。"

    _550w_help_step "5" "手动添加(方式)"
    print "  直接建文件:"
    _550w_help_cmd "nano ~/.550w/boot_anim/01_hello.zsh"
    print ""
    print "  内容:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_typing_v2 \"BOOT\" 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_wave_v2 40%f"
    print ""
    print "  保存重启 Termux 生效。"

    _550w_help_step "6" "常用动画推荐"
    print "  快速(适合 fast 速度):"
    print "    _550w_anim_glitch_v3"
    print "    _550w_anim_snow"
    print "    _550w_anim_jitter"
    print ""
    print "  中等(仪式感):"
    print "    _550w_anim_wave_v2"
    print "    _550w_anim_ecg_v2"
    print "    _550w_anim_spinner_braille"
    print ""
    print "  长(展示用):"
    print "    _550w_anim_cnn"
    print "    _550w_anim_transformer"
    print "    _550w_anim_gradient_descent"

    _550w_help_step "7" "文件命名规则"
    print "  前缀数字越小越早播。"
    print "    00_xxx.zsh   最前"
    print "    99_xxx.zsh   最后"
    print ""
    print "  菜单加入的默认用 99_user_NN。"
    print "  想插到前面? 手动重命名。"

    _550w_help_step "8" "查看列表"
    _550w_help_cmd "550w-boot-anim-list"
    print "  或:"
    _550w_help_cmd "ls ~/.550w/boot_anim/"

    _550w_help_step "9" "清空全部"
    _550w_help_cmd "550w-anim → 14 → 4"
    print "  删掉所有开机动画文件。"
    print "  之后开机只播默认流程。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  开机动画你会加了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 18 步 · 自定义动画"
    _550w_help_pause
}
# ══════════════════ 第 18 步 · 自定义动画 ══════════════════

_550w_help_tut18() {
    _550w_help_head "第 18 步 · 自定义动画"
    _550w_help_goal "写自己的开机动画函数"
    _550w_help_pre "完成第 17 步"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "动画放哪"
    print "  选项 A: 加进 anim.zsh"
    print -P "  %F{${_550W_C[dim]}}~/.550w/anim.zsh 末尾追加%f"
    print ""
    print "  选项 B: 独立文件"
    print -P "  %F{${_550W_C[dim]}}~/.550w/anim_custom.zsh%f"
    print "  然后 core.zsh 加载器里加上它。"
    print ""
    print "  选项 A 更简单。"

    _550w_help_step "2" "最小动画函数"
    print "  追加到 anim.zsh 末尾:"
    print -P "  %F{${_550W_C[dim]}}_550w_anim_hello() {%f"
    print -P "  %F{${_550W_C[dim]}}    local text=\"\${1:-HELLO}\"%f"
    print -P "  %F{${_550W_C[dim]}}    local i%f"
    print -P "  %F{${_550W_C[dim]}}    for (( i=0; i<5; i++ )); do%f"
    print -P "  %F{${_550W_C[dim]}}        printf '\\r  \\e[38;5;46m%s\\e[0m' \"\$text\"%f"
    print -P "  %F{${_550W_C[dim]}}        _550w_pause 200%f"
    print -P "  %F{${_550W_C[dim]}}        printf '\\r\\e[K'%f"
    print -P "  %F{${_550W_C[dim]}}        _550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}        (( _550W_SKIP )) && break%f"
    print -P "  %F{${_550W_C[dim]}}    done%f"
    print -P "  %F{${_550W_C[dim]}}    printf '\\r  \\e[1m\\e[38;5;46m%s\\e[0m\\n' \"\$text\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "3" "用到的 API"
    print -P "  %F{${_550W_C[cyan]}}_550w_pause ms%f       暂停 ms 毫秒(可被跳过)"
    print -P "  %F{${_550W_C[cyan]}}_550W_SKIP%f          用户是否跳过(1=是)"
    print -P "  %F{${_550W_C[cyan]}}_550w_cls%f            清屏"
    print -P "  %F{${_550W_C[cyan]}}_550w_cur_hide/reset%f  隐藏/显示光标"
    print -P "  %F{${_550W_C[cyan]}}_550W_C[ok]%f          颜色码(46)"
    print ""
    print "  颜色码表:"
    printf '  \e[38;5;%s m%-14s\e[0m 绿色\n' "${_550W_C[ok]}" "[ok]"
    printf '  \e[38;5;%sm%-14s\e[0m 青色\n' "${_550W_C[cyan]}" "[cyan]"
    printf '  \e[38;5;%sm%-14s\e[0m 红色\n' "${_550W_C[err]}" "[err]"
    printf '  \e[38;5;%sm%-14s\e[0m 黄色\n' "${_550W_C[warn]}" "[warn]"
    printf '  \e[38;5;%sm%-14s\e[0m 暗灰\n' "${_550W_C[dim]}" "[dim]"

    _550w_help_step "4" "加载并测试"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    _550w_help_cmd "_550w_anim_hello \"测试\""

    _550w_help_step "5" "加到开机"
    print "  手动加:"
    _550w_help_cmd "nano ~/.550w/boot_anim/05_hello.zsh"
    print ""
    print "  内容:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_hello \"开机\"%f"

    _550w_help_step "6" "触发跳过机制"
    print "  循环里的标准写法:"
    print -P "  %F{${_550w_C[dim]}}for i in ...; do%f"
    print -P "  %F{${_550w_C[dim]}}    ... 动画帧 ...%f"
    print -P "  %F{${_550w_C[dim]}}    (( _550W_SKIP )) && break%f"
    print -P "  %F{${_550w_C[dim]}}done%f"
    print ""
    print "  用户按任意键 → _550W_SKIP=1 → 跳出循环"

    _550w_help_step "7" "运动感技巧"
    print "  · 用 \\r 回行首, 同位置刷新"
    print "  · 用 \\e[K 清当前行"
    print "  · 关键帧用 _550w_pause 控制节奏"
    print "  · 循环末尾必须检查 _550W_SKIP"

    _550w_help_step "8" "多色渐变示例"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_rainbow() {%f"
    print -P "  %F{${_550w_C[dim]}}    local -a colors=(196 214 220 46 51 45 135)%f"
    print -P "  %F{${_550w_C[dim]}}    local i j%f"
    print -P "  %F{${_550w_C[dim]}}    for (( i=1; i<=20; i++ )); do%f"
    print -P "  %F{${_550w_C[dim]}}        printf '\\r  '%f"
    print -P "  %F{${_550w_C[dim]}}        for (( j=1; j<=7; j++ )); do%f"
    print -P "  %F{${_550w_C[dim]}}            printf '\\e[38;5;%sm█' \"\${colors[\$j]}\"%f"
    print -P "  %F{${_550w_C[dim]}}        done%f"
    print -P "  %F{${_550w_C[dim]}}        printf '\\e[0m'%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_pause 100%f"
    print -P "  %F{${_550w_C[dim]}}        (( _550W_SKIP )) && break%f"
    print -P "  %F{${_550w_C[dim]}}    done%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你能写动画了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 19 步 · 高级技巧"
    _550w_help_pause
}

# ══════════════════ 第 19 步 · 高级技巧 ══════════════════

_550w_help_tut19() {
    _550w_help_head "第 19 步 · 高级技巧"
    _550w_help_goal "调试、变量查询、批量操作"
    _550w_help_pre "已完成前 18 步"
    _550w_help_cost "10 分钟" "★★★★☆"

    _550w_help_step "1" "查看所有变量"
    _550w_help_cmd "550w-settings → 13"
    print "  或者:"
    _550w_help_cmd "set | grep _550W_ | head -40"
    _550w_help_cmd "set | grep _550w_ | head -40"

    _550w_help_step "2" "查看所有函数"
    _550w_help_cmd "550w-help → 2 → 5"
    print "  或:"
    _550w_help_cmd "print -l _550w_* _550w-* 550w-* | sort -u"

    _550w_help_step "3" "搜索命令"
    _550w_help_cmd "550w-help → 2 → 6"
    print "  输入关键词如 'theme', 列出所有含它的函数。"

    _550w_help_step "4" "调试模式"
    print "  启动时输出所有 debug 日志:"
    _550w_help_cmd "export _550W_LOG_LEVEL=4"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    print "  恢复:"
    _550w_help_cmd "export _550W_LOG_LEVEL=3"

    _550w_help_step "5" "快速测试单文件语法"
    _550w_help_cmd "zsh -n ~/.550w/core.zsh"
    _550w_help_cmd "zsh -n ~/.550w/settings.zsh"
    print "  无输出 = 语法正确。"

    _550w_help_step "6" "定位语法错位置"
    print "  如果 zsh -n 报错:"
    _550w_help_cmd "zsh -n ~/.550w/xxx.zsh 2>&1 | head -3"
    print "  看报错行号, 用 sed 查看:"
    _550w_help_cmd "sed -n 'XXX,XXXp' ~/.550w/xxx.zsh"

    _550w_help_step "7" "批量调用 AI"
    print "  循环调多个 provider 对比:"
    print -P "  %F{${_550w_C[dim]}}for p in glm deepseek qwen; do%f"
    print -P "  %F{${_550w_C[dim]}}    echo \"==> \$p\"%f"
    print -P "  %F{${_550w_C[dim]}}    550w-moss-set \$p%f"
    print -P "  %F{${_550w_C[dim]}}    550w-ai \"1+1=?\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "8" "子 shell 里改全局变量"
    print "  错误示范:"
    print -P "  %F{${_550w_C[dim]}}result=\$(550w-ai \"hi\")%f"
    print "  这样 _550W_MOSS_REPLY 只在子 shell 里有值。"
    print ""
    print "  正确示范:"
    print -P "  %F{${_550w_C[dim]}}550w-ai \"hi\"%f"
    print -P "  %F{${_550w_C[dim]}}echo \"\$_550W_MOSS_REPLY\"%f"

    _550w_help_step "9" "查看当前环境"
    _550w_help_cmd "550w-status"
    _550w_help_cmd "550w-real → 1"
    _550w_help_cmd "env | grep -i 550w"

    _550w_help_step "10" "会话持久化"
    print "  存到文件:"
    _550w_help_cmd "550w-new → 1 → 1    保存会话"
    print "  加载:"
    _550w_help_cmd "550w-extras → 3 → 3"

    _550w_help_step "11" "自定义别名"
    _550w_help_cmd "550w-extras → 2 → 2"
    print "  添加别名, 例如:"
    print "    ll=ls -la"
    print "    g=git"
    print "    ai=550w-ai"

    _550w_help_step "12" "打开核心文件看源码"
    _550w_help_cmd "nano ~/.550w/core.zsh"
    print "  或只看某函数:"
    _550w_help_cmd "grep -n -A 10 '^550w-status' ~/.550w/core.zsh"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你进入高级用户"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 第 20 步 · 排错大典"
    _550w_help_pause
}
# ══════════════════ 第 20 步 · 排错大典 ══════════════════

_550w_help_tut20() {
    _550w_help_head "第 20 步 · 排错大典"
    _550w_help_goal "遇到任何问题都能自己搞定"
    _550w_help_pre "已能进系统"
    _550w_help_cost "参考随时查" "★★★☆☆"

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 1:开机无动画%f"
    print "  可能原因:"
    print "    1) core.zsh 未加载"
    print "    2) .zshrc source 行错"
    print "    3) core.zsh 语法错"
    print "  排查:"
    _550w_help_cmd "grep 550w ~/.zshrc"
    _550w_help_cmd "ls -la ~/.550w/core.zsh"
    _550w_help_cmd "zsh -n ~/.550w/core.zsh"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 2:命令找不到%f"
    print "  例: '550w-status: command not found'"
    print "  排查:"
    _550w_help_cmd "which 550w-status"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print "  还不行:"
    _550w_help_cmd "exec zsh"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 3:AI 不回复%f"
    print "  排查:"
    _550w_help_cmd "550w-moss"
    _550w_help_cmd "echo \$ZHIPU_API_KEY"
    _550w_help_cmd "550w-settings → 6 → 13"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 4:密码框卡死%f"
    print "  处理:"
    _550w_help_cmd "Ctrl+C"
    _550w_help_cmd "550w-reset"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 5:开机时键盘失灵%f"
    print "  处理: 关掉 Termux 重开。"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 6:屏幕乱码%f"
    print "  处理:"
    _550w_help_cmd "reset"
    print "  或关掉 Termux 重开。"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 7:主题不生效%f"
    print "  处理:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 8:扩展文件报语法错%f"
    print "  排查:"
    _550w_help_cmd "zsh -n ~/.550w/xxx.zsh"
    print "  看错误行号, 用 sed 定位:"
    _550w_help_cmd "sed -n 'XXX,XXXp' ~/.550w/xxx.zsh"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 9:开机动画过长%f"
    print "  处理:"
    _550w_help_cmd "550w-speed flash"
    _550w_help_cmd "550w-fx 0"
    print ""

    print -P "  %F{${_550w_C[cyan]}}%B▸ 症状 10:插件不加载%f"
    print "  排查:"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugins"
    _550w_help_cmd "ls ~/.550w/扩展/插件名/main.zsh"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 11:插件缺依赖%f"
    print "  输出: '缺命令: jq'"
    print "  处理:"
    _550w_help_cmd "pkg install jq"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 12:备份恢复失败%f"
    print "  排查:"
    _550w_help_cmd "ls -lah ~/.550w/backups/"
    _550w_help_cmd "550w-settings → 9 → 7   校验"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 13:磁盘空间满%f"
    print "  排查:"
    _550w_help_cmd "du -sh ~/.550w/*"
    print "  清理:"
    _550w_help_cmd "550w-settings → 9 → 6    清备份"
    _550w_help_cmd "550w-settings → 10 → 4   清日志"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 14:热重载不生效%f"
    print "  处理:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print "  或:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""

    print -P "  %F{${_550W_C[cyan]}}%B▸ 症状 15:彻底重置%f"
    print "  最后手段:"
    _550w_help_warn "会删掉所有数据"
    _550w_help_cmd "cp -r ~/.550w ~/.550w_backup_$(date +%Y%m%d)"
    _550w_help_cmd "rm -rf ~/.550w"
    _550w_help_cmd "source ~/.zshrc"
    print ""

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  20 步教程全部学完"
    print ""
    print -P "  %F{${_550W_C[cyan]}}继续深入:%f"
    print "    · 主菜单 → 5  插件专章(20 节)"
    print "    · 主菜单 → 8  开发者指南"
    print "    · 主菜单 → 9  FAQ"
    _550w_help_pause
}
# ══════════════════ 应用场景 · 主菜单 ══════════════════

_550w_help_menu_scenario() {
    while true; do
        _550w_help_head "应用场景" "15 个真实任务"
        print ""
        _550w_help_sub "AI 相关"
        _550w_help_row "1"  "场景 01"  "看代码/找 bug"
        _550w_help_row "2"  "场景 02"  "翻译一段话"
        _550w_help_row "3"  "场景 03"  "总结长文档"
        _550w_help_row "4"  "场景 04"  "帮我写个脚本"
        _550w_help_row "5"  "场景 05"  "批量对话对比"

        _550w_help_sub "数据相关"
        _550w_help_row "6"  "场景 06"  "备份到云盘"
        _550w_help_row "7"  "场景 07"  "换手机搬家"
        _550w_help_row "8"  "场景 08"  "分享给朋友"

        _550w_help_sub "日常"
        _550w_help_row "9"  "场景 09"  "定时提醒"
        _550w_help_row "10" "场景 10"  "记录灵感"

        _550w_help_sub "进阶"
        _550w_help_row "11" "场景 11"  "监控系统"
        _550w_help_row "12" "场景 12"  "美化终端"
        _550w_help_row "13" "场景 13"  "个性化启动"
        _550w_help_row "14" "场景 14"  "写插件"
        _550w_help_row "15" "场景 15"  "出故障排错"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-15]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_help_sc01 ;;
            2)  _550w_help_sc02 ;;
            3)  _550w_help_sc03 ;;
            4)  _550w_help_sc04 ;;
            5)  _550w_help_sc05 ;;
            6)  _550w_help_sc06 ;;
            7)  _550w_help_sc07 ;;
            8)  _550w_help_sc08 ;;
            9)  _550w_help_sc09 ;;
            10) _550w_help_sc10 ;;
            11) _550w_help_sc11 ;;
            12) _550w_help_sc12 ;;
            13) _550w_help_sc13 ;;
            14) _550w_help_sc14 ;;
            15) _550w_help_sc15 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 场景 01 · 看代码 ══════════════════

_550w_help_sc01() {
    _550w_help_head "场景 01 · 看代码找 bug"
    _550w_help_goal "让 AI 帮你分析一段代码"
    _550w_help_cost "2 分钟" "★☆☆☆☆"

    _550w_help_step "1" "准备代码"
    print "  假设你有文件 ~/my.py:"
    print -P "  %F{${_550W_C[dim]}}def add(a, b):%f"
    print -P "  %F{${_550w_C[dim]}}    return a + b%f"
    print ""

    _550w_help_step "2" "把代码喂给 AI"
    print "  方式 A: 直接粘贴"
    _550w_help_cmd '550w-ai "看下这段代码有没有bug: def add(a,b): return a+b"'
    print ""
    print "  方式 B: 从文件读"
    _550w_help_cmd '550w-ai "看下这段代码: $(cat ~/my.py)"'
    print ""

    _550w_help_step "3" "追问"
    print "  AI 会分析, 你可以继续问:"
    _550w_help_cmd '550w-ai "帮我优化一下"'
    _550w_help_cmd '550w-ai "加个类型提示"'
    _550w_help_cmd '550w-ai "写个单元测试"'

    _550w_help_step "4" "用新加功能(更专业)"
    _550w_help_cmd "550w-new → 6 → 1    代码高亮"
    _550w_help_cmd "550w-new → 6 → 3    图表生成"

    _550w_help_tip "复杂代码建议分段粘贴, 避免超长"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 02 · 翻译 ══════════════════

_550w_help_sc02() {
    _550w_help_head "场景 02 · 翻译一段话"
    _550w_help_goal "中英互译, 多种方式"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    _550w_help_step "1" "直接翻译"
    _550w_help_cmd '550w-ai "翻译成英文: 你好世界"'
    _550w_help_cmd '550w-ai "翻译成中文: Hello World"'

    _550w_help_step "2" "用专用翻译模式"
    _550w_help_cmd "550w-new → 5 → 3"
    print "  可选: 中译英 / 英译中 / 自动"

    _550w_help_step "3" "长文本翻译"
    print "  从文件读:"
    _550w_help_cmd '550w-ai "翻译成英文: $(cat file.txt)"'
    print ""
    print "  或分批:"
    print -P "  %F{${_550w_C[dim]}}head -50 file.txt > part1; 550w-ai \"翻译: \$(cat part1)\"%f"

    _550w_help_step "4" "保留格式"
    print "  要求 AI 保留 Markdown:"
    _550w_help_cmd '550w-ai "翻译下面内容, 保留 Markdown 格式: $(cat doc.md)"'

    _550w_help_tip "翻译长文本建议分成 500~1000 字一段, 效果更准"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 03 · 总结文档 ══════════════════

_550w_help_sc03() {
    _550w_help_head "场景 03 · 总结长文档"
    _550w_help_goal "把长文章压成几句话"
    _550w_help_cost "2 分钟" "★☆☆☆☆"

    _550w_help_step "1" "用摘要模式"
    _550w_help_cmd "550w-new → 5 → 1"
    print "  输入文本, 输出 100 字以内摘要。"

    _550w_help_step "2" "直接从文件读"
    _550w_help_cmd '550w-ai "总结: $(cat document.txt)"'
    _550w_help_cmd '550w-ai "用 3 句话总结: $(cat article.md)"'

    _550w_help_step "3" "指定角度"
    _550w_help_cmd '550w-ai "从技术角度总结: $(cat doc.txt)"'
    _550w_help_cmd '550w-ai "列出 5 个要点: $(cat doc.txt)"'
    _550w_help_cmd '550w-ai "提取关键词: $(cat doc.txt)"'

    _550w_help_step "4" "分批处理超长文档"
    print -P "  %F{${_550w_C[dim]}}split -l 100 long.txt part_%f"
    print -P "  %F{${_550w_C[dim]}}for f in part_*; do%f"
    print -P "  %F{${_550w_C[dim]}}    550w-ai \"总结: \$(cat \$f)\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_tip "把多个摘要再让 AI 汇总, 效果更好"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 04 · 写脚本 ══════════════════

_550w_help_sc04() {
    _550w_help_head "场景 04 · 帮我写个脚本"
    _550w_help_goal "把需求描述给 AI, 拿到可运行代码"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "描述需求"
    _550w_help_cmd '550w-ai "写个 bash 脚本: 列出当前目录下大于 1MB 的文件"'

    _550w_help_step "2" "收代码到文件"
    print "  方式 A: 手动复制(简单)"
    print "  AI 回复后, 手动复制到 ~/script.sh"
    print ""
    print "  方式 B: 直接重定向"
    _550w_help_cmd '550w-ai "写个脚本: 列出大文件" > ~/script.sh'
    _550w_help_note "会有解释文字混进去, 需手动清理"

    _550w_help_step "3" "让 AI 精炼"
    _550w_help_cmd '550w-ai "只输出代码, 不要解释: 列出大于1MB文件"'

    _550w_help_step "4" "测试脚本"
    _550w_help_cmd "chmod +x ~/script.sh"
    _550w_help_cmd "bash ~/script.sh"

    _550w_help_step "5" "让 AI 改进"
    _550w_help_cmd '550w-ai "让脚本支持参数: 目录路径"'

    _550w_help_tip "让 AI 加注释: '每行加中文注释'"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 05 · 批量对话 ══════════════════

_550w_help_sc05() {
    _550w_help_head "场景 05 · 批量对话对比"
    _550w_help_goal "同一问题问多个 AI, 对比结果"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "用内置多模型投票"
    _550w_help_cmd "550w-new → 4 → 2"
    print "  输入问题 + 3~5 个 provider, 自动并发问。"

    _550w_help_step "2" "手动循环对比"
    print -P "  %F{${_550w_C[dim]}}for p in glm deepseek qwen moonshot; do%f"
    print -P "  %F{${_550w_C[dim]}}    print \"===== \$p =====\"%f"
    print -P "  %F{${_550w_C[dim]}}    550w-moss-set \$p%f"
    print -P "  %F{${_550w_C[dim]}}    550w-ai \"解释一下量子纠缠\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "3" "对比结果保存"
    print -P "  %F{${_550w_C[dim]}}for p in glm deepseek qwen; do%f"
    print -P "  %F{${_550w_C[dim]}}    550w-moss-set \$p >/dev/null%f"
    print -P "  %F{${_550w_C[dim]}}    550w-ai \"问题\" >> compare.txt%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "4" "双模型对比"
    _550w_help_cmd "550w-new → 4 → 1"
    print "  输入两个 provider, 并排显示回复。"

    _550w_help_step "5" "评分记录"
    _550w_help_cmd "550w-new → 4 → 3"
    print "  对最近回复打 1~5 分, 记录到 scores.log。"

    _550w_help_tip "切 provider 前先 export 对应 API Key"

    _550w_help_divider
    _550w_help_pause
}
# ══════════════════ 场景 06 · 备份到云盘 ══════════════════

_550w_help_sc06() {
    _550w_help_head "场景 06 · 备份到云盘"
    _550w_help_goal "把 550W 数据存到网盘/云"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "生成备份"
    _550w_help_cmd "550w-settings → 9 → 1"
    print "  生成 ~/.550w/backups/backup_xxx.tar.gz"

    _550w_help_step "2" "知道备份在哪"
    _550w_help_cmd "ls -lah ~/.550w/backups/"
    print "  找到最新那个 .tar.gz。"

    _550w_help_step "3" "复制到共享存储"
    print "  Termux 家目录在 Android 里不直接可见, 需要先复制到共享存储:"
    _550w_help_cmd 'cp ~/.550w/backups/backup_xxx.tar.gz /storage/emulated/0/Download/'
    print ""
    print "  Termux 需要储存权限:"
    _550w_help_cmd "termux-setup-storage"

    _550w_help_step "4" "上传网盘"
    print "  用手机上的网盘 App(百度/阿里/夸克等):"
    print "    1) 打开网盘 App"
    print "    2) 上传 -> 选 /Download/backup_xxx.tar.gz"
    print "    3) 完成"

    _550w_help_step "5" "恢复时"
    print "  从网盘下载到 Download, 然后:"
    _550w_help_cmd 'cp /storage/emulated/0/Download/backup_xxx.tar.gz ~/'
    _550w_help_cmd 'cd ~; tar -xzf backup_xxx.tar.gz'
    print "  会解出 .550w 目录, 手动替换。"

    _550w_help_step "6" "自动备份到共享存储"
    print "  脚本示例, 加到 ~/.zshrc:"
    print -P "  %F{${_550w_C[dim]}}_550w_auto_backup() {%f"
    print -P "  %F{${_550w_C[dim]}}    local stamp=\$(date +%Y%m%d_%H%M%S)%f"
    print -P "  %F{${_550w_C[dim]}}    tar -czf /storage/emulated/0/Download/550w_\$stamp.tar.gz -C ~ .550w%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_tip "备份加密后上传更安全: 550w-settings → 9 → 3"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 07 · 换手机搬家 ══════════════════

_550w_help_sc07() {
    _550w_help_head "场景 07 · 换手机搬家"
    _550w_help_goal "完整迁移到新手机"
    _550w_help_cost "10 分钟" "★★★☆☆"

    _550w_help_step "1" "旧手机准备"
    print "  a) 确保 550W 能跑"
    print "  b) 生成导出包:"
    _550w_help_cmd "550w-settings → 11 → 1"
    print ""
    print "  生成:"
    print -P "  %F{${_550w_C[dim]}}~/.550w/backups/export_all_xxx.tar.gz%f"

    _550w_help_step "2" "旧手机传输"
    _550w_help_cmd 'cp ~/.550w/backups/export_all_xxx.tar.gz /storage/emulated/0/Download/'
    print "  用蓝牙/微信/QQ/网盘传到新手机。"

    _550w_help_step "3" "新手机装 Termux"
    print "  从 F-Droid 或 GitHub 装 Termux(别从 Google Play)。"
    print "  打开, 允许存储权限:"
    _550w_help_cmd "termux-setup-storage"

    _550w_help_step "4" "新手机装依赖"
    _550w_help_cmd "pkg update && pkg upgrade"
    _550w_help_cmd "pkg install zsh curl git nano"

    _550w_help_step "5" "把包放到新手机"
    print "  从 Download 复制到家目录:"
    _550w_help_cmd 'cp /storage/emulated/0/Download/export_all_xxx.tar.gz ~/'

    _550w_help_step "6" "解包"
    _550w_help_cmd "cd ~"
    _550w_help_cmd "tar -xzf export_all_xxx.tar.gz"
    print "  会解出 .550w 目录。"

    _550w_help_step "7" "配置 .zshrc"
    print "  新手机还没有 .zshrc。"
    _550w_help_cmd 'echo "source ~/.550w/core.zsh" >> ~/.zshrc'
    print ""
    print "  或者用安装脚本(如果有)。"

    _550w_help_step "8" "重新配置 API Key"
    print "  环境变量不会迁移, 需在新手机重设:"
    _550w_help_cmd 'echo "export ZHIPU_API_KEY=\"你的Key\"" >> ~/.zshrc'
    _550w_help_cmd "source ~/.zshrc"

    _550w_help_step "9" "验证"
    _550w_help_cmd "550w-status"
    _550w_help_cmd "550w-ai \"你好\""
    _550w_help_cmd "550w-plugins"

    _550w_help_step "10" "小坑提示"
    print "  · 路径会变(用户名/Android 版本不同)"
    print "  · 插件依赖需重装: pkg install ..."
    print "  · 主题文件自动带过去"
    print "  · 备份文件夹里的旧备份也会一起带"
    print "  · 想轻量迁移? 11 → 8 生成同步包"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 08 · 分享给朋友 ══════════════════

_550w_help_sc08() {
    _550w_help_head "场景 08 · 分享给朋友"
    _550w_help_goal "分享你写的插件/主题"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "打包插件"
    _550w_help_cmd "550w-plugin-pack 你的插件名"
    print "  生成:"
    print -P "  %F{${_550w_C[dim]}}~/.550w/backups/插件名-版本-时间.tar.gz%f"

    _550w_help_step "2" "传给朋友"
    _550w_help_cmd 'cp ~/.550w/backups/插件名-xxx.tar.gz /storage/emulated/0/Download/'
    print "  用微信/QQ/网盘发给他。"

    _550w_help_step "3" "朋友安装"
    print "  朋友收到后:"
    _550w_help_cmd 'cp /storage/emulated/0/Download/插件名-xxx.tar.gz ~/'
    _550w_help_cmd "550w-plugin-install ~/插件名-xxx.tar.gz"
    print "  自动解包到 ~/.550w/扩展/插件名/"

    _550w_help_step "4" "检查依赖"
    _550w_help_cmd "550w-plugin-info 插件名"
    print "  看'依赖'部分, 缺失的命令需 pkg install。"

    _550w_help_step "5" "分享主题"
    print "  导出:"
    _550w_help_cmd "550w-settings → 3 → 9"
    print ""
    print "  朋友导入:"
    _550w_help_cmd "550w-settings → 3 → 10"

    _550w_help_step "6" "分享开机动画"
    print "  把你 ~/.550w/boot_anim/ 里的 .zsh 文件发给朋友。"
    print "  朋友放到自己 ~/.550w/boot_anim/ 就行。"
    _550w_help_note "动画函数名必须一致(都从 anim.zsh 里调)"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 09 · 定时提醒 ══════════════════

_550w_help_sc09() {
    _550w_help_head "场景 09 · 定时提醒"
    _550w_help_goal "用 550w-new 里的生活工具"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "简单倒计时"
    _550w_help_cmd "550w-new → 8 → 1"
    print "  输入秒数, 屏幕上倒计时。"

    _550w_help_step "2" "定时提醒(后台)"
    _550w_help_cmd "550w-new → 8 → 2"
    print "  输入内容 + 分钟数。"
    print "  到时间终端会响铃(视觉)。"
    print "  不阻塞其它操作。"

    _550w_help_step "3" "番茄钟"
    _550w_help_cmd "550w-new → 8 → 3"
    print "  默认 25 分钟工作 + 5 分钟休息。"
    print "  可自定义时长。"

    _550w_help_step "4" "待办清单"
    _550w_help_cmd "550w-new → 8 → 4"
    print "  支持: 添加/完成/删除"
    print "  存到 ~/.550w/new/todo.txt"

    _550w_help_step "5" "快捷笔记"
    _550w_help_cmd "550w-new → 8 → 5"
    print "  新建/查看/编辑笔记"
    print "  存到 ~/.550w/new/notes/"

    _550w_help_step "6" "书签管理"
    _550w_help_cmd "550w-new → 8 → 6"
    print "  添加常用路径/命令, 快速访问。"

    _550w_help_step "7" "系统定时任务(高级)"
    print "  Termux 可以用 cron(需装 termux-services):"
    _550w_help_cmd "pkg install termux-services"
    _550w_help_cmd "sv-enable crond"
    print "  然后 crontab -e 编辑。"

    _550w_help_tip "推荐用 550w-new 的内置功能, 简单可靠"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 10 · 记录灵感 ══════════════════

_550w_help_sc10() {
    _550w_help_head "场景 10 · 记录灵感"
    _550w_help_goal "快捷记录想法, 用 AI 整理"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "新建笔记"
    _550w_help_cmd "550w-new → 8 → 5 → a"
    print "  输入标题和内容。"
    print "  存到 ~/.550w/new/notes/标题.txt"

    _550w_help_step "2" "快速记一行(不用菜单)"
    print -P "  %F{${_550w_C[dim]}}echo \"\$(date '+%F %T') 想法: xxx\" >> ~/ideas.txt%f"

    _550w_help_step "3" "用 AI 整理碎片灵感"
    print "  积累一堆想法后:"
    _550w_help_cmd '550w-ai "整理这些想法, 归类: $(cat ~/ideas.txt)"'

    _550w_help_step "4" "标签管理"
    print "  笔记文件里加 #标签:"
    print -P "  %F{${_550w_C[dim]}}今天想到一个点子 #tech #idea%f"
    print ""
    print "  搜索:"
    _550w_help_cmd "grep '#tech' ~/.550w/new/notes/*.txt"

    _550w_help_step "5" "让 AI 提炼"
    _550w_help_cmd '550w-ai "从这些笔记里提取 3 个行动项: $(cat ~/.550w/new/notes/*.txt)"'

    _550w_help_tip "笔记多了之后, 定期用 AI 总结"

    _550w_help_divider
    _550w_help_pause
}
# ══════════════════ 场景 11 · 监控系统 ══════════════════

_550w_help_sc11() {
    _550w_help_head "场景 11 · 监控系统"
    _550w_help_goal "用真实数据看手机状态"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "看 CPU/内存/温度"
    _550w_help_cmd "550w-real → 1"
    print "  显示:"
    print "    CPU 型号/核心/当前频率/最大频率/调度器"
    print "    传感器数/CPU 温度/最高温/平均温"
    print "    内存总量/可用/使用率"
    print "    磁盘总量/剩余/使用率"

    _550w_help_step "2" "只看 CPU"
    _550w_help_cmd "550w-real → 2"

    _550w_help_step "3" "只看温度"
    _550w_help_cmd "550w-real → 3"
    print "  92 个 thermal_zone, 显示最高/最低/平均。"

    _550w_help_step "4" "只看内存"
    _550w_help_cmd "550w-real → 4"
    print "  总量/可用/空闲/缓存/缓冲区/使用率。"

    _550w_help_step "5" "温度 Top 3"
    _550w_help_cmd "550w-real → 7"
    print "  显示最热的三个传感器。"

    _550w_help_step "6" "导出数据"
    _550w_help_cmd "550w-real → 8"
    print "  保存到 ~/.550w/backups/real_xxx.txt"

    _550w_help_step "7" "持续监控(手动)"
    print "  循环看 CPU 频率:"
    print -P "  %F{${_550w_C[dim]}}while true; do%f"
    print -P "  %F{${_550w_C[dim]}}    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq%f"
    print -P "  %F{${_550w_C[dim]}}    sleep 2%f"
    print -P "  %F{${_550w_C[dim]}}done%f"
    print ""
    print "  Ctrl+C 停止。"

    _550w_help_step "8" "对比命令统计"
    _550w_help_cmd "550w-extras → 5 → 2"
    print "  看哪个命令你用得最多。"

    _550w_help_tip "550w-real 数据都是真的, 不假"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 12 · 美化终端 ══════════════════

_550w_help_sc12() {
    _550w_help_head "场景 12 · 美化终端"
    _550w_help_goal "配色 + 提示符 + 特效"
    _550w_help_cost "5 分钟" "★☆☆☆☆"

    _550w_help_step "1" "换主题"
    _550w_help_cmd "550w-theme cyber"
    _550w_help_cmd "550w-theme ice"
    _550w_help_cmd "550w-settings → 3"

    _550w_help_step "2" "改主色调"
    _550w_help_cmd "550w-settings → 1 → 10"
    print "  12 个预设或输入色号。"

    _550w_help_step "3" "改提示符"
    _550w_help_cmd "550w-settings → 2"
    print "  可开关 SID/模式/MOSS/时间。"

    _550w_help_step "4" "调动画"
    _550w_help_cmd "550w-speed normal"
    _550w_help_cmd "550w-fx 1"

    _550w_help_step "5" "加特效动画"
    _550w_help_cmd "550w-anim → 3 → 1"
    print "  试试 glitch / 雪花 / 撕裂。"

    _550w_help_step "6" "改用户档案"
    _550w_help_cmd "550w-settings → 5"
    print "  改用户名/签名/头像。"

    _550w_help_step "7" "自定义欢迎画"
    print "  改用户档案后下次登录:"
    _550w_help_cmd "550w-welcome"
    print "  看新的欢迎画。"

    _550w_help_step "8" "推荐配置"
    print "  冷色系(默认感):"
    print "    cyber + 51(青) + 45(蓝)"
    print ""
    print "  暖色系:"
    print "    amber + 214(橙) + 220(黄)"
    print ""
    print "  赛博朋克:"
    print "    crimson + 196(红) + 135(紫)"
    print ""
    print "  极简:"
    print "    主题任意 + 只留时间 + 关扫描线"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 13 · 个性化启动 ══════════════════

_550w_help_sc13() {
    _550w_help_head "场景 13 · 个性化启动"
    _550w_help_goal "定制开机动画流程"
    _550w_help_cost "10 分钟" "★★★☆☆"

    _550w_help_step "1" "看当前开机动画"
    _550w_help_cmd "550w-boot-anim-list"
    _550w_help_cmd "ls ~/.550w/boot_anim/"

    _550w_help_step "2" "加一个动画"
    _550w_help_cmd "550w-anim → 14 → 1"
    print "  从 62 个预设挑。"
    print "  例: 20(波浪) / 21(ECG) / 22(频谱)"

    _550w_help_step "3" "加多个动画"
    print "  多次重复 14 → 1, 会依次加入。"
    print "  文件名自动编号 99_user_NN。"

    _550w_help_step "4" "调整顺序"
    print "  打开 boot_anim 目录:"
    _550w_help_cmd "ls ~/.550w/boot_anim/"
    print ""
    print "  重命名控制顺序:"
    _550w_help_cmd "mv 99_user_02.zsh 05_xxx.zsh"
    print "  数字小的先播。"

    _550w_help_step "5" "手动写一个"
    _550w_help_cmd "nano ~/.550w/boot_anim/01_custom.zsh"
    print "  内容举例:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_glitch_v3 \"WAKE UP\" 10%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 300%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_wave_v2 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_typing_v2 \"SYSTEM READY\" 40%f"

    _550w_help_step "6" "删除动画"
    _550w_help_cmd "550w-anim → 14 → 2"

    _550w_help_step "7" "清空全部"
    _550w_help_cmd "550w-anim → 14 → 4"

    _550w_help_step "8" "加速/减速"
    print "  全局速度:"
    _550w_help_cmd "550w-speed slow"
    print "  单个动画内部_550w_pause 控制。"
    print "  boot_anim 里可以写 _550w_pause_hold 强制等待。"

    _550w_help_step "9" "示例: 黑客风"
    print "  创建 ~/.550w/boot_anim/01_hacker.zsh:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_binary_v2 3 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_hex_v2 3 16%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_glitch_v3 \"ACCESS GRANTED\" 12%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_hex_scramble \"SYSTEM\"%f"

    _550w_help_tip "复杂动画组合起来效果炸裂"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 14 · 写插件 ══════════════════

_550w_help_sc14() {
    _550w_help_head "场景 14 · 写插件"
    _550w_help_goal "从需求到成品"
    _550w_help_cost "15 分钟" "★★★★☆"

    _550w_help_step "1" "想清楚需求"
    print "  例: 想要一个命令 550w-ip 显示公网 IP。"
    print "  用 curl 调 ipify.org 获取。"

    _550w_help_step "2" "创建骨架"
    _550w_help_cmd "550w-plugin-new ipinfo"

    _550w_help_step "3" "写 main.zsh"
    print "  编辑 ~/.550w/扩展/ipinfo/main.zsh:"
    print -P "  %F{${_550w_C[dim]}}# @name: ipinfo%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 显示公网 IP%f"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-ip() {%f"
    print -P "  %F{${_550w_C[dim]}}    local ip=\$(curl -s --max-time 5 https://api.ipify.org)%f"
    print -P "  %F{${_550w_C[dim]}}    if [[ -n \"\$ip\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}        _plugin_log info \"公网 IP: \$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}        print \"公网 IP: \$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}    else%f"
    print -P "  %F{${_550w_C[dim]}}        print \"获取失败\"%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "4" "重载测试"
    _550w_help_cmd "550w-plugin-reload ipinfo"
    _550w_help_cmd "550w-ip"

    _550w_help_step "5" "加功能: 带参数的"
    print -P "  %F{${_550w_C[dim]}}550w-ip-ping() {%f"
    print -P "  %F{${_550w_C[dim]}}    local target=\"\${1:-8.8.8.8}\"%f"
    print -P "  %F{${_550w_C[dim]}}    local t=\$(curl -s -o /dev/null -w '%{time_total}' --max-time 3 \"https://\$target\" 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    print \"延迟: \$(awk -v x=\$t 'BEGIN{printf \\\"%.0f\\\", x*1000}') ms\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "6" "用配置 API"
    print -P "  %F{${_550w_C[dim]}}550w-ip-save() {%f"
    print -P "  %F{${_550w_C[dim]}}    local ip=\$(curl -s https://api.ipify.org)%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_config_set last_ip \"\$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"已保存: \$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-ip-show() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"上次: \$(_plugin_config_get last_ip \"无\")\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "7" "加钩子"
    print "  在 main.zsh 顶部注释:"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print ""
    print "  加函数:"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_ipinfo_login() {%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"ipinfo 已加载\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "调试"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugin-logs ipinfo"
    _550w_help_cmd "zsh -n ~/.550w/扩展/ipinfo/main.zsh"

    _550w_help_step "9" "打包分享"
    _550w_help_cmd "550w-plugin-pack ipinfo"

    _550w_help_tip "写插件最花时间在调试, 多 550w-plugin-reload"

    _550w_help_divider
    _550w_help_pause
}

# ══════════════════ 场景 15 · 出故障排错 ══════════════════

_550w_help_sc15() {
    _550w_help_head "场景 15 · 出故障排错"
    _550w_help_goal "从症状到解决"
    _550w_help_cost "5 分钟" "★★★☆☆"

    _550w_help_step "1" "通用排查顺序"
    print "  1) 看错误信息(完整读出)"
    print "  2) 语法检查: zsh -n 文件"
    print "  3) 重新加载: unset _550W_LOADED && source ~/.zshrc"
    print "  4) 重启 shell: exec zsh"
    print "  5) 重启 Termux"
    print "  6) 恢复默认设置"
    print "  7) 从备份恢复"
    print "  8) 彻底重置"

    _550w_help_step "2" "看系统状态"
    _550w_help_cmd "550w-status"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-moss"
    _550w_help_cmd "550w-real → 1"

    _550w_help_step "3" "看日志"
    _550w_help_cmd "550w-settings → 10 → 1"
    _550w_help_cmd 'tail -30 ~/.550w/logs/550w_$(date +%Y%m%d).log'

    _550w_help_step "4" "看审计"
    _550w_help_cmd 'tail -20 ~/.550w/.550w_audit'

    _550w_help_step "5" "语法错定位"
    _550w_help_cmd "zsh -n ~/.550w/core.zsh 2>&1 | head -3"
    print "  看报错行号, 定位:"
    _550w_help_cmd "sed -n 'XXX,XXXp' ~/.550w/core.zsh"

    _550w_help_step "6" "用调试模式"
    _550w_help_cmd "export _550W_LOG_LEVEL=4"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print "  会打印所有 debug 日志。"

    _550w_help_step "7" "恢复设置"
    _550w_help_cmd "550w-settings → 14 → 2"
    print "  会重置配置。"

    _550w_help_step "8" "从备份恢复"
    _550w_help_cmd "550w-settings → 9 → 4"
    print "  选最近的备份覆盖。"

    _550w_help_step "9" "彻底重置"
    _550w_help_warn "会删所有数据"
    _550w_help_cmd 'cp -r ~/.550w ~/.550w.bak_$(date +%Y%m%d)'
    _550w_help_cmd "rm -rf ~/.550w"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"

    _550w_help_step "10" "版本兼容"
    print "  550W 版本不匹配时可能出错。"
    _550w_help_cmd "550w-version"
    print "  检查扩展文件的 @requires_550w 声明。"

    _550w_help_step "11" "报给朋友/社区"
    print "  收集:"
    print "    · 触发命令"
    print "    · 完整报错"
    print "    · 版本: 550w-version"
    print "    · 内核: uname -a"
    print "    · Shell: echo \$ZSH_VERSION"
    print "    · 终端: echo \$TERM"

    _550w_help_tip "问题定位 80% 靠仔细读报错信息"

    _550w_help_divider
    print -P "  %F{${_550W_C[cyan]}}继续深入:%f"
    print "    · 主菜单 → 5  插件专章(20 节)"
    print "    · 主菜单 → 8  开发者指南"
    print "    · 主菜单 → 9  FAQ"
    _550w_help_pause
}
# ══════════════════ 插件专章 · 主菜单 ══════════════════

_550w_help_menu_plugin() {
    while true; do
        _550w_help_head "插件专章" "20 节 + 5 个完整示例"
        print ""

        _550w_help_sub "基础(1~5)"
        _550w_help_row "1"  "节 01"  "插件是什么"
        _550w_help_row "2"  "节 02"  "目录结构"
        _550w_help_row "3"  "节 03"  "第一个插件"
        _550w_help_row "4"  "节 04"  "main.zsh 详解"
        _550w_help_row "5"  "节 05"  "元数据"

        _550w_help_sub "进阶(6~10)"
        _550w_help_row "6"  "节 06"  "命令依赖 @requires"
        _550w_help_row "7"  "节 07"  "插件依赖 @depends"
        _550w_help_row "8"  "节 08"  "钩子 @hook"
        _550w_help_row "9"  "节 09"  "配置隔离 API"
        _550w_help_row "10" "节 10"  "日志隔离 API"

        _550w_help_sub "操作(11~14)"
        _550w_help_row "11" "节 11"  "启用/禁用"
        _550w_help_row "12" "节 12"  "打包"
        _550w_help_row "13" "节 13"  "安装"
        _550w_help_row "14" "节 14"  "调试"

        _550w_help_sub "示例(15~19)"
        _550w_help_row "15" "节 15"  "示例1: hello"
        _550w_help_row "16" "节 16"  "示例2: weather"
        _550w_help_row "17" "节 17"  "示例3: todo"
        _550w_help_row "18" "节 18"  "示例4: 时钟(钩子)"
        _550w_help_row "19" "节 19"  "示例5: 系统监控"

        _550w_help_sub "总结(20)"
        _550w_help_row "20" "节 20"  "最佳实践"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-20]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_help_p01 ;;
            2)  _550w_help_p02 ;;
            3)  _550w_help_p03 ;;
            4)  _550w_help_p04 ;;
            5)  _550w_help_p05 ;;
            6)  _550w_help_p06 ;;
            7)  _550w_help_p07 ;;
            8)  _550w_help_p08 ;;
            9)  _550w_help_p09 ;;
            10) _550w_help_p10 ;;
            11) _550w_help_p11 ;;
            12) _550w_help_p12 ;;
            13) _550w_help_p13 ;;
            14) _550w_help_p14 ;;
            15) _550w_help_p15 ;;
            16) _550w_help_p16 ;;
            17) _550w_help_p17 ;;
            18) _550w_help_p18 ;;
            19) _550w_help_p19 ;;
            20) _550w_help_p20 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 节 01 · 插件是什么 ══════════════════

_550w_help_p01() {
    _550w_help_head "插件专章 · 节 01" "插件是什么"
    _550w_help_goal "理解插件的本质"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "一句话定义"
    print "  插件 = 一个文件夹, 里面装你的自定义功能。"
    print "  放到 ~/.550w/扩展/ 下, 开机自动加载。"

    _550w_help_step "2" "对比:函数 vs 插件"
    print "  函数: 直接写在 core.zsh 里"
    print "    优点: 集中, 好查"
    print "    缺点: 文件越来越长, 不好维护"
    print ""
    print "  插件: 独立文件夹"
    print "    优点: 隔离, 好分享, 好删除"
    print "    缺点: 多一层目录"

    _550w_help_step "3" "插件能做什么"
    print "  · 加新命令(如 550w-weather)"
    print "  · 加新别名"
    print "  · 注册钩子(命令前/后/登录/退出)"
    print "  · 读写自己的配置"
    print "  · 写自己的日志"
    print "  · 依赖其它插件"
    print "  · 依赖系统命令"

    _550w_help_step "4" "插件不能做什么"
    print "  · 不能改 core.zsh 的核心逻辑(需改源码)"
    print "  · 不能阻止别的插件加载"
    print "  · 不能调用 settings.zsh 里的私有函数"
    print "    (但可以调公开的 550w-* 命令)"

    _550w_help_step "5" "插件 vs 扩展文件"
    print "  ~/.550w/ 下有两类:"
    print "    · core.zsh / settings.zsh / anim.zsh 等"
    print "      → 官方扩展文件, 由 550W 维护"
    print "    · ~/.550w/扩展/ 下每个子目录"
    print "      → 你的插件, 独立加载"
    print ""
    print "  插件出问题不影响官方文件。"

    _550w_help_step "6" "加载流程"
    print "  1) core.zsh 加载完"
    print "  2) 扫 ~/.550w/扩展/ 下所有子目录"
    print "  3) 每个子目录找 main.zsh"
    print "  4) 检查依赖(命令 + 插件)"
    print "  5) 语法检查"
    print "  6) source main.zsh"
    print "  7) 注册钩子"
    print "  8) 记入已加载列表"

    _550w_help_step "7" "出错怎么办"
    print "  任一插件加载失败:"
    print "    · 不影响其它插件"
    print "    · 记入错误列表"
    print "    · 550w-plugin-errors 查看"

    _550w_help_step "8" "适用场景"
    print "  适合做成插件的:"
    print "    · 常用工具(天气/翻译/IP)"
    print "    · 项目专用命令集"
    print "    · 特定场景的钩子"
    print "    · 想分享给别人的功能"
    print ""
    print "  不适合:"
    print "    · 一次性的临时代码"
    print "    · 需要改核心的改动"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  你理解插件了"
    _550w_help_pause
}

# ══════════════════ 节 02 · 目录结构 ══════════════════

_550w_help_p02() {
    _550w_help_head "插件专章 · 节 02" "目录结构"
    _550w_help_goal "搞清楚每个文件干什么"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "基本结构"
    print "  ~/.550w/扩展/"
    print "  ├── weather/          ← 插件文件夹"
    print "  │   ├── main.zsh      ← 入口(必须有)"
    print "  │   ├── config.zsh    ← 配置(可选)"
    print "  │   └── README.md     ← 说明(可选)"
    print "  ├── tools/"
    print "  │   └── main.zsh"
    print "  └── monitor/"
    print "      ├── main.zsh"
    print "      └── log/          ← 日志(自动创建)"

    _550w_help_step "2" "main.zsh"
    print "  插件入口, 必须有。"
    print "  加载器只 source 这个文件。"
    print ""
    print "  里面可以:"
    print "    · 定义函数"
    print "    · 定义别名"
    print "    · source 同目录其它文件"
    print "    · 注册钩子(通过元数据)"

    _550w_help_step "3" "config.zsh"
    print "  可选。 存放变量/常量。"
    print "  在 main.zsh 顶部 source 它:"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print ""
    print "  示例内容:"
    print -P "  %F{${_550w_C[dim]}}typeset -g WEATHER_API=\"https://api.example.com\"%f"
    print -P "  %F{${_550w_C[dim]}}typeset -g WEATHER_TIMEOUT=10%f"

    _550w_help_step "4" "其它文件"
    print "  可以放任意文件:"
    print "    · helper.zsh    辅助函数"
    print "    · data.txt      数据"
    print "    · template.md   模板"
    print "    · subdir/       子目录"
    print ""
    print "  加载规则: 只 main.zsh 会被自动 source。"
    print "  其它文件要在 main.zsh 里手动 source。"

    _550w_help_step "5" "log/ 目录"
    print "  自动创建(加载时)。"
    print "  每天一个文件: 20261007.log"
    print ""
    print "  用 API 写日志:"
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"消息\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log warn \"警告\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log error \"错误\"%f"
    print ""
    print "  查看:"
    _550w_help_cmd "550w-plugin-logs 插件名"

    _550w_help_step "6" "config/ 目录"
    print "  自动创建(加载时)。"
    print "  存放插件自己的配置:"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/插件名/config/config%f"
    print ""
    print "  格式 key=\"value\", 一行一条。"
    print "  用 API 读写:"
    _550w_help_cmd "_plugin_config_set key value"
    _550w_help_cmd "v=\$(_plugin_config_get key 默认值)"

    _550w_help_step "7" ".disabled 标记"
    print "  禁用插件时, 会在插件目录里创建:"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/插件名/.disabled%f"
    print ""
    print "  加载器看到就跳过。"
    print "  启用时删除此文件。"

    _550w_help_step "8" "README.md"
    print "  可选, 建议写:"
    print "    · 插件用途"
    print "    · 用法示例"
    print "    · 依赖"
    print "    · 已知问题"
    print ""
    print "  550w-plugin-new 会自动生成模板。"

    _550w_help_step "9" "完整示例目录"
    print "  ~/.550w/扩展/weather/"
    print "  ├── main.zsh          入口"
    print "  ├── config.zsh        默认配置"
    print "  ├── helper.zsh        辅助函数"
    print "  ├── README.md         说明"
    print "  ├── config/           运行配置"
    print "  │   └── config        用户改的值"
    print "  └── log/              运行日志"
    print "      └── 20261007.log"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  目录结构清楚了"
    _550w_help_pause
}

# ══════════════════ 节 03 · 第一个插件 ══════════════════

_550w_help_p03() {
    _550w_help_head "插件专章 · 节 03" "第一个插件"
    _550w_help_goal "5 分钟写出并跑通 hello 插件"
    _550w_help_cost "5 分钟" "★☆☆☆☆"

    _550w_help_step "1" "创建"
    _550w_help_cmd "550w-plugin-new hello"
    _550w_help_expect "✓ 已创建插件: hello" "会生成 3 个文件"

    _550w_help_step "2" "看目录"
    _550w_help_cmd "ls -la ~/.550w/扩展/hello/"
    print "  看到:"
    print "    main.zsh"
    print "    config.zsh"
    print "    README.md"

    _550w_help_step "3" "看默认内容"
    _550w_help_cmd "cat ~/.550w/扩展/hello/main.zsh"
    print "  默认会有一个 550w-hello 函数。"

    _550w_help_step "4" "编辑"
    _550w_help_cmd "nano ~/.550w/扩展/hello/main.zsh"
    print ""
    print "  改成这样:"
    print -P "  %F{${_550w_C[dim]}}# @name: hello%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: 你的名字%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 打个招呼%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550w_C[dim]}}    local name=\"\${1:-世界}\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"你好, \$name!\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  保存: Ctrl+O → 回车 → Ctrl+X"

    _550w_help_step "5" "重载"
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_expect "✓ 已重载: hello"

    _550w_help_step "6" "测试"
    _550w_help_cmd "550w-hello"
    _550w_help_expect "你好, 世界!"
    _550w_help_cmd "550w-hello 张三"
    _550w_help_expect "你好, 张三!"

    _550w_help_step "7" "查看列表"
    _550w_help_cmd "550w-plugins"
    print "  会显示 hello 插件, 状态 ● 已加载"

    _550w_help_step "8" "查看详情"
    _550w_help_cmd "550w-plugin-info hello"
    print "  显示元数据/文件/函数/依赖。"

    _550w_help_step "9" "加第二个函数"
    print "  继续编辑 main.zsh, 追加:"
    print -P "  %F{${_550w_C[dim]}}550w-bye() {%f"
    print -P "  %F{${_550w_C[dim]}}    local name=\"\${1:-朋友}\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"再见, \$name\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_cmd "550w-bye"
    _550w_help_expect "再见, 朋友"

    _550w_help_step "10" "重启验证持久性"
    _550w_help_cmd "exec zsh"
    print "  重进后:"
    _550w_help_cmd "550w-hello"
    _550w_help_expect "仍然工作"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  第一个插件跑通了"
    print ""
    print -P "  %F{${_550W_C[cyan]}}下一步:%f 节 04 · main.zsh 详解"
    _550w_help_pause
}
# ══════════════════ 节 04 · main.zsh 详解 ══════════════════

_550w_help_p04() {
    _550w_help_head "插件专章 · 节 04" "main.zsh 详解"
    _550w_help_goal "完全掌握入口文件写法"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "文件结构"
    print "  一个规范的 main.zsh 分 3 部分:"
    print ""
    print "  ① 头部: 元数据注释"
    print "  ② 中部: source 其它文件, 定义变量"
    print "  ③ 主体: 定义函数"

    _550w_help_step "2" "头部元数据"
    print "  必须是文件最前面的连续注释:"
    print -P "  %F{${_550w_C[dim]}}# @name: 显示名%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: 作者%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 一句话说明%f"
    print -P "  %F{${_550w_C[dim]}}# @requires: 命令依赖%f"
    print -P "  %F{${_550w_C[dim]}}# @depends: 插件依赖%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: 钩子%f"
    _550w_help_note "中间不能有空行或代码, 否则解析截断"

    _550w_help_step "3" "source 其它文件"
    print "  标准写法:"
    print -P "  %F{${_550w_C[dim]}}local _dir=\"\${_550W_PLUGIN_SELF:-\$(dirname \"\${(%):-%N}\")}\"%f"
    print -P "  %F{${_550w_C[dim]}}[[ -r \"\$_dir/config.zsh\" ]] && source \"\$_dir/config.zsh\"%f"
    print ""
    print "  \$_550W_PLUGIN_SELF 是加载器设置的变量:"
    print "  指向插件自己的目录(绝对路径)。"
    print ""
    print "  \${(%):-%N} 是 zsh 特有语法, 拿当前文件的路径。"
    print "  用作 fallback(手动 source 时也能定位)。"

    _550w_help_step "4" "定义函数"
    print "  命名约定: 550w-<插件名> 或 550w-<功能>"
    print ""
    print "  标准形式:"
    print -P "  %F{${_550w_C[dim]}}550w-weather() {%f"
    print -P "  %F{${_550w_C[dim]}}    local city=\"\${1:-北京}\"%f"
    print -P "  %F{${_550w_C[dim]}}    # 干活%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  带子命令(类似 git):"
    print -P "  %F{${_550w_C[dim]}}550w-todo() {%f"
    print -P "  %F{${_550w_C[dim]}}    local cmd=\"\${1:-show}\"%f"
    print -P "  %F{${_550w_C[dim]}}    case \"\$cmd\" in%f"
    print -P "  %F{${_550w_C[dim]}}        add) ... ;;%f"
    print -P "  %F{${_550w_C[dim]}}        del) ... ;;%f"
    print -P "  %F{${_550w_C[dim]}}        show) ... ;;%f"
    print -P "  %F{${_550w_C[dim]}}    esac%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "5" "返回码"
    print "  返回 0 = 成功"
    print "  返回非 0 = 失败"
    print ""
    print "  使用:"
    print -P "  %F{${_550w_C[dim]}}550w-check() {%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -f \"\$1\" ]] || return 1%f"
    print -P "  %F{${_550w_C[dim]}}    return 0%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  调用方:"
    print -P "  %F{${_550w_C[dim]}}550w-check file.txt && echo OK%f"

    _550w_help_step "6" "打印输出"
    print "  print / echo / printf 都可用。"
    print "  带颜色用 print -P:"
    print -P "  %F{${_550w_C[dim]}}print -P \"%F{46}绿色%f 正常\"%f"
    print ""
    print "  简单方式:"
    print -P "  %F{${_550w_C[dim]}}printf '\\e[38;5;46m%s\\e[0m\\n' \"消息\"%f"

    _550w_help_step "7" "错误处理"
    print -P "  %F{${_550w_C[dim]}}550w-foo() {%f"
    print -P "  %F{${_550w_C[dim]}}    command -v curl >/dev/null 2>&1 || {%f"
    print -P "  %F{${_550w_C[dim]}}        print \"需要 curl\" >&2%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    }%f"
    print -P "  %F{${_550w_C[dim]}}    ...%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "调用 MOSS"
    print -P "  %F{${_550w_C[dim]}}550w-ask() {%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_moss_chat \"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    if [[ -n \"\$_550W_MOSS_REPLY\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}        print \"\$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    _550w_help_warn "不要在 \$(...) 里调 _550w_moss_chat, 全局变量会丢"

    _550w_help_step "9" "常用内部函数"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "_550w_pause ms" "暂停(可跳过)"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "_550w_cls" "清屏"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550w_C[ok]}" "_550w_anim_type 文本" "打字机"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "_550w_anim_box 行..." "框"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "_550w_moss_chat 消息" "AI 对话"
    printf '  \e[38;5;%sm%-26s\e[0m %s\n' "${_550W_C[ok]}" "_plugin_log info 消息" "写日志"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  main.zsh 你能写了"
    _550w_help_pause
}

# ══════════════════ 节 05 · 元数据 ══════════════════

_550w_help_p05() {
    _550w_help_head "插件专章 · 节 05" "元数据"
    _550w_help_goal "完整掌握 7 个元数据字段"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "元数据在哪"
    print "  文件最顶部的连续 # 注释:"
    print -P "  %F{${_550w_C[dim]}}# @name: xxx%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: xxx%f"
    print ""
    print "  遇到第一个非 # 行就停止解析。"

    _550w_help_step "2" "@name 显示名"
    print "  用途: 在列表里显示的名字"
    print "  默认: 文件夹名"
    print "  例:"
    print -P "  %F{${_550w_C[dim]}}# @name: 天气查询%f"
    print "  插件名叫 weather, 显示名是'天气查询'。"

    _550w_help_step "3" "@version 版本号"
    print "  语义化版本: 主.次.补丁"
    print "  例: 1.0.0 / 1.2.3 / 0.5.0"
    print ""
    print "  打包时用在文件名:"
    print "    weather-1.0.0-20261007.tar.gz"

    _550w_help_step "4" "@author 作者"
    print "  写你自己名字或昵称。"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"

    _550w_help_step "5" "@desc 说明"
    print "  一句话。"
    print "  显示在插件列表和详情页。"
    print -P "  %F{${_550w_C[dim]}}# @desc: 查询任意城市天气(AI)%f"
    print ""
    print "  太长的会截断, 建议 < 40 字符。"

    _550w_help_step "6" "@requires 命令依赖"
    print "  空格分隔的命令列表。"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl jq awk%f"
    print ""
    print "  加载时检查:"
    print "    · 命令存在 → 继续加载"
    print "    · 缺命令 → 跳过 + 警告"
    print ""
    print "  缺依赖时用户可以:"
    _550w_help_cmd "pkg install jq"
    _550w_help_cmd "550w-plugin-reload 插件名"

    _550w_help_step "7" "@depends 插件依赖"
    print "  依赖的其它插件名。"
    print -P "  %F{${_550w_C[dim]}}# @depends: tools net%f"
    print ""
    print "  加载前先加载 tools 和 net。"
    print "  缺依赖 → 跳过 + 警告。"
    print ""
    _550w_help_warn "不要写循环依赖(A→B→A 会死循环)"

    _550w_help_step "8" "@hook 钩子"
    print "  空格分隔的钩子类型:"
    print -P "  %F{${_550w_C[dim]}}# @hook: login precmd%f"
    print ""
    print "  支持:"
    print "    precmd   每条命令前"
    print "    preexec  每条命令后"
    print "    chpwd    切换目录"
    print "    login    登录后"
    print "    logout   退出时"
    print ""
    print "  需配套定义函数:"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_<插件名>_<钩子名>()%f"

    _550w_help_step "9" "完整示例"
    print -P "  %F{${_550w_C[dim]}}# @name: 天气%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 查天气%f"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-weather() { ... }%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_weather_login() { ... }%f"

    _550w_help_step "10" "查看元数据"
    _550w_help_cmd "550w-plugin-info 插件名"
    print "  显示: 名称/版本/作者/说明/依赖/钩子"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  元数据全掌握"
    _550w_help_pause
}

# ══════════════════ 节 06 · 命令依赖 ══════════════════

_550w_help_p06() {
    _550w_help_head "插件专章 · 节 06" "命令依赖 @requires"
    _550w_help_goal "声明插件需要的系统命令"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "为什么需要"
    print "  插件用 curl 但用户没装 → 运行才报错。"
    print "  用 @requires 声明 → 加载时就检查。"
    print ""
    print "  好处:"
    print "    · 提前发现问题"
    print "    · 用户看得到缺什么"
    print "    · 不加载坏插件"

    _550w_help_step "2" "声明格式"
    print "  main.zsh 顶部:"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl jq awk%f"
    print ""
    print "  空格分隔, 一行写完。"

    _550w_help_step "3" "加载时的检查"
    print "  加载器会:"
    print "    1) 逐个命令 command -v 检查"
    print "    2) 全部存在 → 加载"
    print "    3) 缺任意一个 → 跳过 + 警告"
    print ""
    print "  警告信息:"
    print -P "  %F{${_550w_C[warn]}}[550W] 插件 weather 跳过(缺命令: jq)%f"

    _550w_help_step "4" "查看错误"
    _550w_help_cmd "550w-plugin-errors"
    print "  会显示:"
    print "    weather  命令缺失: jq"
    print "    monitor  插件缺失: net"

    _550w_help_step "5" "解决缺命令"
    print "  装命令:"
    _550w_help_cmd "pkg install jq"
    print ""
    print "  重载:"
    _550w_help_cmd "550w-plugin-reload weather"

    _550w_help_step "6" "常见命令依赖"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "curl"     "HTTP 请求"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "wget"     "下载"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "jq"       "JSON 解析"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "awk"      "文本处理"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "sed"      "文本替换"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "grep"     "搜索"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "python3"  "Python"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "git"      "Git"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "bc"       "计算"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "openssl"  "加密"

    _550w_help_step "7" "主动检查"
    print "  在插件函数里也可检查:"
    print -P "  %F{${_550w_C[dim]}}550w-foo() {%f"
    print -P "  %F{${_550w_C[dim]}}    if ! command -v jq >/dev/null 2>&1; then%f"
    print -P "  %F{${_550w_C[dim]}}        print \"需要 jq: pkg install jq\"%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}    ...%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "容错降级"
    print "  允许有则用, 无则降级:"
    print -P "  %F{${_550w_C[dim]}}550w-parse() {%f"
    print -P "  %F{${_550w_C[dim]}}    if command -v jq >/dev/null 2>&1; then%f"
    print -P "  %F{${_550w_C[dim]}}        print \"\$1\" | jq .%f"
    print -P "  %F{${_550w_C[dim]}}    else%f"
    print -P "  %F{${_550w_C[dim]}}        print \"\$1\"   # 原样输出%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "9" "批量检查"
    print "  用 550w-plugin-info:"
    _550w_help_cmd "550w-plugin-info 插件名"
    print "  会列出依赖, 每个前面:"
    print "    ✓ 已安装"
    print "    ✗ 缺失"

    _550w_help_step "10" "最佳实践"
    print "  · 只用必须的依赖"
    print "  · 用宽泛的命令(awk 几乎都有)"
    print "  · 尽量少依赖 python3/openssl 等大包"
    print "  · 给替代方案(如上面容错降级)"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  命令依赖会用了"
    _550w_help_pause
}
# ══════════════════ 节 07 · 插件依赖 ══════════════════

_550w_help_p07() {
    _550w_help_head "插件专章 · 节 07" "插件依赖 @depends"
    _550w_help_goal "插件之间互相依赖"
    _550w_help_cost "5 分钟" "★★★☆☆"

    _550w_help_step "1" "为什么需要"
    print "  插件 A 用 B 里定义的函数 → A 必须先加载。"
    print "  @depends 让加载器知道顺序。"

    _550w_help_step "2" "声明格式"
    print -P "  %F{${_550w_C[dim]}}# @depends: tools net%f"
    print "  表示: 加载本插件前, 先加载 tools 和 net。"

    _550w_help_step "3" "拓扑排序"
    print "  加载器按依赖图排序:"
    print ""
    print "  依赖图:"
    print "    A → B → C"
    print "    D → B"
    print ""
    print "  加载顺序: C, B, D, A"
    print "  (被依赖的先加载)"

    _550w_help_step "4" "循环依赖"
    print "  错误示例:"
    print "    A @depends: B"
    print "    B @depends: A"
    print ""
    print "  加载器会输出:"
    print -P "  %F{${_550w_C[err]}}[550W] 插件循环依赖: A B%f"
    print "  这两个插件都会被跳过。"

    _550w_help_step "5" "缺插件时的行为"
    print "  A @depends: B, 但 B 不存在:"
    print "    · A 跳过"
    print "    · 警告: '缺插件: B'"
    print "    · A 记入错误列表"
    print ""
    print "  用 550w-plugin-errors 查看。"

    _550w_help_step "6" "跨插件调用"
    print "  插件 tools 定义:"
    print -P "  %F{${_550w_C[dim]}}550w-tools-log() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"[tools] \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  插件 app 声明依赖 tools:"
    print -P "  %F{${_550w_C[dim]}}# @depends: tools%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-app-run() {%f"
    print -P "  %F{${_550w_C[dim]}}    550w-tools-log \"app 执行\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  因为 tools 先加载, app 能直接用它的函数。"

    _550w_help_step "7" "避免硬依赖"
    print "  软件工程经验: 少用依赖。"
    print "  宁可复制小段代码, 也别跨插件调。"
    print ""
    print "  例外:"
    print "    · 工具类插件(被多个引用)"
    print "    · 确实需要的公共逻辑"

    _550w_help_step "8" "调试依赖问题"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugins"
    print "  列表里:"
    print "    ● 已加载   ○ 未加载   ✗ 已禁用"
    print "  '未加载' 可能是缺依赖。"

    _550w_help_step "9" "查看依赖图"
    print "  手动查:"
    print -P "  %F{${_550w_C[dim]}}for d in ~/.550w/扩展/*/; do%f"
    print -P "  %F{${_550w_C[dim]}}    n=\$(basename \$d)%f"
    print -P "  %F{${_550w_C[dim]}}    dep=\$(grep -m1 '@depends:' \$d/main.zsh | cut -d: -f2)%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -n \"\$dep\" ]] && echo \"\$n 依赖:\$dep\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "10" "最佳实践"
    print "  · 依赖越少越好"
    print "  · 名字写准(区分大小写)"
    print "  · 依赖必须在 ~/.550w/扩展/ 里存在"
    print "  · 不要循环"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  插件依赖会用了"
    _550w_help_pause
}

# ══════════════════ 节 08 · 钩子 @hook ══════════════════

_550w_help_p08() {
    _550w_help_head "插件专章 · 节 08" "钩子 @hook"
    _550w_help_goal "在特定时机自动执行代码"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "什么是钩子"
    print "  钩子 = 在特定事件发生时自动执行的函数。"
    print "  例: 每次登录后自动打印欢迎语。"

    _550w_help_step "2" "5 种钩子类型"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "precmd"  "每条命令执行前"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "preexec" "每条命令执行后"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "chpwd"   "切换目录后"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "login"   "登录成功后一次"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "logout"  "shell 退出时"

    _550w_help_step "3" "声明钩子"
    print "  main.zsh 顶部:"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print ""
    print "  多个:"
    print -P "  %F{${_550w_C[dim]}}# @hook: login precmd%f"

    _550w_help_step "4" "定义钩子函数"
    print "  命名规则:"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_<插件名>_<钩子名>()%f"
    print ""
    print "  例(插件名 welcome, 钩子 login):"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_welcome_login() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"欢迎回来!\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "5" "完整示例: login 钩子"
    print -P "  %F{${_550w_C[dim]}}# @name: welcome%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_welcome_login() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"👋 \$_550W_USER_NAME, 欢迎回来\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"欢迎语已打印\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "6" "完整示例: precmd 钩子"
    print -P "  %F{${_550w_C[dim]}}# @hook: precmd%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_mymon_precmd() {%f"
    print -P "  %F{${_550w_C[dim]}}    local freq=\$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -n \"\$freq\" ]] && {%f"
    print -P "  %F{${_550w_C[dim]}}        print -P \"%F{240}CPU: \$((freq/1000)) MHz%f\"%f"
    print -P "  %F{${_550w_C[dim]}}    }%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  效果: 每条命令前都打印 CPU 频率。"

    _550w_help_step "7" "完整示例: chpwd 钩子"
    print -P "  %F{${_550w_C[dim]}}# @hook: chpwd%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_x_chpwd() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"进入: \$PWD\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "完整示例: logout 钩子"
    print -P "  %F{${_550w_C[dim]}}# @hook: logout%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_x_logout() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"再见\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"退出\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  退出 shell 时执行(exit / Ctrl+D)。"

    _550w_help_step "9" "钩子执行顺序"
    print "  多个插件注册同一钩子:"
    print "    按插件加载顺序依次执行。"
    print ""
    print "  依赖排序影响钩子顺序。"
    print "  被依赖的先执行。"

    _550w_help_step "10" "查看已注册钩子"
    _550w_help_cmd "550w-plugin-hooks"
    print "  列出:"
    print "    · 每个插件的 @hook 声明"
    print "    · 实际挂载到 zsh 的函数"

    _550w_help_step "11" "移除所有钩子"
    _550w_help_cmd "550w-plugin-hooks-remove"
    print "  清除所有 _550w_plugin_hook_* 钩子。"
    print "  重启后重新加载会再挂。"

    _550w_help_step "12" "常见错误"
    print "  ✗ 钩子不执行"
    print "    原因1: 函数名拼错"
    print "      规则: _550w_plugin_hook_<插件名>_<钩子名>"
    print "    原因2: @hook 声明里名字不对"
    print "    原因3: 插件未加载"
    print ""
    print "  ✗ 循环调用"
    print "    precmd 里调 AI(会再触发 precmd) → 死循环"
    print "    避免: 用变量防重入"

    _550w_help_step "13" "性能注意"
    print "  precmd/preexec 每条命令都跑。"
    print "  里面别放耗时操作(HTTP/文件扫描)。"
    print ""
    print "  适合: 打印状态、轻量检查"
    print "  不适合: 网络请求、大文件处理"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  钩子你能用了"
    _550w_help_pause
}

# ══════════════════ 节 09 · 配置隔离 ══════════════════

_550w_help_p09() {
    _550w_help_head "插件专章 · 节 09" "配置隔离 API"
    _550w_help_goal "让插件有独立的持久化配置"
    _550w_help_cost "6 分钟" "★★★☆☆"

    _550w_help_step "1" "配置文件位置"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/插件名/config/config%f"
    print ""
    print "  格式:"
    print -P "  %F{${_550w_C[dim]}}key1=\"value1\"%f"
    print -P "  %F{${_550w_C[dim]}}key2=\"value2\"%f"
    print ""
    print "  一行一对, key 用引号包值。"

    _550w_help_step "2" "读配置"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get key [默认值]%f"
    print ""
    print "  返回 key 的值。不存在返回默认值。"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}local city=\$(_plugin_config_get city \"北京\")%f"
    print -P "  %F{${_550w_C[dim]}}echo \"城市: \$city\"%f"

    _550w_help_step "3" "写配置"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set key value%f"
    print ""
    print "  存在则覆盖, 不存在则添加。"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set city \"上海\"%f"

    _550w_help_step "4" "完整示例"
    print -P "  %F{${_550w_C[dim]}}550w-weather() {%f"
    print -P "  %F{${_550w_C[dim]}}    local city=\"\${1:-\$(_plugin_config_get city \"北京\")}\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"查询 \$city 天气...\"%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_moss_chat \"\$city 今天天气\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-weather-set() {%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_config_set city \"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"默认城市: \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "5" "使用场景"
    print "  · 用户偏好(城市/时长/格式)"
    print "  · 上次状态(最后一次成功/失败)"
    print "  · 缓存(避免重复请求)"
    print "  · 计数器"

    _550w_help_step "6" "查看配置"
    _550w_help_cmd "550w-plugin-config 插件名"
    print "  会:"
    print "    · 显示所有配置"
    print "    · 提供编辑/删除入口"

    _550w_help_step "7" "手动编辑"
    print "  直接编辑文件:"
    _550w_help_cmd "nano ~/.550w/扩展/插件名/config/config"
    print ""
    print "  改完直接生效(下次读时读新值)。"

    _550w_help_step "8" "删除配置"
    print "  删掉整个 config 文件:"
    _550w_help_cmd "rm ~/.550w/扩展/插件名/config/config"
    print ""
    print "  下次读时返回默认值。"

    _550w_help_step "9" "防止值里的引号问题"
    print "  _plugin_config_set 会自动转义双引号:"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set key \"包含\\\"引号\\\"的值\"%f"
    print ""
    print "  读回来:"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get key%f"

    _550w_help_step "10" "配置 vs 硬编码"
    print "  硬编码(不推荐):"
    print -P "  %F{${_550w_C[dim]}}local city=\"北京\"%f"
    print ""
    print "  配置(推荐):"
    print -P "  %F{${_550w_C[dim]}}local city=\$(_plugin_config_get city \"北京\")%f"
    print ""
    print "  配置能改, 硬编码不能。"

    _550w_help_step "11" "多配置示例"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set city \"北京\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set timeout \"10\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set format \"brief\"%f"
    print ""
    print "  读:"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get city%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get timeout \"30\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get format \"full\"%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  配置隔离会用了"
    _550w_help_pause
}
# ══════════════════ 节 10 · 日志隔离 ══════════════════

_550w_help_p10() {
    _550w_help_head "插件专章 · 节 10" "日志隔离 API"
    _550w_help_goal "让插件有独立的日志"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "日志位置"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/插件名/log/YYYYMMDD.log%f"
    print ""
    print "  每天一个文件, 自动创建目录。"

    _550w_help_step "2" "写日志"
    print -P "  %F{${_550w_C[dim]}}_plugin_log <级别> <消息>%f"
    print ""
    print "  级别: info / warn / error / debug"
    print ""
    print "  示例:"
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"初始化完成\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log warn \"参数异常: \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log error \"请求失败\"%f"

    _550w_help_step "3" "日志格式"
    print "  每行:"
    print -P "  %F{${_550w_C[dim]}}2026-10-07 14:30:22 [info] 初始化完成%f"
    print ""
    print "  字段: 时间戳 + 级别 + 消息"

    _550w_help_step "4" "完整示例"
    print -P "  %F{${_550w_C[dim]}}550w-ip() {%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"查询公网 IP\"%f"
    print -P "  %F{${_550w_C[dim]}}    local ip=\$(curl -s --max-time 5 https://api.ipify.org)%f"
    print -P "  %F{${_550w_C[dim]}}    if [[ -n \"\$ip\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}        _plugin_log info \"获取成功: \$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}        print \"IP: \$ip\"%f"
    print -P "  %F{${_550w_C[dim]}}    else%f"
    print -P "  %F{${_550w_C[dim]}}        _plugin_log error \"获取失败\"%f"
    print -P "  %F{${_550w_C[dim]}}        print \"失败\"%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "5" "查看日志"
    _550w_help_cmd "550w-plugin-logs 插件名"
    print "  会:"
    print "    · 显示今日日志(末 30 条)"
    print "    · 问是否看历史"

    _550w_help_step "6" "手动查看"
    _550w_help_cmd 'cat ~/.550w/扩展/插件名/log/$(date +%Y%m%d).log'
    _550w_help_cmd 'tail -50 ~/.550w/扩展/插件名/log/*.log'

    _550w_help_step "7" "清空日志"
    _550w_help_cmd "550w-plugin-log-clear 插件名"
    print "  删除所有 .log 文件。"

    _550w_help_step "8" "日志 vs 打印"
    print "  打印(print):"
    print "    · 用户看得到"
    print "    · 不持久化"
    print ""
    print "  日志(_plugin_log):"
    print "    · 用户看不到(后台)"
    print "    · 持久化到文件"
    print "    · 可追溯"
    print ""
    print "  建议: 关键动作打日志, 用户结果用 print。"

    _550w_help_step "9" "级别使用"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "${_550w_C[dim]}" "debug" "调试细节"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "${_550w_C[ok]}" "info"  "正常流程"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "${_550w_C[warn]}" "warn" "警告(不致命)"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "${_550w_C[err]}" "error" "错误"

    _550w_help_step "10" "日志自动管理"
    print "  目前不会自动清理插件日志。"
    print "  手动清理:"
    _550w_help_cmd "rm ~/.550w/扩展/*/log/*.log"
    print ""
    print "  或加到 crontab 定期清。"

    _550w_help_step "11" "防止日志泄露隐私"
    print "  日志会保存到文件。"
    print "  写日志时注意:"
    print "    · 别写 API Key"
    print "    · 别写密码"
    print "    · 别写敏感 URL"
    print ""
    print "  例(不推荐):"
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"Key: \$ZHIPU_API_KEY\"%f"
    print ""
    print "  好:"
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"Key 已使用\"%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  日志隔离会用了"
    _550w_help_pause
}

# ══════════════════ 节 11 · 启用/禁用 ══════════════════

_550w_help_p11() {
    _550w_help_head "插件专章 · 节 11" "启用/禁用"
    _550w_help_goal "不删除的情况下临时停用插件"
    _550w_help_cost "4 分钟" "★☆☆☆☆"

    _550w_help_step "1" "为什么用禁用而非删除"
    print "  禁用:"
    print "    · 文件还在"
    print "    · 配置和日志保留"
    print "    · 随时启回来"
    print ""
    print "  删除:"
    print "    · 整个文件夹没了"
    print "    · 配置/日志全丢"
    print "    · 需从备份恢复"

    _550w_help_step "2" "机制"
    print "  禁用时创建标记文件:"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/插件名/.disabled%f"
    print ""
    print "  加载器扫描时:"
    print "    · 看到 .disabled → 跳过"
    print "    · 看不到 → 正常加载"

    _550w_help_step "3" "禁用插件"
    _550w_help_cmd "550w-plugin-disable hello"
    _550w_help_expect "✓ 已禁用: hello"

    _550w_help_step "4" "启用插件"
    _550w_help_cmd "550w-plugin-enable hello"
    _550w_help_expect "✓ 已启用: hello"

    _550w_help_step "5" "菜单操作"
    _550w_help_cmd "550w-plugin → 10  禁用"
    _550w_help_cmd "550w-plugin → 9   启用"
    print ""
    print "  或:"
    _550w_help_cmd "550w-settings → 7"

    _550w_help_step "6" "查看状态"
    _550w_help_cmd "550w-plugins"
    print ""
    print "  标记:"
    print "    ● 已加载"
    print "    ○ 未加载(未启动时)"
    print "    ✗ 已禁用"

    _550w_help_step "7" "批量禁用"
    print -P "  %F{${_550w_C[dim]}}for p in plugin1 plugin2 plugin3; do%f"
    print -P "  %F{${_550w_C[dim]}}    550w-plugin-disable \$p%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "8" "批量启用"
    print -P "  %F{${_550w_C[dim]}}for d in ~/.550w/扩展/*/.disabled(N); do%f"
    print -P "  %F{${_550w_C[dim]}}    rm -f \"\$d\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "9" "手动禁用(不通过命令)"
    print "  直接创建标记:"
    _550w_help_cmd "touch ~/.550w/扩展/插件名/.disabled"
    print ""
    print "  或重命名整个文件夹(不推荐):"
    _550w_help_cmd "mv ~/.550w/扩展/插件名 ~/.550w/扩展/插件名.disabled"

    _550w_help_step "10" "场景"
    print "  · 调试: 禁用其他插件, 只留正在改的"
    print "  · 临时: 不想看到某个插件的输出"
    print "  · 排查: 禁用后问题消失 → 那个插件有问题"

    _550w_help_step "11" "注意"
    print "  禁用后:"
    print "    · 插件定义的命令消失"
    print "    · 钩子不再触发"
    print "    · 但文件/配置/日志保留"
    print ""
    print "  重启生效(或 550w-plugin-reload)。"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  启用/禁用会用了"
    _550w_help_pause
}

# ══════════════════ 节 12 · 打包 ══════════════════

_550w_help_p12() {
    _550w_help_head "插件专章 · 节 12" "打包"
    _550w_help_goal "把插件打成 tar.gz 分享给别人"
    _550w_help_cost "4 分钟" "★☆☆☆☆"

    _550w_help_step "1" "打包命令"
    _550w_help_cmd "550w-plugin-pack 插件名"
    _550w_help_expect "✓ 已打包: 插件名-版本-时间.tar.gz"

    _550w_help_step "2" "输出位置"
    print -P "  %F{${_550w_C[dim]}}~/.550w/backups/插件名-版本-时间.tar.gz%f"
    print ""
    print "  例:"
    print -P "  %F{${_550w_C[dim]}}weather-1.0.0-20261007_143022.tar.gz%f"

    _550w_help_step "3" "打包内容"
    print "  整个插件文件夹:"
    print "    weather/"
    print "    ├── main.zsh"
    print "    ├── config.zsh"
    print "    ├── log/          ← 也会打包"
    print "    └── config/       ← 也会打包"
    print ""
    _550w_help_warn "日志/配置里有隐私信息, 分享前先清理"

    _550w_help_step "4" "清理后打包"
    _550w_help_cmd "rm -rf ~/.550w/扩展/weather/log/*"
    _550w_help_cmd "rm -rf ~/.550w/扩展/weather/config/*"
    _550w_help_cmd "550w-plugin-pack weather"
    print ""
    print "  这样分享出去的包干净。"

    _550w_help_step "5" "手动打包"
    print "  不用命令:"
    _550w_help_cmd 'cd ~/.550w/扩展'
    _550w_help_cmd 'tar -czf ~/weather.tar.gz weather/'
    print ""
    print "  效果一样。"

    _550w_help_step "6" "看打包结果"
    _550w_help_cmd "ls -lah ~/.550w/backups/weather-*.tar.gz"
    _550w_help_cmd "tar -tzf ~/.550w/backups/weather-*.tar.gz | head"

    _550w_help_step "7" "传输到电脑/手机"
    _550w_help_cmd 'cp ~/.550w/backups/weather-*.tar.gz /storage/emulated/0/Download/'
    print ""
    print "  然后用微信/QQ/蓝牙/网盘发出去。"

    _550w_help_step "8" "版本号注意"
    print "  打包文件名会带 @version。"
    print "  改版本时同步改 main.zsh:"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.1%f"
    print ""
    print "  方便别人看出更新。"

    _550w_help_step "9" "分享清单"
    print "  建议一起发:"
    print "    · 插件 .tar.gz"
    print "    · 简短说明(README)"
    print "    · 依赖说明(需要装什么)"
    print "    · 使用示例"

    _550w_help_step "10" "常见问题"
    print "  ✗ 打包时报错 'tar: not found'"
    print "    解决: Termux 自带 tar, 检查 PATH"
    print ""
    print "  ✗ 打包出来的太大"
    print "    原因: 日志/缓存打进去了"
    print "    解决: 先清理再打包"
    print ""
    print "  ✗ 对方装不上"
    print "    原因: 版本不匹配"
    print "    解决: 让对方也升级 550W"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  打包会用了"
    _550w_help_pause
}
# ══════════════════ 节 13 · 安装 ══════════════════

_550w_help_p13() {
    _550w_help_head "插件专章 · 节 13" "安装"
    _550w_help_goal "从 tar.gz 装插件"
    _550w_help_cost "4 分钟" "★☆☆☆☆"

    _550w_help_step "1" "准备"
    print "  假设你收到 weather-1.0.0.tar.gz。"
    print "  先传到手机 Download:"
    _550w_help_cmd 'cp /storage/emulated/0/Download/weather-1.0.0.tar.gz ~/'

    _550w_help_step "2" "安装命令"
    _550w_help_cmd "550w-plugin-install ~/weather-1.0.0.tar.gz"
    _550w_help_expect "✓ 已安装: weather"

    _550w_help_step "3" "自动做什么"
    print "  1) 解包到临时目录"
    print "  2) 找顶层文件夹名"
    print "  3) 复制到 ~/.550w/扩展/weather/"
    print "  4) 检查依赖"
    print "  5) 提示重载"

    _550w_help_step "4" "重载"
    _550w_help_cmd "550w-plugin-reload"
    print "  或:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"

    _550w_help_step "5" "检查结果"
    _550w_help_cmd "550w-plugins"
    _550w_help_cmd "550w-plugin-info weather"

    _550w_help_step "6" "手动安装"
    print "  不用命令:"
    _550w_help_cmd 'cd ~'
    _550w_help_cmd 'tar -xzf weather-1.0.0.tar.gz'
    _550w_help_cmd 'mv weather ~/.550w/扩展/'

    _550w_help_step "7" "同名冲突"
    print "  如果已存在同名插件:"
    print "    install 会问是否覆盖"
    print "    选 y → 删除旧的装新的"
    print "    选 n → 取消"

    _550w_help_step "8" "依赖检查"
    print "  安装后若提示:"
    print -P "  %F{${_550w_C[warn]}}⚠ 已安装但缺依赖: jq%f"
    print ""
    print "  装依赖:"
    _550w_help_cmd "pkg install jq"
    _550w_help_cmd "550w-plugin-reload weather"

    _550w_help_step "9" "从 URL 安装(需先下载)"
    _550w_help_cmd 'curl -L -o /tmp/plugin.tar.gz https://example.com/plugin.tar.gz'
    _550w_help_cmd "550w-plugin-install /tmp/plugin.tar.gz"

    _550w_help_step "10" "批量安装"
    print -P "  %F{${_550w_C[dim]}}for f in ~/plugins/*.tar.gz; do%f"
    print -P "  %F{${_550w_C[dim]}}    550w-plugin-install \"\$f\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "11" "验证安装成功"
    _550w_help_cmd "550w-plugin-errors"
    print "  应无错误。"
    _550w_help_cmd "550w-plugin-logs weather"
    print "  有日志 = 加载成功。"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  安装会用了"
    _550w_help_pause
}

# ══════════════════ 节 14 · 调试 ══════════════════

_550w_help_p14() {
    _550w_help_head "插件专章 · 节 14" "调试"
    _550w_help_goal "插件不工作时怎么排查"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "第一招:看错误列表"
    _550w_help_cmd "550w-plugin-errors"
    print "  显示所有加载失败的插件 + 原因。"

    _550w_help_step "2" "第二招:看列表状态"
    _550w_help_cmd "550w-plugins"
    print "  ● 已加载"
    print "  ○ 未加载"
    print "  ✗ 已禁用"
    print ""
    print "  想加载但显示 ○ → 有问题。"

    _550w_help_step "3" "第三招:语法检查"
    _550w_help_cmd "zsh -n ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  有输出 = 语法错。"
    print "  看行号, 定位:"
    _550w_help_cmd "sed -n 'XXX,XXXp' ~/.550w/扩展/插件名/main.zsh"

    _550w_help_step "4" "第四招:手动 source"
    _550w_help_cmd "source ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  会显示真实错误信息(不吞掉 stderr)。"
    print "  比 550w-plugin-reload 更容易看到问题。"

    _550w_help_step "5" "第五招:看日志"
    _550w_help_cmd "550w-plugin-logs 插件名"
    print ""
    print "  查看插件自己写的 _plugin_log 记录。"

    _550w_help_step "6" "第六招:看详情"
    _550w_help_cmd "550w-plugin-info 插件名"
    print ""
    print "  显示:"
    print "    · 元数据(有没有拼错)"
    print "    · 依赖(命令是否装)"
    print "    · 钩子(声明和函数是否匹配)"
    print "    · 函数列表"

    _550w_help_step "7" "第七招:调试模式"
    print "  main.zsh 里加:"
    print -P "  %F{${_550w_C[dim]}}set -x   # 开始调试%f"
    print -P "  %F{${_550w_C[dim]}}你的代码%f"
    print -P "  %F{${_550w_C[dim]}}set +x   # 关闭调试%f"
    print ""
    print "  会打印每一行执行的命令。"

    _550w_help_step "8" "第八招:检查环境变量"
    print "  main.zsh 里:"
    print -P "  %F{${_550w_C[dim]}}print \"SELF=\$_550W_PLUGIN_SELF\" >&2%f"
    print -P "  %F{${_550w_C[dim]}}print \"CURRENT=\$_550W_PLUGIN_CURRENT\" >&2%f"
    print ""
    print "  加载后看 stderr。"

    _550w_help_step "9" "常见错误速查"
    print -P "  %F{${_550w_C[err]}}✗ 跳过(缺命令: xxx)%f"
    print "    装: pkg install xxx"
    print ""
    print -P "  %F{${_550w_C[err]}}✗ 跳过(缺插件: xxx)%f"
    print "    装依赖插件 或 删 @depends 行"
    print ""
    print -P "  %F{${_550w_C[err]}}✗ 语法错误%f"
    print "    zsh -n 检查"
    print ""
    print -P "  %F{${_550w_C[err]}}✗ 加载失败%f"
    print "    手动 source 看真实错误"
    print ""
    print -P "  %F{${_550w_C[err]}}✗ 命令找不到%f"
    print "    插件加载了吗? 550w-plugins 看"
    print ""
    print -P "  %F{${_550w_C[err]}}✗ 钩子不执行%f"
    print "    函数名规则: _550w_plugin_hook_<插件名>_<钩子名>"

    _550w_help_step "10" "实战: 插件无法加载"
    print "  症状: 550w-plugins 显示 ○ 未加载"
    print ""
    print "  流程:"
    print "    ① 550w-plugin-errors 看原因"
    print "    ② zsh -n main.zsh 查语法"
    print "    ③ source main.zsh 手动跑"
    print "    ④ 550w-plugin-info 看依赖"
    print "    ⑤ 检查 .disabled 标记"
    print "    ⑥ 550w-plugin-reload 重载"

    _550w_help_step "11" "实战: 钩子不触发"
    print "  症状: 声明了 @hook: login, 但登录后没输出"
    print ""
    print "  流程:"
    print "    ① 函数名 = _550w_plugin_hook_<插件名>_<钩子名>"
    print "    ② 550w-plugin-hooks 查看注册"
    print "    ③ main.zsh 里手动调用试试"
    print "    ④ 检查 _550W_SKIP / 静默模式"

    _550w_help_step "12" "实战: 函数冲突"
    print "  症状: 你定义的函数被别的插件覆盖"
    print ""
    print "  排查:"
    print -P "  %F{${_550w_C[dim]}}grep '^550w-xxx()' ~/.550w/扩展/*/main.zsh%f"
    print ""
    print "  避免: 函数名加插件前缀"
    print "    不好: 550w-run"
    print "    好:   550w-weather-run"

    _550w_help_step "13" "孤立测试"
    print "  临时禁用所有其它插件:"
    print -P "  %F{${_550w_C[dim]}}for d in ~/.550w/扩展/*/; do%f"
    print -P "  %F{${_550w_C[dim]}}    [[ \"\$d\" != *weather* ]] && touch \"\${d}.disabled\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"
    print -P "  %F{${_550w_C[dim]}}unset _550W_LOADED && source ~/.zshrc%f"

    _550w_help_step "14" "工具箱"
    print "  所有调试命令汇总:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugins" "状态"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-errors" "错误"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-info [名]" "详情"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-logs [名]" "日志"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-hooks" "钩子"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "550w-plugin-reload [名]" "重载"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550W_C[ok]}" "zsh -n main.zsh" "语法"

    _550w_help_divider
    print -P "  %F{${_550W_C[ok]}}%B✓ 完成%b%f  调试会用了"
    _550w_help_pause
}
# ══════════════════ 节 15 · 示例1: hello ══════════════════

_550w_help_p15() {
    _550w_help_head "插件专章 · 节 15" "示例1: hello(20 行)"
    _550w_help_goal "最简单的完整插件"
    _550w_help_cost "3 分钟" "★☆☆☆☆"

    _550w_help_step "1" "完整代码"
    print "  ~/.550w/扩展/hello/main.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# @name: hello%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 打个招呼%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550w_C[dim]}}    local name=\"\${1:-世界}\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"你好, \$name!\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-hello-time() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"现在: \$(date '+%Y-%m-%d %H:%M:%S')\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "2" "逐行解释"
    print "  # @name: hello      显示名"
    print "  # @version: 1.0.0   版本"
    print "  # @author: Trans    作者"
    print "  # @desc: 打个招呼   说明"
    print "  550w-hello() { }    定义函数"
    print "  local name=\"\${1:-世界}\""
    print "    拿第 1 个参数, 没给就用'世界'"
    print "  print \"你好, \$name!\""
    print "    打印"

    _550w_help_step "3" "安装并使用"
    _550w_help_cmd "550w-plugin-new hello"
    _550w_help_cmd "nano ~/.550w/扩展/hello/main.zsh   # 粘代码"
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_cmd "550w-hello"
    _550w_help_cmd "550w-hello Trans"
    _550w_help_cmd "550w-hello-time"

    _550w_help_step "4" "加配置"
    print "  ~/.550w/扩展/hello/config.zsh:"
    print -P "  %F{${_550w_C[dim]}}typeset -g HELLO_PREFIX=\"你好\"%f"
    print ""
    print "  main.zsh 顶部加:"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print ""
    print "  hello 函数改:"
    print -P "  %F{${_550w_C[dim]}}print \"\$HELLO_PREFIX, \$name!\"%f"

    _550w_help_step "5" "加日志"
    print -P "  %F{${_550w_C[dim]}}550w-hello() {%f"
    print -P "  %F{${_550w_C[dim]}}    local name=\"\${1:-世界}\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"hello: \$name\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"你好, \$name!\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    _550w_help_cmd "550w-plugin-logs hello"

    _550w_help_step "6" "加钩子"
    print "  顶部加:"
    print -P "  %F{${_550w_C[dim]}}# @hook: login%f"
    print ""
    print "  文件末尾加:"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_hello_login() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"[hello] 加载成功\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  下次登录后自动执行。"

    _550w_help_step "7" "测试并打包"
    _550w_help_cmd "550w-plugin-reload hello"
    _550w_help_cmd "550w-hello 测试"
    _550w_help_cmd "550w-plugin-pack hello"

    _550w_help_tip "hello 插件是最小可用模板"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  最简单的插件掌握了"
    _550w_help_pause
}

# ══════════════════ 节 16 · 示例2: weather ══════════════════

_550w_help_p16() {
    _550w_help_head "插件专章 · 节 16" "示例2: weather(40 行)"
    _550w_help_goal "用 AI 做天气查询"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "思路"
    print "  不用自己调天气 API(要注册 Key)。"
    print "  直接让 MOSS AI 回答, 简单粗暴。"

    _550w_help_step "2" "完整代码"
    print "  ~/.550w/扩展/weather/main.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# @name: 天气%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 用 AI 查天气%f"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-weather() {%f"
    print -P "  %F{${_550w_C[dim]}}    local city=\"\${1:-\$(_plugin_config_get city \"\$WEATHER_DEFAULT_CITY\")}\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"查询: \$city\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"🌤  查询 \$city 天气...\"%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_moss_chat \"用一句话说 \$city 今天的天气\"%f"
    print -P "  %F{${_550w_C[dim]}}    if [[ -n \"\$_550W_MOSS_REPLY\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}        print \"\$city: \$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550w_C[dim]}}    else%f"
    print -P "  %F{${_550w_C[dim]}}        print \"查询失败(MOSS 未配置?)\"%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-weather-set() {%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -z \"\$1\" ]] && {%f"
    print -P "  %F{${_550w_C[dim]}}        print \"当前默认: \$(_plugin_config_get city \"\$WEATHER_DEFAULT_CITY\")\"%f"
    print -P "  %F{${_550w_C[dim]}}        return%f"
    print -P "  %F{${_550w_C[dim]}}    }%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_config_set city \"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"默认城市: \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-weather-help() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"用法:\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-weather [城市]     查天气\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-weather-set 北京   设默认城市\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "3" "config.zsh"
    print "  ~/.550w/扩展/weather/config.zsh:"
    print -P "  %F{${_550w_C[dim]}}typeset -g WEATHER_DEFAULT_CITY=\"北京\"%f"

    _550w_help_step "4" "测试"
    _550w_help_cmd "550w-plugin-reload weather"
    _550w_help_cmd "550w-weather"
    _550w_help_cmd "550w-weather 上海"
    _550w_help_cmd "550w-weather-set 广州"
    _550w_help_cmd "550w-weather"
    _550w_help_cmd "550w-weather-help"

    _550w_help_step "5" "查看日志和配置"
    _550w_help_cmd "550w-plugin-logs weather"
    _550w_help_cmd "550w-plugin-config weather"

    _550w_help_step "6" "依赖说明"
    print "  # @requires: curl  → 加载时检查 curl"
    print "  MOSS 本身依赖 curl, 所以 curl 缺失时:"
    print "    ① 插件跳过加载"
    print "    ② 缺 curl 时 MOSS 也禁用"
    print ""
    print "  检查 MOSS:"
    _550w_help_cmd "550w-moss"

    _550w_help_step "7" "优化: 加错误提示"
    print "  想让缺 MOSS 时提示清楚:"
    print -P "  %F{${_550w_C[dim]}}550w-weather() {%f"
    print -P "  %F{${_550w_C[dim]}}    if (( ! _550W_MOSS_ENABLED )); then%f"
    print -P "  %F{${_550w_C[dim]}}        print \"MOSS 未启用: 550w-settings → 6 → 1\"%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}    ...%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "打包分享"
    _550w_help_cmd "550w-plugin-pack weather"
    print ""
    print "  分享给别人后对方:"
    _550w_help_cmd "550w-plugin-install weather-xxx.tar.gz"
    _550w_help_cmd "550w-plugin-reload"

    _550w_help_tip "这插件简单但实用, 适合分享入门"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  你写了实用插件"
    _550w_help_pause
}
# ══════════════════ 节 17 · 示例3: todo ══════════════════

_550w_help_p17() {
    _550w_help_head "插件专章 · 节 17" "示例3: todo(60 行)"
    _550w_help_goal "带子命令的插件"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "需求"
    print "  550w-todo add 买牛奶"
    print "  550w-todo list"
    print "  550w-todo done 2"
    print "  550w-todo del 3"
    print "  550w-todo clear"

    _550w_help_step "2" "完整代码"
    print "  ~/.550w/扩展/todo/main.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# @name: TODO%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 待办清单%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-todo() {%f"
    print -P "  %F{${_550w_C[dim]}}    local cmd=\"\${1:-list}\"%f"
    print -P "  %F{${_550w_C[dim]}}    local file=\"\$_TODO_FILE\"%f"
    print -P "  %F{${_550w_C[dim]}}    case \"\$cmd\" in%f"
    print -P "  %F{${_550w_C[dim]}}        add)   shift; _550w_todo_add \"\$*\" \"\$file\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        list)  _550w_todo_list \"\$file\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        done)  shift; _550w_todo_done \"\$1\" \"\$file\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        del)   shift; _550w_todo_del \"\$1\" \"\$file\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        clear) _550w_todo_clear \"\$file\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        help)  _550w_todo_help ;;%f"
    print -P "  %F{${_550w_C[dim]}}        *)     print \"未知: \$cmd\"; _550w_todo_help ;;%f"
    print -P "  %F{${_550w_C[dim]}}    esac%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_add() {%f"
    print -P "  %F{${_550w_C[dim]}}    local text=\"\$1\" file=\"\$2\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -z \"\$text\" ]] && { print \"用法: 550w-todo add 内容\"; return 1; }%f"
    print -P "  %F{${_550w_C[dim]}}    print \"[ ] \$text\" >> \"\$file\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"添加: \$text\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"✓ 已添加\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_list() {%f"
    print -P "  %F{${_550w_C[dim]}}    local file=\"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -f \"\$file\" ]] || { print \"(空)\"; return 0; }%f"
    print -P "  %F{${_550w_C[dim]}}    local i=0 line%f"
    print -P "  %F{${_550w_C[dim]}}    while IFS= read -r line; do%f"
    print -P "  %F{${_550w_C[dim]}}        (( i++ ))%f"
    print -P "  %F{${_550w_C[dim]}}        printf '  [%2d] %s\\n' \"\$i\" \"\$line\"%f"
    print -P "  %F{${_550w_C[dim]}}    done < \"\$file\"%f"
    print -P "  %F{${_550w_C[dim]}}    (( i == 0 )) && print \"(空)\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_done() {%f"
    print -P "  %F{${_550w_C[dim]}}    local n=\"\$1\" file=\"\$2\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ \"\$n\" =~ '^[0-9]+$' ]] || { print \"用法: 550w-todo done N\"; return 1; }%f"
    print -P "  %F{${_550w_C[dim]}}    sed -i \"\${n}s/^\\[ \\]/[x]/\" \"\$file\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"完成: \$n\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"✓ 标记完成\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_del() {%f"
    print -P "  %F{${_550w_C[dim]}}    local n=\"\$1\" file=\"\$2\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ \"\$n\" =~ '^[0-9]+$' ]] || { print \"用法: 550w-todo del N\"; return 1; }%f"
    print -P "  %F{${_550w_C[dim]}}    sed -i \"\${n}d\" \"\$file\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"删除: \$n\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"✓ 已删除\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_clear() {%f"
    print -P "  %F{${_550w_C[dim]}}    : > \"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"清空\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"✓ 已清空\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_todo_help() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"用法:\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-todo add 内容     添加\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-todo list         列出\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-todo done N       完成第 N 条\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-todo del N        删除第 N 条\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-todo clear        清空\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "3" "config.zsh"
    print -P "  %F{${_550w_C[dim]}}typeset -g _TODO_FILE=\"\${_550W_PLUGIN_SELF}/todo.txt\"%f"

    _550w_help_step "4" "测试"
    _550w_help_cmd "550w-plugin-reload todo"
    _550w_help_cmd "550w-todo add 买牛奶"
    _550w_help_cmd "550w-todo add 写代码"
    _550w_help_cmd "550w-todo add 看文档"
    _550w_help_cmd "550w-todo list"
    _550w_help_cmd "550w-todo done 2"
    _550w_help_cmd "550w-todo list"
    _550w_help_cmd "550w-todo del 1"
    _550w_help_cmd "550w-todo list"

    _550w_help_step "5" "数据存放"
    print -P "  %F{${_550w_C[dim]}}~/.550w/扩展/todo/todo.txt%f"
    print ""
    print "  格式:"
    print -P "  %F{${_550w_C[dim]}}[ ] 买牛奶%f"
    print -P "  %F{${_550w_C[dim]}}[x] 写代码%f"
    print -P "  %F{${_550w_C[dim]}}[ ] 看文档%f"

    _550w_help_step "6" "查看日志"
    _550w_help_cmd "550w-plugin-logs todo"

    _550w_help_step "7" "打包分享"
    _550w_help_cmd "550w-plugin-pack todo"
    print ""
    print "  先清空 todo.txt 再打包:"
    _550w_help_cmd ": > ~/.550w/扩展/todo/todo.txt"
    _550w_help_cmd "550w-plugin-pack todo"

    _550w_help_tip "这就是一个完整可用的 TODO 管理器"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  你写了子命令插件"
    _550w_help_pause
}

# ══════════════════ 节 18 · 示例4: 时钟(钩子) ══════════════════

_550w_help_p18() {
    _550w_help_head "插件专章 · 节 18" "示例4: 时钟(50 行)"
    _550w_help_goal "用钩子自动报时"
    _550w_help_cost "6 分钟" "★★★☆☆"

    _550w_help_step "1" "需求"
    print "  每条命令前显示当前时间。"
    print "  可选开/关。"

    _550w_help_step "2" "完整代码"
    print "  ~/.550w/扩展/clock/main.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# @name: 时钟%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 命令前显示时间%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: precmd%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}# 开关状态(运行时变量, 不持久化)%f"
    print -P "  %F{${_550w_C[dim]}}typeset -g _CLOCK_ENABLED=1%f"
    print -P "  %F{${_550w_C[dim]}}typeset -g _CLOCK_LAST=\"\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-clock() {%f"
    print -P "  %F{${_550w_C[dim]}}    case \"\${1:-status}\" in%f"
    print -P "  %F{${_550w_C[dim]}}        on)  _CLOCK_ENABLED=1; print \"时钟: 开\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        off) _CLOCK_ENABLED=0; print \"时钟: 关\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        status) print \"时钟: \$([[ \$_CLOCK_ENABLED == 1 ]] && echo 开 || echo 关)\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        show) print \"现在: \$(date '+%Y-%m-%d %H:%M:%S')\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        *) _550w_clock_help ;;%f"
    print -P "  %F{${_550w_C[dim]}}    esac%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_clock_help() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"用法:\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-clock on|off|status|show\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}# 钩子函数(名字规则: _550w_plugin_hook_<插件名>_<钩子名>)%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_clock_precmd() {%f"
    print -P "  %F{${_550w_C[dim]}}    (( _CLOCK_ENABLED )) || return 0%f"
    print -P "  %F{${_550w_C[dim]}}    local now=\$(date '+%H:%M:%S')%f"
    print -P "  %F{${_550w_C[dim]}}    [[ \"\$now\" == \"\$_CLOCK_LAST\" ]] && return 0%f"
    print -P "  %F{${_550w_C[dim]}}    _CLOCK_LAST=\"\$now\"%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"%F{240}[\$now]%f\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "3" "config.zsh"
    print -P "  %F{${_550w_C[dim]}}# clock 插件的配置(可空)%f"

    _550w_help_step "4" "重载测试"
    _550w_help_cmd "550w-plugin-reload clock"
    _550w_help_cmd "550w-clock status"
    _550w_help_cmd "550w-clock show"
    print ""
    print "  然后随便敲个命令:"
    _550w_help_cmd "ls"
    print "  会看到命令前多了 [时间]"

    _550w_help_step "5" "关闭钩子"
    _550w_help_cmd "550w-clock off"
    _550w_help_cmd "ls"
    print "  这次没时间前缀了。"

    _550w_help_step "6" "理解钩子原理"
    print "  1) @hook: precmd 声明"
    print "  2) 加载器扫描到 → 注册函数到 zsh"
    print "  3) 每次命令前 zsh 自动调用"
    print "  4) 函数内检查开关, 决定打印"

    _550w_help_step "7" "防止每次都打"
    print "  用 _CLOCK_LAST 记住上次秒数。"
    print "  同一秒内多次调用只打一次。"

    _550w_help_step "8" "查看已注册钩子"
    _550w_help_cmd "550w-plugin-hooks"
    print ""
    print "  会看到:"
    print "    clock  →  precmd  →  _550w_plugin_hook_clock_precmd"

    _550w_help_step "9" "关闭时的替代"
    print "  想短暂禁用:"
    _550w_help_cmd "550w-clock off"
    print ""
    print "  想永久禁用:"
    _550w_help_cmd "550w-plugin-disable clock"
    _550w_help_cmd "550w-plugin-reload"

    _550w_help_step "10" "打包"
    _550w_help_cmd "550w-plugin-pack clock"

    _550w_help_tip "钩子适合做'自动行为', 但别在钩子里做耗时操作"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  你写了带钩子的插件"
    _550w_help_pause
}
# ══════════════════ 节 19 · 示例5: 系统监控 ══════════════════

_550w_help_p19() {
    _550w_help_head "插件专章 · 节 19" "示例5: 系统监控(80 行)"
    _550w_help_goal "读真实硬件数据 + 配置 + 日志"
    _550w_help_cost "10 分钟" "★★★★☆"

    _550w_help_step "1" "需求"
    print "  550w-mon          显示 CPU/内存/温度/磁盘"
    print "  550w-mon cpu      只看 CPU"
    print "  550w-mon mem      只看内存"
    print "  550w-mon temp     只看温度"
    print "  550w-mon watch N  每 N 秒刷新(按 Ctrl+C 退出)"

    _550w_help_step "2" "完整代码"
    print "  ~/.550w/扩展/mon/main.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# @name: 监控%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 系统监控%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-mon() {%f"
    print -P "  %F{${_550w_C[dim]}}    local cmd=\"\${1:-all}\"%f"
    print -P "  %F{${_550w_C[dim]}}    case \"\$cmd\" in%f"
    print -P "  %F{${_550w_C[dim]}}        all)  _550w_mon_cpu; _550w_mon_mem; _550w_mon_temp; _550w_mon_disk ;;%f"
    print -P "  %F{${_550w_C[dim]}}        cpu)  _550w_mon_cpu ;;%f"
    print -P "  %F{${_550w_C[dim]}}        mem)  _550w_mon_mem ;;%f"
    print -P "  %F{${_550w_C[dim]}}        temp) _550w_mon_temp ;;%f"
    print -P "  %F{${_550w_C[dim]}}        disk) _550w_mon_disk ;;%f"
    print -P "  %F{${_550w_C[dim]}}        watch) shift; _550w_mon_watch \"\${1:-2}\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}        *)    _550w_mon_help ;;%f"
    print -P "  %F{${_550w_C[dim]}}    esac%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_cpu() {%f"
    print -P "  %F{${_550w_C[dim]}}    local freq=\$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    local maxf=\$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    local gov=\$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    local cores=\$(ls -d /sys/devices/system/cpu/cpu[0-9]* 2>/dev/null | wc -l | tr -d ' ')%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"%F{51}▸ CPU%f\"%f"
    print -P "  %F{${_550w_C[dim]}}    printf '  %-8s %s 核\\n' \"核心\" \"\$cores\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -n \"\$freq\" ]] && printf '  %-8s %s MHz\\n' \"当前\" \"\$((freq/1000))\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -n \"\$maxf\" ]] && printf '  %-8s %s MHz\\n' \"最大\" \"\$((maxf/1000))\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -n \"\$gov\" ]] && printf '  %-8s %s\\n' \"调度器\" \"\$gov\"%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"CPU: \${freq}Hz gov=\$gov\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_mem() {%f"
    print -P "  %F{${_550w_C[dim]}}    local total=\$(grep -m1 '^MemTotal:' /proc/meminfo | awk '{print \$2}')%f"
    print -P "  %F{${_550w_C[dim]}}    local avail=\$(grep -m1 '^MemAvailable:' /proc/meminfo | awk '{print \$2}')%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"%F{51}▸ 内存%f\"%f"
    print -P "  %F{${_550w_C[dim]}}    awk -v t=\"\$total\" -v a=\"\$avail\" 'BEGIN{%f"
    print -P "  %F{${_550w_C[dim]}}        printf \"  %-8s %.2f GiB\\n\", \"总量\", t/1048576%f"
    print -P "  %F{${_550w_C[dim]}}        printf \"  %-8s %.2f GiB\\n\", \"可用\", a/1048576%f"
    print -P "  %F{${_550w_C[dim]}}        printf \"  %-8s %.1f%%\\n\", \"使用率\", (t-a)*100/t%f"
    print -P "  %F{${_550w_C[dim]}}    }'%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_temp() {%f"
    print -P "  %F{${_550w_C[dim]}}    local max=0 t z%f"
    print -P "  %F{${_550w_C[dim]}}    for z in /sys/class/thermal/thermal_zone*/temp; do%f"
    print -P "  %F{${_550w_C[dim]}}        t=\$(cat \"\$z\" 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}        [[ \"\$t\" =~ '^[0-9]+$' ]] || continue%f"
    print -P "  %F{${_550w_C[dim]}}        (( t > max )) && max=\$t%f"
    print -P "  %F{${_550w_C[dim]}}    done%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"%F{51}▸ 温度%f\"%f"
    print -P "  %F{${_550w_C[dim]}}    if (( max > 0 )); then%f"
    print -P "  %F{${_550w_C[dim]}}        awk -v x=\"\$max\" 'BEGIN{printf \"  %-8s %.1f°C\\n\", \"最高\", x/1000}'%f"
    print -P "  %F{${_550w_C[dim]}}    else%f"
    print -P "  %F{${_550w_C[dim]}}        print \"  无传感器\"%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_disk() {%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"%F{51}▸ 磁盘%f\"%f"
    print -P "  %F{${_550w_C[dim]}}    df -h \"\$HOME\" 2>/dev/null | awk 'NR==2{printf \"  %-8s %s\\n  %-8s %s\\n  %-8s %s\\n\", \"总量\", \$2, \"已用\", \$3, \"剩余\", \$4}'%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_watch() {%f"
    print -P "  %F{${_550w_C[dim]}}    local secs=\"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    while true; do%f"
    print -P "  %F{${_550w_C[dim]}}        clear%f"
    print -P "  %F{${_550w_C[dim]}}        print \"刷新间隔: \${secs}s (Ctrl+C 退出)\"%f"
    print -P "  %F{${_550w_C[dim]}}        print \"\"%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_mon_cpu%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_mon_mem%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_mon_temp%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_mon_disk%f"
    print -P "  %F{${_550w_C[dim]}}        sleep \"\$secs\"%f"
    print -P "  %F{${_550w_C[dim]}}    done%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_mon_help() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"用法:\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-mon              全部\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-mon cpu|mem|temp|disk\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"  550w-mon watch [秒]   持续刷新\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "3" "config.zsh"
    print -P "  %F{${_550w_C[dim]}}# mon 插件配置(可空)%f"

    _550w_help_step "4" "测试"
    _550w_help_cmd "550w-plugin-reload mon"
    _550w_help_cmd "550w-mon"
    _550w_help_cmd "550w-mon cpu"
    _550w_help_cmd "550w-mon temp"
    _550w_help_cmd "550w-mon watch 2"
    print "  Ctrl+C 退出 watch。"

    _550w_help_step "5" "数据来源"
    print "  · CPU 频率: /sys/devices/system/cpu/cpu0/cpufreq/"
    print "  · 内存:    /proc/meminfo"
    print "  · 温度:    /sys/class/thermal/thermal_zone*/temp"
    print "  · 磁盘:    df -h"
    print ""
    print "  所有真实数据。"

    _550w_help_step "6" "查看日志"
    _550w_help_cmd "550w-plugin-logs mon"
    print "  每次调用 CPU 都会记日志。"

    _550w_help_step "7" "打包"
    _550w_help_cmd "550w-plugin-pack mon"

    _550w_help_tip "mon 插件展示了'读真实系统 + 子命令 + 钩子'的完整模式"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  高级插件会写了"
    _550w_help_pause
}

# ══════════════════ 节 20 · 最佳实践 ══════════════════

_550w_help_p20() {
    _550w_help_head "插件专章 · 节 20" "最佳实践"
    _550w_help_goal "写出高质量可维护的插件"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "命名"
    print "  函数名: 550w-<插件名> 或 550w-<插件名>-<功能>"
    print "    ✓ 550w-weather"
    print "    ✓ 550w-weather-set"
    print "    ✗ weather(无前缀)"
    print "    ✗ 550w-w(太短, 易冲突)"
    print ""
    print "  变量名: 加插件前缀"
    print "    ✓ WEATHER_CITY / _WEATHER_CACHE"

    _550w_help_step "2" "元数据"
    print "  顶部必写:"
    print "    # @name: 显示名"
    print "    # @version: 1.0.0"
    print "    # @desc: 一句话"
    print ""
    print "  按需:"
    print "    # @author: xxx"
    print "    # @requires: curl jq"
    print "    # @depends: tools"
    print "    # @hook: login"
    print ""
    print "  中间不留空行, 否则截断。"

    _550w_help_step "3" "错误处理"
    print "  ✗ 不好:"
    print -P "  %F{${_550w_C[dim]}}550w-foo() {%f"
    print -P "  %F{${_550w_C[dim]}}    curl https://xxx%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  ✓ 好:"
    print -P "  %F{${_550w_C[dim]}}550w-foo() {%f"
    print -P "  %F{${_550w_C[dim]}}    local out%f"
    print -P "  %F{${_550w_C[dim]}}    out=\$(curl -s --max-time 5 https://xxx 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}    if [[ -z \"\$out\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}        _plugin_log error \"请求失败\"%f"
    print -P "  %F{${_550w_C[dim]}}        print \"失败\" >&2%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    fi%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\$out\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "4" "参数处理"
    print -P "  %F{${_550w_C[dim]}}550w-foo() {%f"
    print -P "  %F{${_550w_C[dim]}}    local arg1=\"\$1\"%f"
    print -P "  %F{${_550w_C[dim]}}    local arg2=\"\${2:-默认}\"%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -z \"\$arg1\" ]] && {%f"
    print -P "  %F{${_550w_C[dim]}}        print \"用法: 550w-foo <参数>\" >&2%f"
    print -P "  %F{${_550w_C[dim]}}        return 1%f"
    print -P "  %F{${_550w_C[dim]}}    }%f"
    print -P "  %F{${_550w_C[dim]}}    ...%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "5" "配置 vs 硬编码"
    print "  ✗ 硬编码:"
    print -P "  %F{${_550w_C[dim]}}local city=\"北京\"%f"
    print ""
    print "  ✓ 配置(默认北京):"
    print -P "  %F{${_550w_C[dim]}}local city=\$(_plugin_config_get city \"北京\")%f"

    _550w_help_step "6" "日志"
    print "  关键动作写日志:"
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"操作开始: \$1\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log error \"失败原因: xxx\"%f"
    print ""
    print "  别写敏感信息:"
    print "    ✗ API Key / 密码 / 完整 URL"

    _550w_help_step "7" "钩子"
    print "  命名: _550w_plugin_hook_<插件名>_<钩子名>"
    print "  precmd / preexec 里别耗时。"
    print "  用状态变量防重复输出。"

    _550w_help_step "8" "依赖"
    print "  @requires 只列真正需要的命令。"
    print "  @depends 尽量少用(依赖是负担)。"
    print "  容错降级: 有 jq 用, 无则 sed。"

    _550w_help_step "9" "目录组织"
    print "  简单插件: 只 main.zsh"
    print "  中等:     main.zsh + config.zsh"
    print "  复杂:     main.zsh + config.zsh + helper.zsh + data/"
    print ""
    print "  helper.zsh 在 main.zsh 里 source:"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/helper.zsh\"%f"

    _550w_help_step "10" "测试清单"
    print "  提交前测试:"
    print "    □ zsh -n main.zsh         语法"
    print "    □ 550w-plugin-reload      加载"
    print "    □ 每个函数手工跑一遍"
    print "    □ 边界: 空参数, 错参数"
    print "    □ 550w-plugin-errors      无错误"
    print "    □ 550w-plugin-logs        有日志"

    _550w_help_step "11" "分享前"
    print "  □ 清空 log/ 目录"
    print "  □ 清空 config/ 目录"
    print "  □ 检查没有敏感信息"
    print "  □ 写 README.md"
    print "  □ 550w-plugin-pack 打包"

    _550w_help_step "12" "常见反模式"
    print "  ✗ 函数名无前缀(污染全局)"
    print "  ✗ 在 $() 里调 _550w_moss_chat(全局变量丢)"
    print "  ✗ precmd 里发 HTTP(卡每条命令)"
    print "  ✗ 硬编码路径"
    print "  ✗ 无错误处理"
    print "  ✗ 循环依赖"
    print "  ✗ 写敏感信息到日志"

    _550w_help_step "13" "性能建议"
    print "  · 用 local 避免污染"
    print "  · 循环用 (( )) 而非 \$(( ))"
    print "  · 大量文本用 awk 而非循环"
    print "  · 缓存重复调用"
    print "  · 避免子 shell"

    _550w_help_step "14" "版本管理"
    print "  语义化: 主.次.补丁"
    print "    1.0.0 → 1.0.1   修复"
    print "    1.0.0 → 1.1.0   新功能"
    print "    1.0.0 → 2.0.0   破坏性改"
    print ""
    print "  改版本时同步改 main.zsh 顶部 @version。"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  插件专章 20 节全部学完"
    print ""
    print -P "  %F{${_550W_C[cyan]}}继续:%f 主菜单 → 6 动画专章"
    _550w_help_pause
}
# ══════════════════ 动画专章 · 主菜单 ══════════════════

_550w_help_menu_anim() {
    while true; do
        _550w_help_head "动画专章" "234 个动画函数指南"
        print ""
        _550w_help_row "1"  "总览"     "10 个分类介绍"
        _550w_help_row "2"  "基础"     "打字/淡入/滑动/缩放"
        _550w_help_row "3"  "强调"     "抖动/脉冲/呼吸/扫描"
        _550w_help_row "4"  "故障风"   "glitch/雪花/撕裂/VHS"
        _550w_help_row "5"  "进度旋转" "进度条/旋转器"
        _550w_help_row "6"  "波形频谱" "波浪/ECG/频谱"
        _550w_help_row "7"  "图表拓扑" "条形图/拓扑/神经网络"
        _550w_help_row "8"  "编解码"   "二进制/hex/base64"
        _550w_help_row "9"  "密码学"   "AES/RSA/量子"
        _550w_help_row "10" "参数调优" "延迟/SKIP/颜色"
        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_a01 ;;
            2) _550w_help_a02 ;;
            3) _550w_help_a03 ;;
            4) _550w_help_a04 ;;
            5) _550w_help_a05 ;;
            6) _550w_help_a06 ;;
            7) _550w_help_a07 ;;
            8) _550w_help_a08 ;;
            9) _550w_help_a09 ;;
            10) _550w_help_a10 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_a01() {
    _550w_help_head "动画专章 · 总览" "234 个函数 · 10 分类"
    print ""
    printf '  \e[38;5;%sm[ 1]\e[0m 基础动画      20 个  打字/淡入/滑动/缩放/旋转/翻转\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 2]\e[0m 强调动效      20 个  抖动/脉冲/呼吸/闪烁/扫描/边框\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 3]\e[0m 故障风        20 个  glitch/雪花/撕裂/RGB分离/VHS/CRT\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 4]\e[0m 进度旋转      12 个  进度条 5 种 + 旋转器 5 种\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 5]\e[0m 波形频谱      10 个  波浪/ECG/频谱/音频可视化\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 6]\e[0m 图表拓扑      30 个  条形/饼/折线/散点/热力/树/桑基/拓扑\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 7]\e[0m 编解码        14 个  二进制/hex/base64/哈希/MD5\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 8]\e[0m 密码学        30 个  AES/RSA/ECC/证书链/量子\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 9]\e[0m 神经网络      30 个  CNN/RNN/Transformer/GAN\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[10]\e[0m 机器学习      20 个  K-means/PCA/损失曲线\n' "${_550W_C[cyan]}"
    print ""
    print -P "  %F{${_550W_C[dim]}}调用方式: _550w_anim_xxx [参数]%f"
    print -P "  %F{${_550W_C[dim]}}交互浏览: 550w-anim%f"
    print ""
    _550w_help_pause
}

_550w_help_a02() {
    _550w_help_head "动画专章 · 基础" "20 个"
    print "  打字机:"
    printf '  %-30s %s\n' "_550w_anim_typing_v1 文本 [延迟]" "普通逐字"
    printf '  %-30s %s\n' "_550w_anim_typing_v2 文本 [延迟]" "带光标闪烁"
    printf '  %-30s %s\n' "_550w_anim_typing_v3 文本 [延迟]" "带错字回退"
    print ""
    print "  淡入淡出:"
    printf '  %-30s %s\n' "_550w_anim_fade_in 文本" "淡入"
    printf '  %-30s %s\n' "_550w_anim_fade_out 文本" "淡出"
    print ""
    print "  进出场:"
    printf '  %-30s %s\n' "_550w_anim_slide_in 文本" "滑动进入"
    printf '  %-30s %s\n' "_550w_anim_zoom_in 文本" "放大"
    printf '  %-30s %s\n' "_550w_anim_zoom_out 文本" "缩小"
    print ""
    print "  旋转:"
    printf '  %-30s %s\n' "_550w_anim_rotate 文本" "旋转"
    printf '  %-30s %s\n' "_550w_anim_flip 文本" "翻转"
    print ""
    print "  示例:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_typing_v2 \"BOOT\" 40%f"
    _550w_help_pause
}

_550w_help_a03() {
    _550w_help_head "动画专章 · 强调" "20 个"
    printf '  %-30s %s\n' "_550w_anim_shake 文本" "抖动"
    printf '  %-30s %s\n' "_550w_anim_pulse_text 文本" "脉冲"
    printf '  %-30s %s\n' "_550w_anim_breathe_text 文本" "呼吸"
    printf '  %-30s %s\n' "_550w_anim_blink 文本" "闪烁"
    printf '  %-30s %s\n' "_550w_anim_sweep_text 文本" "扫描"
    printf '  %-30s %s\n' "_550w_anim_wipe 文本" "擦除"
    printf '  %-30s %s\n' "_550w_anim_dissolve 文本" "溶解"
    printf '  %-30s %s\n' "_550w_anim_mosaic 文本" "马赛克"
    printf '  %-30s %s\n' "_550w_anim_pixelate 文本" "像素化"
    printf '  %-30s %s\n' "_550w_anim_border_flow 文本" "边框流动"
    printf '  %-30s %s\n' "_550w_anim_border_breathe 文本" "边框呼吸"
    printf '  %-30s %s\n' "_550w_anim_ant_line 文本" "蚂蚁线"
    printf '  %-30s %s\n' "_550w_anim_glow 文本" "光晕"
    printf '  %-30s %s\n' "_550w_anim_highlight 文本 N" "高亮第N字"
    printf '  %-30s %s\n' "_550w_anim_focus 文本" "聚焦"
    printf '  %-30s %s\n' "_550w_anim_ripple 文本" "波纹"
    printf '  %-30s %s\n' "_550w_anim_spiral 文本" "螺旋"
    printf '  %-30s %s\n' "_550w_anim_particles_gather 文本" "粒子汇聚"
    printf '  %-30s %s\n' "_550w_anim_particles_scatter 文本" "粒子扩散"
    printf '  %-30s %s\n' "_550w_anim_frame_shake 文本" "帧抖动"
    _550w_help_pause
}

_550w_help_a04() {
    _550w_help_head "动画专章 · 故障风" "20 个"
    printf '  %-30s %s\n' "_550w_anim_glitch_text_v2 文本" "glitch v2"
    printf '  %-30s %s\n' "_550w_anim_glitch_v3 文本 时长" "glitch v3"
    printf '  %-30s %s\n' "_550w_anim_snow" "雪花"
    printf '  %-30s %s\n' "_550w_anim_tear_v2 文本" "撕裂"
    printf '  %-30s %s\n' "_550w_anim_scan_offset 文本" "扫线偏移"
    printf '  %-30s %s\n' "_550w_anim_rgb_split 文本" "RGB 分离"
    printf '  %-30s %s\n' "_550w_anim_block_shift 文本" "色块错位"
    printf '  %-30s %s\n' "_550w_anim_jitter 文本" "抖动"
    printf '  %-30s %s\n' "_550w_anim_signal_lost 文本" "信号丢失"
    printf '  %-30s %s\n' "_550w_anim_corrupt 文本" "数据损坏"
    printf '  %-30s %s\n' "_550w_anim_hex_scramble 文本" "hex 乱码"
    printf '  %-30s %s\n' "_550w_anim_char_replace 文本" "字符替换"
    printf '  %-30s %s\n' "_550w_anim_freeze 文本" "屏幕冻结"
    printf '  %-30s %s\n' "_550w_anim_noise" "噪点"
    printf '  %-30s %s\n' "_550w_anim_h_stripes N" "水平条纹"
    printf '  %-30s %s\n' "_550w_anim_v_stripes N C" "垂直条纹"
    printf '  %-30s %s\n' "_550w_anim_interference 文本" "干扰波纹"
    printf '  %-30s %s\n' "_550w_anim_tape 文本" "磁带信号"
    printf '  %-30s %s\n' "_550w_anim_vhs 文本" "VHS 风格"
    printf '  %-30s %s\n' "_550w_anim_crt 文本" "CRT 弯曲"
    _550w_help_pause
}

_550w_help_a05() {
    _550w_help_head "动画专章 · 进度旋转" "12 个"
    print "  进度条:"
    printf '  %-30s %s\n' "_550w_anim_bar_basic [宽] [标签]" "普通"
    printf '  %-30s %s\n' "_550w_anim_bar_segmented [段] [标签]" "分段"
    printf '  %-30s %s\n' "_550w_anim_bar_multicolor [宽]" "彩色"
    printf '  %-30s %s\n' "_550w_anim_bar_dual [宽] [标签]" "双向"
    printf '  %-30s %s\n' "_550w_anim_bar_loop [宽] [标签]" "循环"
    print ""
    print "  旋转器:"
    printf '  %-30s %s\n' "_550w_anim_spinner_dot 标签" "点"
    printf '  %-30s %s\n' "_550w_anim_spinner_braille 标签" "盲文"
    printf '  %-30s %s\n' "_550w_anim_spinner_quarter 标签" "四分之一"
    printf '  %-30s %s\n' "_550w_anim_spinner_half 标签" "半圆"
    printf '  %-30s %s\n' "_550w_anim_spinner_arrow 标签" "箭头"
    print ""
    print "  其它:"
    printf '  %-30s %s\n' "_550w_anim_bars_grow 值..." "条形生长"
    printf '  %-30s %s\n' "_550w_anim_pie 值..." "饼图"
    _550w_help_pause
}

_550w_help_a06() {
    _550w_help_head "动画专章 · 波形频谱" "10 个"
    printf '  %-30s %s\n' "_550w_anim_wave_v2 [宽]" "波浪 v2"
    printf '  %-30s %s\n' "_550w_anim_wave_v3 [宽]" "波浪 v3"
    printf '  %-30s %s\n' "_550w_anim_spectrum_v2 [宽]" "频谱 v2"
    printf '  %-30s %s\n' "_550w_anim_spectrum_v3 [宽]" "频谱 v3"
    printf '  %-30s %s\n' "_550w_anim_ecg_v2 [宽]" "心电图 v2"
    printf '  %-30s %s\n' "_550w_anim_ecg_v3 [宽]" "心电图 v3"
    printf '  %-30s %s\n' "_550w_anim_audio_viz [宽]" "音频可视化"
    printf '  %-30s %s\n' "_550w_anim_wave_stack [宽]" "波形堆叠"
    printf '  %-30s %s\n' "_550w_anim_sound" "声波"
    printf '  %-30s %s\n' "_550w_anim_em_wave [宽]" "电磁波"
    _550w_help_pause
}

_550w_help_a07() {
    _550w_help_head "动画专章 · 图表拓扑" "30 个"
    print "  图表:"
    printf '  %-34s %s\n' "_550w_anim_chart_bar 值..." "条形图"
    printf '  %-34s %s\n' "_550w_anim_chart_bar_h 值..." "条形图(竖)"
    printf '  %-34s %s\n' "_550w_anim_chart_pie 值..." "饼图"
    printf '  %-34s %s\n' "_550w_anim_chart_line 值..." "折线图"
    printf '  %-34s %s\n' "_550w_anim_chart_scatter [行] [列]" "散点图"
    printf '  %-34s %s\n' "_550w_anim_chart_heatmap [行] [列]" "热力图"
    printf '  %-34s %s\n' "_550w_anim_chart_tree" "树图"
    printf '  %-34s %s\n' "_550w_anim_chart_sankey" "桑基图"
    printf '  %-34s %s\n' "_550w_anim_chart_force" "力导向"
    print ""
    print "  拓扑:"
    printf '  %-34s %s\n' "_550w_anim_topology_star" "星型"
    printf '  %-34s %s\n' "_550w_anim_topology_ring" "环形"
    printf '  %-34s %s\n' "_550w_anim_topology_mesh" "网格"
    printf '  %-34s %s\n' "_550w_anim_topology_tree" "树型"
    printf '  %-34s %s\n' "_550w_anim_topology_mixed" "混合"
    print ""
    print "  数据流:"
    printf '  %-34s %s\n' "_550w_anim_data_flow [宽]" "数据流动"
    printf '  %-34s %s\n' "_550w_anim_packet_v2 文本" "数据包"
    printf '  %-34s %s\n' "_550w_anim_bits [宽]" "比特流"
    printf '  %-34s %s\n' "_550w_anim_bytes [宽]" "字节流"
    print ""
    print "  神经网络/机器学习(节选):"
    printf '  %-34s %s\n' "_550w_anim_nn" "神经网络"
    printf '  %-34s %s\n' "_550w_anim_cnn" "CNN"
    printf '  %-34s %s\n' "_550w_anim_transformer" "Transformer"
    printf '  %-34s %s\n' "_550w_anim_gradient_descent" "梯度下降"
    printf '  %-34s %s\n' "_550w_anim_loss_curve" "损失曲线"
    printf '  %-34s %s\n' "_550w_anim_kmeans" "K-means"
    _550w_help_pause
}

_550w_help_a08() {
    _550w_help_head "动画专章 · 编解码" "14 个"
    printf '  %-30s %s\n' "_550w_anim_binary_v2 [行] [列]" "二进制流"
    printf '  %-30s %s\n' "_550w_anim_hex_v2 [行] [列]" "十六进制"
    printf '  %-30s %s\n' "_550w_anim_octal" "八进制"
    printf '  %-30s %s\n' "_550w_anim_base64" "Base64"
    printf '  %-30s %s\n' "_550w_anim_encode 文本" "编码演示"
    printf '  %-30s %s\n' "_550w_anim_decode 编码" "解码演示"
    printf '  %-30s %s\n' "_550w_anim_compress 文本" "压缩"
    printf '  %-30s %s\n' "_550w_anim_decompress 文本" "解压"
    printf '  %-30s %s\n' "_550w_anim_hash [行]" "哈希"
    printf '  %-30s %s\n' "_550w_anim_md5 文本" "MD5"
    printf '  %-30s %s\n' "_550w_anim_rng" "随机数"
    printf '  %-30s %s\n' "_550w_anim_entropy [宽]" "熵池"
    printf '  %-30s %s\n' "_550w_anim_bitstream [宽]" "比特流"
    printf '  %-30s %s\n' "_550w_anim_bytestream [宽]" "字节流"
    _550w_help_pause
}

_550w_help_a09() {
    _550w_help_head "动画专章 · 密码学" "30 个"
    printf '  %-30s %s\n' "_550w_anim_encrypt 文本" "加密"
    printf '  %-30s %s\n' "_550w_anim_decrypt_text 密文" "解密"
    printf '  %-30s %s\n' "_550w_anim_key_exchange" "密钥交换"
    printf '  %-30s %s\n' "_550w_anim_rsa" "RSA"
    printf '  %-30s %s\n' "_550w_anim_aes" "AES"
    printf '  %-30s %s\n' "_550w_anim_ecc" "椭圆曲线"
    printf '  %-30s %s\n' "_550w_anim_signature" "数字签名"
    printf '  %-30s %s\n' "_550w_anim_cert_chain" "证书链"
    printf '  %-30s %s\n' "_550w_anim_tsa" "时间戳"
    printf '  %-30s %s\n' "_550w_anim_qubit" "量子比特"
    printf '  %-30s %s\n' "_550w_anim_quantum_gate" "量子门"
    printf '  %-30s %s\n' "_550w_anim_entangle" "量子纠缠"
    printf '  %-30s %s\n' "_550w_anim_wavefunction [宽]" "波函数"
    printf '  %-30s %s\n' "_550w_anim_schrodinger" "薛定谔猫"
    printf '  %-30s %s\n' "_550w_anim_double_slit" "双缝干涉"
    printf '  %-30s %s\n' "_550w_anim_photon" "光子"
    printf '  %-30s %s\n' "_550w_anim_atom" "原子"
    printf '  %-30s %s\n' "_550w_anim_molecule" "分子"
    printf '  %-30s %s\n' "_550w_anim_lattice" "晶格"
    printf '  %-30s %s\n' "_550w_anim_band" "能带"
    print "  ...(共 30 个, 用 550w-anim → 9 浏览)"
    _550w_help_pause
}

_550w_help_a10() {
    _550w_help_head "动画专章 · 参数调优" "延迟/跳过/颜色"
    _550w_help_step "1" "延迟参数"
    print "  很多动画有 delay 参数:"
    print "    _550w_anim_typing_v2 \"文本\" 40"
    print "                                        ↑ 每字延迟毫秒"
    print ""
    print "  范围建议: 20~80"
    print "  · 20  很快"
    print "  · 40  标准"
    print "  · 80  慢"

    _550w_help_step "2" "宽度参数"
    print "  波形/频谱/进度条等有 width:"
    print "    _550w_anim_wave_v2 40"
    print "                         ↑ 40 字符宽"
    print ""
    print "  Termux 建议 30~50。"

    _550w_help_step "3" "跳过机制"
    print "  所有动画都会响应 _550W_SKIP:"
    print -P "  %F{${_550w_C[dim]}}_550W_SKIP=0    正常播放%f"
    print -P "  %F{${_550w_C[dim]}}_550W_SKIP=1    立即跳过%f"
    print ""
    print "  用户按任意键 → _550W_SKIP=1"

    _550w_help_step "4" "颜色参数"
    print "  部分动画接受颜色码:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_fade_in \"文本\" 51%f"
    print "                                        ↑ 色号"
    print ""
    print "  常用:"
    print "    46  绿色    51  青色"
    print "    214 橙色    196 红色"
    print "    220 黄色    45  蓝色"

    _550w_help_step "5" "速度影响"
    print "  _550W_SPEED 会缩放所有 _550w_pause:"
    print -P "  %F{${_550w_C[dim]}}_550W_SPEED=flash    30%%%f"
    print -P "  %F{${_550w_C[dim]}}_550W_SPEED=fast     60%%%f"
    print -P "  %F{${_550w_C[dim]}}_550W_SPEED=normal  100%%%f"
    print -P "  %F{${_550w_C[dim]}}_550W_SPEED=slow    180%%%f"
    print -P "  %F{${_550w_C[dim]}}_550W_SPEED=hold      0%%(定格)%f"

    _550w_help_step "6" "循环次数"
    print "  某些动画有 cycles 参数:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_pulse_text \"文本\" 5%f"
    print "                                        ↑ 循环 5 次"

    _550w_help_step "7" "组合动画"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_typing_v2 \"BOOT\" 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 300%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_glitch_v3 \"LOADING\" 8%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_wave_v2 40%f"

    _550w_help_step "8" "调试动画"
    print "  单独跑一个:"
    _550w_help_cmd "_550w_anim_cnn"
    print ""
    print "  全部预览:"
    _550w_help_cmd "550w-anim → 13     演示"
    print ""
    print "  交互式:"
    _550w_help_cmd "550w-anim"

    _550w_help_step "9" "性能建议"
    print "  · 大宽度动画耗 CPU"
    print "  · 帧率高(延迟低)耗 CPU"
    print "  · 想省电: 用 fast 速度"
    print "  · 想稳定: 宽度 ≤ 40"

    _550w_help_step "10" "自定义动画"
    print "  写自己的(见教程 18):"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_mycustom() {%f"
    print -P "  %F{${_550w_C[dim]}}    local text=\"\${1:-HELLO}\"%f"
    print -P "  %F{${_550w_C[dim]}}    local i%f"
    print -P "  %F{${_550w_C[dim]}}    for (( i=0; i<5; i++ )); do%f"
    print -P "  %F{${_550w_C[dim]}}        print -P \"%F{46}\$text%f\"%f"
    print -P "  %F{${_550w_C[dim]}}        _550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}        (( _550W_SKIP )) && break%f"
    print -P "  %F{${_550w_C[dim]}}    done%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  动画专章全掌握"
    _550w_help_pause
}
# ══════════════════ 开机专章 · 主菜单 ══════════════════

_550w_help_menu_boot() {
    while true; do
        _550w_help_head "开机专章" "开机 15 步详解"
        print ""
        _550w_help_row "1"  "总览"        "开机流程一览"
        _550w_help_row "2"  "冷启动"      "Phase -1"
        _550w_help_row "3"  "BIOS POST"   "Phase A"
        _550w_help_row "4"  "硬件扫描"    "Phase B"
        _550w_help_row "5"  "网络接管"    "Phase C+D"
        _550w_help_row "6"  "内核自检"    "Phase E"
        _550w_help_row "7"  "AI 自检"     "Phase F"
        _550w_help_row "8"  "密码框"      "Phase 4"
        _550w_help_row "9"  "授权"        "Phase 5"
        _550w_help_row "10" "欢迎画"      "Welcome"
        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_b01 ;;
            2) _550w_help_b02 ;;
            3) _550w_help_b03 ;;
            4) _550w_help_b04 ;;
            5) _550w_help_b05 ;;
            6) _550w_help_b06 ;;
            7) _550w_help_b07 ;;
            8) _550w_help_b08 ;;
            9) _550w_help_b09 ;;
            10) _550w_help_b10 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_b01() {
    _550w_help_head "开机专章 · 总览" "15 步流程"
    print "  完整时序:"
    print ""
    printf '  \e[38;5;%sm[ 1]\e[0m 冷启动脉冲      Phase -1\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 2]\e[0m 警告 + 接管链路 Phase 0\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 3]\e[0m BIOS POST 12 项 Phase A\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 4]\e[0m 硬件深度扫描    Phase B\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 5]\e[0m 端口扫描 + 撕裂 Phase C\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 6]\e[0m 网络嗅探 + 握手 Phase D\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 7]\e[0m 内核自检 20 项  Phase E\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 8]\e[0m AI 引擎自检     Phase F\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[ 9]\e[0m Linux 容器扫描  Phase G\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[10]\e[0m 打字机 + SID    Phase 1\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[11]\e[0m 四层加载        Phase 2\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[12]\e[0m 拓扑 + 权重     Phase 3\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[13]\e[0m [你的动画]      boot_anim/*\n' "${_550W_C[ok]}"
    printf '  \e[38;5;%sm[14]\e[0m 密码框          Phase 4\n' "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm[15]\e[0m 授权 + 欢迎画   Phase 5\n' "${_550W_C[cyan]}"
    print ""
    print -P "  %F{${_550W_C[dim]}}控制:任意键跳过 / q 紧急退出%f"
    print ""
    _550w_help_pause
}

_550w_help_b02() {
    _550w_help_head "开机专章 · 冷启动" "Phase -1"
    _550w_help_goal "开机最前面的仪式感"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    print "  屏幕从纯黑开始。"
    print ""
    print "  第 1 步:"
    print "    中心出现一个 '◆' 字符"
    print "    呼吸 3 次(变亮变暗)"
    print ""
    print "  第 2 步:"
    print "    glitch 乱码: '550W CORE 唤醒'"
    print ""
    print "  第 3 步:"
    print "    hexdump 4 行内存转储"
    print ""
    print "  第 4 步:"
    print "    闪烁 '◆ CORE ONLINE ◆'"
    print ""
    print "  函数: _550w_phase_neg1()"
    print "  位置: core.zsh"
    print ""
    print "  跳过: 按任意键"
    print ""
    _550w_help_pause
}

_550w_help_b03() {
    _550w_help_head "开机专章 · BIOS POST" "Phase A"
    _550w_help_goal "12 项硬件自检"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    print "  显示 12 项自检:"
    print ""
    printf '  %-8s %s\n' "PPWR"  "电源单元检测"
    printf '  %-8s %s\n' "PCPU"  "处理器初始化"
    printf '  %-8s %s\n' "PMEM"  "物理内存自检"
    printf '  %-8s %s\n' "PIO"   "输入输出总线"
    printf '  %-8s %s\n' "PVID"  "显示接口"
    printf '  %-8s %s\n' "PNET"  "网络接口"
    printf '  %-8s %s\n' "PUSB"  "USB 总线"
    printf '  %-8s %s\n' "PSTOR" "存储控制器"
    printf '  %-8s %s\n' "PTPM"  "可信平台模块"
    printf '  %-8s %s\n' "PACM"  "高级配置管理"
    printf '  %-8s %s\n' "PSMB"  "SMBIOS 表"
    printf '  %-8s %s\n' "PAPIC" "中断控制器"
    print ""
    print "  每项: 显示 code, 等 50ms, 输出 OK"
    print ""
    print "  最后:"
    print "    · MEM 地址扫描 32 个块"
    print "    · 显示内存大小"
    print "    · 打印 BIOS 版本 + 时间戳"
    print ""
    print "  函数: _550w_boot_phase_A_kernel()"
    print "  位置: core.zsh"
    print ""
    _550w_help_pause
}

_550w_help_b04() {
    _550w_help_head "开机专章 · 硬件扫描" "Phase B"
    _550w_help_goal "8 组硬件深度检测"
    _550w_help_cost "2 分钟" "★★☆☆☆"

    print "  8 组:"
    print ""
    print "  [1/8] CPU"
    print "    型号 / 架构 / 核心数 / 频率"
    print ""
    print "  [2/8] 内存"
    print "    总量 / 校验"
    print ""
    print "  [3/8] 存储"
    print "    剩余空间 / 文件系统"
    print ""
    print "  [4/8] GPU"
    print "    型号 / 显存"
    print ""
    print "  [5/8] 网络"
    print "    MAC / 接口"
    print ""
    print "  [6/8] 传感器"
    print "    CPU 温度 / 风扇转速"
    print ""
    print "  [7/8] 电源"
    print "    电压 / 电池"
    print ""
    print "  [8/8] 内核"
    print "    版本 / 主机名"
    print ""
    print "  函数: _550w_boot_phase_B_hardware()"
    print "  位置: core.zsh"
    print ""
    print -P "  %F{${_550W_C[warn]}}⚠ 部分数据是视觉演出(温度/风扇/电源)%f"
    print -P "  %F{${_550W_C[dim]}}真实数据用 550w-real 查看%f"
    print ""
    _550w_help_pause
}

_550w_help_b05() {
    _550w_help_head "开机专章 · 网络接管" "Phase C + D"
    _550w_help_goal "端口扫描 + 嗅探 + 加密"
    _550w_help_cost "2 分钟" "★★☆☆☆"

    print "  Phase C 端口扫描:"
    print "    23 个常见端口逐个测"
    print "    每个随机显示 开放/关闭"
    print "    ↓"
    print "    屏幕撕裂乱码"
    print "    ↓"
    print "    ⚠ 警告框:未授权访问检测"
    print "    ↓"
    print "    接管进度条(20 档)"
    print ""
    print "  Phase D 网络嗅探:"
    print "    8 个数据包(src → dst)"
    print "    ↓"
    print "    链路延迟探测(真实 ping)"
    print "    ↓"
    print "    6 步加密握手:"
    print "      · RSA-4096 密钥对"
    print "      · ECDH 通道"
    print "      · AES-256-GCM"
    print "      · HMAC-SHA512"
    print "      · 量子纠缠同步"
    print "      · 双因子验证"
    print ""
    print "  函数:"
    print "    _550w_boot_phase_C_takeover()"
    print "    _550w_boot_phase_D_network()"
    print ""
    _550w_help_pause
}

_550w_help_b06() {
    _550w_help_head "开机专章 · 内核自检" "Phase E"
    _550w_help_goal "20 项核心组件"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    print "  20 项:"
    print ""
    printf '  %-16s %s\n' "量子核心"      "Quantum Core x16"
    printf '  %-16s %s\n' "计算单元"      "Compute Unit x32"
    printf '  %-16s %s\n' "记忆矩阵"      "Memory Matrix"
    printf '  %-16s %s\n' "数据链路"      "Data Link"
    printf '  %-16s %s\n' "MOOS接口"      "MOOS Interface"
    printf '  %-16s %s\n' "550W内核"      "Kernel \$_550W_VERSION"
    printf '  %-16s %s\n' "时空锚点"      "Anchor Sync"
    printf '  %-16s %s\n' "引力波模块"    "Grav-Wave"
    printf '  %-16s %s\n' "神经网络"      "Neural Net x128"
    printf '  %-16s %s\n' "自愈系统"      "Self-Heal"
    printf '  %-16s %s\n' "加密引擎"      "Crypto Engine"
    printf '  %-16s %s\n' "量子纠缠"      "Entangle"
    printf '  %-16s %s\n' "低温制冷"      "Cryo-Cool"
    printf '  %-16s %s\n' "能源核心"      "Power Core"
    printf '  %-16s %s\n' "传感器阵列"    "Sensor Array"
    printf '  %-16s %s\n' "陀螺仪"        "Gyro"
    printf '  %-16s %s\n' "惯性导航"      "INS"
    printf '  %-16s %s\n' "光通信"        "Optical Link"
    printf '  %-16s %s\n' "深空天线"      "Deep-Space Ant"
    printf '  %-16s %s\n' "行星发动机"    "Earth Engine"
    print ""
    print "  最后显示: 功率/温度/算力"
    print ""
    print "  函数: _550w_boot_phase_E_selfcheck()"
    print ""
    _550w_help_pause
}

_550w_help_b07() {
    _550w_help_head "开机专章 · AI 自检" "Phase F"
    _550w_help_goal "MOSS 引擎检测 + 评分"
    _550w_help_cost "2 分钟" "★★☆☆☆"

    print "  [MODEL] 加载配置"
    print "    名称 / Provider / 模式 / 量化 / 层数 / 上下文"
    print ""
    print "  [LOAD] 权重加载"
    print "    8 段循环点亮(共 32 层)"
    print ""
    print "  [HLTH] 健康检查"
    print "    连通性(MOSS 在线/降级/离线)"
    print "    API Key(已配置/未配置)"
    print "    记忆条数"
    print "    速率使用"
    print ""
    print "  [SCORE] 综合评分"
    print "    MOSS 启用      +40"
    print "    健康 ok        +30"
    print "    API Key 已配   +20"
    print "    有记忆         +10"
    print "    总分显示进度条"
    print ""
    print "  ≥80: 完全就绪"
    print "  ≥50: 部分就绪"
    print "  <50: 未就绪"
    print ""
    print "  函数: _550w_boot_phase_F_ai_engine()"
    print ""
    _550w_help_pause
}

_550w_help_b08() {
    _550w_help_head "开机专章 · 密码框" "Phase 4"
    _550w_help_goal "单行密码输入"
    _550w_help_cost "2 分钟" "★★☆☆☆"

    print "  显示:"
    print -P "  %F{${_550W_C[dim]}}╔════════════════════════════╗%f"
    print -P "  %F{${_550W_C[dim]}}║%f  550W · 身份验证 · MOSS 核心 %F{${_550W_C[dim]}}║%f"
    print -P "  %F{${_550W_C[dim]}}╚════════════════════════════╝%f"
    print ""
    print "  [信息] 会话      MOSS-XXXX-XXXX"
    print "         版本      v1.0"
    print "         操作员    Trans"
    print "         剩余尝试  3/3"
    print ""
    print "  ────────── 请 输 入 密 码 ──────────"
    print ""
    print "  ┃ >> 密码 ●●●●●●●● [▰▰▱▱▱ 强]"
    print ""
    print "  功能:"
    print "    · 掩码 ● 显示"
    print "    · 实时强度: 弱/中/强/极强"
    print "    · 输入 echo 关闭"
    print "    · Ctrl+C 中止"
    print "    · 超时(默认 30 秒)自动退出"
    print ""
    print "  函数: _550w_phase4_v2()"
    print ""
    _550w_help_pause
}

_550w_help_b09() {
    _550w_help_head "开机专章 · 授权" "Phase 5"
    _550w_help_goal "通过后的动画"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    print "  密码正确后:"
    print ""
    print "  1) glitch '✓ 授权通过'"
    print ""
    print "  2) 五行日志:"
    print "     [23:14:17] 核心上线  ✓  550W_CORE"
    print "     [23:14:17] 链路建立  ✓  LINK_ESTAB"
    print "     [23:14:17] 协议握手  ✓  PROTO_HSHK"
    print "     [23:14:17] MOOS接管  ✓  MOOS_TAKE"
    print "     [23:14:17] 记忆同步  ✓  MEM_SYNC"
    print ""
    print "  3) glitch '550W ONLINE'"
    print ""
    print "  4) pulse 脉冲"
    print ""
    print "  5) 授权方框(hold 不缩放):"
    print "     操作员    Trans"
    print "     权限      全权"
    print "     状态      已接管"
    print "     会话      MOSS-XXXX"
    print ""
    print "  6) 清屏进入欢迎画"
    print ""
    print "  函数: _550w_phase5()"
    print ""
    _550w_help_pause
}

_550w_help_b10() {
    _550w_help_head "开机专章 · 欢迎画" "Welcome"
    _550w_help_goal "最后一步"
    _550w_help_cost "1 分钟" "★☆☆☆☆"

    print "  显示内容:"
    print ""
    print "  1) 6 行渐变 550W 大字"
    print "     行 1: 绿(46)"
    print "     行 2: 绿(46)"
    print "     行 3: 青(51)"
    print "     行 4: 蓝(45)"
    print "     行 5: 紫(39)"
    print "     行 6: 洋红(135)"
    print ""
    print "  2) 欢迎框"
    print "     ◆ WELCOME BACK · 欢迎回来"
    print ""
    print "  3) 操作员档案"
    print "     ├ 用户名   Trans"
    print "     ├ 等级     高级授权"
    print "     └ 权限     全权"
    print ""
    print "  4) 系统状态"
    print "     ├ 核心     已激活"
    print "     ├ 链路     已建立"
    print "     ├ MOSS     在线"
    print "     ├ 记忆     N 条"
    print "     ├ 会话     MOSS-XXXX"
    print "     └ 上次     2026-10-07 14:30"
    print ""
    print "  5) 签名"
    print "     550W · 永不为奴"
    print ""
    print "  6) 提示'按回车进入终端'"
    print ""
    print "  函数: _550w_welcome_screen()"
    print ""
    print "  改档案: 550w-settings → 5"
    print ""
    _550w_help_pause
}
# ══════════════════ 开发者指南 · 主菜单 ══════════════════

_550w_help_menu_dev() {
    while true; do
        _550w_help_head "开发者指南" "API / 扩展 / 调试"
        print ""
        _550w_help_row "1"  "架构总览"     "文件/加载/函数命名"
        _550w_help_row "2"  "核心 API"     "暂停/清屏/动画/颜色"
        _550w_help_row "3"  "MOSS API"     "对话/记忆/Provider"
        _550w_help_row "4"  "硬件 API"     "读取真实系统数据"
        _550w_help_row "5"  "插件 API"     "元数据/钩子/配置/日志"
        _550w_help_row "6"  "写扩展文件"   "在 ~/.550w/ 加文件"
        _550w_help_row "7"  "写插件"       "创建独立文件夹"
        _550w_help_row "8"  "写开机动画"   "boot_anim 里加文件"
        _550w_help_row "9"  "调试技巧"     "set -x / 日志 / 语法检查"
        _550w_help_row "10" "变量索引"     "所有 _550W_* 变量"
        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_d01 ;;
            2) _550w_help_d02 ;;
            3) _550w_help_d03 ;;
            4) _550w_help_d04 ;;
            5) _550w_help_d05 ;;
            6) _550w_help_d06 ;;
            7) _550w_help_d07 ;;
            8) _550w_help_d08 ;;
            9) _550w_help_d09 ;;
            10) _550w_help_d10 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 架构总览 ══════════════════

_550w_help_d01() {
    _550w_help_head "开发者指南 · 架构总览"
    _550w_help_goal "理解 550W 整体结构"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "文件结构"
    print "  ~/.550w/"
    print "  ├── core.zsh        核心(配置/视觉/认证/命令)"
    print "  ├── settings.zsh    设置中心(13 类)"
    print "  ├── help.zsh        使用手册(本文件)"
    print "  ├── anim.zsh        动画库(234 函数)"
    print "  ├── real.zsh        真实系统读取"
    print "  ├── extras.zsh      外围工具"
    print "  ├── new.zsh         新加功能"
    print "  ├── 扩展/           插件目录"
    print "  │   └── 插件名/main.zsh"
    print "  ├── boot_anim/      开机动画"
    print "  │   └── XX_xxx.zsh"
    print "  ├── backups/        备份"
    print "  ├── logs/           日志"
    print "  └── themes/         主题"

    _550w_help_step "2" "加载顺序"
    print "  1) 用户 source ~/.zshrc"
    print "  2) .zshrc 里 source ~/.550w/core.zsh"
    print "  3) core.zsh 定义基础 + 命令"
    print "  4) core.zsh 末尾循环加载:"
    print "     real → anim → help → settings → extras → new"
    print "  5) 每个扩展文件末尾定义自己的东西"
    print "  6) core.zsh 加载 ~/.550w/扩展/*/main.zsh(插件)"
    print "  7) 每个插件被 source"
    print "  8) 开机 _550w_login 触发"

    _550w_help_step "3" "函数命名"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_xxx()" "内部函数(私有)"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "550w-xxx()" "用户命令(公开)"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_plugin_log()" "插件 API"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_plugin_config_get()" "插件 API"

    _550w_help_step "4" "变量命名"
    print "  全局配置变量:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_XXX" "大写+下划线"
    print ""
    print "  局部函数内变量:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550w_xxx" "小写"
    print ""
    print "  数组:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_KNOWN_DISTROS" "多种发行版"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_DETECTED_DISTROS" "实际检测到"

    _550w_help_step "5" "同定义覆盖"
    print "  zsh 特性: 同名函数后定义覆盖先定义。"
    print "  所以升级包总是追加到文件末尾。"
    print ""
    print "  例: core.zsh 定义 550w-toolbox"
    print "      后面文件又定义 550w-toolbox"
    print "      → 后定义的生效。"

    _550w_help_step "6" "扩展文件 vs 插件"
    print "  扩展文件(real.zsh 等):"
    print "    · 官方维护"
    print "    · 由 core.zsh 加载"
    print "    · 覆盖更新"
    print ""
    print "  插件(扩展/*/main.zsh):"
    print "    · 用户自己写"
    print "    · 自动扫描"
    print "    · 独立隔离"

    _550w_help_step "7" "数据文件"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_pass" "密码"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_profile" "用户档案"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_config" "配置"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_session" "会话"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_moss_memory" "AI 记忆"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_ratelimit" "速率计数"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_audit" "审计"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" ".550w_history" "命令历史"

    _550w_help_step "8" "修改流程"
    print "  改任何东西:"
    print "    ① 编辑文件"
    print "    ② unset _550W_LOADED && source ~/.zshrc"
    print "    ③ 测试"
    print "    ④ 出错 → 修 → 重载"
    print "    ⑤ 稳定 → 备份"

    _550w_help_step "9" "版本号"
    print "  _550W_VERSION 定义在 core.zsh 顶部。"
    print "  扩展文件里通常不重新定义。"
    print "  改动大时手动升版本。"

    _550w_help_step "10" "备份建议"
    print "  大改之前:"
    _550w_help_cmd "cp -r ~/.550w ~/.550w.bak_\$(date +%Y%m%d)"
    print ""
    print "  或用内置:"
    _550w_help_cmd "550w-settings → 9 → 1"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  你理解架构了"
    _550w_help_pause
}

# ══════════════════ 核心 API ══════════════════

_550w_help_d02() {
    _550w_help_head "开发者指南 · 核心 API"
    _550w_help_goal "掌握最常用的底层函数"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "_550w_pause ms"
    print "  暂停指定毫秒。"
    print "  受 _550W_SPEED 影响(缩放)。"
    print "  响应 _550W_SKIP(跳过)。"
    print ""
    print "  参数:"
    print "    ms    毫秒数"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 500%f"
    print "  (暂停 500ms × 速度倍率)"

    _550w_help_step "2" "_550w_cls"
    print "  清屏。"
    print "  比 clear 快(用 \\e[H\\e[2J\\e[3J)。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_cls%f"

    _550w_help_step "3" "_550w_ts"
    print "  时间戳 HH:MM:SS.mmm"
    print ""
    print -P "  %F{${_550w_C[dim]}}print \"[\$(_550w_ts)] 消息\"%f"
    print "  输出: [23:14:17.234] 消息"

    _550w_help_step "4" "_550w_cur_hide / _550w_cur_reset"
    print "  隐藏/恢复光标。"
    print "  动画循环用。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_cur_hide%f"
    print -P "  %F{${_550w_C[dim]}}... 动画 ...%f"
    print -P "  %F{${_550w_C[dim]}}_550w_cur_reset%f"

    _550w_help_step "5" "_550w_anim_type 文本 [延迟]"
    print "  打字机效果。"
    print "  每字延迟毫秒。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_anim_type \"正在加载...\" 40%f"

    _550w_help_step "6" "_550w_anim_bar [宽度] [标签]"
    print "  进度条。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_anim_bar 40 \"加载\"%f"

    _550w_help_step "7" "_550w_anim_box 行1 行2 ..."
    print "  居中方框。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_anim_box \"标题\" \"\" \"内容\"%f"

    _550w_help_step "8" "颜色"
    print "  用 %F{色号} 和 %f:"
    print -P "  %F{${_550w_C[dim]}}print -P \"%F{46}绿色%f 正常\"%f"
    print ""
    print "  常用色号:"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[ok]}" "46" "绿"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[cyan]}" "51" "青"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[blue]}" "45" "蓝"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[warn]}" "220" "黄"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[amber]}" "214" "橙"
    printf '  \e[38;5;%sm%-6s\e[0m %s\n' "${_550W_C[err]}" "196" "红"
    print ""
    print "  用变量形式:"
    print -P "  %F{${_550w_C[dim]}}print -P \"%F{\$_550W_C[ok]}绿%f\"%f"

    _550w_help_step "9" "_550w_hw_* 硬件函数"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_cpu" "CPU 型号"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_mem" "内存大小"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_kernel" "内核版本"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_hostname" "主机名"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_arch" "架构"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_cores" "核心数"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_disk" "磁盘剩余"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_mac" "MAC 地址"
    printf '  \e[38;5;%sm%-24s\e[0m %s\n' "${_550w_C[ok]}" "_550w_hw_uptime" "运行时长"

    _550w_help_step "10" "示例: 用核心 API 写函数"
    print -P "  %F{${_550w_C[dim]}}myfun() {%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_cls%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_anim_type \"系统信息\" 40%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"  %F{46}CPU%f \$_(_550w_hw_cpu)\"%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"  %F{46}RAM%f \$_(_550w_hw_mem)\"%f"
    print -P "  %F{${_550w_C[dim]}}    print -P \"  %F{46}内核%f \$_(_550w_hw_kernel)\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  核心 API 掌握"
    _550w_help_pause
}
# ══════════════════ MOSS API ══════════════════

_550w_help_d03() {
    _550w_help_head "开发者指南 · MOSS API"
    _550w_help_goal "在代码里调用 AI"
    _550w_help_cost "8 分钟" "★★★☆☆"

    _550w_help_step "1" "_550w_moss_chat 消息"
    print "  核心对话函数。"
    print "  不返回值, 结果存到全局变量。"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_chat \"你好\"%f"
    print -P "  %F{${_550w_C[dim]}}if [[ -n \"\$_550W_MOSS_REPLY\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550w_C[dim]}}fi%f"
    print ""
    _550w_help_warn "不要在 \$(...) 里调用, 全局状态会丢"

    _550w_help_step "2" "为什么用全局变量"
    print "  \$(...) 创建子 shell。"
    print "  子 shell 里修改变量不影响父 shell。"
    print ""
    print "  ✗ 错误:"
    print -P "  %F{${_550w_C[dim]}}reply=\$(_550w_moss_chat \"hi\")%f"
    print -P "  %F{${_550w_C[dim]}}# \$_550W_MOSS_HISTORY 在父 shell 里没变%f"
    print ""
    print "  ✓ 正确:"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_chat \"hi\"%f"
    print -P "  %F{${_550w_C[dim]}}reply=\"\$_550W_MOSS_REPLY\"%f"

    _550w_help_step "3" "全局变量"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_REPLY" "上次回复"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_LAST_MS" "上次耗时"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_HISTORY" "对话历史数组"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_ENABLED" "开关 0/1"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_PROVIDER" "当前 provider"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_MODEL" "当前模型"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_MOSS_HEALTH" "健康状态"

    _550w_help_step "4" "_550w_moss_health"
    print "  检测 MOSS 是否可用。"
    print "  更新 _550W_MOSS_HEALTH。"
    print ""
    print "  值:"
    print "    ok / degraded / down"
    print "    disabled / no-curl / no-url"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_health%f"
    print -P "  %F{${_550w_C[dim]}}case \"\$_550W_MOSS_HEALTH\" in%f"
    print -P "  %F{${_550w_C[dim]}}    ok) print \"可用\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}    *)  print \"不可用\" ;;%f"
    print -P "  %F{${_550w_C[dim]}}esac%f"

    _550w_help_step "5" "_550w_moss_memory_save / _load"
    print "  保存/加载记忆到文件。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_moss_memory_save%f"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_memory_load%f"
    print ""
    print "  手动改历史后:"
    print -P "  %F{${_550w_C[dim]}}_550W_MOSS_HISTORY+=('{\"role\":\"user\",\"content\":\"hi\"}')%f"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_memory_save%f"

    _550w_help_step "6" "_550w_moss_set / _glm"
    print "  切换 provider:"
    _550w_help_cmd "550w-moss-set deepseek"
    _550w_help_cmd "550w-glm"
    print ""
    print "  底层:"
    print -P "  %F{${_550w_C[dim]}}_550W_MOSS_PROVIDER=\"deepseek\"%f"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_resolve_provider%f"

    _550w_help_step "7" "_550W_PROVIDER_PRESET"
    print "  Provider 预设表。"
    print "  格式: key=value"
    print "  value = 端点|模型|环境变量"
    print ""
    print -P "  %F{${_550w_C[dim]}}print \${_550W_PROVIDER_PRESET[glm]}%f"
    print "  输出:"
    print -P "  %F{${_550w_C[dim]}}https://open.bigmodel.cn/api/paas/v4|glm-4-flash|ZHIPU_API_KEY%f"

    _550w_help_step "8" "示例: 批量对话"
    print -P "  %F{${_550w_C[dim]}}for q in \"问题1\" \"问题2\" \"问题3\"; do%f"
    print -P "  %F{${_550w_C[dim]}}    _550w_moss_chat \"\$q\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"Q: \$q\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"A: \$_550W_MOSS_REPLY\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "9" "示例: 带系统提示词"
    print "  _550w_moss_chat_sys 系统提示词 用户消息"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_moss_chat_sys \"你是专业翻译\" \"翻译: hello\"%f"
    print -P "  %F{${_550w_C[dim]}}print \"\$_550W_MOSS_REPLY\"%f"

    _550w_help_step "10" "错误处理"
    print -P "  %F{${_550w_C[dim]}}_550w_moss_chat \"hi\"%f"
    print -P "  %F{${_550w_C[dim]}}if [[ -z \"\$_550W_MOSS_REPLY\" ]]; then%f"
    print -P "  %F{${_550w_C[dim]}}    print \"调用失败\" >&2%f"
    print -P "  %F{${_550w_C[dim]}}    return 1%f"
    print -P "  %F{${_550w_C[dim]}}fi%f"
    print ""
    print "  失败时 _550W_MOSS_REPLY 会是 '(空响应)' 或错误信息。"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  MOSS API 掌握"
    _550w_help_pause
}

# ══════════════════ 硬件 API ══════════════════

_550w_help_d04() {
    _550w_help_head "开发者指南 · 硬件 API"
    _550w_help_goal "读取真实系统数据"
    _550w_help_cost "6 分钟" "★★★☆☆"

    _550w_help_step "1" "real.zsh 的函数"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_model" "CPU 型号"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_arch" "架构"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_cores" "核心数"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_cur_freq" "当前频率"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_min_freq" "最小频率"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_max_freq" "最大频率"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_cpu_governor" "调度器"

    _550w_help_step "2" "温度"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_temp_zones" "传感器数量"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_temp_cpu" "CPU 温度"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_temp_max" "最高温"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_temp_avg" "平均温"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_temp_top3" "Top 3 传感器"

    _550w_help_step "3" "内存"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_total" "总量"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_avail" "可用"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_free" "空闲"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_cached" "缓存"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_buffers" "缓冲区"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_mem_usage" "使用率"

    _550w_help_step "4" "系统/磁盘"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_kernel" "内核版本"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_os" "OS"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_hostname" "主机名"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_uptime" "运行时长"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_disk_total" "磁盘总量"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_disk_used" "已用"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_disk_free" "剩余"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_disk_usage" "使用率"

    _550w_help_step "5" "其它"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_entropy" "熵池"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_proc_count" "进程数"
    printf '  \e[38;5;%sm%-36s\e[0m %s\n' "${_550w_C[ok]}" "_550w_real_filesystems" "文件系统数"

    _550w_help_step "6" "返回值"
    print "  全部返回字符串(print -n)。"
    print "  读不到返回 'N/A'。"
    print ""
    print "  读法:"
    print -P "  %F{${_550w_C[dim]}}local cpu=\$(_550w_real_cpu_model)%f"
    print -P "  %F{${_550w_C[dim]}}print \"CPU: \$cpu\"%f"

    _550w_help_step "7" "示例: 简易监控"
    print -P "  %F{${_550w_C[dim]}}my-monitor() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"CPU: \$_550w_real_cpu_cur_freq / \$_550w_real_cpu_max_freq\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"温度: \$_550w_real_temp_cpu\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"内存: \$_550w_real_mem_usage\"%f"
    print -P "  %F{${_550w_C[dim]}}    print \"磁盘: \$_550w_real_disk_free\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "8" "注意"
    print "  手机读取限制:"
    print "    ✓ 读得到: CPU/内存/温度/磁盘/熵池"
    print "    ✗ 读不到: 风扇/主板电压/GPU显存"
    print "  读不到的返回 N/A, 不假装有数据。"

    _550w_help_step "9" "直接读文件"
    print "  很多数据来自:"
    print "    /proc/cpuinfo"
    print "    /proc/meminfo"
    print "    /proc/uptime"
    print "    /sys/class/thermal/thermal_zone*/temp"
    print "    /sys/devices/system/cpu/cpu0/cpufreq/*"
    print ""
    print "  你也可以直接 cat 这些文件。"

    _550w_help_step "10" "写你自己的读取"
    print -P "  %F{${_550w_C[dim]}}my-cpu-temp() {%f"
    print -P "  %F{${_550w_C[dim]}}    local max=0 t z%f"
    print -P "  %F{${_550w_C[dim]}}    for z in /sys/class/thermal/thermal_zone*/temp; do%f"
    print -P "  %F{${_550w_C[dim]}}        t=\$(cat \"\$z\" 2>/dev/null)%f"
    print -P "  %F{${_550w_C[dim]}}        [[ \"\$t\" =~ '^[0-9]+\$' ]] || continue%f"
    print -P "  %F{${_550w_C[dim]}}        (( t > max )) && max=\$t%f"
    print -P "  %F{${_550w_C[dim]}}    done%f"
    print -P "  %F{${_550w_C[dim]}}    (( max > 0 )) && awk -v x=\"\$max\" 'BEGIN{printf \"%.1f°C\\n\", x/1000}'%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  硬件 API 掌握"
    _550w_help_pause
}

# ══════════════════ 插件 API ══════════════════

_550w_help_d05() {
    _550w_help_head "开发者指南 · 插件 API"
    _550w_help_goal "插件开发者完整参考"
    _550w_help_cost "5 分钟" "★★★☆☆"

    _550w_help_step "1" "日志 API"
    print -P "  %F{${_550w_C[dim]}}_plugin_log <level> <消息>%f"
    print ""
    print "  level: info / warn / error / debug"
    print ""
    print -P "  %F{${_550w_C[dim]}}_plugin_log info \"初始化\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log warn \"参数异常\"%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_log error \"请求失败\"%f"
    print ""
    print "  写文件: ~/.550w/扩展/插件名/log/YYYYMMDD.log"

    _550w_help_step "2" "配置 API"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_get <key> [默认]%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set <key> <值>%f"
    print ""
    print "  用法:"
    print -P "  %F{${_550w_C[dim]}}local city=\$(_plugin_config_get city \"北京\")%f"
    print -P "  %F{${_550w_C[dim]}}_plugin_config_set city \"上海\"%f"
    print ""
    print "  文件: ~/.550w/扩展/插件名/config/config"

    _550w_help_step "3" "环境变量"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_PLUGIN_SELF" "插件目录"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_PLUGIN_CURRENT" "插件名"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_PLUGIN_CONFIG_DIR" "配置目录"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_PLUGIN_LOG_DIR" "日志目录"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550W_PLUGIN_DIR" "所有插件根目录"

    _550w_help_step "4" "元数据字段"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@name" "显示名"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@version" "版本号"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@author" "作者"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@desc" "一句话说明"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@requires" "命令依赖"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@depends" "插件依赖"
    printf '  \e[38;5;%sm%-16s\e[0m %s\n' "${_550w_C[cyan]}" "@hook" "钩子类型"

    _550w_help_step "5" "钩子类型"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "precmd" "命令前"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "preexec" "命令后"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "chpwd" "切目录"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "login" "登录后"
    printf '  \e[38;5;%sm%-12s\e[0m %s\n' "${_550w_C[ok]}" "logout" "退出时"
    print ""
    print "  函数名规则:"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_<插件名>_<钩子名>()%f"

    _550w_help_step "6" "管理命令(供插件调)"
    _550w_help_cmd "550w-plugins"
    _550w_help_cmd "550w-plugin-info 名"
    _550w_help_cmd "550w-plugin-reload 名"
    _550w_help_cmd "550w-plugin-enable 名"
    _550w_help_cmd "550w-plugin-disable 名"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugin-hooks"
    _550w_help_cmd "550w-plugin-logs 名"
    _550w_help_cmd "550w-plugin-config 名"

    _550w_help_step "7" "内部工具函数"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_scan%f"
    print "    重新扫描所有插件, 填 _550W_PLUGIN_LIST 等。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_meta <名> <字段>%f"
    print "    取插件元数据字段。"
    print "    字段: name/version/author/desc/requires/depends/hooks"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_is_loaded <名>%f"
    print "    返回 0=已加载, 1=未加载。"
    print ""
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_enabled <名>%f"
    print "    返回 0=启用, 1=禁用。"

    _550w_help_step "8" "完整骨架"
    print -P "  %F{${_550w_C[dim]}}# @name: 示例%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 一句话说明%f"
    print -P "  %F{${_550w_C[dim]}}# @requires: curl%f"
    print -P "  %F{${_550w_C[dim]}}# @depends: tools%f"
    print -P "  %F{${_550w_C[dim]}}# @hook: login precmd%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-example() {%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"开始\"%f"
    print -P "  %F{${_550w_C[dim]}}    local v=\$(_plugin_config_get key \"默认\")%f"
    print -P "  %F{${_550w_C[dim]}}    print \"值: \$v\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}_550w_plugin_hook_example_login() {%f"
    print -P "  %F{${_550w_C[dim]}}    _plugin_log info \"登录\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  插件 API 掌握"
    _550w_help_pause
}
# ══════════════════ 写扩展文件 ══════════════════

_550w_help_d06() {
    _550w_help_head "开发者指南 · 写扩展文件"
    _550w_help_goal "在 ~/.550w/ 里加自定义 zsh 文件"
    _550w_help_cost "6 分钟" "★★★☆☆"

    _550w_help_step "1" "什么时候用扩展文件"
    print "  扩展文件 vs 插件:"
    print ""
    print "  扩展文件(real.zsh 一类):"
    print "    · 放 ~/.550w/ 根目录"
    print "    · core.zsh 硬编码加载"
    print "    · 改 core.zsh 才能加新文件"
    print "    · 官方扩展用这种"
    print ""
    print "  插件(扩展/*/main.zsh):"
    print "    · 放 ~/.550w/扩展/子目录"
    print "    · 自动扫描加载"
    print "    · 不用改 core.zsh"
    print "    · 用户自定义用这种"
    print ""
    print "  → 推荐用插件(下节 d07)"
    print "  → 本节的'扩展文件'是给你改官方文件用的"

    _550w_help_step "2" "扩展文件骨架"
    print "  新建 ~/.550w/myext.zsh:"
    print ""
    print -P "  %F{${_550w_C[dim]}}# ~/.550w/myext.zsh — 我的扩展%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}[[ -n \"\$_550W_LOADED\" ]] || return 0%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}myfun() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"Hello\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print -P "  %F{${_550w_C[warn]}}⚠ 第一行的 _550W_LOADED 检查不能漏%f"
    print "    防止 core 没加载时乱跑。"

    _550w_help_step "3" "注册到加载器"
    print "  编辑 core.zsh 末尾的 for 循环:"
    print -P "  %F{${_550w_C[dim]}}for _550w_ext in real anim help settings extras new myext; do%f"
    print -P "  %F{${_550w_C[dim]}}    [[ -r \"\$HOME/.550w/\${_550w_ext}.zsh\" ]] && source \"\$HOME/.550w/\${_550w_ext}.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}done%f"
    print ""
    print "  加上 myext 即可。"

    _550w_help_step "4" "加载顺序"
    print "  for 循环里从左到右依次 source。"
    print "  后加载的覆盖先加载的同名函数。"
    print ""
    print "  想覆盖 550w-status:"
    print "    把 myext 放在 new 后面,"
    print "    在 myext.zsh 里重新定义 550w-status()。"

    _550w_help_step "5" "重载测试"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    _550w_help_cmd "myfun"
    _550w_help_expect "Hello"

    _550w_help_step "6" "注意事项"
    print "  · 文件顶部必须检查 _550W_LOADED"
    print "  · 不要 source core.zsh(会循环)"
    print "  · 函数名加前缀避免冲突"
    print "  · 长文件拆成多个"
    print "  · 语法错误会中断后续加载"

    _550w_help_step "7" "调试"
    _550w_help_cmd "zsh -n ~/.550w/myext.zsh"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    _550w_help_cmd "print -l _550w_ext"
    print "  最后一条显示当前加载器里的扩展列表。"

    _550w_help_step "8" "什么时候不该用扩展文件"
    print "  不推荐:"
    print "    · 频繁改动的自定义功能"
    print "    · 想分享给别人的东西"
    print "    · 一次性脚本"
    print ""
    print "  这些用插件更好。"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  扩展文件会加"
    _550w_help_pause
}

# ══════════════════ 写插件 ══════════════════

_550w_help_d07() {
    _550w_help_head "开发者指南 · 写插件"
    _550w_help_goal "推荐方式: 独立文件夹"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "为什么用插件"
    print "  · 自动扫描(不用改 core.zsh)"
    print "  · 独立隔离(不影响主脚本)"
    print "  · 好分享(打包 tar.gz)"
    print "  · 有元数据/依赖/钩子"
    print "  · 有配置/日志隔离"

    _550w_help_step "2" "快速创建"
    _550w_help_cmd "550w-plugin-new myplugin"
    print ""
    print "  生成:"
    print "    ~/.550w/扩展/myplugin/"
    print "    ├── main.zsh    入口"
    print "    ├── config.zsh  配置"
    print "    └── README.md   说明"

    _550w_help_step "3" "写 main.zsh"
    _550w_help_cmd "nano ~/.550w/扩展/myplugin/main.zsh"
    print ""
    print "  内容:"
    print -P "  %F{${_550w_C[dim]}}# @name: 我的插件%f"
    print -P "  %F{${_550w_C[dim]}}# @version: 1.0.0%f"
    print -P "  %F{${_550w_C[dim]}}# @author: Trans%f"
    print -P "  %F{${_550w_C[dim]}}# @desc: 一句话说明%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}source \"\$_550W_PLUGIN_SELF/config.zsh\"%f"
    print -P "  %F{${_550w_C[dim]}}%f"
    print -P "  %F{${_550w_C[dim]}}550w-myplugin() {%f"
    print -P "  %F{${_550w_C[dim]}}    print \"Hello from myplugin\"%f"
    print -P "  %F{${_550w_C[dim]}}}%f"

    _550w_help_step "4" "重载测试"
    _550w_help_cmd "550w-plugin-reload myplugin"
    _550w_help_cmd "550w-myplugin"
    _550w_help_expect "Hello from myplugin"

    _550w_help_step "5" "查看状态"
    _550w_help_cmd "550w-plugins"
    _550w_help_cmd "550w-plugin-info myplugin"

    _550w_help_step "6" "加复杂功能"
    print "  参考插件专章(主菜单 → 5)"
    print "  · 节 14 用日志"
    print "  · 节 15 用配置"
    print "  · 节 16 用钩子"

    _550w_help_step "7" "分享"
    _550w_help_cmd "550w-plugin-pack myplugin"
    print ""
    print "  生成 tar.gz, 别人 install:"
    _550w_help_cmd "550w-plugin-install 别人的.tar.gz"

    _550w_help_step "8" "调试"
    print "  出错看:"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugin-logs myplugin"
    _550w_help_cmd "zsh -n ~/.550w/扩展/myplugin/main.zsh"

    _550w_help_step "9" "推荐阅读"
    print "  插件专章 20 节(主菜单 → 5):"
    print "    · 从零到完整示例"
    print "    · 5 个完整可用的插件源码"
    print "    · 最佳实践"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  插件会写了"
    _550w_help_pause
}

# ══════════════════ 写开机动画 ══════════════════

_550w_help_d08() {
    _550w_help_head "开发者指南 · 写开机动画"
    _550w_help_goal "在 boot_anim/ 里加自定义动画"
    _550w_help_cost "5 分钟" "★★☆☆☆"

    _550w_help_step "1" "目录位置"
    print -P "  %F{${_550w_C[dim]}}~/.550w/boot_anim/%f"
    print ""
    print "  每个 .zsh 文件会被 source 一次。"
    print "  按文件名排序(00_ 到 99_)。"

    _550w_help_step "2" "创建"
    _550w_help_cmd "550w-boot-anim-new 01_hello"
    print ""
    print "  或手动:"
    _550w_help_cmd "nano ~/.550w/boot_anim/01_hello.zsh"

    _550w_help_step "3" "内容"
    print "  直接写函数调用:"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_typing_v2 \"BOOT\" 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_glitch_v3 \"LOADING\" 8%f"
    print ""
    print "  或被 source 时执行的任何 zsh 代码。"

    _550w_help_step "4" "插入位置"
    print "  boot_anim 在开机流程第 12 步之后执行:"
    print "    Phase 3 (拓扑+权重)"
    print "    ↓"
    print "    [boot_anim/*.zsh 依次执行]"
    print "    ↓"
    print "    Phase 4 (密码框)"
    print ""
    print "  即: 用户输密码之前。"

    _550w_help_step "5" "用户跳过机制"
    print "  用户在动画里按任意键 → _550W_SKIP=1"
    print "  你的动画里应该检查:"
    print -P "  %F{${_550w_C[dim]}}for i in ...; do%f"
    print -P "  %F{${_550w_C[dim]}}    ... 一帧 ...%f"
    print -P "  %F{${_550w_C[dim]}}    (( _550W_SKIP )) && break%f"
    print -P "  %F{${_550w_C[dim]}}done%f"

    _550w_help_step "6" "可用的动画函数"
    print "  234 个, 见 anim.zsh。"
    print "  浏览:"
    _550w_help_cmd "550w-anim"
    print ""
    print "  常用:"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550w_anim_typing_v2 文本 延迟" "打字"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550w_anim_glitch_v3 文本 时长" "故障"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550w_anim_wave_v2 宽" "波形"
    printf '  \e[38;5;%sm%-30s\e[0m %s\n' "${_550w_C[ok]}" "_550w_anim_bar_basic 宽 标签" "进度条"

    _550w_help_step "7" "测试"
    _550w_help_cmd "550w-boot-anim-list"
    print ""
    print "  临时测试:"
    _550w_help_cmd "source ~/.550w/boot_anim/01_hello.zsh"
    print ""
    print "  正式测试: unset + source ~/.zshrc, 看开机。"

    _550w_help_step "8" "排序控制"
    print "  文件名前缀:"
    print "    00_xxx.zsh   最前"
    print "    50_xxx.zsh   中间"
    print "    99_xxx.zsh   最后"
    print ""
    print "  菜单加的默认 99_user_NN。"

    _550w_help_step "9" "完整示例: 黑客风"
    print -P "  %F{${_550w_C[dim]}}# 01_hacker.zsh%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_binary_v2 3 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_hex_v2 3 16%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_glitch_v3 \"ACCESS GRANTED\" 12%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 200%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_hex_scramble \"SYSTEM\"%f"

    _550w_help_step "10" "完整示例: 仪式感"
    print -P "  %F{${_550w_C[dim]}}# 05_ceremony.zsh%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_box \"系统就绪\" \"\" \"即将进入终端\"%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 500%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_wave_v3 40%f"
    print -P "  %F{${_550w_C[dim]}}_550w_pause 300%f"
    print -P "  %F{${_550w_C[dim]}}_550w_anim_pulse_text \"READY\" 3%f"

    _550w_help_step "11" "注意"
    print "  · 不要 clear(会清掉前面动画)"
    print "  · 不要 exit(会中断开机)"
    print "  · 不要跑耗时命令(网络/大文件)"
    print "  · 检查 _550W_SKIP 响应跳过"
    print "  · 单个文件别超过 200 行"
    print "  · 出错了只是不执行, 不崩系统"

    _550w_help_step "12" "管理命令"
    _550w_help_cmd "550w-boot-anim-list"
    _550w_help_cmd "550w-boot-anim-new 02_xxx"
    _550w_help_cmd "550w-boot-anim-edit 02_xxx"
    _550w_help_cmd "550w-boot-anim-remove 02_xxx"
    _550w_help_cmd "550w-anim → 14   菜单"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  开机动画会加"
    _550w_help_pause
}
# ══════════════════ 调试技巧 ══════════════════

_550w_help_d09() {
    _550w_help_head "开发者指南 · 调试技巧"
    _550w_help_goal "快速定位 bug"
    _550w_help_cost "8 分钟" "★★★★☆"

    _550w_help_step "1" "语法检查"
    _550w_help_cmd "zsh -n ~/.550w/core.zsh"
    _550w_help_cmd "zsh -n ~/.550w/扩展/xxx/main.zsh"
    print ""
    print "  无输出 = 语法正确。"
    print "  有输出 → 看行号定位。"

    _550w_help_step "2" "定位语法错"
    _550w_help_cmd "zsh -n ~/.550w/xxx.zsh 2>&1 | head -3"
    print ""
    print "  输出类似:"
    print -P "  %F{${_550w_C[err]}}.../core.zsh:1234: parse error near 'fi'%f"
    print ""
    print "  用 sed 看那一带:"
    _550w_help_cmd "sed -n '1230,1240p' ~/.550w/core.zsh"

    _550w_help_step "3" "查找括号不匹配"
    print "  bash -n 会给更具体的提示:"
    _550w_help_cmd "bash -n ~/.550w/core.zsh 2>&1 | head -5"
    print ""
    print "  显示 'unexpected token' 附近的行号。"

    _550w_help_step "4" "统计括号"
    print "  用 awk 数 { } 是否配平:"
    print -P "  %F{${_550w_C[dim]}}awk '{o+=gsub(/{/,\"\"); c+=gsub(/}/,\"\")} END{print \"open=\" o \" close=\" c}' ~/.550w/xxx.zsh%f"
    print ""
    print "  两个数字应相等。"

    _550w_help_step "5" "set -x 追踪"
    print "  在函数里加:"
    print -P "  %F{${_550w_C[dim]}}myfun() {%f"
    print -P "  %F{${_550w_C[dim]}}    set -x%f"
    print -P "  %F{${_550w_C[dim]}}    你的代码%f"
    print -P "  %F{${_550w_C[dim]}}    set +x%f"
    print -P "  %F{${_550w_C[dim]}}}%f"
    print ""
    print "  会打印每行执行的命令。"

    _550w_help_step "6" "打印变量"
    print -P "  %F{${_550w_C[dim]}}print \"VAR=\$VAR\" >&2%f"
    print ""
    print "  用 >&2 打到 stderr 避免被吞。"

    _550w_help_step "7" "查看所有函数"
    _550w_help_cmd "print -l _550w_* _550w-* 550w-* | sort -u"

    _550w_help_step "8" "查看变量"
    _550w_help_cmd "set | grep _550W_ | head -50"
    _550w_help_cmd "typeset | grep _550W_"

    _550w_help_step "9" "调试模式"
    print -P "  %F{${_550w_C[dim]}}export _550W_LOG_LEVEL=4%f"
    print -P "  %F{${_550w_C[dim]}}unset _550W_LOADED && source ~/.zshrc%f"
    print ""
    print "  core.zsh 里的 _550w_log debug 会全部输出。"

    _550w_help_step "10" "调试插件"
    _550w_help_cmd "550w-plugin-errors"
    _550w_help_cmd "550w-plugin-logs 插件名"
    _550w_help_cmd "550w-plugin-info 插件名"
    _550w_help_cmd "source ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  source 不重定向 stderr, 会显示真实报错。"

    _550w_help_step "11" "调试开机动画"
    print "  手动跑:"
    _550w_help_cmd "source ~/.550w/boot_anim/01_xxx.zsh"
    print ""
    print "  看是否报错。"
    print "  或临时禁用:"
    _550w_help_cmd "mv ~/.550w/boot_anim/01_xxx.zsh{,.off}"

    _550w_help_step "12" "网络调试"
    _550w_help_cmd "curl -v --max-time 5 https://open.bigmodel.cn"
    _550w_help_cmd "ping -c 3 baidu.com"

    _550w_help_step "13" "查看进程"
    _550w_help_cmd "ps -ef | grep -v grep | grep 550w"
    print ""
    print "  Termux 上进程一般很少。"

    _550w_help_step "14" "调试 AI"
    print -P "  %F{${_550w_C[dim]}}echo \"Key: \${#ZHIPU_API_KEY} 字符\"%f"
    print -P "  %F{${_550w_C[dim]}}550w-moss%f"
    print -P "  %F{${_550w_C[dim]}}550w-settings → 6 → 13%f"
    print ""
    print "  健康检查会 curl 端点。"

    _550w_help_step "15" "逐步二分"
    print "  找不到 bug 时:"
    print "    1) 注释掉文件后半, 看还报错吗"
    print "    2) 逐步恢复, 直到报错"
    print "    3) 定位到那一段"
    print ""
    print "  用 head 截断:"
    _550w_help_cmd "head -1000 ~/.550w/core.zsh > /tmp/test.zsh"

    _550w_help_step "16" "开启 xtrace"
    _550w_help_cmd "zsh -x -c 'source ~/.550w/core.zsh' 2>&1 | tail -50"
    print ""
    print "  看最后 50 行, 错误就在附近。"

    _550w_help_step "17" "对比法"
    print "  出 bug 前有备份:"
    _550w_help_cmd "diff ~/.550w.bak/core.zsh ~/.550w/core.zsh"
    print ""
    print "  看改了哪。"

    _550w_help_step "18" "日志法"
    print "  在关键点插日志:"
    print -P "  %F{${_550w_C[dim]}}_550w_log debug \"到达 A\"%f"
    print -P "  %F{${_550w_C[dim]}}...%f"
    print -P "  %F{${_550w_C[dim]}}_550w_log debug \"到达 B\"%f"
    print ""
    print "  看走到哪一步停。"

    _550w_help_step "19" "隔离法"
    print "  把可疑代码挪到独立文件:"
    print -P "  %F{${_550w_C[dim]}}echo '可疑代码' > /tmp/test.zsh%f"
    print -P "  %F{${_550w_C[dim]}}zsh -n /tmp/test.zsh%f"
    print -P "  %F{${_550w_C[dim]}}zsh /tmp/test.zsh%f"
    print ""
    print "  单独跑, 排除上下文干扰。"

    _550w_help_step "20" "核对参考"
    print "  对照本手册各章:"
    print "    · 核心 API: 主菜单 → 8 → 2"
    print "    · MOSS API: 主菜单 → 8 → 3"
    print "    · 插件 API: 主菜单 → 8 → 5"

    _550w_help_divider
    print -P "  %F{${_550w_C[ok]}}%B✓ 完成%b%f  调试会了"
    _550w_help_pause
}

# ══════════════════ 变量索引 ══════════════════

_550w_help_d10() {
    _550w_help_head "开发者指南 · 变量索引" "所有 _550W_* 变量"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 核心%f"
    printf '  %-32s %s\n' "_550W_VERSION" "$_550W_VERSION"
    printf '  %-32s %s\n' "_550W_LOADED" "$_550W_LOADED"
    printf '  %-32s %s\n' "_550W_DONE" "$_550W_DONE"
    printf '  %-32s %s\n' "_550W_MODE" "$_550W_MODE"
    printf '  %-32s %s\n' "_550W_SESSION_ID" "$_550W_SESSION_ID"
    printf '  %-32s %s\n' "_550W_START_TIME" "$_550W_START_TIME"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 路径%f"
    printf '  %-32s %s\n' "_550W_PASS_FILE" "$_550W_PASS_FILE"
    printf '  %-32s %s\n' "_550W_PROFILE_FILE" "$_550W_PROFILE_FILE"
    printf '  %-32s %s\n' "_550W_CONFIG_FILE" "$_550W_CONFIG_FILE"
    printf '  %-32s %s\n' "_550W_SESSION_FILE" "$_550W_SESSION_FILE"
    printf '  %-32s %s\n' "_550W_MOSS_MEMORY_FILE" "$_550W_MOSS_MEMORY_FILE"
    printf '  %-32s %s\n' "_550W_MOSS_RATELIMIT_FILE" "$_550W_MOSS_RATELIMIT_FILE"
    printf '  %-32s %s\n' "_550W_MOSS_AUDIT_FILE" "$_550W_MOSS_AUDIT_FILE"
    printf '  %-32s %s\n' "_550W_PLUGIN_DIR" "$_550W_PLUGIN_DIR"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 界面%f"
    printf '  %-32s %s\n' "_550W_SPEED" "$_550W_SPEED"
    printf '  %-32s %s\n' "_550W_MODE_ANIM" "$_550W_MODE_ANIM"
    printf '  %-32s %s\n' "_550W_FX" "$_550W_FX"
    printf '  %-32s %s\n' "_550W_BEEP" "$_550W_BEEP"
    printf '  %-32s %s\n' "_550W_COLORS" "$_550W_COLORS"
    printf '  %-32s %s\n' "_550W_CURSOR_CTL" "$_550W_CURSOR_CTL"
    printf '  %-32s %s\n' "_550W_LOG_LEVEL" "$_550W_LOG_LEVEL"
    printf '  %-32s %s\n' "_550W_THEME" "$_550W_THEME"
    printf '  %-32s %s\n' "_550W_COLOR_PRIMARY" "${_550W_COLOR_PRIMARY:-cyan}"
    printf '  %-32s %s\n' "_550W_COLOR_ACCENT" "${_550W_COLOR_ACCENT:-ok}"
    printf '  %-32s %s\n' "_550W_COLOR_BG" "${_550W_COLOR_BG:-black}"
    printf '  %-32s %s\n' "_550W_FONT" "${_550W_FONT:-monospace}"
    printf '  %-32s %s\n' "_550W_FONT_SIZE" "${_550W_FONT_SIZE:-14}"
    printf '  %-32s %s\n' "_550W_TIME_FORMAT" "${_550W_TIME_FORMAT:-24h}"
    printf '  %-32s %s\n' "_550W_DATE_FORMAT" "${_550W_DATE_FORMAT:-Y-m-d}"
    printf '  %-32s %s\n' "_550W_BORDER_STYLE" "${_550W_BORDER_STYLE:-double}"
    printf '  %-32s %s\n' "_550W_SCANLINE" "${_550W_SCANLINE:-1}"
    printf '  %-32s %s\n' "_550W_STATUSBAR" "${_550W_STATUSBAR:-1}"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 提示符%f"
    printf '  %-32s %s\n' "_550W_PS1_MODE" "${_550W_PS1_MODE:-full}"
    printf '  %-32s %s\n' "_550W_PS1_SHOW_SID" "${_550W_PS1_SHOW_SID:-1}"
    printf '  %-32s %s\n' "_550W_PS1_SHOW_MODE" "${_550W_PS1_SHOW_MODE:-1}"
    printf '  %-32s %s\n' "_550W_PS1_SHOW_MOSS" "${_550W_PS1_SHOW_MOSS:-1}"
    printf '  %-32s %s\n' "_550W_PS1_SHOW_TIME" "${_550W_PS1_SHOW_TIME:-1}"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 认证%f"
    printf '  %-32s %s\n' "_550W_PASS" "已设置(长度 ${#_550W_PASS})"
    printf '  %-32s %s\n' "_550W_MAX_ATTEMPTS" "$_550W_MAX_ATTEMPTS"
    printf '  %-32s %s\n' "_550W_READ_TIMEOUT" "$_550W_READ_TIMEOUT"
    printf '  %-32s %s\n' "_550W_PW_MASK_MAX" "$_550W_PW_MASK_MAX"
    printf '  %-32s %s\n' "_550W_PASS_MIN_LEN" "${_550W_PASS_MIN_LEN:-4}"
    printf '  %-32s %s\n' "_550W_COOLDOWN_ATTEMPTS" "$_550W_COOLDOWN_ATTEMPTS"
    printf '  %-32s %s\n' "_550W_COOLDOWN_SECONDS" "$_550W_COOLDOWN_SECONDS"
    printf '  %-32s %s\n' "_550W_IDLE_LOCKOUT" "$_550W_IDLE_LOCKOUT"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 用户档案%f"
    printf '  %-32s %s\n' "_550W_USER_NAME" "$_550W_USER_NAME"
    printf '  %-32s %s\n' "_550W_USER_LEVEL" "$_550W_USER_LEVEL"
    printf '  %-32s %s\n' "_550W_USER_ROLE" "$_550W_USER_ROLE"
    printf '  %-32s %s\n' "_550W_USER_MOTTO" "$_550W_USER_MOTTO"
    printf '  %-32s %s\n' "_550W_USER_AVATAR" "${_550W_USER_AVATAR:-(空)}"
    printf '  %-32s %s\n' "_550W_USER_JOINED" "$_550W_USER_JOINED"
    printf '  %-32s %s\n' "_550W_USER_LOGINS" "$_550W_USER_LOGINS"
    printf '  %-32s %s\n' "_550W_USER_LASTLOGIN" "${_550W_USER_LASTLOGIN:-(空)}"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ MOSS%f"
    printf '  %-32s %s\n' "_550W_MOSS_ENABLED" "$_550W_MOSS_ENABLED"
    printf '  %-32s %s\n' "_550W_MOSS_PROVIDER" "$_550W_MOSS_PROVIDER"
    printf '  %-32s %s\n' "_550W_MOSS_MODEL" "$_550W_MOSS_MODEL"
    printf '  %-32s %s\n' "_550W_MOSS_MODE" "$_550W_MOSS_MODE"
    printf '  %-32s %s\n' "_550W_MOSS_TEMPERATURE" "$_550W_MOSS_TEMPERATURE"
    printf '  %-32s %s\n' "_550W_MOSS_MAX_TOKENS" "$_550W_MOSS_MAX_TOKENS"
    printf '  %-32s %s\n' "_550W_MOSS_CTX_WINDOW" "$_550W_MOSS_CTX_WINDOW"
    printf '  %-32s %s\n' "_550W_MOSS_MEMORY_MAX" "$_550W_MOSS_MEMORY_MAX"
    printf '  %-32s %s\n' "_550W_MOSS_TIMEOUT" "$_550W_MOSS_TIMEOUT"
    printf '  %-32s %s\n' "_550W_MOSS_AUDIT_ENABLED" "$_550W_MOSS_AUDIT_ENABLED"
    printf '  %-32s %s\n' "_550W_MOSS_HEALTH" "$_550W_MOSS_HEALTH"
    printf '  %-32s %s\n' "_550W_MOSS_RATELIMIT_DAILY" "$_550W_MOSS_RATELIMIT_DAILY"
    printf '  %-32s %s\n' "_550W_MOSS_RATELIMIT_USED" "$_550W_MOSS_RATELIMIT_USED"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ MOSS 对话%f"
    printf '  %-32s %s\n' "_550W_MOSS_REPLY" "${_550W_MOSS_REPLY:0:40}..."
    printf '  %-32s %s\n' "_550W_MOSS_LAST_MS" "$_550W_MOSS_LAST_MS"
    printf '  %-32s %s\n' "_550W_MOSS_HISTORY" "${#_550W_MOSS_HISTORY[@]} 条"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 插件%f"
    printf '  %-32s %s\n' "_550W_PLUGIN_LIST" "${#_550W_PLUGIN_LIST[@]} 个"
    printf '  %-32s %s\n' "_550W_PLUGIN_LOADED" "${#_550W_PLUGIN_LOADED[@]} 个"
    printf '  %-32s %s\n' "_550W_PLUGIN_ERRORS" "${#_550W_PLUGIN_ERRORS[@]} 个"
    printf '  %-32s %s\n' "_550W_PLUGIN_CURRENT" "${_550W_PLUGIN_CURRENT:-(未加载)}"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 高级%f"
    printf '  %-32s %s\n' "_550W_HEARTBEAT_INTERVAL" "$_550W_HEARTBEAT_INTERVAL"
    printf '  %-32s %s\n' "_550W_CMD_TIMING_THRESHOLD" "$_550W_CMD_TIMING_THRESHOLD"
    printf '  %-32s %s\n' "_550W_STATS_ENABLED" "${_550W_STATS_ENABLED:-1}"
    printf '  %-32s %s\n' "_550W_STATS_MAX_LINES" "${_550W_STATS_MAX_LINES:-5000}"
    printf '  %-32s %s\n' "_550W_LOG_KEEP_DAYS" "${_550W_LOG_KEEP_DAYS:-30}"
    printf '  %-32s %s\n' "_550W_BACKUP_KEEP" "${_550W_BACKUP_KEEP:-10}"
    printf '  %-32s %s\n' "_550W_BACKUP_AUTO" "${_550W_BACKUP_AUTO:-0}"
    printf '  %-32s %s\n' "_550W_BACKUP_COMPRESS" "${_550W_BACKUP_COMPRESS:-1}"
    printf '  %-32s %s\n' "_550W_LOG_ROTATE_SIZE" "${_550W_LOG_ROTATE_SIZE:-1048576}"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 运行时%f"
    printf '  %-32s %s\n' "_550W_SKIP" "$_550W_SKIP"
    printf '  %-32s %s\n' "_550W_EMERGENCY" "$_550W_EMERGENCY"
    printf '  %-32s %s\n' "_550W_ATTEMPTS" "$_550W_ATTEMPTS"
    printf '  %-32s %s\n' "_550W_FAIL_COUNT" "$_550W_FAIL_COUNT"
    printf '  %-32s %s\n' "_550W_LAST_ACTIVITY" "$_550W_LAST_ACTIVITY"
    printf '  %-32s %s\n' "_550W_LAST_BEAT" "$_550W_LAST_BEAT"
    printf '  %-32s %s\n' "_550W_CMD_START" "$_550W_CMD_START"
    print ""

    print -P "  %F{${_550w_C[ok]}}%B▸ 颜色表 (部分)%f"
    printf '  \e[38;5;%sm%-32s\e[0m %s\n' "${_550W_C[cyan]}" "_550W_C[cyan]" "${_550W_C[cyan]}"
    printf '  \e[38;5;%sm%-32s\e[0m %s\n' "${_550W_C[ok]}" "_550W_C[ok]" "${_550W_C[ok]}"
    printf '  \e[38;5;%sm%-32s\e[0m %s\n' "${_550W_C[warn]}" "_550W_C[warn]" "${_550W_C[warn]}"
    printf '  \e[38;5;%sm%-32s\e[0m %s\n' "${_550W_C[err]}" "_550W_C[err]" "${_550W_C[err]}"
    printf '  \e[38;5;%sm%-32s\e[0m %s\n' "${_550W_C[dim]}" "_550W_C[dim]" "${_550W_C[dim]}"
    print ""

    print -P "  %F{${_550w_C[dim]}}按回车返回...%f"
    read -r
}
# ══════════════════ FAQ · 主菜单 ══════════════════

_550w_help_menu_faq() {
    while true; do
        _550w_help_head "FAQ" "50 个常见问题"
        print ""
        _550w_help_sub "按类别浏览"
        _550w_help_row "1"  "安装与启动" "8 个"
        _550w_help_row "2"  "AI 对话"    "10 个"
        _550w_help_row "3"  "密码与安全" "6 个"
        _550w_help_row "4"  "主题与外观" "6 个"
        _550w_help_row "5"  "插件"       "8 个"
        _550w_help_row "6"  "备份与数据" "6 个"
        _550w_help_row "7"  "故障排除"   "6 个"

        _550w_help_sub "搜索"
        _550w_help_row "8"  "搜索问题"   "关键词查找"

        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_install ;;
            2) _550w_help_faq_ai ;;
            3) _550w_help_faq_pass ;;
            4) _550w_help_faq_theme ;;
            5) _550w_help_faq_plugin ;;
            6) _550w_help_faq_backup ;;
            7) _550w_help_faq_trouble ;;
            8) _550w_help_faq_search ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_search() {
    _550w_help_head "FAQ 搜索"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    _550w_help_info "搜索功能需手动 grep 本文件:"
    print ""
    print -P "  %F{${_550w_C[dim]}}grep -A 5 \"\$kw\" ~/.550w/help.zsh%f"
    print ""
    print -P "  %F{${_550w_C[dim]}}或: 550w-help → 2 → 6 命令搜索%f"
    print ""
    _550w_help_pause
}

# ══════════════════ FAQ · 安装与启动 ══════════════════

_550w_help_faq_install() {
    while true; do
        _550w_help_head "FAQ · 安装与启动" "8 个"
        print ""
        _550w_help_row "1" "打开 Termux 没动画"
        _550w_help_row "2" "开机后白屏/卡住"
        _550w_help_row "3" "提示 command not found: 550w-*"
        _550w_help_row "4" "开机动画播一半停了"
        _550w_help_row "5" "PS1 显示异常"
        _550w_help_row "6" "Termux 每次打开都从零开始"
        _550w_help_row "7" "开机速度太慢"
        _550w_help_row "8" "想卸载 550W"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_i1 ;;
            2) _550w_help_faq_i2 ;;
            3) _550w_help_faq_i3 ;;
            4) _550w_help_faq_i4 ;;
            5) _550w_help_faq_i5 ;;
            6) _550w_help_faq_i6 ;;
            7) _550w_help_faq_i7 ;;
            8) _550w_help_faq_i8 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_i1() {
    _550w_help_head "FAQ" "打开 Termux 没动画"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 打开 Termux 后一片黑, 没有矩阵雨/BIOS POST 等动画。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三步排查。"
    print ""
    print "  步骤 1: 检查 .zshrc"
    _550w_help_cmd "grep 550w ~/.zshrc"
    print ""
    print "  期望: 看到 source ~/.550w/core.zsh"
    print "  没有 → 加:"
    _550w_help_cmd 'echo "source ~/.550w/core.zsh" >> ~/.zshrc'
    print ""
    print "  步骤 2: 检查 core.zsh 存在"
    _550w_help_cmd "ls -la ~/.550w/core.zsh"
    print ""
    print "  没有 → 550W 未安装 或 文件丢失。"
    print ""
    print "  步骤 3: 语法检查"
    _550w_help_cmd "zsh -n ~/.550w/core.zsh"
    print ""
    print "  有输出 → 看行号, 定位修。"
    print "  无输出 → 试:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    print "  还不行 → 重启 Termux。"
    print ""
    _550w_help_pause
}

_550w_help_faq_i2() {
    _550w_help_head "FAQ" "开机后白屏/卡住"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 开机动画播到一半不动了, 或白屏。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 分情况。"
    print ""
    print "  情况 A: 卡在动画里"
    print "    · 按任意键跳过"
    print "    · 或按 q 紧急退出"
    print ""
    print "  情况 B: 卡在密码框"
    print "    · Ctrl+C 中断"
    print "    · 550w-reset 重置登录"
    print ""
    print "  情况 C: 完全白屏/黑屏"
    print "    · 关掉 Termux 重开"
    print "    · 还不行, 长按 Termux 图标 → 强制停止"
    print ""
    print "  情况 D: 提示符显示乱码"
    _550w_help_cmd "reset"
    print ""
    print "  情况 E: 输入命令无响应"
    print "    · Ctrl+C"
    print "    · Ctrl+D 退出 shell"
    print "    · 重开"
    print ""
    _550w_help_pause
}

_550w_help_faq_i3() {
    _550w_help_head "FAQ" "command not found: 550w-*"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 敲 550w-status 报 'command not found'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 核心未加载或扩展缺失。"
    print ""
    print "  排查 1: 核心加载了吗"
    _550w_help_cmd "echo \$ _550W_LOADED"
    print "  期望: 1"
    print "  空或 0 → 核心没加载。"
    print ""
    print "  排查 2: 命令定义了没"
    _550w_help_cmd "which 550w-status"
    print "  期望: 显示函数定义。"
    print "  空 → 命令确实没定义。"
    print ""
    print "  修复 1: 重新加载"
    _550w_help_cmd "unset _550W_LOADED"
    _550w_help_cmd "source ~/.zshrc"
    print ""
    print "  修复 2: 重启 shell"
    _550w_help_cmd "exec zsh"
    print ""
    print "  修复 3: 检查扩展文件"
    _550w_help_cmd "ls ~/.550w/*.zsh"
    print "  应看到: core/real/anim/help/settings/extras/new"
    print ""
    print "  修复 4: 检查加载器"
    _550w_help_cmd "grep 'for _550w_ext' ~/.550w/core.zsh"
    print "  确认扩展名列表正确。"
    print ""
    _550w_help_pause
}

_550w_help_faq_i4() {
    _550w_help_head "FAQ" "开机动画播一半停了"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 开机动画走到某一步就不继续了。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 常见几种。"
    print ""
    print "  原因 1: 等用户输入"
    print "    · 密码框在等密码(正常)"
    print "    · 欢迎画在等回车(正常)"
    print ""
    print "  原因 2: 某步卡住了"
    print "    · 网络步骤: curl 可能超时"
    print "    · 检查网络: 关掉 wifi 试试"
    print ""
    print "  原因 3: boot_anim 里有个死循环"
    print "    · 检查你的 ~/.550w/boot_anim/*.zsh"
    print "    · 临时禁用: mv boot_anim boot_anim.off"
    print ""
    print "  原因 4: 某扩展文件报错中断"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc 2>&1 | tail -20"
    print "  看报错。"
    print ""
    _550w_help_pause
}

_550w_help_faq_i5() {
    _550w_help_head "FAQ" "PS1 显示异常"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 提示符显示乱码或含 '%F{...}' 字面字符。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f PS1 转义没被解释。"
    print ""
    print "  排查:"
    _550w_help_cmd "echo \$PS1"
    print ""
    print "  如果看到字面 '%F{51}' → 问题在此。"
    print ""
    print "  修复:"
    _550w_help_cmd "550w-settings → 2 → 6   应用"
    print "  或:"
    _550w_help_cmd "_550w_build_ps1"
    print ""
    print "  还不行 → 手动检查:"
    _550w_help_cmd "grep -A 5 '_550w_build_ps1' ~/.550w/core.zsh"
    print ""
    print "  PS1 里应该用 $'...' 单引号美元形式:"
    print -P "  %F{${_550w_C[dim]}}PS1=\$'%F{51}...'%f"
    print ""
    _550w_help_pause
}

_550w_help_faq_i6() {
    _550w_help_head "FAQ" "Termux 每次打开都从零开始"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 每次打开 Termux 都重头来, 配置不保存。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 数据保存在 ~/.550w/, 应持久。"
    print ""
    print "  排查 1: 家目录是否持久"
    _550w_help_cmd "ls -la ~/.550w/.550w_config"
    print ""
    print "  不存在 → 配置没保存。"
    print "  存在但改了不生效 → 加载器问题。"
    print ""
    print "  排查 2: .zshrc 是否被覆盖"
    print "  Termux 升级/重装可能重置。"
    _550w_help_cmd "cat ~/.zshrc"
    print ""
    print "  排查 3: 存储权限"
    _550w_help_cmd "termux-setup-storage"
    print ""
    print "  排查 4: 手动保存配置"
    _550w_help_cmd "550w-settings → 8 → 1"
    print ""
    _550w_help_pause
}

_550w_help_faq_i7() {
    _550w_help_head "FAQ" "开机速度太慢"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 开机动画播十几秒, 想快点进终端。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 调速度和特效。"
    print ""
    print "  极速方案:"
    _550w_help_cmd "550w-speed flash"
    _550w_help_cmd "550w-fx 0"
    print "  效果: 3 秒内进"
    print ""
    print "  完全跳过(包括动画):"
    _550w_help_cmd "550w-speed instant"
    _550w_help_cmd "550w-settings → 1 → 3  → silent"
    print "  效果: 1 秒"
    print ""
    print "  临时跳过(本次):"
    print "    · 动画时按任意键"
    print "    · 或 q 直接退"
    print ""
    print "  单次会话跳过登录:"
    _550w_help_cmd "550w-skip"
    print ""
    _550w_help_pause
}

_550w_help_faq_i8() {
    _550w_help_head "FAQ" "想卸载 550W"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想彻底删除 550W, 回到普通 Termux。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三步。"
    print ""
    print "  步骤 1: 备份(可选)"
    _550w_help_cmd 'cp -r ~/.550w ~/550w_backup_$(date +%Y%m%d)'
    print ""
    print "  步骤 2: 从 .zshrc 删 source 行"
    _550w_help_cmd "nano ~/.zshrc"
    print "  删除 'source ~/.550w/core.zsh' 那一行。"
    print ""
    print "  或一键:"
    _550w_help_cmd "sed -i '/550w\\/core.zsh/d' ~/.zshrc"
    print ""
    print "  步骤 3: 删除数据"
    _550w_help_cmd "rm -rf ~/.550w"
    print ""
    print "  步骤 4: 重启"
    _550w_help_cmd "exec zsh"
    print ""
    print "  完全卸载完成。"
    print ""
    print -P "  %F{${_550w_C[warn]}}⚠ 删除后不可恢复(除非有备份)%f"
    print ""
    _550w_help_pause
}
# ══════════════════ FAQ · AI 对话 ══════════════════

_550w_help_faq_ai() {
    while true; do
        _550w_help_head "FAQ · AI 对话" "10 个"
        print ""
        _550w_help_row "1"  "AI 不回复"
        _550w_help_row "2"  "缺少 API Key"
        _550w_help_row "3"  "已达每日限额"
        _550w_help_row "4"  "调用失败"
        _550w_help_row "5"  "回复乱码/截断"
        _550w_help_row "6"  "上下文丢失"
        _550w_help_row "7"  "想切模型"
        _550w_help_row "8"  "AI 回复太慢"
        _550w_help_row "9"  "AI 不懂中文"
        _550w_help_row "10" "如何导出对话"
        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_a1 ;;
            2) _550w_help_faq_a2 ;;
            3) _550w_help_faq_a3 ;;
            4) _550w_help_faq_a4 ;;
            5) _550w_help_faq_a5 ;;
            6) _550w_help_faq_a6 ;;
            7) _550w_help_faq_a7 ;;
            8) _550w_help_faq_a8 ;;
            9) _550w_help_faq_a9 ;;
            10) _550w_help_faq_a10 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_a1() {
    _550w_help_head "FAQ · AI" "不回复"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 550w-ai \"你好\" 没反应, 或显示 '(空响应)'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 分步排查。"
    print ""
    print "  步骤 1: 检查开关"
    _550w_help_cmd "550w-moss"
    print "  看 '启用' 是不是 1。"
    print "  不是 → 550w-settings → 6 → 1"
    print ""
    print "  步骤 2: 检查 API Key"
    _550w_help_cmd "550w-moss"
    print "  看 'Token' 是不是 '已配置'。"
    print "  不是 → 550w-settings → 6 → 12"
    print ""
    print "  步骤 3: 健康检查"
    _550w_help_cmd "550w-settings → 6 → 13"
    print "  看 MOSS 是否 ok。"
    print ""
    print "  步骤 4: 检查网络"
    _550w_help_cmd "curl -v --max-time 5 https://open.bigmodel.cn"
    print "  超时 → 网络问题。"
    print ""
    print "  步骤 5: 换 provider"
    _550w_help_cmd "550w-moss-set deepseek"
    print ""
    _550w_help_pause
}

_550w_help_faq_a2() {
    _550w_help_head "FAQ · AI" "缺少 API Key"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 提示 '缺少 API Key'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 环境变量未设置, 或设了但没生效。"
    print ""
    print "  排查 1: 环境变量存在吗"
    _550w_help_cmd "echo \$ZHIPU_API_KEY"
    print "  空 → 未设置。"
    print ""
    print "  排查 2: 设置并生效"
    _550w_help_cmd 'echo "export ZHIPU_API_KEY=\"你的Key\"" >> ~/.zshrc'
    _550w_help_cmd "source ~/.zshrc"
    print ""
    print "  或一键:"
    _550w_help_cmd "550w-settings → 6 → 12"
    print "  它会问是否写入 ~/.zshrc。"
    print ""
    print "  排查 3: 换 provider 后 Key 名字不同"
    print "  deepseek 用 DEEPSEEK_API_KEY"
    print "  qwen 用 DASHSCOPE_API_KEY"
    print ""
    _550w_help_pause
}

_550w_help_faq_a3() {
    _550w_help_head "FAQ · AI" "已达每日限额"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 提示 '已达每日限额'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 550W 内置速率限制(默认 2000/天), 防止烧钱。"
    print ""
    print "  查看:"
    _550w_help_cmd "550w-moss"
    print "  看 '额度' 一行: 3/2000 表示已用 3 条。"
    print ""
    print "  方案 1: 提高上限"
    _550w_help_cmd "550w-settings → 6 → 9"
    print "  输入更大数字(最大 99999)。"
    print ""
    print "  方案 2: 手动重置"
    _550w_help_cmd "rm ~/.550w/.550w_ratelimit"
    print "  下次调用会从 0 开始。"
    print ""
    print "  方案 3: 关闭限制"
    print "  把上限设为 99999(等于没限)。"
    print ""
    print -P "  %F{${_550w_C[warn]}}⚠ 真实限额由 API 服务商控制, 550W 只是本地计数%f"
    print ""
    _550w_help_pause
}

_550w_help_faq_a4() {
    _550w_help_head "FAQ · AI" "调用失败"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 提示 '调用失败'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 网络/Key/端点 三者之一。"
    print ""
    print "  排查 1: 端点可达"
    _550w_help_cmd "echo \$_550W_MOSS_CLOUD_URL"
    _550w_help_cmd "curl -v \$ZHIPU_API_KEY https://open.bigmodel.cn"
    print ""
    print "  排查 2: 查看审计"
    _550w_help_cmd 'tail -5 ~/.550w/.550w_audit'
    print "  看最后一次调用的耗时。"
    print ""
    print "  排查 3: 换 provider 对比"
    _550w_help_cmd "550w-glm"
    _550w_help_cmd '550w-ai "hi"'
    print ""
    print "  排查 4: 实时调试"
    _550w_help_cmd "curl -X POST https://open.bigmodel.cn/api/paas/v4/chat/completions -H \"Authorization: Bearer \$ZHIPU_API_KEY\" -H 'Content-Type: application/json' -d '{\"model\":\"glm-4-flash\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}]}'"
    print ""
    print "  看返回什么。"
    print ""
    _550w_help_pause
}

_550w_help_faq_a5() {
    _550w_help_head "FAQ · AI" "回复乱码/截断"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f AI 回复显示乱码, 或只有一半。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 字符集或解析问题。"
    print ""
    print "  排查 1: 字符集"
    _550w_help_cmd "echo \$LANG"
    print "  期望: 含 UTF-8"
    print "  没有 → 加到 .zshrc:"
    _550w_help_cmd 'echo "export LANG=en_US.UTF-8" >> ~/.zshrc'
    _550w_help_cmd "source ~/.zshrc"
    print ""
    print "  排查 2: Termux 字体"
    print "  换字体: 长按屏幕 → 更多 → 字体"
    print ""
    print "  排查 3: 截断"
    print "  回复被截断 → 可能 JSON 解析问题。"
    print "  看原始回复:"
    _550w_help_cmd "curl -X POST ... (同上, 直接跑 curl)"
    print ""
    print "  排查 4: 查看完整回复"
    _550w_help_cmd "echo \$_550W_MOSS_REPLY"
    print ""
    _550w_help_pause
}

_550w_help_faq_a6() {
    _550w_help_head "FAQ · AI" "上下文丢失"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 说了名字, 再问 AI 不记得了。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 几种可能。"
    print ""
    print "  原因 1: 上下文窗口满了"
    print "  默认 10 轮, 超过会丢弃最旧的。"
    _550w_help_cmd "550w-settings → 6 → 7"
    print "  改为更大(如 20)。"
    print ""
    print "  原因 2: 记忆没保存"
    _550w_help_cmd "550w-memory show"
    print "  如果有前文 → 记忆正常。"
    print ""
    print "  原因 3: 关掉 Termux 后未加载"
    _550w_help_cmd "550w-memory show"
    print "  为空 → 记忆文件丢了。"
    print ""
    print "  原因 4: 记忆上限太小"
    _550w_help_cmd "550w-settings → 6 → 8"
    print "  默认 50 条, 加大(如 200)。"
    print ""
    print "  原因 5: 在子 shell 里调用"
    print "  ✗ result=\$(550w-ai \"hi\")"
    print "  ✓ 550w-ai \"hi\""
    print ""
    _550w_help_pause
}

_550w_help_faq_a7() {
    _550w_help_head "FAQ · AI" "想切模型"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想换 AI 模型。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 550W 支持 15 个 provider。"
    print ""
    print "  方式 1: 菜单"
    _550w_help_cmd "550w-moss-set"
    print "  会列出所有, 输入名字。"
    print ""
    print "  方式 2: 直接"
    _550w_help_cmd "550w-moss-set deepseek"
    _550w_help_cmd "550w-moss-set qwen"
    _550w_help_cmd "550w-moss-set moonshot"
    print ""
    print "  方式 3: 一键回智谱"
    _550w_help_cmd "550w-glm"
    print ""
    print "  方式 4: 图形界面"
    _550w_help_cmd "550w-settings → 6 → 2"
    print ""
    print "  15 个 provider:"
    print "    glm / glm-pro / glm-air / zai"
    print "    openai / deepseek / moonshot"
    print "    qwen / groq / siliconflow / openrouter / mistral / stepfun"
    print "    local / custom"
    print ""
    _550w_help_pause
}

_550w_help_faq_a8() {
    _550w_help_head "FAQ · AI" "回复太慢"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f AI 回复要等好久。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 多因素。"
    print ""
    print "  原因 1: 网络"
    _550w_help_cmd "550w-real → 1"
    print "  看网络延迟。"
    print ""
    print "  原因 2: provider 慢"
    print "  · glm-4-flash 快"
    print "  · glm-4-plus 慢但强"
    print "  · groq 极快"
    print "  · qwen-turbo 快"
    _550w_help_cmd "550w-moss-set groq"
    print ""
    print "  原因 3: MaxTokens 太大"
    _550w_help_cmd "550w-settings → 6 → 6"
    print "  改小(如 512)"
    print ""
    print "  原因 4: 上下文太长"
    _550w_help_cmd "550w-settings → 6 → 7"
    print "  改小(如 5 轮)"
    print ""
    print "  原因 5: 请求超时设置"
    _550w_help_cmd "550w-settings → 6 → 10"
    print ""
    _550w_help_pause
}

_550w_help_faq_a9() {
    _550w_help_head "FAQ · AI" "AI 不懂中文"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 用中文问, AI 回英文。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 模型本身问题。"
    print ""
    print "  国产 provider 中文好:"
    print "  · glm(智谱)"
    print "  · deepseek"
    print "  · qwen(通义)"
    print "  · moonshot(月之暗面)"
    print ""
    print "  海外 provider 英文好:"
    print "  · openai"
    print "  · mistral"
    print ""
    print "  切换:"
    _550w_help_cmd "550w-moss-set glm"
    print ""
    print "  或者明确要求:"
    _550w_help_cmd '550w-ai "用中文回答: what is AI"'
    _550w_help_cmd '550w-ai "请始终用简体中文回复"'
    print ""
    print "  长期设置: 用系统提示词"
    _550w_help_cmd "550w-new → 3 → 7   角色预设"
    print ""
    _550w_help_pause
}

_550w_help_faq_a10() {
    _550w_help_head "FAQ · AI" "如何导出对话"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想把对话记录导出保存。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三种方式。"
    print ""
    print "  方式 1: 导出为 Markdown"
    _550w_help_cmd "550w-new → 2 → 5"
    print "  生成 ~/.550w/new/chats/export_xxx.md"
    print ""
    print "  方式 2: 导出为 JSON"
    _550w_help_cmd "550w-new → 2 → 6"
    print "  生成 export_xxx.json"
    print ""
    print "  方式 3: 直接看记忆文件"
    _550w_help_cmd "cat ~/.550w/.550w_moss_memory"
    print "  每行一条 JSON 消息。"
    print ""
    print "  方式 4: 用 550w-memory"
    _550w_help_cmd "550w-memory path"
    print "  拿到文件路径。"
    print ""
    print "  保存到共享存储:"
    _550w_help_cmd 'cp ~/.550w/new/chats/export_*.md /storage/emulated/0/Download/'
    print ""
    print "  或从 550w-extras:"
    _550w_help_cmd "550w-extras → 10 → 4   导出记忆"
    print ""
    _550w_help_pause
}
# ══════════════════ FAQ · 密码与安全 ══════════════════

_550w_help_faq_pass() {
    while true; do
        _550w_help_head "FAQ · 密码与安全" "6 个"
        print ""
        _550w_help_row "1" "密码忘了"
        _550w_help_row "2" "改密码"
        _550w_help_row "3" "密码强度要求"
        _550w_help_row "4" "被锁定怎么办"
        _550w_help_row "5" "文件权限"
        _550w_help_row "6" "密码明文存储安全吗"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_p1 ;;
            2) _550w_help_faq_p2 ;;
            3) _550w_help_faq_p3 ;;
            4) _550w_help_faq_p4 ;;
            5) _550w_help_faq_p5 ;;
            6) _550w_help_faq_p6 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_p1() {
    _550w_help_head "FAQ · 密码" "密码忘了"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 密码忘了, 进不去系统。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三种方法。"
    print ""
    print "  方法 1: 设置中心重置"
    print "    能进系统(还没锁):"
    _550w_help_cmd "550w-settings → 4 → 2"
    print "    密码重置为默认 563214789"
    print ""
    print "  方法 2: 手动改文件"
    _550w_help_cmd 'echo "563214789" > ~/.550w/.550w_pass'
    _550w_help_cmd "chmod 600 ~/.550w/.550w_pass"
    print ""
    print "  方法 3: 用紧急脚本(如果存在)"
    _550w_help_cmd "bash ~/.550w_emergency.sh"
    print "    选 3 重置密码"
    print ""
    print "  之后重启:"
    _550w_help_cmd "550w-reset"
    print ""
    print "  默认密码: 563214789"
    print ""
    _550w_help_pause
}

_550w_help_faq_p2() {
    _550w_help_head "FAQ · 密码" "改密码"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 怎么改密码?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三种方式。"
    print ""
    print "  方式 1(推荐): 设置中心"
    _550w_help_cmd "550w-settings → 4 → 1"
    print "  输两次确认。"
    print ""
    print "  方式 2: 命令行"
    _550w_help_cmd 'echo "我的新密码" > ~/.550w/.550w_pass'
    _550w_help_cmd "chmod 600 ~/.550w/.550w_pass"
    print ""
    print "  方式 3: nano 编辑"
    _550w_help_cmd "nano ~/.550w/.550w_pass"
    print ""
    print "  改完立即生效(下次登录用新密码)。"
    print ""
    _550w_help_pause
}

_550w_help_faq_p3() {
    _550w_help_head "FAQ · 密码" "强度要求"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 密码要几位? 有强度要求吗?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 默认最小 4 位, 可调。"
    print ""
    print "  改最小长度:"
    _550w_help_cmd "550w-settings → 4 → 3"
    print "  范围 4~32。"
    print ""
    print "  强度显示:"
    printf '  \e[38;5;%s m%-8s\e[0m %s\n' "196" "弱" "长度 < 4"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "220" "中" "长度 4~7"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "46" "强" "长度 8~11"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "51" "极强" "长度 ≥ 12"
    print ""
    print "  建议: 8 位以上, 混合数字字母。"
    print ""
    print "  注意: 550W 不检查字符种类, 只看长度。"
    print ""
    _550w_help_pause
}

_550w_help_faq_p4() {
    _550w_help_head "FAQ · 密码" "被锁定怎么办"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 输错 3 次被锁定, 进不去。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 几种解锁方式。"
    print ""
    print "  原因: 连续失败 3 次(默认), 或空闲 30 分钟锁定。"
    print ""
    print "  解锁 1: 重启 shell"
    _550w_help_cmd "550w-reset"
    print ""
    print "  解锁 2: 重开 Termux"
    print "    · 关掉 Termux"
    print "    · 重新打开"
    print ""
    print "  解锁 3: 改锁定阈值"
    _550w_help_cmd "550w-settings → 4 → 5"
    print "  改最大尝试次数(如 10)。"
    print ""
    print "  解锁 4: 关空闲锁定"
    _550w_help_cmd "550w-settings → 4 → 9"
    print "  改空闲锁定秒数(如 86400 = 1天)。"
    print ""
    print "  解锁 5: 查看失败次数"
    _550w_help_cmd "550w-status"
    print "  看 '失败' 字段。"
    print ""
    _550w_help_pause
}

_550w_help_faq_p5() {
    _550w_help_head "FAQ · 密码" "文件权限"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 密码文件权限是啥? 安全吗?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 全部 600, 仅自己可读。"
    print ""
    print "  查看:"
    _550w_help_cmd "ls -la ~/.550w/.550w_pass"
    print "  应显示 -rw------- 或 -rw-------"
    print ""
    print "  如果权限变了:"
    _550w_help_cmd "chmod 600 ~/.550w/.550w_pass"
    print ""
    print "  其它敏感文件:"
    _550w_help_cmd "ls -la ~/.550w/.550w_profile"
    _550w_help_cmd "ls -la ~/.550w/.550w_config"
    _550w_help_cmd "ls -la ~/.550w/.550w_moss_memory"
    print ""
    print "  都应该 600。"
    print ""
    print "  批量修复:"
    _550w_help_cmd "chmod 600 ~/.550w/.550w_*"
    print ""
    _550w_help_pause
}

_550w_help_faq_p6() {
    _550w_help_head "FAQ · 密码" "明文存储安全吗"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 密码是明文存储, 安全吗?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 本地个人使用场景够用, 但不是绝对安全。"
    print ""
    print "  防护:"
    print "    · 权限 600, 其它 App 读不到"
    print "    · Android 沙箱隔离"
    print "    · 不知道路径也拿不到"
    print ""
    print "  风险:"
    print "    · 手机 root 后可读"
    print "    · 通过 MT 管理器也能看"
    print "    · 备份文件不加密"
    print ""
    print "  加强建议:"
    print "    · 用 8 位以上密码"
    print "    · 别写明显词汇"
    print "    · 备份时选'加密备份'(9 → 3)"
    print ""
    print "  想要真正安全: 用磁盘加密"
    print "  (Termux 本身不支持, 需 Android 全盘加密)"
    print ""
    _550w_help_pause
}

# ══════════════════ FAQ · 主题与外观 ══════════════════

_550w_help_faq_theme() {
    while true; do
        _550w_help_head "FAQ · 主题与外观" "6 个"
        print ""
        _550w_help_row "1" "换主题"
        _550w_help_row "2" "主题不生效"
        _550w_help_row "3" "自定义配色"
        _550w_help_row "4" "改提示符"
        _550w_help_row "5" "屏幕太窄显示乱"
        _550w_help_row "6" "字体太小/太大"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_t1 ;;
            2) _550w_help_faq_t2 ;;
            3) _550w_help_faq_t3 ;;
            4) _550w_help_faq_t4 ;;
            5) _550w_help_faq_t5 ;;
            6) _550w_help_faq_t6 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_t1() {
    _550w_help_head "FAQ · 主题" "换主题"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 怎么换主题?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 5 套内置, 切换简单。"
    print ""
    print "  内置主题:"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "51"  "cyber"   "经典青蓝"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "214" "amber"   "琥珀暖色"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "45"  "ice"     "冰蓝冷色"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "34"  "moss"    "深绿"
    printf '  \e[38;5;%sm●\e[0m %-10s %s\n' "196" "crimson" "猩红"
    print ""
    print "  命令行:"
    _550w_help_cmd "550w-theme cyber"
    _550w_help_cmd "550w-theme ice"
    print ""
    print "  菜单:"
    _550w_help_cmd "550w-settings → 3"
    print ""
    print "  生效: 部分立即, 部分下次启动。"
    print "  强制刷新: unset _550W_LOADED && source ~/.zshrc"
    print ""
    _550w_help_pause
}

_550w_help_faq_t2() {
    _550w_help_head "FAQ · 主题" "主题不生效"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 切了主题但界面颜色没变。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 重新加载。"
    print ""
    print "  原因: 主题色表在内存里, 改了变量不重绘。"
    print ""
    print "  修复 1:"
    _550w_help_cmd "unset _550W_LOADED"
    _550w_help_cmd "source ~/.zshrc"
    print ""
    print "  修复 2:"
    _550w_help_cmd "exec zsh"
    print ""
    print "  修复 3: 检查主题文件"
    _550w_help_cmd "cat ~/.550w/.550w_config | grep THEME"
    print "  看 THEME 是不是改后的。"
    print ""
    print "  修复 4: 手动设置"
    _550w_help_cmd "_550W_THEME=\"ice\""
    _550w_help_cmd "_550w_config_save"
    print ""
    _550w_help_pause
}

_550w_help_faq_t3() {
    _550w_help_head "FAQ · 主题" "自定义配色"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想自定义颜色。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 改主色调或创建主题。"
    print ""
    print "  方式 1: 改主色调"
    _550w_help_cmd "550w-settings → 1 → 10"
    print "  12 个预设或输入色号。"
    print ""
    print "  方式 2: 创建主题"
    _550w_help_cmd "550w-settings → 3 → 6"
    print "  输入名字(如 mytheme)。"
    print "  编辑:"
    _550w_help_cmd "550w-settings → 3 → 7"
    print ""
    print "  格式:"
    print -P "  %F{${_550w_C[dim]}}_550W_C[cyan]=51%f"
    print -P "  %F{${_550w_C[dim]}}_550W_C[ok]=46%f"
    print -P "  %F{${_550w_C[dim]}}_550W_C[err]=196%f"
    print -P "  %F{${_550w_C[dim]}}...%f"
    print ""
    print "  色号 0~255。"
    print "  保存 → source 生效。"
    print ""
    print "  推荐色号:"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "46"  "46"  "绿"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "51"  "51"  "青"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "45"  "45"  "蓝"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "135" "135" "紫"
    printf '  \e[38;5;%sm%-8s\e[0m %s\n' "214" "214" "橙"
    print ""
    _550w_help_pause
}

_550w_help_faq_t4() {
    _550w_help_head "FAQ · 主题" "改提示符"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想改提示符显示内容。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 设置中心 2 号。"
    print ""
    print "  可开关:"
    print "    · SID 显示"
    print "    · 模式显示"
    print "    · MOSS 显示"
    print "    · 时间显示"
    print ""
    _550w_help_cmd "550w-settings → 2"
    print ""
    print "  样式:"
    print "    full     完整"
    print "    minimal  简洁"
    print "    plain    纯文本"
    print ""
    print "  完全自定义(高级): 编辑 core.zsh 里的 _550w_build_ps1()"
    print ""
    _550w_help_pause
}

_550w_help_faq_t5() {
    _550w_help_head "FAQ · 主题" "屏幕窄显示乱"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 菜单显示换行/错位。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 屏幕太窄, 分几种。"
    print ""
    print "  原因 1: 中文字符宽度"
    print "  中文算 2 宽, 短菜单可能换行。"
    print "  解决: 长按屏幕 → 更多 → 字号缩小。"
    print ""
    print "  原因 2: 横屏/竖屏"
    print "  建议竖屏使用。"
    print ""
    print "  原因 3: Termux 字体"
    print "  长按屏幕 → 更多 → 字体。"
    print ""
    print "  原因 4: 提示符太长"
    _550w_help_cmd "550w-settings → 2 → 1"
    print "  换 minimal 或 plain。"
    print ""
    print "  原因 5: 终端宽度"
    _550w_help_cmd "echo \$COLUMNS"
    print "  常见 60~100。"
    print ""
    _550w_help_pause
}

_550w_help_faq_t6() {
    _550w_help_head "FAQ · 主题" "字体大小"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 字体太小/太大。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f Termux 层调整, 不是 550W 层。"
    print ""
    print "  操作:"
    print "    1) 长按屏幕任意位置"
    print "    2) 选'更多'"
    print "    3) 选'字体'(或 'Style')"
    print "    4) 选字号"
    print ""
    print "  或双指缩放:"
    print "    · 两指捏合  → 缩小"
    print "    · 两指张开  → 放大"
    print ""
    print "  550W 的 _550W_FONT_SIZE 是记录用, 不真正改字体。"
    _550w_help_cmd "550w-settings → 1 → 14"
    print ""
    _550w_help_pause
}

# ══════════════════ FAQ · 插件 ══════════════════

_550w_help_faq_plugin() {
    while true; do
        _550w_help_head "FAQ · 插件" "8 个"
        print ""
        _550w_help_row "1" "插件不加载"
        _550w_help_row "2" "插件报错"
        _550w_help_row "3" "缺依赖"
        _550w_help_row "4" "插件命令找不到"
        _550w_help_row "5" "改插件不生效"
        _550w_help_row "6" "分享给朋友"
        _550w_help_row "7" "禁用 vs 删除"
        _550w_help_row "8" "写自己的插件"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_g1 ;;
            2) _550w_help_faq_g2 ;;
            3) _550w_help_faq_g3 ;;
            4) _550w_help_faq_g4 ;;
            5) _550w_help_faq_g5 ;;
            6) _550w_help_faq_g6 ;;
            7) _550w_help_faq_g7 ;;
            8) _550w_help_faq_g8 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_g1() {
    _550w_help_head "FAQ · 插件" "不加载"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 放了插件但没加载。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 检查结构。"
    print ""
    print "  结构要求:"
    print "    ~/.550w/扩展/插件名/main.zsh"
    print "    ↑ 必须文件夹里有 main.zsh"
    print ""
    print "  检查:"
    _550w_help_cmd "ls ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  没有 → 缺 main.zsh(改名或创建)"
    print ""
    print "  加载状态:"
    _550w_help_cmd "550w-plugins"
    print "  看 ● ○ ✗ 标记。"
    print ""
    print "  错误:"
    _550w_help_cmd "550w-plugin-errors"
    print ""
    print "  手动重载:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print ""
    _550w_help_pause
}

_550w_help_faq_g2() {
    _550w_help_head "FAQ · 插件" "报错"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 加载时提示'插件 xxx 加载失败'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 语法错/运行错。"
    print ""
    print "  排查 1: 语法"
    _550w_help_cmd "zsh -n ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  排查 2: 手动 source"
    _550w_help_cmd "source ~/.550w/扩展/插件名/main.zsh"
    print "  会显示真实错误(不吞 stderr)。"
    print ""
    print "  排查 3: 日志"
    _550w_help_cmd "550w-plugin-logs 插件名"
    print ""
    print "  排查 4: 详情"
    _550w_help_cmd "550w-plugin-info 插件名"
    print ""
    print "  常见错误:"
    print "    · 缺 }\\( \\) 等括号"
    print "    · 中文全角字符混入"
    print "    · 引号不匹配"
    print "    · 用了未定义的变量"
    print ""
    _550w_help_pause
}

_550w_help_faq_g3() {
    _550w_help_head "FAQ · 插件" "缺依赖"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 提示'插件 xxx 跳过(缺命令: jq)'。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 装依赖。"
    print ""
    print "  装:"
    _550w_help_cmd "pkg install jq"
    print ""
    print "  重载:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print ""
    print "  常见依赖:"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "curl"     "HTTP"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "jq"       "JSON"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "python3"  "Python"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "git"      "Git"
    printf '  \e[38;5;%sm%-14s\e[0m %s\n' "${_550w_C[ok]}" "openssl"  "加密"
    print ""
    print "  不想装? 禁用插件:"
    _550w_help_cmd "550w-plugin-disable 插件名"
    print ""
    _550w_help_pause
}

_550w_help_faq_g4() {
    _550w_help_head "FAQ · 插件" "命令找不到"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 插件加载了, 但它的命令用不了。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 分几种。"
    print ""
    print "  原因 1: 函数名拼写"
    _550w_help_cmd "cat ~/.550w/扩展/插件名/main.zsh | grep '^550w-'"
    print "  看实际定义了什么函数。"
    print ""
    print "  原因 2: 函数名不带 550w-"
    print "  如果函数叫 myfun() → 输入 myfun 才能用。"
    print ""
    print "  原因 3: 插件未加载"
    _550w_help_cmd "550w-plugins"
    print ""
    print "  原因 4: 覆盖"
    print "  多个插件定义了同名函数, 后加载的覆盖。"
    _550w_help_cmd "grep -r '^550w-xxx' ~/.550w/扩展/"
    print ""
    print "  修复:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    _550w_help_pause
}

_550w_help_faq_g5() {
    _550w_help_head "FAQ · 插件" "改插件不生效"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 改了 main.zsh 但没变化。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 重载。"
    print ""
    print "  zsh 已加载的函数不会自动重读。"
    print ""
    print "  修复 1:"
    _550w_help_cmd "550w-plugin-reload 插件名"
    print ""
    print "  修复 2:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    print "  修复 3:"
    _550w_help_cmd "exec zsh"
    print ""
    print "  修复 4: 确认文件真的改了"
    _550w_help_cmd "tail -20 ~/.550w/扩展/插件名/main.zsh"
    print ""
    print "  常见陷阱:"
    print "    · nano 没保存(Ctrl+O)"
    print "    · 改的是缓存版本"
    print "    · 编辑的是 ~/.550w/扩展/插件名/旧副本"
    print ""
    _550w_help_pause
}

_550w_help_faq_g6() {
    _550w_help_head "FAQ · 插件" "分享给朋友"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想把自己写的插件分享给朋友。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 打包。"
    print ""
    print "  步骤 1: 清理日志"
    _550w_help_cmd "rm -rf ~/.550w/扩展/插件名/log/*"
    _550w_help_cmd "rm -rf ~/.550w/扩展/插件名/config/*"
    print ""
    print "  步骤 2: 打包"
    _550w_help_cmd "550w-plugin-pack 插件名"
    print "  生成 ~/.550w/backups/插件名-1.0.0-时间.tar.gz"
    print ""
    print "  步骤 3: 传到 Download"
    _550w_help_cmd 'cp ~/.550w/backups/插件名-*.tar.gz /storage/emulated/0/Download/'
    print ""
    print "  步骤 4: 发给朋友"
    print "  微信/QQ/蓝牙/网盘都行。"
    print ""
    print "  朋友安装:"
    _550w_help_cmd "550w-plugin-install 收到.tar.gz"
    print ""
    _550w_help_pause
}

_550w_help_faq_g7() {
    _550w_help_head "FAQ · 插件" "禁用 vs 删除"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 不想用某插件, 禁用还是删除?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 看情况。"
    print ""
    print "  禁用(推荐):"
    _550w_help_cmd "550w-plugin-disable 插件名"
    print "  · 文件保留"
    print "  · 配置/日志保留"
    print "  · 随时启回来"
    print "  · 只是不加载"
    print ""
    print "  删除:"
    _550w_help_cmd "550w-plugin-remove 插件名"
    print "  · 整个文件夹删掉"
    print "  · 配置/日志全丢"
    print "  · 想用要重新安装"
    print ""
    print "  建议:"
    print "    · 临时不用 → 禁用"
    print "    · 确定不要 → 删除"
    print "    · 不确定 → 先禁用"
    print ""
    _550w_help_pause
}

_550w_help_faq_g8() {
    _550w_help_head "FAQ · 插件" "写自己的插件"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想写自己的插件, 从哪开始?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 看插件专章。"
    print ""
    print "  快速路径:"
    print "    1) 550w-plugin-new myplugin"
    print "    2) nano ~/.550w/扩展/myplugin/main.zsh"
    print "    3) 写一个 550w-myplugin() 函数"
    print "    4) 550w-plugin-reload myplugin"
    print "    5) 测试 550w-myplugin"
    print ""
    print "  详细教程: 主菜单 → 5 插件专章"
    print "    · 节 03 第一个插件"
    print "    · 节 04 main.zsh 详解"
    print "    · 节 05 元数据"
    print "    · 节 06~10 依赖/钩子/配置/日志"
    print "    · 节 15~19 完整示例"
    print ""
    print "  参考扩展:"
    _550w_help_cmd "cat ~/.550w/new.zsh"
    _550w_help_cmd "cat ~/.550w/anim.zsh"
    print ""
    _550w_help_pause
}

# ══════════════════ FAQ · 备份与数据 ══════════════════

_550w_help_faq_backup() {
    while true; do
        _550w_help_head "FAQ · 备份与数据" "6 个"
        print ""
        _550w_help_row "1" "怎么备份"
        _550w_help_row "2" "从备份恢复"
        _550w_help_row "3" "换手机迁移"
        _550w_help_row "4" "备份文件在哪"
        _550w_help_row "5" "备份太大"
        _550w_help_row "6" "备份加密"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_bk1 ;;
            2) _550w_help_faq_bk2 ;;
            3) _550w_help_faq_bk3 ;;
            4) _550w_help_faq_bk4 ;;
            5) _550w_help_faq_bk5 ;;
            6) _550w_help_faq_bk6 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_bk1() {
    _550w_help_head "FAQ · 备份" "怎么备份"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 怎么备份 550W?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 一键。"
    print ""
    print "  方式 1: 菜单"
    _550w_help_cmd "550w-settings → 9 → 1"
    print ""
    print "  方式 2: 命令行"
    _550w_help_cmd "550w-ex-bak-quick"
    print ""
    print "  方式 3: 手动 tar"
    _550w_help_cmd 'tar -czf ~/550w_backup_$(date +%Y%m%d).tar.gz -C ~ .550w'
    print ""
    print "  生成: ~/.550w/backups/backup_YYYYMMDD_HHMMSS.tar.gz"
    print ""
    print "  建议: 大改配置前先备份。"
    print ""
    _550w_help_pause
}

_550w_help_faq_bk2() {
    _550w_help_head "FAQ · 备份" "从备份恢复"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 配置改坏了, 怎么恢复?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三种方式。"
    print ""
    print "  方式 1: 菜单"
    _550w_help_cmd "550w-settings → 9 → 4"
    print "  会问:先备份当前状态, 再覆盖。"
    print ""
    print "  方式 2: 手动"
    _550w_help_cmd 'cd ~'
    _550w_help_cmd 'mv .550w .550w.old'
    _550w_help_cmd 'tar -xzf ~/.550w.old/backups/backup_xxx.tar.gz'
    print ""
    print "  方式 3: 单独恢复"
    print "  只恢复配置:"
    _550w_help_cmd 'tar -xzf backup.tar.gz .550w/.550w_config --strip-components=1'
    print ""
    print "  恢复后:"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    _550w_help_pause
}

_550w_help_faq_bk3() {
    _550w_help_head "FAQ · 备份" "换手机迁移"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 换手机怎么搬 550W?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 见教程第 10 步。"
    print ""
    print "  流程:"
    print "    1) 旧机: 550w-settings → 11 → 1 (导出全部)"
    print "    2) 传到新机 (蓝牙/微信/网盘)"
    print "    3) 新机装 Termux"
    print "    4) 新机解包: tar -xzf export_all_xxx.tar.gz"
    print "    5) 新机配 .zshrc:"
    print -P "  %F{${_550w_C[dim]}}       echo 'source ~/.550w/core.zsh' >> ~/.zshrc%f"
    print "    6) 新机重设 API Key"
    print ""
    print "  详细教程:"
    _550w_help_cmd "550w-help → 3 → 10"
    print ""
    print "  轻量迁移(只个人信息):"
    _550w_help_cmd "550w-settings → 11 → 8"
    print ""
    _550w_help_pause
}

_550w_help_faq_bk4() {
    _550w_help_head "FAQ · 备份" "备份文件在哪"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 备份文件存哪里?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f ~/.550w/backups/。"
    print ""
    print "  查看:"
    _550w_help_cmd "ls -lah ~/.550w/backups/"
    print ""
    print "  文件命名:"
    print "    backup_YYYYMMDD_HHMMSS.tar.gz  手动"
    print "    auto_YYYYMMDD_HHMMSS.tar.gz    自动"
    print "    export_all_xxx.tar.gz          完整导出"
    print "    config_xxx.cfg                 配置"
    print "    profile_xxx.cfg                档案"
    print "    memory_xxx.jsonl               记忆"
    print "    theme_xxx.theme                主题"
    print "    插件名-1.0.0-xxx.tar.gz        插件包"
    print ""
    print "  复制到共享存储:"
    _550w_help_cmd 'cp ~/.550w/backups/backup_xxx.tar.gz /storage/emulated/0/Download/'
    print ""
    _550w_help_pause
}

_550w_help_faq_bk5() {
    _550w_help_head "FAQ · 备份" "备份太大"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 备份文件很大, 怎么办?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 几种。"
    print ""
    print "  原因: 备份包含命令历史/日志/旧会话/插件日志。"
    print ""
    print "  查看:"
    _550w_help_cmd "du -sh ~/.550w/*"
    print ""
    print "  清理:"
    _550w_help_cmd "550w-settings → 10 → 4   清日志"
    _550w_help_cmd "550w-settings → 9 → 6    清旧备份"
    _550w_help_cmd "rm ~/.550w/.550w_history"
    _550w_help_cmd "rm ~/.550w/扩展/*/log/*"
    print ""
    print "  只备份关键文件:"
    _550w_help_cmd "550w-settings → 11 → 2/3/4"
    print ""
    print "  关自动备份:"
    _550w_help_cmd "550w-settings → 9 → 8"
    _550w_help_cmd "550w-settings → 12 → 6    改保留个数"
    print ""
    _550w_help_pause
}

_550w_help_faq_bk6() {
    _550w_help_head "FAQ · 备份" "备份加密"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 备份里有敏感信息, 怎么加密?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 用加密备份。"
    print ""
    print "  菜单:"
    _550w_help_cmd "550w-settings → 9 → 3"
    print "  会问加密密码。"
    print "  生成 xxx.tar.gz.enc"
    print ""
    print "  依赖 openssl:"
    _550w_help_cmd "command -v openssl"
    print "  没有 → pkg install openssl"
    print ""
    print "  恢复:"
    _550w_help_cmd "550w-settings → 9 → 4"
    print "  选 .enc 文件, 输入密码。"
    print ""
    print "  手动加密:"
    _550w_help_cmd 'tar -czf - ~/.550w | openssl enc -aes-256-cbc -a -salt -out backup.enc'
    print "  解密:"
    _550w_help_cmd 'openssl enc -d -aes-256-cbc -a -in backup.enc | tar -xz -C ~'
    print ""
    print -P "  %F{${_550w_C[warn]}}⚠ 密码忘了无法恢复!%f"
    print ""
    _550w_help_pause
}

# ══════════════════ FAQ · 故障排除 ══════════════════

_550w_help_faq_trouble() {
    while true; do
        _550w_help_head "FAQ · 故障排除" "6 个"
        print ""
        _550w_help_row "1" "系统卡死"
        _550w_help_row "2" "命令无响应"
        _550w_help_row "3" "扩展文件报错"
        _550w_help_row "4" "500W 系统状态全黄"
        _550w_help_row "5" "彻底重置"
        _550w_help_row "6" "截图/报告问题"
        print ""
        _550w_help_row "0"  "返回"
        _550w_help_divider
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_faq_tr1 ;;
            2) _550w_help_faq_tr2 ;;
            3) _550w_help_faq_tr3 ;;
            4) _550w_help_faq_tr4 ;;
            5) _550w_help_faq_tr5 ;;
            6) _550w_help_faq_tr6 ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_faq_tr1() {
    _550w_help_head "FAQ · 故障" "系统卡死"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 终端完全无响应。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 分级处理。"
    print ""
    print "  步骤 1: 中断"
    print "    Ctrl+C"
    print ""
    print "  步骤 2: 退出 shell"
    print "    Ctrl+D"
    print "    (可能需要按多次)"
    print ""
    print "  步骤 3: 关闭 Termux"
    print "    · 从最近应用里划掉"
    print "    · 或长按图标 → 强制停止"
    print ""
    print "  步骤 4: 检查 boot_anim"
    _550w_help_cmd "mv ~/.550w/boot_anim ~/.550w/boot_anim.off"
    print ""
    print "  步骤 5: 检查加载器"
    _550w_help_cmd "nano ~/.zshrc"
    print "  临时注释掉 source ~/.550w/core.zsh"
    print ""
    print "  步骤 6: 重装"
    _550w_help_cmd "rm -rf ~/.550w"
    print ""
    _550w_help_pause
}

_550w_help_faq_tr2() {
    _550w_help_head "FAQ · 故障" "命令无响应"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 敲了命令, 没输出。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 几种。"
    print ""
    print "  原因 1: 命令在等输入"
    print "  光标在闪烁 → 输入点什么或 Ctrl+C"
    print ""
    print "  原因 2: 命令在跑"
    print "  ps 查看:"
    _550w_help_cmd "ps -ef | head"
    print ""
    print "  原因 3: 命令卡在 I/O"
    print "  · 网络命令等超时"
    print "  · Ctrl+C 中断"
    print ""
    print "  原因 4: 命令真的没输出"
    print "  有些命令成功就静默。"
    print ""
    print "  原因 5: 输出被重定向"
    print "  ls > file → 不会显示"
    print ""
    _550w_help_pause
}

_550w_help_faq_tr3() {
    _550w_help_head "FAQ · 故障" "扩展文件报错"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 加载时某个 .zsh 文件报错。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 定位。"
    print ""
    print "  排查 1: 语法"
    _550w_help_cmd "zsh -n ~/.550w/xxx.zsh"
    print ""
    print "  排查 2: 定位"
    _550w_help_cmd "zsh -n ~/.550w/xxx.zsh 2>&1 | head -3"
    print "  看行号, 用 sed 查看:"
    _550w_help_cmd "sed -n 'XXX,XXXp' ~/.550w/xxx.zsh"
    print ""
    print "  排查 3: 括号配平"
    print -P "  %F{${_550w_C[dim]}}awk '{o+=gsub(/{/,\"\"); c+=gsub(/}/,\"\")} END{print o,c}' ~/.550w/xxx.zsh%f"
    print ""
    print "  排查 4: 临时禁用"
    _550w_help_cmd "mv ~/.550w/xxx.zsh ~/.550w/xxx.zsh.off"
    _550w_help_cmd "unset _550W_LOADED && source ~/.zshrc"
    print ""
    print "  排查 5: 覆盖"
    print "  从备份或原版恢复该文件。"
    print ""
    _550w_help_pause
}

_550w_help_faq_tr4() {
    _550w_help_head "FAQ · 故障" "系统状态全黄"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 550w-status 显示好多黄色/红色。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 看具体字段。"
    print ""
    print "  MOSS 健康:"
    print "    unknown → 未检查, 跑 550w-settings → 6 → 13"
    print "    degraded → 401/403, Key 问题"
    print "    down → 网络不通"
    print ""
    print "  记忆:"
    print "    0 条 → 正常(还没聊过)"
    print ""
    print "  失败:"
    print "    显示数字 → 输入密码错了几次"
    print ""
    print "  整体排查:"
    _550w_help_cmd "550w-moss"
    _550w_help_cmd "550w-real → 1"
    _550w_help_cmd "550w-settings → 6 → 13"
    print ""
    print -P "  %F{${_550w_C[dim]}}大部分黄色是正常的(未配置状态)%f"
    print ""
    _550w_help_pause
}

_550w_help_faq_tr5() {
    _550w_help_head "FAQ · 故障" "彻底重置"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想从零开始, 彻底重置。"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 三步。"
    print ""
    print "  步骤 1: 备份(可选)"
    _550w_help_cmd 'cp -r ~/.550w ~/550w_bak_$(date +%Y%m%d)'
    print ""
    print "  步骤 2: 删除数据"
    _550w_help_cmd "rm -rf ~/.550w"
    print ""
    print "  步骤 3: 重装"
    print "  (把安装包重新解压 / 下载安装脚本)"
    print ""
    print "  或只重置配置:"
    _550w_help_cmd "550w-settings → 14 → 2"
    print ""
    print "  只重置档案:"
    _550w_help_cmd "550w-settings → 5 → 11"
    print ""
    print "  只重置密码:"
    _550w_help_cmd "550w-settings → 4 → 2"
    print ""
    print -P "  %F{${_550w_C[warn]}}⚠ rm -rf 不可恢复!%f"
    print ""
    _550w_help_pause
}

_550w_help_faq_tr6() {
    _550w_help_head "FAQ · 故障" "报告问题"
    print -P "  %F{${_550w_C[err]}}%B问:%b%f 想报告 bug, 需要提供什么信息?"
    print ""
    print -P "  %F{${_550w_C[ok]}}%B答:%b%f 收集以下信息。"
    print ""
    print "  1. 触发命令"
    print "    你敲的完整命令"
    print ""
    print "  2. 完整报错"
    print "    从第一个字符到最后一个字符"
    print ""
    print "  3. 系统信息"
    _550w_help_cmd "550w-version"
    _550w_help_cmd "uname -a"
    _550w_help_cmd "echo \$ZSH_VERSION"
    _550w_help_cmd "echo \$TERM"
    print ""
    print "  4. 相关文件状态"
    _550w_help_cmd "ls -la ~/.550w/"
    _550w_help_cmd "ls -la ~/.550w/扩展/"
    print ""
    print "  5. 系统状态"
    _550w_help_cmd "550w-status"
    _550w_help_cmd "550w-plugin-errors"
    print ""
    print "  6. 日志"
    _550w_help_cmd "tail -30 ~/.550w/logs/*.log"
    print ""
    print "  把这些贴给对方/开发者。"
    print ""
    _550w_help_pause
}
# ══════════════════ 关于 · 主菜单 ══════════════════

_550w_help_menu_about() {
    while true; do
        _550w_help_head "关于"
        print ""
        _550w_help_row "1" "版本信息"  "版本/构建/文件行数"
        _550w_help_row "2" "项目简介"  "550W 是什么"
        _550w_help_row "3" "更新日志"  "v1.0 变更"
        _550w_help_row "4" "许可协议"  "MIT"
        _550w_help_row "5" "致谢名单"  "感谢"
        print ""
        _550w_help_row "0" "返回"
        _550w_help_divider
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_help_about_version ;;
            2) _550w_help_about_intro ;;
            3) _550w_help_about_changelog ;;
            4) _550w_help_about_license ;;
            5) _550w_help_about_thanks ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_help_about_version() {
    _550w_help_head "关于 · 版本信息"
    print ""
    printf '  %-14s %s\n' "版本" "$_550W_VERSION"
    printf '  %-14s %s\n' "构建" "$_550W_BUILD_DATE"
    printf '  %-14s %s\n' "会话" "$_550W_SESSION_ID"
    printf '  %-14s %s\n' "用户" "$_550W_USER_NAME"
    printf '  %-14s %s\n' "主机" "$(_550w_real_hostname)"
    printf '  %-14s %s\n' "Shell" "$ZSH_VERSION"
    printf '  %-14s %s\n' "终端" "${TERM:-unknown}"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 文件%f"
    local total=0 f n
    for f in "$HOME/.550w"/*.zsh(N); do
        n=$(wc -l < "$f" 2>/dev/null | tr -d ' ')
        [[ "$n" =~ '^[0-9]+$' ]] || n=0
        (( total += n ))
        printf '  %-24s %6s 行\n' "${f:t}" "$n"
    done
    printf '  %-24s %6s 行\n' "合计" "$total"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 目录大小%f"
    printf '  %-24s %s\n' "总占用" "$(du -sh "$HOME/.550w" 2>/dev/null | cut -f1)"
    printf '  %-24s %s\n' "插件数" "$(ls -d "$HOME/.550w/扩展"/*/ 2>/dev/null | wc -l | tr -d ' ')"
    printf '  %-24s %s\n' "开机动画" "$(ls -1 "$HOME/.550w/boot_anim"/*.zsh(N) 2>/dev/null | wc -l | tr -d ' ')"
    printf '  %-24s %s\n' "主题数" "$(ls -1 "$HOME/.550w/themes"/*.theme(N) 2>/dev/null | wc -l | tr -d ' ')"
    print ""
    _550w_help_pause
}

_550w_help_about_intro() {
    _550w_help_head "关于 · 项目简介"
    print "  550W 超算接管系统 是:"
    print ""
    print "  一个把 Termux 启动过程改造成"
    print "  《流浪地球》550W / MOSS 接管动画的"
    print "  zsh 脚本系统。"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 设计目标%f"
    print "    · 视觉: 复刻电影里的开机仪式感"
    print "    · 实用: 真的能日常用(AI/记忆/插件)"
    print "    · 可扩展: 插件/主题/动画都能自己加"
    print "    · 可维护: 模块化拆分, 好改好删"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 主要功能%f"
    print "    · 开机 15 步动画"
    print "    · 密码保护 + 空闲锁定"
    print "    · MOSS AI 对话(15 个 provider)"
    print "    · 持久记忆"
    print "    · 插件系统(元数据/依赖/钩子)"
    print "    · 主题系统"
    print "    · 真实系统数据读取"
    print "    · 数据备份/恢复/迁移"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 技术%f"
    print "    · 纯 zsh, 无编译"
    print "    · 除 curl 外零外部依赖"
    print "    · 全部数据在 ~/.550w/"
    print "    · 模块化(8 个扩展文件)"
    print ""
    print -P "  %F{${_550w_C[cyan]}}▸ 灵感来源%f"
    print "    · 电影《流浪地球》"
    print "    · 550W / MOSS 量子超算设定"
    print "    · Termux 社区"
    print ""
    _550w_help_pause
}

_550w_help_about_changelog() {
    _550w_help_head "关于 · 更新日志"
    print -P "  %F{${_550w_C[bright]}}%Bv1.0%b%f  (当前版本)"
    print "  ──────────────────────────────────"
    print "  · 核心重写(约 3400 行)"
    print "  · 目录重构 ~/.550w/"
    print "  · 6 个扩展文件:"
    print "      real.zsh      真实系统数据"
    print "      anim.zsh      234 个动画"
    print "      help.zsh      本手册"
    print "      settings.zsh  设置中心"
    print "      extras.zsh    外围工具"
    print "      new.zsh       新加功能"
    print "  · 15 个 AI Provider"
    print "  · 速度 5 级: flash/fast/normal/slow/hold"
    print "  · 欢迎画 6 行渐变大字"
    print "  · 密码不可查看(只改)"
    print "  · 插件系统 v2:"
    print "      元数据/依赖/钩子/配置/日志"
    print "      启用禁用/打包安装"
    print "  · 开机动画文件夹机制"
    print "  · 备份加密"
    print "  · 跨设备同步"
    print "  · 50 个 FAQ"
    print ""
    print -P "  %F{${_550w_C[dim]}}%Bv5.5.0-core%b%(初版)%f"
    print "  ──────────────────────────────────"
    print "  · 20 段基础实现"
    print "  · 基础动画 + 认证 + MOSS"
    print "  · 单文件 ~/.550w_login.zsh"
    print ""
    print -P "  %F{${_550w_C[dim]}}%Bv4.x%b%(历史)%f"
    print "  · 密码框 + 6 种动画"
    print "  · 55 处 bug 修复"
    print ""
    print -P "  %F{${_550w_C[dim]}}%Bv3.0%b%(历史)%f"
    print "  · 视觉升级"
    print ""
    print -P "  %F{${_550w_C[dim]}}%Bv2.x%b%(历史)%f"
    print "  · v2.5: 20 项增强"
    print "  · v2.6: MOSS AI"
    print ""
    _550w_help_pause
}

_550w_help_about_license() {
    _550w_help_head "关于 · 许可协议"
    print -P "  %F{${_550w_C[cyan]}}%BMIT License%b%f"
    print "  ──────────────────────────────────"
    print ""
    print "  Copyright (c) 2026 Trans"
    print ""
    print "  Permission is hereby granted, free of charge,"
    print "  to any person obtaining a copy of this software"
    print "  and associated documentation files (the \"Software\"),"
    print "  to deal in the Software without restriction,"
    print "  including without limitation the rights to use,"
    print "  copy, modify, merge, publish, distribute,"
    print "  sublicense, and/or sell copies of the Software,"
    print "  and to permit persons to whom the Software is"
    print "  furnished to do so, subject to the following"
    print "  conditions:"
    print ""
    print "  The above copyright notice and this permission"
    print "  notice shall be included in all copies or"
    print "  substantial portions of the Software."
    print ""
    print "  THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT"
    print "  WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,"
    print "  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF"
    print "  MERCHANTABILITY, FITNESS FOR A PARTICULAR"
    print "  PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL"
    print "  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR"
    print "  ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER"
    print "  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,"
    print "  ARISING FROM, OUT OF OR IN CONNECTION WITH THE"
    print "  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE"
    print "  SOFTWARE."
    print ""
    print -P "  %F{${_550w_C[dim]}}简言之: 随便用, 随便改, 出事别怪我%f"
    print ""
    _550w_help_pause
}

_550w_help_about_thanks() {
    _550w_help_head "关于 · 致谢名单"
    print -P "  %F{${_550w_C[cyan]}}%B▸ 灵感%f"
    print "    · 电影《流浪地球》(2019 / 2023)"
    print "    · 550W / MOSS 量子超算设定"
    print ""
    print -P "  %F{${_550w_C[cyan]}}%B▸ 技术%f"
    print "    · zsh 官方文档"
    print "    · Termux 项目"
    print "    · 所有开源贡献者"
    print ""
    print -P "  %F{${_550w_C[cyan]}}%B▸ AI 服务%f"
    print "    · 智谱 GLM"
    print "    · DeepSeek"
    print "    · 阿里通义千问"
    print "    · 月之暗面 Kimi"
    print "    · OpenAI"
    print "    · 其它 10 个 Provider"
    print ""
    print -P "  %F{${_550w_C[cyan]}}%B▸ 个人%f"
    print "    · 感谢 Trans 长期测试反馈"
    print "    · 感谢所有提建议的用户"
    print ""
    print -P "  %F{${_550w_C[cyan]}}%B▸ 开源社区%f"
    print "    · GNU / Linux"
    print "    · 所有把代码开源出来的人"
    print ""
    print -P "  %F{${_550w_C[dim]}}如果 550W 让你觉得有趣, 那就是最好的回报%f"
    print ""
    _550w_help_pause
}

# ══════════════════ 收尾 ══════════════════

_550w_help_about() {
    _550w_help_menu_about
}

# 加载提示(调试用, 默认静默)
(( _550W_LOG_LEVEL >= 4 )) && \
    print -P "%F{${_550w_C[dim]}}[550W] help.zsh 已加载(10 大章 · 60 命令 · 50 FAQ)%f" >&2
    
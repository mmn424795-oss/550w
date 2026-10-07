# ~/.550w/new.zsh — 550W 新加功能 v1.0
# 50 项：对话增强 / 提示词 / 模型 / 工具 / 生活
# 依赖：core.zsh 已加载

[[ -n "$_550W_LOADED" ]] || return 0

# ══════════════════ 路径与状态 ══════════════════
typeset -g _550W_NEW_DIR="${HOME}/.550w/new"
typeset -g _550W_CHAT_DIR="${HOME}/.550w/new/chats"
typeset -g _550W_PROMPT_DIR="${HOME}/.550w/new/prompts"
typeset -g _550W_TODO_FILE="${HOME}/.550w/new/todo.txt"
typeset -g _550W_NOTE_DIR="${HOME}/.550w/new/notes"
typeset -g _550W_BM_FILE="${HOME}/.550w/new/bookmarks.txt"
typeset -g _550W_VAULT_FILE="${HOME}/.550w/new/vault.enc"

[[ -d "$_550W_NEW_DIR"   ]] || mkdir -p "$_550W_NEW_DIR"
[[ -d "$_550W_CHAT_DIR"  ]] || mkdir -p "$_550W_CHAT_DIR"
[[ -d "$_550W_PROMPT_DIR" ]] || mkdir -p "$_550W_PROMPT_DIR"
[[ -d "$_550W_NOTE_DIR"  ]] || mkdir -p "$_550W_NOTE_DIR"

# ══════════════════ 辅助 ══════════════════

_550w_new_head() {
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

_550w_new_row() {
    local num="$1" text="$2"
    printf '  \e[38;5;%sm[%2s]\e[0m %s\n' "${_550W_C[cyan]}" "$num" "$text"
}

_550w_new_pause() {
    print ""
    print -P "  %F{${_550W_C[dim]}}按回车返回...%f"
    read -r
}

_550w_new_msg() {
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

550w-new() {
    while true; do
        _550w_new_head "550W 新加功能"
        print -P "  %F{${_550W_C[dim]}}50 项扩展功能%f"
        print ""
        _550w_new_row "1"  "对话增强   分支/标签/搜索/收藏/合并"
        _550w_new_row "2"  "对话分析   统计/图表/回放/比较"
        _550w_new_row "3"  "提示词库   保存/变量/导入/导出/角色"
        _550w_new_row "4"  "模型对比   对比/投票/评分/反馈"
        _550w_new_row "5"  "文本处理   摘要/关键词/翻译"
        _550w_new_row "6"  "代码工具   高亮/执行/公式/表格/图表"
        _550w_new_row "7"  "文件阅读   PDF/MD/目录/Git/日志/配置/CSV"
        _550w_new_row "8"  "生活工具   定时/提醒/番茄钟/待办/笔记/书签"
        _550w_new_row "9"  "安全工具   保险箱/二维码/加密/哈希"
        _550w_new_row "10" "开发工具   编码/正则/JSON/时间戳"
        print ""
        _550w_new_row "0"  "退出"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_new_menu_chat ;;
            2)  _550w_new_menu_analysis ;;
            3)  _550w_new_menu_prompt ;;
            4)  _550w_new_menu_model ;;
            5)  _550w_new_menu_text ;;
            6)  _550w_new_menu_code ;;
            7)  _550w_new_menu_read ;;
            8)  _550w_new_menu_life ;;
            9)  _550w_new_menu_sec ;;
            10) _550w_new_menu_dev ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ 1. 对话增强 ══════════════════

_550w_new_menu_chat() {
    while true; do
        _550w_new_head "对话增强"
        _550w_new_row "1"  "对话分支    从一条消息分叉出新对话"
        _550w_new_row "2"  "对话标签    给当前对话打标签"
        _550w_new_row "3"  "对话搜索    全文搜索历史"
        _550w_new_row "4"  "对话收藏    标记重要对话"
        _550w_new_row "5"  "对话重命名  修改会话名"
        _550w_new_row "6"  "对话合并    合并两段对话"
        _550w_new_row "7"  "对话统计    词数/轮数/时长"
        _550w_new_row "8"  "对话图表    话题分布"
        _550w_new_row "9"  "对话回放    重播历史"
        _550w_new_row "10" "对话比较    两个回复对比"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_chat_branch ;;
            2) _550w_new_chat_tag ;;
            3) _550w_new_chat_search ;;
            4) _550w_new_chat_star ;;
            5) _550w_new_chat_rename ;;
            6) _550w_new_chat_merge ;;
            7) _550w_new_chat_stats ;;
            8) _550w_new_chat_chart ;;
            9) _550w_new_chat_replay ;;
            10) _550w_new_chat_compare ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# 保存当前会话到文件
_550w_new_chat_save() {
    local name="${1:-session_$(date +%Y%m%d_%H%M%S)}"
    local file="$_550W_CHAT_DIR/${name}.jsonl"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg err "当前会话为空"
        return 1
    fi
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        print -r -- "${_550W_MOSS_HISTORY[$i]}"
    done > "$file"
    print -P "  %F{${_550W_C[ok]}}✓ 已保存: ${file:t}%f"
    sleep 0.8
    return 0
}

# 分支：把当前会话另存为新文件，作为新对话的起点
_550w_new_chat_branch() {
    _550w_new_head "对话分支"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg err "当前会话为空，无法分支"
        return
    fi
    print "  当前会话有 ${#_550W_MOSS_HISTORY[@]} 条消息"
    print -n "  新分支名: "
    local name
    read -r name
    [[ -z "$name" ]] && return
    _550w_new_chat_save "branch_${name}_$(date +%Y%m%d_%H%M%S)"
    _550w_new_pause
}

# 标签
_550w_new_chat_tag() {
    _550w_new_head "对话标签"
    print "  标签用于标记对话主题，写入 ~/.550w/new/chats/tags.txt"
    print -n "  标签（逗号分隔）: "
    local tags
    read -r tags
    [[ -z "$tags" ]] && return
    local tagfile="$_550W_CHAT_DIR/tags.txt"
    print "$(date +%Y%m%d_%H%M%S)|$_550W_SESSION_ID|$tags" >> "$tagfile"
    _550w_new_msg ok "已标记: $tags"
}

# 搜索
_550w_new_chat_search() {
    _550w_new_head "对话搜索"
    print -n "  关键词: "
    local kw
    read -r kw
    [[ -z "$kw" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}搜索结果：%f"
    local found=0 f line
    for f in "$_550W_CHAT_DIR"/*.jsonl(N); do
        while IFS= read -r line; do
            if [[ "$line" == *"$kw"* ]]; then
                found=1
                print "  ${f:t}: ${line:0:60}..."
            fi
        done < "$f"
    done
    # 也搜当前内存
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        if [[ "${_550W_MOSS_HISTORY[$i]}" == *"$kw"* ]]; then
            found=1
            print "  [当前] ${_550W_MOSS_HISTORY[$i]:0:60}..."
        fi
    done
    (( found )) || _550w_new_msg wrn "未找到"
    _550w_new_pause
}

# 收藏
_550w_new_chat_star() {
    _550w_new_head "对话收藏"
    local starfile="$_550W_CHAT_DIR/stars.txt"
    [[ -f "$starfile" ]] || touch "$starfile"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg err "当前会话为空"
        return
    fi
    local file="$starfile"
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        print -r -- "${_550W_MOSS_HISTORY[$i]}" >> "$file"
    done
    print -P "  %F{${_550W_C[ok]}}✓ 已收藏 ${#_550W_MOSS_HISTORY[@]} 条%f"
    sleep 1
}

# 重命名
_550w_new_chat_rename() {
    _550w_new_head "对话重命名"
    local files=("$_550W_CHAT_DIR"/*.jsonl(N))
    if (( ${#files[@]} == 0 )); then
        _550w_new_msg wrn "无历史会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t}"
    done
    print ""
    print -n "  选择编号: "
    local n
    read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    print -n "  新名称: "
    local newname
    read -r newname
    [[ -z "$newname" ]] && return
    mv "${files[$n]}" "$_550W_CHAT_DIR/${newname}.jsonl"
    _550w_new_msg ok "已重命名"
}

# 合并
_550w_new_chat_merge() {
    _550w_new_head "对话合并"
    local files=("$_550W_CHAT_DIR"/*.jsonl(N))
    if (( ${#files[@]} < 2 )); then
        _550w_new_msg wrn "需要至少 2 个会话"
        return
    fi
    local i
    for (( i=1; i<=${#files[@]}; i++ )); do
        print "  [$i] ${files[$i]:t}"
    done
    print ""
    print -n "  第一个编号: "; local a; read -r a
    print -n "  第二个编号: "; local b; read -r b
    [[ "$a" =~ '^[0-9]+$' && "$b" =~ '^[0-9]+$' ]] || return
    (( a < 1 || a > ${#files[@]} || b < 1 || b > ${#files[@]} )) && return
    local out="$_550W_CHAT_DIR/merged_$(date +%Y%m%d_%H%M%S).jsonl"
    cat "${files[$a]}" "${files[$b]}" > "$out"
    _550w_new_msg ok "已合并为 ${out:t}"
}

# 统计
_550w_new_chat_stats() {
    _550w_new_head "对话统计"
    local total=0 words=0 i
    local content chars
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        total++
        chars=${#_550W_MOSS_HISTORY[$i]}
        words=$(( words + chars / 4 ))
    done
    local uptime=$(( ${EPOCHSECONDS:-$(date +%s)} - _550W_START_TIME ))
    printf '  %-14s %s\n' "消息总数" "$total 条"
    printf '  %-14s %s\n' "估算词数" "$words"
    printf '  %-14s %s\n' "会话时长" "${uptime}s"
    printf '  %-14s %s\n' "Provider" "$_550W_MOSS_PROVIDER"
    printf '  %-14s %s\n' "模型" "$_550W_MOSS_MODEL"
    printf '  %-14s %s\n' "速率" "$_550W_MOSS_RATELIMIT_USED / $_550W_MOSS_RATELIMIT_DAILY"
    _550w_new_pause
}

# 图表：按角色分布画横向条形
_550w_new_chat_chart() {
    _550w_new_head "对话图表"
    local user=0 assistant=0 system=0 other=0
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        case "${_550W_MOSS_HISTORY[$i]}" in
            *'"role":"user"'*)      (( user++ )) ;;
            *'"role":"assistant"'*) (( assistant++ )) ;;
            *'"role":"system"'*)    (( system++ )) ;;
            *)                      (( other++ )) ;;
        esac
    done
    local total=$(( user + assistant + system + other ))
    (( total == 0 )) && { _550w_new_msg wrn "无数据"; return; }
    print -P "  %F{${_550W_C[cyan]}}消息角色分布%f"
    print ""
    local W=30
    local uw=$(( user * W / total ))
    local aw=$(( assistant * W / total ))
    local sw=$(( system * W / total ))
    local ow=$(( other * W / total ))
    local b="" j
    for (( j=0; j<uw; j++ )); do b+="█"; done
    print -P "  %F{${_550W_C[ok]}}U%f $b ($user)"
    b=""
    for (( j=0; j<aw; j++ )); do b+="█"; done
    print -P "  %F{${_550W_C[cyan]}}A%f $b ($assistant)"
    b=""
    for (( j=0; j<sw; j++ )); do b+="█"; done
    print -P "  %F{${_550W_C[warn]}}S%f $b ($system)"
    if (( other > 0 )); then
        b=""
        for (( j=0; j<ow; j++ )); do b+="█"; done
        print -P "  %F{${_550W_C[dim]}}O%f $b ($other)"
    fi
    _550w_new_pause
}

# 回放
_550w_new_chat_replay() {
    _550w_new_head "对话回放"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg wrn "无历史"
        return
    fi
    print -P "  %F{${_550W_C[dim]}}按回车逐条播放（q 退出）%f"
    print ""
    local i
    for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
        local role="?"
        [[ "${_550W_MOSS_HISTORY[$i]}" == *'"role":"user"'* ]]      && role="U"
        [[ "${_550W_MOSS_HISTORY[$i]}" == *'"role":"assistant"'* ]] && role="A"
        [[ "${_550W_MOSS_HISTORY[$i]}" == *'"role":"system"'* ]]    && role="S"
        print -P "  %F{${_550W_C[cyan]}}[$role]%f ${_550W_MOSS_HISTORY[$i]:0:100}"
        local k
        read -r -k 1 k
        [[ "$k" == "q" ]] && break
    done
    _550w_new_pause
}

# 比较：同一问题两个回复的并排对比（简版）
_550w_new_chat_compare() {
    _550w_new_head "对话比较"
    print "  输入两个问题，分别调用 MOSS，并排显示回复"
    print ""
    print -n "  问题 A: "; local qa; read -r qa
    [[ -z "$qa" ]] && return
    print -n "  问题 B: "; local qb; read -r qb
    [[ -z "$qb" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}正在请求 A...%f"
    _550w_moss_chat "$qa"
    local ra="$_550W_MOSS_REPLY"
    print -P "  %F{${_550W_C[cyan]}}正在请求 B...%f"
    _550w_moss_chat "$qb"
    local rb="$_550W_MOSS_REPLY"
    print ""
    print -P "  %F{${_550W_C[ok]}}%B── A ──%b%f $qa"
    print "  $ra"
    print ""
    print -P "  %F{${_550W_C[warn]}}%B── B ──%b%f $qb"
    print "  $rb"
    _550w_new_pause
}

# ══════════════════ 2. 对话分析（入口，跳转到已实现函数）══════════════════

_550w_new_menu_analysis() {
    while true; do
        _550w_new_head "对话分析"
        _550w_new_row "1"  "对话统计    词数/轮数/时长"
        _550w_new_row "2"  "对话图表    角色分布条形图"
        _550w_new_row "3"  "对话回放    逐条重播"
        _550w_new_row "4"  "对话比较    两个回复并排"
        _550w_new_row "5"  "导出为 MD  当前会话导出 Markdown"
        _550w_new_row "6"  "导出为 JSON 原始格式"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_chat_stats ;;
            2) _550w_new_chat_chart ;;
            3) _550w_new_chat_replay ;;
            4) _550w_new_chat_compare ;;
            5) _550w_new_chat_export_md ;;
            6) _550w_new_chat_export_json ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_chat_export_md() {
    _550w_new_head "导出为 Markdown"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg err "当前会话为空"
        return
    fi
    local dest="$_550W_CHAT_DIR/export_$(date +%Y%m%d_%H%M%S).md"
    {
        print "# 550W 对话记录"
        print ""
        print "- 会话: $_550W_SESSION_ID"
        print "- 时间: $(date '+%Y-%m-%d %H:%M:%S')"
        print "- 模型: $_550W_MOSS_MODEL"
        print "- 条数: ${#_550W_MOSS_HISTORY[@]}"
        print ""
        print "---"
        print ""
        local i role content
        for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
            content="${_550W_MOSS_HISTORY[$i]}"
            if [[ "$content" == *'"role":"user"'* ]]; then
                print "**U:**"
            elif [[ "$content" == *'"role":"assistant"'* ]]; then
                print "**A:**"
            else
                print "**S:**"
            fi
            # 提取 content
            local c
            c=$(print -nr -- "$content" | sed -n 's/.*"content":"\([^"]*\)".*/\1/p' | head -1)
            print "$c"
            print ""
        done
    } > "$dest"
    print -P "  %F{${_550W_C[ok]}}✓ 已导出: ${dest:t}%f"
    _550w_new_pause
}

_550w_new_chat_export_json() {
    _550w_new_head "导出为 JSON"
    if (( ${#_550W_MOSS_HISTORY[@]} == 0 )); then
        _550w_new_msg err "当前会话为空"
        return
    fi
    local dest="$_550W_CHAT_DIR/export_$(date +%Y%m%d_%H%M%S).json"
    {
        print "{"
        print "  \"sid\": \"$_550W_SESSION_ID\","
        print "  \"model\": \"$_550W_MOSS_MODEL\","
        print "  \"provider\": \"$_550W_MOSS_PROVIDER\","
        print "  \"exported\": \"$(date '+%Y-%m-%d %H:%M:%S')\","
        print "  \"messages\": ["
        local i
        for (( i=1; i<=${#_550W_MOSS_HISTORY[@]}; i++ )); do
            local sep=","
            (( i == ${#_550W_MOSS_HISTORY[@]} )) && sep=""
            print "    ${_550W_MOSS_HISTORY[$i]}${sep}"
        done
        print "  ]"
        print "}"
    } > "$dest"
    print -P "  %F{${_550W_C[ok]}}✓ 已导出: ${dest:t}%f"
    _550w_new_pause
}

# ══════════════════ 3. 提示词库 ══════════════════

_550w_new_menu_prompt() {
    while true; do
        _550w_new_head "提示词库"
        local n=0
        [[ -d "$_550W_PROMPT_DIR" ]] && n=$(ls -1 "$_550W_PROMPT_DIR"/*.txt 2>/dev/null | wc -l | tr -d ' ')
        print -P "  %F{${_550W_C[dim]}}已存 $n 条 · 目录 $_550W_PROMPT_DIR%f"
        print ""
        _550w_new_row "1"  "保存提示词  存到文件"
        _550w_new_row "2"  "列出提示词  浏览全部"
        _550w_new_row "3"  "使用提示词  发送到 MOSS"
        _550w_new_row "4"  "变量替换    \${var} 变量填充"
        _550w_new_row "5"  "从文件导入  复制 txt 到库"
        _550w_new_row "6"  "导出到文件  复制到指定路径"
        _550w_new_row "7"  "角色预设    系统提示词"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_prompt_save ;;
            2) _550w_new_prompt_list ;;
            3) _550w_new_prompt_use ;;
            4) _550w_new_prompt_var ;;
            5) _550w_new_prompt_import ;;
            6) _550w_new_prompt_export ;;
            7) _550w_new_prompt_role ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_prompt_save() {
    _550w_new_head "保存提示词"
    print -n "  名称（无空格）: "; local name; read -r name
    [[ -z "$name" ]] && return
    print -n "  内容: "; local content; read -r content
    [[ -z "$content" ]] && return
    print -r -- "$content" > "$_550W_PROMPT_DIR/${name}.txt"
    _550w_new_msg ok "已保存: ${name}.txt"
}

_550w_new_prompt_list() {
    _550w_new_head "提示词列表"
    local found=0 f
    for f in "$_550W_PROMPT_DIR"/*.txt(N); do
        found=1
        printf '  \e[38;5;%sm●\e[0m %-20s %s\n' \
            "${_550W_C[ok]}" "${f:t:r}" "$(head -c 50 "$f")"
    done
    (( found )) || _550w_new_msg wrn "库为空"
    _550w_new_pause
}

_550w_new_prompt_use() {
    _550w_new_head "使用提示词"
    local found=0 f i=0
    local -a files=()
    for f in "$_550W_PROMPT_DIR"/*.txt(N); do
        found=1
        (( i++ ))
        files+=("$f")
        print "  [$i] ${f:t:r}"
    done
    if (( ! found )); then
        _550w_new_msg wrn "库为空"
        return
    fi
    print ""
    print -n "  选择: "; local n; read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    local content
    content=$(cat "${files[$n]}")
    print ""
    print -P "  %F{${_550W_C[cyan]}}发送: %f$content"
    _550w_moss_chat "$content"
    print -P "  %F{${_550W_C[ok]}}[550W]%f $_550W_MOSS_REPLY"
    _550w_new_pause
}

_550w_new_prompt_var() {
    _550w_new_head "变量替换"
    print "  提示词里写 \${name}，运行时替换"
    print ""
    print -n "  提示词: "; local tmpl; read -r tmpl
    [[ -z "$tmpl" ]] && return
    local result="$tmpl" var val
    while [[ "$result" =~ '\$\{([a-zA-Z_]+)\}' ]]; do
        var="${match[1]}"
        print -n "  $var = "; read -r val
        result="${result//\$\{$var\}/$val}"
    done
    print ""
    print -P "  %F{${_550W_C[ok]}}结果: %f$result"
    print ""
    print -n "  发送到 MOSS? (y/N): "; local go; read -r go
    if [[ "$go" == "y" || "$go" == "Y" ]]; then
        _550w_moss_chat "$result"
        print -P "  %F{${_550W_C[ok]}}[550W]%f $_550W_MOSS_REPLY"
    fi
    _550w_new_pause
}

_550w_new_prompt_import() {
    _550w_new_head "导入提示词"
    print -n "  源文件路径: "; local src; read -r src
    [[ -r "$src" ]] || { _550w_new_msg err "文件不存在"; return; }
    local name="${src:t:r}"
    cp "$src" "$_550W_PROMPT_DIR/${name}.txt"
    _550w_new_msg ok "已导入为 ${name}.txt"
}

_550w_new_prompt_export() {
    _550w_new_head "导出提示词"
    local found=0 f i=0
    local -a files=()
    for f in "$_550W_PROMPT_DIR"/*.txt(N); do
        found=1
        (( i++ ))
        files+=("$f")
        print "  [$i] ${f:t:r}"
    done
    if (( ! found )); then
        _550w_new_msg wrn "库为空"
        return
    fi
    print ""
    print -n "  选择: "; local n; read -r n
    [[ "$n" =~ '^[0-9]+$' ]] || return
    (( n < 1 || n > ${#files[@]} )) && return
    print -n "  导出到: "; local dest; read -r dest
    [[ -z "$dest" ]] && return
    cp "${files[$n]}" "$dest"
    _550w_new_msg ok "已导出到 $dest"
}

_550w_new_prompt_role() {
    _550w_new_head "角色预设"
    print "  常用系统提示词模板"
    print ""
    print "  [1] 专业助手   严谨、准确、不废话"
    print "  [2] 编程助手   代码优先、附带解释"
    print "  [3] 翻译助手   直译 + 意译双版本"
    print "  [4] 创意助手   发散、灵活、比喻多"
    print "  [5] 自定义     手动输入"
    print ""
    print -n "  选择: "; local c; read -r c
    local role=""
    case "$c" in
        1) role="你是专业助手，回答简洁准确，避免冗余。" ;;
        2) role="你是资深程序员，优先给代码，代码后再简要解释。" ;;
        3) role="你是翻译助手，先直译再意译，保留原意。" ;;
        4) role="你是创意助手，回答生动，多用比喻和例子。" ;;
        5) print -n "  自定义系统提示词: "; read -r role ;;
        *) return ;;
    esac
    [[ -z "$role" ]] && return
    print ""
    print -n "  用户消息: "; local msg; read -r msg
    [[ -z "$msg" ]] && return
    print ""
    _550w_moss_chat_sys "$role" "$msg"
    print -P "  %F{${_550W_C[ok]}}[550W]%f $_550W_MOSS_REPLY"
    _550w_new_pause
}

# ══════════════════ 4. 模型对比 ══════════════════

_550w_new_menu_model() {
    while true; do
        _550w_new_head "模型对比"
        _550w_new_row "1"  "双模型对比  同问发两个 provider"
        _550w_new_row "2"  "多模型投票  3~5 模型同答"
        _550w_new_row "3"  "结果评分    手动打分记录"
        _550w_new_row "4"  "反馈标注    好/坏反馈入库"
        _550w_new_row "5"  "查看反馈    历史反馈"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_model_duo ;;
            2) _550w_new_model_vote ;;
            3) _550w_new_model_score ;;
            4) _550w_new_model_feedback ;;
            5) _550w_new_model_feedback_view ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_model_duo() {
    _550w_new_head "双模型对比"
    print -n "  问题: "; local q; read -r q
    [[ -z "$q" ]] && return
    print ""
    print -n "  Provider A: "; local pa; read -r pa
    print -n "  Provider B: "; local pb; read -r pb
    [[ -z "$pa" || -z "$pb" ]] && return

    local saved_p="$_550W_MOSS_PROVIDER"
    local saved_m="$_550W_MOSS_MODEL"
    local saved_t="$_550W_MOSS_TOKEN"
    local saved_u="$_550W_MOSS_CLOUD_URL"

    print ""
    print -P "  %F{${_550W_C[cyan]}}[A] $pa 请求中...%f"
    _550W_MOSS_PROVIDER="$pa"
    _550w_moss_resolve_provider 1
    _550w_moss_chat "$q"
    local ra="$_550W_MOSS_REPLY"

    print -P "  %F{${_550W_C[cyan]}}[B] $pb 请求中...%f"
    _550W_MOSS_PROVIDER="$pb"
    _550w_moss_resolve_provider 1
    _550w_moss_chat "$q"
    local rb="$_550W_MOSS_REPLY"

    _550W_MOSS_PROVIDER="$saved_p"
    _550W_MOSS_MODEL="$saved_m"
    _550W_MOSS_TOKEN="$saved_t"
    _550W_MOSS_CLOUD_URL="$saved_u"

    print ""
    print -P "  %F{${_550W_C[ok]}}%B══ A: $pa ══%b%f"
    print "  $ra"
    print ""
    print -P "  %F{${_550W_C[warn]}}%B══ B: $pb ══%b%f"
    print "  $rb"
    _550w_new_pause
}

_550w_new_menu_text() {
    while true; do
        _550w_new_head "文本处理"
        _550w_new_row "1"  "自动摘要    长文本摘要"
        _550w_new_row "2"  "关键词提取  自动关键词"
        _550w_new_row "3"  "翻译模式    中英互译"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-3]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_text_summarize ;;
            2) _550w_new_text_keywords ;;
            3) _550w_new_text_translate ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_text_summarize() {
    _550w_new_head "自动摘要"
    print "  输入长文本（一行，回车结束）"
    print -n "  > "
    local text
    read -r text
    [[ -z "$text" ]] && return
    local prompt="请用不超过 100 字总结以下文本，只输出摘要：\n$text"
    print ""
    print -P "  %F{${_550W_C[cyan]}}MOSS 处理中...%f"
    _550w_moss_chat "$prompt"
    print -P "  %F{${_550W_C[ok]}}摘要：%f$_550W_MOSS_REPLY"
    _550w_new_pause
}

_550w_new_text_keywords() {
    _550w_new_head "关键词提取"
    print "  输入文本"
    print -n "  > "
    local text
    read -r text
    [[ -z "$text" ]] && return
    local prompt="从以下文本提取 5~10 个关键词，用逗号分隔，只输出关键词：\n$text"
    print ""
    print -P "  %F{${_550W_C[cyan]}}MOSS 处理中...%f"
    _550w_moss_chat "$prompt"
    print -P "  %F{${_550W_C[ok]}}关键词：%f$_550W_MOSS_REPLY"
    _550w_new_pause
}

_550w_new_text_translate() {
    _550w_new_head "翻译模式"
    print "  [1] 中译英   [2] 英译中   [3] 自动"
    print -n "  选择: "
    local c
    read -r c
    local dir=""
    case "$c" in
        1) dir="中译英" ;;
        2) dir="英译中" ;;
        3) dir="自动识别语言并翻译" ;;
        *) return ;;
    esac
    print ""
    print -n "  原文: "
    local text
    read -r text
    [[ -z "$text" ]] && return
    local prompt="$dir，只输出译文，不加解释：\n$text"
    print ""
    print -P "  %F{${_550W_C[cyan]}}MOSS 处理中...%f"
    _550w_moss_chat "$prompt"
    print -P "  %F{${_550W_C[ok]}}译文：%f$_550W_MOSS_REPLY"
    _550w_new_pause
}

# ══════════════════ 6. 代码工具 ══════════════════

_550w_new_menu_code() {
    while true; do
        _550w_new_head "代码工具"
        _550w_new_row "1"  "代码高亮    简单着色"
        _550w_new_row "2"  "代码执行    沙箱运行"
        _550w_new_row "3"  "公式渲染    LaTeX 显示"
        _550w_new_row "4"  "表格渲染    Markdown 表格"
        _550w_new_row "5"  "图表生成    文字转 ASCII 图"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_code_highlight ;;
            2) _550w_new_code_run ;;
            3) _550w_new_code_formula ;;
            4) _550w_new_code_table ;;
            5) _550w_new_code_chart ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_code_highlight() {
    _550w_new_head "代码高亮"
    print "  输入文件路径（支持 .sh .py .zsh .js）"
    print -n "  > "
    local f
    read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    print ""
    local ext="${f##*.}"
    local line
    while IFS= read -r line; do
        # 简单着色规则
        if [[ "$line" == "#"* ]]; then
            # 注释：暗灰
            print -P "  %F{${_550W_C[dim]}}$line%f"
        elif [[ "$line" == *"function"* || "$line" == *"def "* || "$line" == *"()"* ]]; then
            # 函数定义：青
            print -P "  %F{${_550W_C[cyan]}}$line%f"
        elif [[ "$line" == *"if "* || "$line" == *"else"* || "$line" == *"for "* || "$line" == *"while "* ]]; then
            # 控制流：黄
            print -P "  %F{${_550W_C[warn]}}$line%f"
        elif [[ "$line" == *"return"* || "$line" == *"echo"* || "$line" == *"print"* ]]; then
            # 输出：绿
            print -P "  %F{${_550W_C[ok]}}$line%f"
        else
            print "  $line"
        fi
    done < "$f"
    _550w_new_pause
}

_550w_new_code_run() {
    _550w_new_head "代码执行"
    print "  警告：会在本地执行代码，请确保内容安全"
    print ""
    print "  [1] Shell (sh)   [2] Python3   [3] Zsh"
    print -n "  选择: "
    local c
    read -r c
    local interp=""
    case "$c" in
        1) interp="sh" ;;
        2) interp="python3" ;;
        3) interp="zsh" ;;
        *) return ;;
    esac
    command -v "$interp" >/dev/null 2>&1 || {
        _550w_new_msg err "$interp 未安装"
        return
    }
    print ""
    print -n "  代码: "
    local code
    read -r code
    [[ -z "$code" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}执行中...%f"
    print ""
    local out
    out=$($interp -c "$code" 2>&1)
    local rc=$?
    print "  ─── 输出 ───"
    print "$out"
    print "  ─── 返回码: $rc ───"
    _550w_new_pause
}

_550w_new_code_formula() {
    _550w_new_head "公式渲染"
    print "  输入 LaTeX 公式（终端仅简单美化）"
    print -n "  > "
    local formula
    read -r formula
    [[ -z "$formula" ]] && return
    print ""
    print -P "  %F{${_550W_C[cyan]}}原始:%f $formula"
    print ""
    # 简单美化：替换常见符号
    local pretty="$formula"
    pretty="${pretty//\\alpha/α}"
    pretty="${pretty//\\beta/β}"
    pretty="${pretty//\\gamma/γ}"
    pretty="${pretty//\\delta/δ}"
    pretty="${pretty//\\pi/π}"
    pretty="${pretty//\\sum/Σ}"
    pretty="${pretty//\\int/∫}"
    pretty="${pretty//\\infty/∞}"
    pretty="${pretty//\\times/×}"
    pretty="${pretty//\\div/÷}"
    pretty="${pretty//\\pm/±}"
    pretty="${pretty//\\leq/≤}"
    pretty="${pretty//\\geq/≥}"
    pretty="${pretty//\\neq/≠}"
    pretty="${pretty//\\approx/≈}"
    pretty="${pretty//\\sqrt/√}"
    print -P "  %F{${_550W_C[ok]}}美化:%f $pretty"
    print ""
    print -P "  %F{${_550W_C[dim]}}注：终端不支持真正的数学排版%f"
    _550w_new_pause
}

_550w_new_code_table() {
    _550w_new_head "表格渲染"
    print "  输入 Markdown 表格（3 行）"
    print "  例: | A | B |"
    print "      |---|---|"
    print "      | 1 | 2 |"
    print ""
    local -a lines=()
    local i
    for (( i=1; i<=3; i++ )); do
        print -n "  L$i: "
        local l
        read -r l
        lines+=("$l")
    done
    print ""
    print -P "  %F{${_550W_C[ok]}}渲染结果：%f"
    for l in "${lines[@]}"; do
        print "  $l"
    done
    _550w_new_pause
}

_550w_new_code_chart() {
    _550w_new_head "图表生成"
    print "  输入数值（逗号分隔）"
    print "  例: 10,25,40,55,80"
    print -n "  > "
    local input
    read -r input
    [[ -z "$input" ]] && return
    local -a vals=(${(s:,:)input})
    print ""
    print -P "  %F{${_550W_C[ok]}}柱状图：%f"
    local v
    for v in "${vals[@]}"; do
        [[ "$v" =~ '^[0-9]+$' ]] || continue
        local b=""
        local j
        for (( j=0; j<v; j++ )); do b+="▇"; done
        printf '  %4d %s\n' "$v" "$b"
    done
    print ""
    print -P "  %F{${_550W_C[cyan]}}折线图（数字越大越靠上）：%f"
    local max=0
    for v in "${vals[@]}"; do
        [[ "$v" =~ '^[0-9]+$' ]] || continue
        (( v > max )) && max=$v
    done
    (( max == 0 )) && { _550w_new_pause; return; }
    local height=8
    local h
    for (( h=height; h>=1; h-- )); do
        local row=""
        for v in "${vals[@]}"; do
            [[ "$v" =~ '^[0-9]+$' ]] || { row+=" "; continue; }
            local level=$(( v * height / max ))
            (( level >= h )) && row+="●" || row+=" "
        done
        printf '  %s\n' "$row"
    done
    _550w_new_pause
}

# ══════════════════ 7. 文件阅读 ══════════════════

_550w_new_menu_read() {
    while true; do
        _550w_new_head "文件阅读"
        _550w_new_row "1"  "PDF 阅读    提取文本"
        _550w_new_row "2"  "Markdown    美化显示"
        _550w_new_row "3"  "目录树      结构树状展示"
        _550w_new_row "4"  "Git 状态    仓库信息"
        _550w_new_row "5"  "日志分析    读取日志"
        _550w_new_row "6"  "配置解析    读取配置"
        _550w_new_row "7"  "数据分析    CSV 统计"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_read_pdf ;;
            2) _550w_new_read_md ;;
            3) _550w_new_read_tree ;;
            4) _550w_new_read_git ;;
            5) _550w_new_read_log ;;
            6) _550w_new_read_config ;;
            7) _550w_new_read_csv ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_read_pdf() {
    _550w_new_head "PDF 阅读"
    print -n "  PDF 路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    if command -v pdftotext >/dev/null 2>&1; then
        print ""
        pdftotext "$f" - 2>/dev/null | head -60
    else
        _550w_new_msg err "未装 pdftotext（pkg install poppler）"
    fi
    _550w_new_pause
}

_550w_new_read_md() {
    _550w_new_head "Markdown 阅读"
    print -n "  文件路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    print ""
    local line
    while IFS= read -r line; do
        if [[ "$line" == "# "* ]]; then
            print -P "  %F{${_550W_C[bright]}}%B${line#\# }%b%f"
        elif [[ "$line" == "## "* ]]; then
            print -P "  %F{${_550W_C[cyan]}}%B${line#\#\# }%b%f"
        elif [[ "$line" == "### "* ]]; then
            print -P "  %F{${_550W_C[cyan]}}${line#\#\#\# }%f"
        elif [[ "$line" == '```'* ]]; then
            print -P "  %F{${_550W_C[dim]}}─── code ───%f"
        elif [[ "$line" == "- "* || "$line" == "* "* ]]; then
            print -P "  %F{${_550W_C[ok]}}  • ${line:2}%f"
        elif [[ "$line" == "> "* ]]; then
            print -P "  %F{${_550W_C[dim]}}│ ${line:2}%f"
        else
            print "  $line"
        fi
    done < "$f"
    _550w_new_pause
}

_550w_new_read_tree() {
    _550w_new_head "目录树"
    print -n "  目录路径（默认 ~）: "; local d; read -r d
    [[ -z "$d" ]] && d="$HOME"
    [[ -d "$d" ]] || { _550w_new_msg err "目录不存在"; return; }
    print ""
    if command -v tree >/dev/null 2>&1; then
        tree -L 3 "$d" 2>/dev/null | head -50
    else
        find "$d" -maxdepth 3 2>/dev/null | head -50 | sed 's|^|  |'
    fi
    _550w_new_pause
}

_550w_new_read_git() {
    _550w_new_head "Git 状态"
    print -n "  仓库路径（默认 .）: "; local d; read -r d
    [[ -z "$d" ]] && d="."
    [[ -d "$d/.git" ]] || { _550w_new_msg err "不是 git 仓库"; return; }
    command -v git >/dev/null 2>&1 || { _550w_new_msg err "未装 git"; return; }
    print ""
    print -P "  %F{${_550W_C[cyan]}}分支:%f $(git -C "$d" branch --show-current 2>/dev/null)"
    print -P "  %F{${_550W_C[cyan]}}提交:%f $(git -C "$d" log -1 --oneline 2>/dev/null)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}状态:%f"
    git -C "$d" status -s 2>/dev/null | head -20 | sed 's|^|  |'
    _550w_new_pause
}

_550w_new_read_log() {
    _550w_new_head "日志分析"
    print -n "  日志路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    print ""
    print -P "  %F{${_550W_C[cyan]}}行数:%f $(wc -l < "$f" | tr -d ' ')"
    print -P "  %F{${_550W_C[cyan]}}大小:%f $(du -h "$f" | cut -f1)"
    print ""
    print -P "  %F{${_550W_C[cyan]}}最后 15 行:%f"
    tail -15 "$f" | sed 's|^|  |'
    _550w_new_pause
}

_550w_new_read_config() {
    _550w_new_head "配置解析"
    print -n "  配置路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    print ""
    local line n=0
    while IFS= read -r line; do
        (( n++ ))
        (( n > 40 )) && { print "  ..."; break; }
        if [[ "$line" == \#* ]]; then
            print -P "  %F{${_550W_C[dim]}}$line%f"
        elif [[ "$line" == *"="* ]]; then
            local k="${line%%=*}" v="${line#*=}"
            print -P "  %F{${_550W_C[cyan]}}$k%f = $v"
        else
            print "  $line"
        fi
    done < "$f"
    _550w_new_pause
}

_550w_new_read_csv() {
    _550w_new_head "数据分析 (CSV)"
    print -n "  CSV 路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    print ""
    local rows cols
    rows=$(wc -l < "$f" | tr -d ' ')
    cols=$(head -1 "$f" | awk -F, '{print NF}')
    printf '  %-14s %s\n' "行数" "$rows"
    printf '  %-14s %s\n' "列数" "$cols"
    print ""
    print -P "  %F{${_550W_C[cyan]}}表头:%f"
    head -1 "$f" | sed 's|^|  |'
    print ""
    print -P "  %F{${_550W_C[cyan]}}前 5 行:%f"
    head -6 "$f" | tail -5 | sed 's|^|  |'
    _550w_new_pause
}

# ══════════════════ 8. 生活工具 ══════════════════

_550w_new_menu_life() {
    while true; do
        _550w_new_head "生活工具"
        _550w_new_row "1"  "定时任务    setTimeout 风格"
        _550w_new_row "2"  "提醒系统    到点提醒"
        _550w_new_row "3"  "番茄钟      25 分钟专注"
        _550w_new_row "4"  "待办清单    todo 管理"
        _550w_new_row "5"  "笔记系统    快捷笔记"
        _550w_new_row "6"  "书签管理    收藏位置"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_life_timer ;;
            2) _550w_new_life_remind ;;
            3) _550w_new_life_pomodoro ;;
            4) _550w_new_life_todo ;;
            5) _550w_new_life_note ;;
            6) _550w_new_life_bookmark ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_life_timer() {
    _550w_new_head "定时任务"
    print -n "  秒数: "; local s; read -r s
    [[ "$s" =~ '^[0-9]+$' ]] || return
    print ""
    print -P "  %F{${_550W_C[cyan]}}倒计时 $s 秒...%f"
    local i
    for (( i=s; i>0; i-- )); do
        printf '\r  剩余 %3d 秒' "$i"
        sleep 1
    done
    printf '\r\e[K'
    print -P "  %F{${_550W_C[ok]}}✓ 时间到%f"
    _550w_beep ok
    _550w_new_pause
}

_550w_new_life_remind() {
    _550w_new_head "提醒系统"
    print -n "  提醒内容: "; local msg; read -r msg
    print -n "  多少分钟后: "; local min; read -r min
    [[ "$min" =~ '^[0-9]+$' ]] || return
    local sec=$(( min * 60 ))
    print ""
    print -P "  %F{${_550W_C[cyan]}}已设定：$min 分钟后提醒「$msg」%f"
    print -P "  %F{${_550W_C[dim]}}（后台运行，不阻塞终端）%f"
    ( sleep "$sec"; print -P "\n%F{${_550W_C[warn]}}🔔 提醒: $msg%f"; _550w_beep ok ) &
    _550w_new_pause
}

_550w_new_life_pomodoro() {
    _550w_new_head "番茄钟"
    print -n "  工作时长（分钟，默认 25）: "; local w; read -r w
    [[ -z "$w" ]] && w=25
    print -n "  休息时长（分钟，默认 5）: "; local r; read -r r
    [[ -z "$r" ]] && r=5
    print ""
    print -P "  %F{${_550W_C[cyan]}}开始工作 $w 分钟%f"
    local i
    for (( i=w*60; i>0; i-- )); do
        printf '\r  工作 %02d:%02d  ' $(( i / 60 )) $(( i % 60 ))
        sleep 1
    done
    printf '\r\e[K'
    _550w_beep ok
    print -P "  %F{${_550W_C[ok]}}✓ 工作结束，休息 $r 分钟%f"
    for (( i=r*60; i>0; i-- )); do
        printf '\r  休息 %02d:%02d  ' $(( i / 60 )) $(( i % 60 ))
        sleep 1
    done
    printf '\r\e[K'
    _550w_beep ok
    print -P "  %F{${_550W_C[ok]}}✓ 番茄钟完成%f"
    _550w_new_pause
}

_550w_new_life_todo() {
    while true; do
        _550w_new_head "待办清单"
        print ""
        if [[ -f "$_550W_TODO_FILE" ]]; then
            local n=0 line
            while IFS= read -r line; do
                (( n++ ))
                if [[ "$line" == "x|"* ]]; then
                    print -P "  %F{${_550W_C[dim]}}[$n] ✓ ${line:2}%f"
                else
                    print -P "  %F{${_550W_C[cyan]}}[$n]%f ○ $line"
                fi
            done < "$_550W_TODO_FILE"
            (( n == 0 )) && print -P "  %F{${_550W_C[dim]}}（空）%f"
        else
            print -P "  %F{${_550W_C[dim]}}（空）%f"
        fi
        print ""
        print "  [a] 添加   [d] 完成   [r] 删除   [0] 返回"
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            a|A)
                print -n "  内容: "; local t; read -r t
                [[ -n "$t" ]] && print "$t" >> "$_550W_TODO_FILE"
                ;;
            d|D)
                print -n "  编号: "; local n; read -r n
                [[ "$n" =~ '^[0-9]+$' ]] || continue
                if [[ -f "$_550W_TODO_FILE" ]]; then
                    sed -i "${n}s/^/x|/" "$_550W_TODO_FILE"
                fi
                ;;
            r|R)
                print -n "  编号: "; local n; read -r n
                [[ "$n" =~ '^[0-9]+$' ]] || continue
                [[ -f "$_550W_TODO_FILE" ]] && sed -i "${n}d" "$_550W_TODO_FILE"
                ;;
            0|"") return ;;
        esac
    done
}

_550w_new_life_note() {
    while true; do
        _550w_new_head "笔记系统"
        local n=0 f
        for f in "$_550W_NOTE_DIR"/*.txt(N); do
            (( n++ ))
            print "  [$n] ${f:t:r}"
        done
        (( n == 0 )) && print -P "  %F{${_550W_C[dim]}}（无笔记）%f"
        print ""
        print "  [a] 新建   [v] 查看   [e] 编辑   [0] 返回"
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            a|A)
                print -n "  标题: "; local t; read -r t
                [[ -z "$t" ]] && continue
                print -n "  内容: "; local content; read -r content
                print "$content" > "$_550W_NOTE_DIR/${t}.txt"
                _550w_new_msg ok "已保存"
                ;;
            v|V)
                print -n "  编号: "; local idx; read -r idx
                local -a files=("$_550W_NOTE_DIR"/*.txt(N))
                [[ "$idx" =~ '^[0-9]+$' ]] && (( idx >= 1 && idx <= ${#files[@]} )) && {
                    print ""
                    cat "${files[$idx]}"
                    _550w_new_pause
                }
                ;;
            e|E)
                print -n "  编号: "; local idx; read -r idx
                local -a files=("$_550W_NOTE_DIR"/*.txt(N))
                if [[ "$idx" =~ '^[0-9]+$' ]] && (( idx >= 1 && idx <= ${#files[@]} )); then
                    if command -v nano >/dev/null 2>&1; then
                        nano "${files[$idx]}"
                    else
                        _550w_new_msg err "未装 nano"
                    fi
                fi
                ;;
            0|"") return ;;
        esac
    done
}

_550w_new_life_bookmark() {
    while true; do
        _550w_new_head "书签管理"
        print ""
        if [[ -f "$_550W_BM_FILE" ]]; then
            local n=0 line
            while IFS= read -r line; do
                (( n++ ))
                print "  [$n] $line"
            done < "$_550W_BM_FILE"
            (( n == 0 )) && print -P "  %F{${_550W_C[dim]}}（空）%f"
        else
            print -P "  %F{${_550W_C[dim]}}（空）%f"
        fi
        print ""
        print "  [a] 添加   [r] 删除   [0] 返回"
        print -n "  选择: "
        local c
        read -r c
        case "$c" in
            a|A)
                print -n "  书签内容: "; local t; read -r t
                [[ -n "$t" ]] && print "$t" >> "$_550W_BM_FILE"
                ;;
            r|R)
                print -n "  编号: "; local n; read -r n
                [[ "$n" =~ '^[0-9]+$' ]] || continue
                [[ -f "$_550W_BM_FILE" ]] && sed -i "${n}d" "$_550W_BM_FILE"
                ;;
            0|"") return ;;
        esac
    done
}

# ══════════════════ 9. 安全工具 ══════════════════

_550w_new_menu_sec() {
    while true; do
        _550w_new_head "安全工具"
        _550w_new_row "1"  "密码保险箱  加密存储"
        _550w_new_row "2"  "二维码生成  文本转码"
        _550w_new_row "3"  "二维码识别  图片转文本"
        _550w_new_row "4"  "加密解密    文本加解密"
        _550w_new_row "5"  "哈希工具    计算哈希"
        _550w_new_row "6"  "随机密码    强密码生成"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-6]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_sec_vault ;;
            2) _550w_new_sec_qr_gen ;;
            3) _550w_new_sec_qr_read ;;
            4) _550w_new_sec_crypto ;;
            5) _550w_new_sec_hash ;;
            6) _550w_new_sec_passgen ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_sec_vault() {
    _550w_new_head "密码保险箱"
    print -P "  %F{${_550W_C[warn]}}密码以加密方式存储，主密码仅本地使用%f"
    print ""
    if [[ ! -f "$_550W_VAULT_FILE" ]]; then
        print "  首次使用，请设置主密码"
        print -n "  主密码: "; local p; read -rs p; print ""
        print -n "  确认: "; local p2; read -rs p2; print ""
        [[ "$p" != "$p2" ]] && { _550w_new_msg err "不一致"; return; }
        print "$p" | sha256sum | awk '{print $1}' > "$_550W_VAULT_FILE.key"
        touch "$_550W_VAULT_FILE"
        _550w_new_msg ok "保险箱已创建"
        return
    fi
    print -n "  主密码: "; local p; read -rs p; print ""
    local hash
    hash=$(print "$p" | sha256sum | awk '{print $1}')
    local stored
    stored=$(cat "$_550W_VAULT_FILE.key" 2>/dev/null)
    [[ "$hash" != "$stored" ]] && { _550w_new_msg err "密码错误"; return; }
    print ""
    print -P "  %F{${_550W_C[cyan]}}保险箱已解锁%f"
    print ""
    local line n=0
    while IFS= read -r line; do
        (( n++ ))
        print "  [$n] ${line%%:*}"
    done < "$_550W_VAULT_FILE"
    print ""
    print "  [a] 添加   [v] 查看   [0] 返回"
    print -n "  选择: "; local c; read -r c
    case "$c" in
        a|A)
            print -n "  名称: "; local name; read -r name
            print -n "  密码: "; local val; read -rs val; print ""
            # 简单异或 + base64
            local enc
            enc=$(print "$val" | openssl enc -aes-256-cbc -a -pass "pass:$p" -pbkdf2 2>/dev/null)
            print "$name:$enc" >> "$_550W_VAULT_FILE"
            _550w_new_msg ok "已添加"
            ;;
        v|V)
            print -n "  编号: "; local idx; read -r idx
            if [[ "$idx" =~ '^[0-9]+$' ]]; then
                local entry
                entry=$(sed -n "${idx}p" "$_550W_VAULT_FILE")
                local enc="${entry#*:}"
                print ""
                print "  名称: ${entry%%:*}"
                print -n "  密码: "
                print "$enc" | openssl enc -aes-256-cbc -d -a -pass "pass:$p" -pbkdf2 2>/dev/null
                print ""
                _550w_new_pause
            fi
            ;;
    esac
}

_550w_new_sec_qr_gen() {
    _550w_new_head "二维码生成"
    print -n "  内容: "; local t; read -r t
    [[ -z "$t" ]] && return
    if command -v qrencode >/dev/null 2>&1; then
        print ""
        qrencode -t ANSIUTF8 "$t"
        _550w_new_pause
    else
        _550w_new_msg err "未装 qrencode（pkg install qrencode）"
    fi
}

_550w_new_sec_qr_read() {
    _550w_new_head "二维码识别"
    print -n "  图片路径: "; local f; read -r f
    [[ -r "$f" ]] || { _550w_new_msg err "文件不存在"; return; }
    if command -v zbarimg >/dev/null 2>&1; then
        print ""
        zbarimg -q "$f" 2>/dev/null
    else
        _550w_new_msg err "未装 zbarimg（pkg install zbar）"
    fi
    _550w_new_pause
}

_550w_new_sec_crypto() {
    _550w_new_head "加密解密"
    print "  [1] 加密   [2] 解密"
    print -n "  选择: "; local c; read -r c
    local mode=""
    case "$c" in
        1) mode="enc" ;;
        2) mode="dec" ;;
        *) return ;;
    esac
    print -n "  密码: "; local p; read -rs p; print ""
    print -n "  文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    if [[ "$mode" == "enc" ]]; then
        print "$t" | openssl enc -aes-256-cbc -a -pass "pass:$p" -pbkdf2 2>/dev/null
    else
        print "$t" | openssl enc -d -aes-256-cbc -a -pass "pass:$p" -pbkdf2 2>/dev/null
    fi
    print ""
    _550w_new_pause
}

_550w_new_sec_hash() {
    _550w_new_head "哈希工具"
    print -n "  文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    printf '  %-8s %s\n' "MD5"    "$(print -n "$t" | md5sum | awk '{print $1}')"
    printf '  %-8s %s\n' "SHA1"   "$(print -n "$t" | sha1sum | awk '{print $1}')"
    printf '  %-8s %s\n' "SHA256" "$(print -n "$t" | sha256sum | awk '{print $1}')"
    printf '  %-8s %s\n' "SHA512" "$(print -n "$t" | sha512sum | awk '{print $1}')"
    _550w_new_pause
}

_550w_new_sec_passgen() {
    _550w_new_head "随机密码"
    print -n "  长度（默认 16）: "; local len; read -r len
    [[ -z "$len" ]] && len=16
    [[ "$len" =~ '^[0-9]+$' ]] || return
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*"
    local pwd="" i
    for (( i=0; i<len; i++ )); do
        pwd+="${chars[$((RANDOM % ${#chars} + 1))]}"
    done
    print ""
    print -P "  %F{${_550W_C[ok]}}%B$pwd%b%f"
    print ""
    print -n "  复制到剪贴板? (y/N): "; local c; read -r c
    if [[ "$c" == "y" ]] && command -v termux-clipboard-set >/dev/null 2>&1; then
        print -n "$pwd" | termux-clipboard-set
        _550w_new_msg ok "已复制"
    fi
    _550w_new_pause
}

# ══════════════════ 10. 开发工具 ══════════════════

_550w_new_menu_dev() {
    while true; do
        _550w_new_head "开发工具"
        _550w_new_row "1"  "编码转换    base64/hex/url"
        _550w_new_row "2"  "正则测试    正则调试"
        _550w_new_row "3"  "JSON 格式化 JSON 美化"
        _550w_new_row "4"  "时间戳转换  unix 时间"
        _550w_new_row "5"  "进制转换    2/8/10/16 进制"
        _550w_new_row "6"  "URL 编解码"
        _550w_new_row "7"  "UUID 生成"
        _550w_new_row "8"  "随机字符串"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-8]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_dev_encode ;;
            2) _550w_new_dev_regex ;;
            3) _550w_new_dev_json ;;
            4) _550w_new_dev_time ;;
            5) _550w_new_dev_radix ;;
            6) _550w_new_dev_url ;;
            7) _550w_new_dev_uuid ;;
            8) _550w_new_dev_rand ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

_550w_new_dev_encode() {
    _550w_new_head "编码转换"
    print -n "  文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    printf '  %-10s %s\n' "base64" "$(print -n "$t" | base64)"
    printf '  %-10s %s\n' "hex"    "$(print -n "$t" | xxd -p 2>/dev/null || print -n "$t" | od -An -tx1 | tr -d ' \n')"
    printf '  %-10s %s\n' "url"    "$(print -n "$t" | od -An -tx1 | tr ' ' '%' | tr -d '\n' | tr '[:lower:]' '[:upper:]')"
    _550w_new_pause
}

_550w_new_dev_regex() {
    _550w_new_head "正则测试"
    print -n "  正则: "; local re; read -r re
    [[ -z "$re" ]] && return
    print -n "  测试文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    if command -v grep >/dev/null 2>&1 && grep --version 2>/dev/null | grep -q GNU; then
        if print -n "$t" | grep -qP "$re" 2>/dev/null; then
            print -P "  %F{${_550W_C[ok]}}✓ 匹配%f"
            print "  匹配部分:"
            print -n "$t" | grep -oP "$re" 2>/dev/null | sed 's|^|    |'
        else
            print -P "  %F{${_550W_C[err]}}✗ 不匹配%f"
        fi
    else
        if [[ "$t" =~ "$re" ]]; then
            print -P "  %F{${_550W_C[ok]}}✓ 匹配%f"
            print "  匹配部分: ${match[0]}"
        else
            print -P "  %F{${_550W_C[err]}}✗ 不匹配%f"
        fi
    fi
    _550w_new_pause
}

_550w_new_dev_json() {
    _550w_new_head "JSON 格式化"
    print -n "  JSON 文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    if command -v python3 >/dev/null 2>&1; then
        print "$t" | python3 -m json.tool 2>/dev/null | sed 's|^|  |' || \
            _550w_new_msg err "不是合法 JSON"
    elif command -v jq >/dev/null 2>&1; then
        print "$t" | jq . 2>/dev/null | sed 's|^|  |' || \
            _550w_new_msg err "不是合法 JSON"
    else
        _550w_new_msg err "需装 python3 或 jq"
    fi
    _550w_new_pause
}

_550w_new_dev_time() {
    _550w_new_head "时间戳转换"
    print "  [1] 当前时间戳   [2] 时间戳→日期   [3] 日期→时间戳"
    print -n "  选择: "; local c; read -r c
    case "$c" in
        1)
            print ""
            printf '  %-14s %s\n' "秒"     "$(date +%s)"
            printf '  %-14s %s\n' "毫秒"   "$(date +%s%3N)"
            printf '  %-14s %s\n' "日期"   "$(date '+%Y-%m-%d %H:%M:%S')"
            printf '  %-14s %s\n' "ISO"    "$(date -Iseconds)"
            ;;
        2)
            print -n "  时间戳: "; local ts; read -r ts
            [[ "$ts" =~ '^[0-9]+$' ]] || return
            print ""
            print "  $(date -d "@$ts" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"
            ;;
        3)
            print -n "  日期 (Y-m-d H:M:S): "; local ds; read -r ds
            [[ -z "$ds" ]] && return
            print ""
            print "  $(date -d "$ds" +%s 2>/dev/null)"
            ;;
    esac
    _550w_new_pause
}

_550w_new_dev_radix() {
    _550w_new_head "进制转换"
    print -n "  数字: "; local n; read -r n
    [[ -z "$n" ]] && return
    print ""
    if [[ "$n" =~ '^[0-9]+$' ]]; then
        printf '  %-6s %s\n' "10"  "$n"
        printf '  %-6s %s\n' "2"   "$(print "obase=2; $n" | bc 2>/dev/null)"
        printf '  %-6s %s\n' "8"   "$(print "obase=8; $n" | bc 2>/dev/null)"
        printf '  %-6s %s\n' "16"  "$(printf '%x' "$n")"
    else
        _550w_new_msg err "请输入十进制数字"
    fi
    _550w_new_pause
}

_550w_new_dev_url() {
    _550w_new_head "URL 编解码"
    print "  [1] 编码   [2] 解码"
    print -n "  选择: "; local c; read -r c
    print -n "  文本: "; local t; read -r t
    [[ -z "$t" ]] && return
    print ""
    if [[ "$c" == "1" ]]; then
        if command -v python3 >/dev/null 2>&1; then
            python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$t"
        else
            print -n "$t" | od -An -tx1 | tr ' ' '%' | tr -d '\n' | tr '[:lower:]' '[:upper:]'
        fi
    else
        if command -v python3 >/dev/null 2>&1; then
            python3 -c "import urllib.parse,sys; print(urllib.parse.unquote(sys.argv[1]))" "$t"
        else
            _550w_new_msg err "需装 python3"
        fi
    fi
    print ""
    _550w_new_pause
}

_550w_new_dev_uuid() {
    _550w_new_head "UUID 生成"
    print ""
    if command -v uuidgen >/dev/null 2>&1; then
        local i
        for (( i=1; i<=5; i++ )); do
            print "  $(uuidgen)"
        done
    elif [[ -r /proc/sys/kernel/random/uuid ]]; then
        local i
        for (( i=1; i<=5; i++ )); do
            print "  $(cat /proc/sys/kernel/random/uuid)"
        done
    else
        local i
        for (( i=1; i<=5; i++ )); do
            printf '  %04X%04X-%04X-%04X-%04X-%04X%04X%04X\n' \
                $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM)) $((RANDOM))
        done
    fi
    _550w_new_pause
}

_550w_new_dev_rand() {
    _550w_new_head "随机字符串"
    print -n "  长度（默认 32）: "; local len; read -r len
    [[ -z "$len" ]] && len=32
    [[ "$len" =~ '^[0-9]+$' ]] || return
    local chars="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local s="" i
    for (( i=0; i<len; i++ )); do
        s+="${chars[$((RANDOM % ${#chars} + 1))]}"
    done
    print ""
    print "  $s"
    _550w_new_pause
}

# ══════════════════ [补丁] 覆盖子菜单（删 9 项后）══════════════════

# 代码工具：删 公式渲染/代码执行 → 3 项
_550w_new_menu_code() {
    while true; do
        _550w_new_head "代码工具"
        _550w_new_row "1"  "代码高亮    简单着色"
        _550w_new_row "2"  "表格渲染    Markdown 表格"
        _550w_new_row "3"  "图表生成    文字转 ASCII 图"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-3]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_code_highlight ;;
            2) _550w_new_code_table ;;
            3) _550w_new_code_chart ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# 文件阅读：删 PDF 阅读/Git 集成 → 5 项
_550w_new_menu_read() {
    while true; do
        _550w_new_head "文件阅读"
        _550w_new_row "1"  "Markdown    美化显示"
        _550w_new_row "2"  "目录树      结构树状展示"
        _550w_new_row "3"  "日志分析    读取日志"
        _550w_new_row "4"  "配置解析    读取配置"
        _550w_new_row "5"  "数据分析    CSV 统计"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-5]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_read_md ;;
            2) _550w_new_read_tree ;;
            3) _550w_new_read_log ;;
            4) _550w_new_read_config ;;
            5) _550w_new_read_csv ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# 安全工具：删 二维码/加密解密/保险箱 → 2 项
_550w_new_menu_sec() {
    while true; do
        _550w_new_head "安全工具"
        _550w_new_row "1"  "哈希工具    计算哈希"
        _550w_new_row "2"  "随机密码    强密码生成"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-2]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_sec_hash ;;
            2) _550w_new_sec_passgen ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# 开发工具：删 JSON 格式化 → 7 项
_550w_new_menu_dev() {
    while true; do
        _550w_new_head "开发工具"
        _550w_new_row "1"  "编码转换    base64/hex/url"
        _550w_new_row "2"  "正则测试    正则调试"
        _550w_new_row "3"  "时间戳转换  unix 时间"
        _550w_new_row "4"  "进制转换    2/8/10/16 进制"
        _550w_new_row "5"  "URL 编解码"
        _550w_new_row "6"  "UUID 生成"
        _550w_new_row "7"  "随机字符串"
        print ""
        _550w_new_row "0"  "返回"
        print ""
        print -n "  选择 [0-7]: "
        local c
        read -r c
        case "$c" in
            1) _550w_new_dev_encode ;;
            2) _550w_new_dev_regex ;;
            3) _550w_new_dev_time ;;
            4) _550w_new_dev_radix ;;
            5) _550w_new_dev_url ;;
            6) _550w_new_dev_uuid ;;
            7) _550w_new_dev_rand ;;
            0|"") return ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ [补丁] 主菜单（删 9 项后）══════════════════

550w-new() {
    while true; do
        _550w_new_head "550W 新加功能"
        print -P "  %F{${_550W_C[dim]}}54 项扩展功能 · 10 个分组%f"
        print ""
        _550w_new_row "1"  "对话增强   (10)  分支/标签/搜索/收藏/合并"
        _550w_new_row "2"  "对话分析   ( 6)  统计/图表/回放/比较/导出"
        _550w_new_row "3"  "提示词库   ( 7)  保存/变量/导入/导出/角色"
        _550w_new_row "4"  "模型对比   ( 5)  对比/投票/评分/反馈"
        _550w_new_row "5"  "文本处理   ( 3)  摘要/关键词/翻译"
        _550w_new_row "6"  "代码工具   ( 3)  高亮/表格/图表"
        _550w_new_row "7"  "文件阅读   ( 5)  Markdown/目录/日志/配置/CSV"
        _550w_new_row "8"  "生活工具   ( 6)  定时/提醒/番茄钟/待办/笔记/书签"
        _550w_new_row "9"  "安全工具   ( 2)  哈希/随机密码"
        _550w_new_row "10" "开发工具   ( 7)  编码/正则/时间戳/进制/URL/UUID/随机"
        print ""
        _550w_new_row "0"  "退出"
        print ""
        print -n "  选择 [0-10]: "
        local c
        read -r c
        case "$c" in
            1)  _550w_new_menu_chat ;;
            2)  _550w_new_menu_analysis ;;
            3)  _550w_new_menu_prompt ;;
            4)  _550w_new_menu_model ;;
            5)  _550w_new_menu_text ;;
            6)  _550w_new_menu_code ;;
            7)  _550w_new_menu_read ;;
            8)  _550w_new_menu_life ;;
            9)  _550w_new_menu_sec ;;
            10) _550w_new_menu_dev ;;
            0|"") return 0 ;;
            *) continue ;;
        esac
    done
}

# ══════════════════ [补丁] 桩函数（防旧菜单误调）══════════════════

_550w_new_sec_qr_gen()  { _550w_new_msg wrn "功能已移除"; }
_550w_new_sec_qr_read() { _550w_new_msg wrn "功能已移除"; }
_550w_new_sec_crypto()  { _550w_new_msg wrn "功能已移除"; }
_550w_new_sec_vault()   { _550w_new_msg wrn "功能已移除"; }
_550w_new_read_pdf()    { _550w_new_msg wrn "功能已移除"; }
_550w_new_read_git()    { _550w_new_msg wrn "功能已移除"; }
_550w_new_dev_json()    { _550w_new_msg wrn "功能已移除"; }
_550w_new_code_formula() { _550w_new_msg wrn "功能已移除"; }
_550w_new_code_run()    { _550w_new_msg wrn "功能已移除"; }

# ══════════════════ [补丁] 已删除功能记录 ══════════════════

typeset -ga _550W_NEW_REMOVED=(
    "二维码生成|依赖 qrencode 未装"
    "二维码识别|依赖 zbarimg 未装"
    "PDF 阅读|依赖 pdftotext 未装"
    "密码保险箱|依赖 openssl 命令行未装"
    "加密解密|依赖 openssl 命令行未装"
    "JSON 格式化|依赖 python3/jq 未装"
    "公式渲染|终端不支持数学排版"
    "代码执行|安全风险"
    "Git 集成|依赖 git 未装"
)

550w-new-removed() {
    _550w_new_head "已移除功能"
    print -P "  %F{${_550W_C[dim]}}以下功能因依赖缺失或安全原因移除%f"
    print ""
    local entry name reason
    for entry in "${_550W_NEW_REMOVED[@]}"; do
        name="${entry%%|*}"
        reason="${entry#*|}"
        printf '  \e[38;5;%sm✗\e[0m %-14s \e[38;5;%sm%s\e[0m\n' \
            "${_550W_C[err]}" "$name" "${_550W_C[dim]}" "$reason"
    done
    print ""
    _550w_new_pause
}




_550w_new_model_vote() {
    _550w_new_head "多模型投票"
    print -n "  问题: "; local q; read -r q
    [[ -z "$q" ]] && return
    print ""
    print "  输入 3~5 个 provider（逗号分隔）"
    print "  例: glm,deepseek,qwen"
    print -n "  Provider: "; local list; read -r list
    [[ -z "$list" ]] && return

    local saved_p="$_550W_MOSS_PROVIDER"
    local saved_m="$_550W_MOSS_MODEL"
    local saved_t="$_550W_MOSS_TOKEN"
    local saved_u="$_550W_MOSS_CLOUD_URL"

    local p
    for p in ${=list//,/ }; do
        print ""
        print -P "  %F{${_550W_C[cyan]}}══ $p ══%f"
        _550W_MOSS_PROVIDER="$p"
        _550w_moss_resolve_provider 1
        _550w_moss_chat "$q"
        print "  $_550W_MOSS_REPLY"
    done

    _550W_MOSS_PROVIDER="$saved_p"
    _550W_MOSS_MODEL="$saved_m"
    _550W_MOSS_TOKEN="$saved_t"
    _550W_MOSS_CLOUD_URL="$saved_u"
    _550w_new_pause
}

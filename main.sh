#!/bin/bash

# ANSI カラーコードの配列
COLORS=(31 33 93 32 34 36 35)

target_string="helloworld"
num_chars=${#target_string}
# 無限ループでカラフルな出力を繰り返します
while true; do
    found=false
    cmd="paste"
    # target_stringの文字に基づいてコマンドを構築
    for ((i=0; i<num_chars; i++)); do
        char=${target_string:$i:1}  # 文字列から1文字を取得
        for file in ./alphabet/*.sh; do
            # ファイル名にtarget_stringが含まれ、そのファイルが実行可能であれば
            if [[ $file == *$char* ]] && [ -x "$file" ]; then
                found=true
                break
            fi
        done
        # 該当するファイルが一つもなければメッセージを出力
        if [ "$found" == "false" ]; then
            $char="under"
        fi
        color_code=${COLORS[i % ${#COLORS[@]}]}  # 文字に対応する色を取得

        cmd="$cmd <(./alphabet/$char.sh | sed 's/^/\x1b[${color_code}m/;s/$/\x1b[0m/')"
    done

    clear  # 画面をクリアしてから新しい出力を表示
    # コマンドを評価して実行
    eval $cmd

    # カーソルをリセットし、1秒待機
    echo -ne "\033[0m\r"
    sleep 1
    
    # 配列の色をシャッフル
    COLORS=( $(shuf -e "${COLORS[@]}") )
done
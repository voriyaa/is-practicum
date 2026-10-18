#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Usage: $0 <repo_url> <branch_1> <branch_2>"
    exit 1
fi

REPO=$1
BRANCH_1=$2
BRANCH_2=$3
REPORT="diff_report_${BRANCH_1}_vs_${BRANCH_2}.txt"
TMP_DIR=$(mktemp -d)

git clone -q "$REPO" "$TMP_DIR" || { rm -rf "$TMP_DIR"; exit 1; }
CHANGES=$(git -C "$TMP_DIR" diff --name-status --no-renames "origin/$BRANCH_1" "origin/$BRANCH_2") || { rm -rf "$TMP_DIR"; exit 1; }
rm -rf "$TMP_DIR"

TOTAL=$(echo "$CHANGES" | grep -c .)
ADDED=$(echo "$CHANGES" | grep -c "^A")
DELETED=$(echo "$CHANGES" | grep -c "^D")
MODIFIED=$(echo "$CHANGES" | grep -c "^M")

cat > "$REPORT" <<END
Отчет о различиях между ветками

================================
Репозиторий:    $REPO
Ветка 1:        $BRANCH_1
Ветка 2:        $BRANCH_2
Дата генерации: $(date "+%Y-%m-%d %H:%M:%S")
================================

СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:
$CHANGES

СТАТИСТИКА:
Всего измененных файлов: $TOTAL
Добавлено (A):    $ADDED
Удалено (D):      $DELETED
Изменено (M):     $MODIFIED
END

echo "Report saved to $REPORT"

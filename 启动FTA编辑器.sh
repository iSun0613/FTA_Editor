#!/usr/bin/env bash
# FTA/ETA 编辑器一键启动脚本（macOS / Linux / WSL）
# 首次运行会自动创建虚拟环境并安装依赖，之后运行可直接启动。
set -e
cd "$(dirname "$0")"

PY="${PYTHON:-python3}"
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "错误：未找到 $PY，请先安装 Python 3.10+。"
  echo "  macOS: 请从 https://www.python.org/downloads/ 安装，或 brew install python"
  echo "  Linux: sudo apt install python3"
  exit 1
fi

# GUI 依赖检查（tkinter）
if ! "$PY" -c "import tkinter" >/dev/null 2>&1; then
  echo "错误：缺少 tkinter（图形界面依赖）。"
  echo "  macOS: 请使用 python.org 官方安装包（自带 tkinter），而非 Homebrew 精简版"
  echo "  Linux: 请安装 python3-tk，如 sudo apt install python3-tk"
  exit 1
fi

# 使用项目内虚拟环境（首次自动创建）
VENV=".venv"
if [ ! -d "$VENV" ]; then
  echo "正在创建虚拟环境 .venv ..."
  if ! "$PY" -m venv "$VENV" >/dev/null 2>&1; then
    echo "警告：创建虚拟环境失败，将直接使用系统 Python。"
    echo "  Debian/Ubuntu 可先安装：sudo apt install python3-venv"
    VENV=""
  fi
fi

if [ -n "$VENV" ]; then
  # shellcheck disable=SC1091
  source "$VENV/bin/activate"
  PY="python"
fi

if [ -f requirements.txt ]; then
  echo "正在检查并安装依赖..."
  "$PY" -m pip install -r requirements.txt
fi

echo "正在启动 FTA/ETA 编辑器..."
exec "$PY" src/FTA_Editor_UI.py
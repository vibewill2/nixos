#!/bin/sh

# Detecta a interface de rede ativa
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

while true; do
  # --- CÁLCULO DE REDE ---
  R1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  T1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
  sleep 1
  R2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  T2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  RX=$(( (R2 - R1) / 1024 ))
  TX=$(( (T2 - T1) / 1024 ))

  # --- CPU ---
  CPU=$(cut -d' ' -f1 /proc/loadavg)

  # --- MEMÓRIA ---
  MEM=$(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100}')

  # --- VOLUME ---
  VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o "[0-9]\+%" | head -1)
  [ -z "$VOL" ] && VOL="0%"

  # --- DATA ---
  DATE=$(date +'%d/%m/%Y %H:%M')

  # --- SAÍDA FINAL COM TODAS AS CORES ---
  # CPU: Ciano | MEM: Verde | REDE: Amarelo | VOL: Magenta | DATA: Laranja/Ouro
  echo "<span color='#00ffff'></span> $CPU | <span color='#00ff00'>💾</span> $MEM | <span color='#ffff00'>🌐</span> ${RX}K↓ ${TX}K↑ | <span color='#ff00ff'></span> $VOL | <span color='#ffaa00'></span> $DATE"
done
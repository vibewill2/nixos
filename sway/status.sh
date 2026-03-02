#!/bin/sh

# Detecta a interface de rede ativa automaticamente (ex: enp3s0 ou wlan0)
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

while true; do
  # --- CÁLCULO DE REDE (Diferença de 1 segundo) ---
  # Lê os bytes recebidos e enviados
  R1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  T1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
  sleep 1
  R2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  T2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

  # Converte a diferença para KB/s
  RX=$(( (R2 - R1) / 1024 ))
  TX=$(( (T2 - T1) / 1024 ))

  # --- CPU (Carga média de 1 min via /proc para evitar erro de tradução) ---
  CPU=$(cut -d' ' -f1 /proc/loadavg)

  # --- MEMÓRIA ---
  MEM=$(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100}')

  # --- VOLUME ---
  VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o "[0-9]\+%" | head -1)
  [ -z "$VOL" ] && VOL="0%"

  # --- DATA ---
  DATE=$(date +'%d/%m/%Y %H:%M')

  # SAÍDA: Um único ícone para Down e Up 🌐
  # Formato: CPU | MEM | REDE (D/U) | VOL | DATA
  echo " $CPU | 💾 $MEM | 🌐 ${RX}K↓ ${TX}K↑ |  $VOL |  $DATE"
done
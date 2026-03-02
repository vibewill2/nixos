#!/bin/sh

# Detecta a interface de rede ativa (ignora o 'lo')
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)

# Função para converter bytes em KB/s ou MB/s
format_speed() {
    if [ "$1" -gt 1024 ]; then
        printf "%.1f MB/s" "$(echo "scale=2; $1/1024" | bc)"
    else
        printf "%d KB/s" "$1"
    fi
}

while true; do
  # --- REDE (Cálculo de diferença de 1 segundo) ---
  RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
  sleep 1
  RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
  TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
  
  # Calcula a velocidade em KB/s
  RX_SPEED=$(( (RX2 - RX1) / 1024 ))
  TX_SPEED=$(( (TX2 - TX1) / 1024 ))

  # --- CPU ---
  CPU=$(cut -d' ' -f1 /proc/loadavg)

  # --- MEMÓRIA ---
  MEM=$(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100}')

  # --- VOLUME ---
  VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o "[0-9]\+%" | head -1)
  [ -z "$VOL" ] && VOL="0%"

  # --- DATA ---
  DATE=$(date +'%d/%m/%Y %H:%M')

  # Saída com ícones de rede: ⬇️ Download | ⬆️ Upload
  echo " $CPU | 💾 $MEM | ⬇️ ${RX_SPEED}KB/s ⬆️ ${TX_SPEED}KB/s |  $VOL |  $DATE"
done
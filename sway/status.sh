#!/bin/sh

while true; do
  # CPU: Usando /proc/loadavg para ser mais direto e evitar problemas de tradução do 'uptime'
  # O primeiro valor é a carga do último 1 minuto.
  CPU=$(cut -d' ' -f1 /proc/loadavg)

  # MEMÓRIA: Mantendo sua lógica, mas garantindo que o 'free' esteja disponível
  MEM=$(free | grep Mem | awk '{printf "%.0f%%", $3/$2 * 100}')

  # Volume: Melhorando a captura para evitar erros caso o pactl demore a responder
  VOL=$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -o "[0-9]\+%" | head -1)
  [ -z "$VOL" ] && VOL="0%"

  # Data
  DATE=$(date +'%d/%m/%Y %H:%M')

  # Saída para a barra do SwayFX
  echo " $CPU | 💾 $MEM |  $VOL |  $DATE"
  
  sleep 1
done
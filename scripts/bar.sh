#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

# load colors
. ~/.config/chadwm/scripts/bar_themes/catppuccin

battery_directory_prefix="/sys/class/power_supply/BAT"
battery_exists=false

for i in {0..9}; do
    current_battery_directory="$battery_directory_prefix$i"
    if [ -d "$current_battery_directory" ]; then
        battery_exists=true
        break
    fi
done

battery() {
  if [ "$battery_exists" = true ]; then
    charging=$(cat /sys/class/power_supply/BAT*/status)
    capacity=$(cat /sys/class/power_supply/BAT*/capacity)
    cbicons="󰢟󰢜󰂆󰂇󰂈󰢝󰂉󰢞󰂊󰂋"
    bicons="󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"
    if [ "$charging" = "Charging" ]; then
      icon=$(expr substr $cbicons $(($capacity / 10)) 1)
    else
      icon=$(expr substr $bicons $(($capacity / 10)) 1)
    fi
    printf "     ^c$blue^ $icon $capacity"
  fi
}

cpu() {
  c=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%%"}')
  printf "^c$green^ ^b$black^ "
  printf "^c$green^ ^b$black^ $c"
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

lan() {
  # Get the currently active interfac
  gateway=$(ip route show default | awk '/default/ {print $3}')
  interface=$(ip route get "$gateway" | awk '/dev/ {print $3}')

  # Check if its connected or not
  case "$(cat /sys/class/net/$interface/operstate 2>/dev/null)" in
    up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
    down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
  esac
}

clock() {
  clocks="󱑊󱐿󱑀󱑁󱑂󱑃󱑄󱑅󱑆󱑇󱑈󱑉"
  time=$(date '+%H')
  hour=$(($time%12+1))
  c=$(expr substr $clocks $hour 1)
  printf "^c$black^ ^b$darkblue^ $c "
  printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do
  sleep 1 && xsetroot -name "   $(battery) $(cpu) $(mem) $(lan) $(clock)"
done

date=$(date +'%Y-%m-%d %I:%M:%S %p')
swaymsg -t subscribe -m '["window"]' | jq -r '.container.name'

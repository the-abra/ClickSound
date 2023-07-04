function LifeTime() {
target_date="2024-07-04"
today=$(date +%Y-%m-%d)
seconds_per_day=86400

target_epoch=$(date -d "$target_date" +%s)
current_epoch=$(date -d "$today" +%s)

time_diff=$((target_epoch - current_epoch))
days_diff=$((time_diff / seconds_per_day))

current_year=$(date -d "$today" +%Y)
leap_year=0

if (( (current_year % 4 == 0 && current_year % 100 != 0) || current_year % 400 == 0 )); then
  leap_year=1
fi

if (( leap_year == 1 && $(date -d "$today" +%m-%d) > "02-28" )); then
  days_diff=$((days_diff + 1))
fi
}


count=${1:-5}
readonly MAIN_ACTIVITY="com.thoughtworks.fancy_yacht_frontend/.MainActivity"

function cold_start() {
  adb shell am start -W -S -R "$count" $MAIN_ACTIVITY
}

function hot_start() {
  for ((i = 0; i < count; i++)); do
    adb shell input keyevent 3
    sleep 1
    adb shell am start -W $MAIN_ACTIVITY
  done
}

function calculate_start_total_time() {
  $1 | grep 'TotalTime' | awk '{sum+=$2}END{print sum}'
}

function calculate_start_average_time() {
  total_time=$(calculate_start_total_time "$1")
  echo $((total_time / count))
}

function test_cold_start() {
  echo "--- Cold start testing ---"
  echo "Average Time: $(calculate_start_average_time cold_start)"
  echo "----- Cold start end -----"
}

function test_hot_start() {
  echo "---- Hot start testing ---"
  echo "Average Time: $(calculate_start_average_time hot_start)"
  echo "------ Hot start end -----"
}

echo "--------------------------"
test_cold_start
echo
echo
test_hot_start
echo "--------------------------"

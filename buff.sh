wm size reset
sleep 0.2

size=$(wm size | grep -oE '[0-9]+x[0-9]+')
dpi=$(wm density | grep -oE '[0-9]+')

if [ -z "$dpi" ]; then
  echo "❌ Không lấy được DPI. Thoát..."
  exit 1
fi

width=$(echo "$size" | cut -d'x' -f1)
height=$(echo "$size" | cut -d'x' -f2)

compare=$(echo "$dpi < 400" | bc)
if [ "$compare" -eq 1 ]; then
  scale=1.2
  echo "🔧 Buff màn hình lên $scale"

  new_width=$(echo "$width * $scale" | bc | cut -d'.' -f1)
  new_height=$(echo "$height * $scale" | bc | cut -d'.' -f1)

  wm size ${new_width}x${new_height}
  echo "✅ Kích thước màn hình đã đổi: ${new_width}x${new_height}"
else
  echo "📌 DPI đủ cao, giữ nguyên độ phân giải gốc."
fi

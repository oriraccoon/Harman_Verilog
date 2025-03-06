# Vivado 종료 전에 Git 자동 커밋 & 푸시 실행
puts "Running Git Auto Commit & Push..."

# Git 저장소 경로로 이동
cd "C:/Users/kccistc/Documents/GitHub/Harman_Verilog"

# Git 명령 실행 (Windows에서는 exec 앞에 start /b를 붙여 비동기 실행 가능)
exec git add .
exec git commit -m "Auto commit from Vivado"
exec git push origin main

puts "Git Auto Commit & Push Completed!"

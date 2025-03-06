# git_auto_commit_push.ps1
$repoPath = "C:\Users\kccistc\Documents\GitHub\Harman_Verilog"  # 로컬 레포지토리 경로
$gitExe = "C:\Program Files\Git\bin\git.exe"   # Git 실행 파일 경로

# Vivado 종료 감지 (Vivado 프로세스 이름)
$vivadoProcess = "vivado.exe"
$processRunning = Get-Process | Where-Object { $_.Name -eq $vivadoProcess }

while ($processRunning) {
    Start-Sleep -Seconds 5
    $processRunning = Get-Process | Where-Object { $_.Name -eq $vivadoProcess }
}

# Vivado가 종료되면 Git 자동 커밋 및 푸시
Set-Location -Path $repoPath

# 현재 시간 포맷 (예: 2025-03-06 15:30)
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"

# 커밋 메시지에 시간 포함
$commitMessage = "Auto commit after Vivado closed at $currentTime"

# Git 커밋 및 푸시
& $gitExe add .
& $gitExe commit -m $commitMessage
& $gitExe push origin main

# 3초 대기 후 PowerShell 창 종료
Start-Sleep -Seconds 3
Exit

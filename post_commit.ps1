$repoPath = "C:\Users\kccistc\Documents\GitHub\Harman_Verilog"  # 로컬 레포지토리 경로
$gitExe = "C:\Program Files\Git\bin\git.exe"   # Git 실행 파일 경로

# Vivado 프로세스 감지
$vivadoProcess = "vivado.exe"

# Vivado 실행 여부 확인
$processRunning = Get-Process -Name $vivadoProcess -ErrorAction SilentlyContinue

if ($processRunning) {
    Write-Host "Vivado 실행 중... 종료될 때까지 대기합니다."
    Wait-Process -Name $vivadoProcess
}

Write-Host "Vivado 종료 감지됨. Git 자동 커밋 및 푸시 시작."

# Git 커밋 및 푸시 수행
Set-Location -Path $repoPath

# 현재 시간 포맷 (예: 2025-03-06 15:30)
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"
$commitMessage = "Auto commit after Vivado closed at $currentTime"

& $gitExe add .
& $gitExe commit -m $commitMessage
& $gitExe push origin main

Write-Host "Git 자동 커밋 및 푸시 완료."

# 3초 대기 후 PowerShell 창 종료
Start-Sleep -Seconds 3
Exit

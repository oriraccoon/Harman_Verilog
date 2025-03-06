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
& $gitExe add .
& $gitExe commit -m "Auto commit after Vivado closed"
& $gitExe push origin main

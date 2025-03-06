@echo off
runas /user:Administratorstart "" "C:\Xilinx\Vivado\2020.2\bin\vivado.bat"
powershell -ExecutionPolicy Bypass -File "C:\Users\kccistc\Documents\GitHub\Harman_Verilog\post_commit.ps1"
@echo off
start "" "C:\Xilinx\Vivado\2020.2\bin\unwrapped\win64.o\vvgl.exe"   # Vivado 경로
powershell -ExecutionPolicy Bypass -File "C:\Users\kccistc\Documents\GitHub\Harman_Verilog\post_commit.ps1"

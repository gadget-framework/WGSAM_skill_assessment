; main file for gadget - created in Rgadget
; WGTS/main.ldist.cap.com - Mon Sep 25 16:43:51 2023
timefile Modelfiles/time
areafile Modelfiles/area
printfiles ; no printfile supplied
[stock]
stockfiles cap
[tagging]
[otherfood]
[fleet]
fleetfiles Modelfiles/fleet_cap
[likelihood]
likelihoodfiles WGTS/likelihood.ldist.cap.com

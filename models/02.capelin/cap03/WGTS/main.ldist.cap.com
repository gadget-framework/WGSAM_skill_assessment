; main file for gadget - created in Rgadget
; WGTS/main.ldist.cap.com - Sun Sep 17 21:23:21 2023
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

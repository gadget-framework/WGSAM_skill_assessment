; main file for gadget - created in Rgadget
; WGTS/main.ldist.had.com - Mon Apr  3 17:05:56 2023
timefile Modelfiles/time
areafile Modelfiles/area
printfiles ; no printfile supplied
[stock]
stockfiles had
[tagging]
[otherfood]
[fleet]
fleetfiles Modelfiles/fleet_had
[likelihood]
likelihoodfiles WGTS/likelihood.ldist.had.com

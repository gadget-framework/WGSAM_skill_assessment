; main file for gadget - created in Rgadget
; WGTS/main.ldist.cod.com - Sat Sep 23 03:34:42 2023
timefile Modelfiles/time
areafile Modelfiles/area
printfiles ; no printfile supplied
[stock]
stockfiles cod
[tagging]
[otherfood]
[fleet]
fleetfiles Modelfiles/fleet_cod
[likelihood]
likelihoodfiles WGTS/likelihood.ldist.cod.com

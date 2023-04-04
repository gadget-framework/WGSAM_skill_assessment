; Likelihood file - created in Rgadget
; WGTS/likelihood.ldist.had.com - 2023-04-03
[component]
name		alk.had.surQ2
weight		0.117205813408345
type		catchdistribution
datafile		Data/catchdistribution.alk.had.surQ2.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.alk.had.surQ2.area.agg
ageaggfile		Aggfiles/catchdistribution.alk.had.surQ2.age.agg
lenaggfile		Aggfiles/catchdistribution.alk.had.surQ2.len.agg
fleetnames		survQ2had
stocknames		had
;
[component]
name		alk.had.surQ4
weight		0.103616205574552
type		catchdistribution
datafile		Data/catchdistribution.alk.had.surQ4.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.alk.had.surQ4.area.agg
ageaggfile		Aggfiles/catchdistribution.alk.had.surQ4.age.agg
lenaggfile		Aggfiles/catchdistribution.alk.had.surQ4.len.agg
fleetnames		survQ4had
stocknames		had
;
[component]
name		ldist.had.com
weight		930.232558139535
type		catchdistribution
datafile		Data/catchdistribution.ldist.had.com.sumofsquares
function		sumofsquares
aggregationlevel		1
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.had.com.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.had.com.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.had.com.len.agg
fleetnames		comhad
stocknames		had
;
[component]
name		ldist.had.surQ2
weight		0.0915750915750916
type		catchdistribution
datafile		Data/catchdistribution.ldist.had.surQ2.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.had.surQ2.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.had.surQ2.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.had.surQ2.len.agg
fleetnames		survQ2had
stocknames		had
;
[component]
name		ldist.had.surQ4
weight		0.0890471950133571
type		catchdistribution
datafile		Data/catchdistribution.ldist.had.surQ4.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.had.surQ4.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.had.surQ4.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.had.surQ4.len.agg
fleetnames		survQ4had
stocknames		had
;
[component]
name		siQ2.had
weight		0.0272257010618023
type		surveyindices
datafile		Data/surveyindices.siQ2.had.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ2.had.area.agg
lenaggfile		Aggfiles/surveyindices.siQ2.had.len.agg
stocknames		had
fittype		loglinearfit
;
[component]
name		siQ4.had
weight		0.0274800769442154
type		surveyindices
datafile		Data/surveyindices.siQ4.had.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ4.had.area.agg
lenaggfile		Aggfiles/surveyindices.siQ4.had.len.agg
stocknames		had
fittype		loglinearfit
;
[component]
name		understocking
weight		10
type		understocking
;
[component]
name		bounds
weight		10
type		penalty
datafile		Data/bounds.penaltyfile
;

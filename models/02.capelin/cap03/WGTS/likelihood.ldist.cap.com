; Likelihood file - created in Rgadget
; WGTS/likelihood.ldist.cap.com - 2023-09-17
[component]
name		alk.cap.surQ1
weight		0.0247770069375619
type		catchdistribution
datafile		Data/catchdistribution.alk.cap.surQ1.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.alk.cap.surQ1.area.agg
ageaggfile		Aggfiles/catchdistribution.alk.cap.surQ1.age.agg
lenaggfile		Aggfiles/catchdistribution.alk.cap.surQ1.len.agg
fleetnames		survQ1cap
stocknames		cap
;
[component]
name		ldist.cap.com
weight		239.693192713327
type		catchdistribution
datafile		Data/catchdistribution.ldist.cap.com.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.cap.com.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.cap.com.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.cap.com.len.agg
fleetnames		comcap
stocknames		cap
;
[component]
name		ldist.cap.surQ1
weight		0.0244140625
type		catchdistribution
datafile		Data/catchdistribution.ldist.cap.surQ1.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.cap.surQ1.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.cap.surQ1.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.cap.surQ1.len.agg
fleetnames		survQ1cap
stocknames		cap
;
[component]
name		ldist.cap.surQ3
weight		0.0791765637371338
type		catchdistribution
datafile		Data/catchdistribution.ldist.cap.surQ3.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.cap.surQ3.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.cap.surQ3.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.cap.surQ3.len.agg
fleetnames		survQ3cap
stocknames		cap
;
[component]
name		siQ1.cap
weight		0.192418703097941
type		surveyindices
datafile		Data/surveyindices.siQ1.cap.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ1.cap.area.agg
lenaggfile		Aggfiles/surveyindices.siQ1.cap.len.agg
stocknames		cap
fittype		loglinearfit
;
[component]
name		siQ3.cap
weight		0.227998176014592
type		surveyindices
datafile		Data/surveyindices.siQ3.cap.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ3.cap.area.agg
lenaggfile		Aggfiles/surveyindices.siQ3.cap.len.agg
stocknames		cap
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

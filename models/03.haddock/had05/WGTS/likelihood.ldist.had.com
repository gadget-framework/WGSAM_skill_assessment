; Likelihood file - created in Rgadget
; WGTS/likelihood.ldist.had.com - 2023-04-14
[component]
name		alk.had.surQ1
weight		0.175932441942294
type		catchdistribution
datafile		Data/catchdistribution.alk.had.surQ1.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.alk.had.surQ1.area.agg
ageaggfile		Aggfiles/catchdistribution.alk.had.surQ1.age.agg
lenaggfile		Aggfiles/catchdistribution.alk.had.surQ1.len.agg
fleetnames		survQ1had
stocknames		had
;
[component]
name		ldist.had.com
weight		1351.16876097825
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
name		ldist.had.surQ1
weight		0.103584006629376
type		catchdistribution
datafile		Data/catchdistribution.ldist.had.surQ1.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.had.surQ1.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.had.surQ1.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.had.surQ1.len.agg
fleetnames		survQ1had
stocknames		had
;
[component]
name		ldist.had.surQ3
weight		0.100532823967025
type		catchdistribution
datafile		Data/catchdistribution.ldist.had.surQ3.sumofsquares
function		sumofsquares
aggregationlevel		0
overconsumption		0
epsilon		10
areaaggfile		Aggfiles/catchdistribution.ldist.had.surQ3.area.agg
ageaggfile		Aggfiles/catchdistribution.ldist.had.surQ3.age.agg
lenaggfile		Aggfiles/catchdistribution.ldist.had.surQ3.len.agg
fleetnames		survQ3had
stocknames		had
;
[component]
name		siQ1.had
weight		0.0277932184546971
type		surveyindices
datafile		Data/surveyindices.siQ1.had.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ1.had.area.agg
lenaggfile		Aggfiles/surveyindices.siQ1.had.len.agg
stocknames		had
fittype		loglinearfit
;
[component]
name		siQ3.had
weight		0.0279485746226942
type		surveyindices
datafile		Data/surveyindices.siQ3.had.lengths
sitype		lengths
biomass		1
areaaggfile		Aggfiles/surveyindices.siQ3.had.area.agg
lenaggfile		Aggfiles/surveyindices.siQ3.had.len.agg
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

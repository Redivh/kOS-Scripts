clearscreen.
lock relvelocity to  ship:velocity:orbit - target:velocity:orbit.
lock targetdirection to target:position:normalized.
lock SideSlip_vec to VCRS(VCRS(targetdirection,ship:velocity:orbit),targetdirection):normalized.
set SideSlipCoef to 4.
lock SideSlipSpeed to VDOT(SideSlip_vec,relvelocity)/SideSlipCoef.
lock max_acc_tar to VDOT(targetdirection,availablethrust*ship:facing:vector)/mass.
lock target_dist to target:position:mag.
lock speed_to_target to VDOT(relvelocity,targetdirection).

//lock PointVector to relvelocity+SideSlip_vec*SideSlipSpeed.
lock PointVector to relvelocity.
lock steering to PointVector:direction.
lock DeltaV to relvelocity:mag.
lock throttle to 0.
lock amax to availablethrust/mass.
lock alignang to VANG(ship:facing:vector,PointVector).
print "Aligning to Retrograde Burn".
set TargetPos to VECDRAW(V(0,0,0),target:position,GREEN,"Target Position",1.0,TRUE,.5).
set RelativeVel to VECDRAW(V(0,0,0),relvelocity,RED,"RelativeVel",1.0,TRUE,.5).
until alignang < 1 {
	print "Direction Angle Error = " + round(alignang,1) + "   "at(0,2).
}

until DeltaV <= .1 {
	set TargetPos to VECDRAW(V(0,0,0),target:position,GREEN,"Target Position",1.0,TRUE,.5).
	set RelativeVel to VECDRAW(V(0,0,0),relvelocity,RED,"RelativeVel",1.0,TRUE,.5).
	set SideSlipVec to VECDRAW(relvelocity,(1/SideSlipCoef)*SideSlip_vec*SideSlipSpeed,Blue,"SideSlip_vec",1.0,TRUE,.5).
	set PointDrawVec to VECDRAW(V(0,0,0),PointVector,Blue," ",1.0,TRUE,.5).
    set Alt_ship1 to altitude.
	set Alt_target1 to target:altitude.
	set Diff1 to abs(Alt_ship1 - Alt_target1).
    wait .0001.
    set Alt_ship2 to altitude.
	set Alt_target2 to target:altitude.
	set Diff2 to abs(Alt_ship2 - Alt_target2).
    set diff to Diff2-Diff1.
    if diff >= 0 {
        lock throttle to DeltaV/amax.
    }
}
lock throttle to 0.
clearscreen. 
print "Rendezvous Phase 1 Complete, Phase 2 Begin".
set bufferdist to 50.
lock stopcheck to (target:position:mag - bufferdist) - 2*(VDOT(target:position:normalized,relvelocity))^2/amax.
lock PointVector to target:position.
print "Aligning to Prograde Burn".
until alignang < 1 {
	print "Direction Angle Error = " + round(alignang,1) + "   "at(0,2).
}
clearscreen.
set throttlecheck to stopcheck.
until stopcheck < 0 {
	lock throttle to sqrt(max(0,stopcheck/throttlecheck)).
	print "amax = " + round(amax,2) at (0,2).
	print "stopcheck = " + round(stopcheck,2) at(0,3).
	}
lock throttle to 0.
lock PointVector to relvelocity+SideSlip_vec*SideSlipSpeed.
set startretro to .25*target:position:mag+bufferdist.
set SideSlipCoef to 1.
until DeltaV <= .1 {
	set TargetPos to VECDRAW(V(0,0,0),target:position,GREEN,"Target Position",1.0,TRUE,.5).
	set RelativeVel to VECDRAW(V(0,0,0),relvelocity,RED,"RelativeVel",1.0,TRUE,.5).
	set SideSlipVec to VECDRAW(relvelocity,2*SideSlip_vec*SideSlipSpeed,Blue,"SideSlip_vec",1.0,TRUE,.5).
	set PointDrawVec to VECDRAW(V(0,0,0),PointVector,WHITE," ",1.0,TRUE,.5).
    set Alt_ship1 to altitude.
	set Alt_target1 to target:altitude.
	set Diff1 to abs(Alt_ship1 - Alt_target1).
    wait .0001.
    set Alt_ship2 to altitude.
	set Alt_target2 to target:altitude.
	set Diff2 to abs(Alt_ship2 - Alt_target2).
    set diff to Diff2-Diff1.
	if startretro > target:position:mag {
		lock throttle to DeltaV/amax.
		}
	print "amax = " + round(amax,2) at (0,2).
	print "stopcheck = " + round(stopcheck,2) at(0,3).
	print "Target Dist = " + round(target:position:mag,2) at(0,4).
	print "startretro = " + round(startretro,2) at(0,5).
}
lock throttle to 0.
CLEARVECDRAWS().
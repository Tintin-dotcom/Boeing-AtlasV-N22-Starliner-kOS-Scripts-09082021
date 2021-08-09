clearscreen.
wait 4.
stage.
wait 3.
lock throttle to 1.
wait 1.5.
stage.
set target to "Iss".
lock inclination to 90 - (target:orbit:inclination + 6.6).
set runmode to "Liftoff".
set stage2 to "n".
set stage3 to "n".
set tval to 0.
set tes1 to "n".

until runmode = "Done" {
	if runmode = "Liftoff" {
		if ship:apoapsis > target:orbit:apoapsis {
			lock throttle to 0.
			wait 1.
			stage.
			set runmode to "Coastphase".
		}
		turn(inclination).
	}
	if ship:solidfuel < 89 and stage2 = "n" {
		stage.
		set stage2 to "y".
	}
	if ship:stagedeltav(ship:stagenum):current < 25 and stage2 = "y" and stage3 = "n" {
		wait 2.
		stage.
		wait 3.
		stage.
		wait 6.
		stage.
		set stage2 to "n".
		set stage3 to "y".
	}
	
	if runmode = "Coastphase" {
		if eta:apoapsis < 21 and tes1 = "n" {
			stage.
			wait 2.
			lock throttle to 1.
			set tes1 to "y".
		}
		if ship:periapsis > 150000 {
				lock throttle to 0.
				set runmode to "Done".
		}
	}
	
	printVesselStats().
}
sas on.

function printVesselStats {
	clearscreen.
	print "Telemetry:" at(1, 4).
	print "Altitude above sea level: " + round(ship:altitude) + "m" at(10, 5).
	print "Current apoapsis: " + round(ship:apoapsis) + "m" at (10, 6).
	print "Current periapsis: " + round(ship:periapsis) + "m" at (10, 7).
	print "Orbital velocity: " + round(ship:velocity:orbit:mag * 3.6) + "km/h" at(10, 9).
	print "Ship longitude: " + round(ship:longitude) + "º" at (10, 10).
	print "Target longitude: " + round(target:longitude) + "º" at (10, 11).
}

function turn {
	parameter heading.
	if alt:radar < 1000 {
		lock angle to 90.
		lock steering to heading(heading, angle).
	}
	else if alt:radar > 60000 {
		lock steering to prograde.
	}
	else{
		lock angle to 104 - 1.03287 * alt:radar^.4.
		lock steering to heading(heading, angle).
	}
}


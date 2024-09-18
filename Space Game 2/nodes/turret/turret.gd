extends TakerNode

var spinSpeed = 1.5

func _ready():
	
	$PowerTimer.wait_time = PowerFrequency

func _physics_process(delta):
	$Label.text = str(StoredPower)
	
	if StoredPower >= PoweredThreshold:
		Powered = 1
	else:
		Powered = 0
	
	if Powered:
		$Pivot/barrel.color.b += 1
		$Pivot.rotation_degrees += spinSpeed

func _on_power_timer_timeout():
	getPower()

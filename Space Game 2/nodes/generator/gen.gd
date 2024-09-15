extends GiverNode

func _physics_process(delta):
	$Label.text = str(StoredPower)

func _on_timer_timeout():
	updateDistances()

func _on_generate_power_timeout():
	StoredPower += 1

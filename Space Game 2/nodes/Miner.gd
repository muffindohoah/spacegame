extends TakerNode

func _ready():
	
	$PowerTimer.wait_time = PowerFrequency

func _physics_process(delta):
	$Label.text = str(StoredPower)
	
	if StoredPower >= PoweredThreshold:
		Powered = 1
	else:
		Powered = 0
	
	if Powered:
		_powered_process()

func _powered_process():
	pass

func mine():
	for i in ConnectedNodes.size():
		
		if ConnectedNodes[i] != null && ConnectedNodes[i].is_in_group("asteroid"):
			$Pivot.look_at(ConnectedNodes[i].position)
			ConnectedNodes[i].Rocks -= 1
			Utils.SpaceRocks += 1

func _on_connector_area_entered(area):
	if area.get_parent().is_in_group("asteroid"):
		connectNode(area.get_parent())

func _on_power_timer_timeout():
	getPower()
	if Powered:
		mine()

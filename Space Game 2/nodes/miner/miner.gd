extends TakerNode

var focusAsteroid = null

func _ready():
	findAsteroid()
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
	
	$Pivot.rotation = lerp_angle($Pivot.rotation, get_angle_to(focusAsteroid.position), 0.01)

func findAsteroid():
	if ConnectedNodes.find("Asteroid"):
		for i in ConnectedNodes.size():
			if ConnectedNodes[i] != null && ConnectedNodes[i].is_in_group("asteroid"):
				focusAsteroid = ConnectedNodes[i]
				return true
	else:
		focusAsteroid = null
		return false

func mine():
	if focusAsteroid:
		
		focusAsteroid.Rocks -= 1
		Utils.SpaceRocks += 1


func _on_connector_area_entered(area):
	if area.get_parent().is_in_group("asteroid"):
		connectNode(area.get_parent())

func _on_power_timer_timeout():
	if focusAsteroid == null:
		findAsteroid()
	else:
		
		getPower()
	
	if Powered:
		mine()

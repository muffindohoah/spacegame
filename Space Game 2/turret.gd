extends Node2D

var StoredPower = 5
var PowerThreshold = 1
var Powered = 0

@export var PowerFrequency : float = 1

var ConnectedNodes = {}

var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1
	}

func _ready():
	
	$PowerTimer.wait_time = PowerFrequency
	
	Utils.Demanders.append(self)

func _physics_process(delta):
	$Label.text = str(StoredPower)
	
	if StoredPower >= PowerThreshold:
		Powered = 1
	else:
		Powered = 0
	
	if Powered:
		$Pivot/barrel.color.b += 1
		$Pivot.rotation_degrees += 1.5

func getPower():
	
	request()
	print("need power")
	StoredPower -= 1
	

func receive(data):
	print("Received Power")
	StoredPower += data.Power

func request():
	for i in ConnectedNodes.size():
		if ConnectedNodes[i].is_in_group("relay"):
			ConnectedNodes[i].send(RequestForm)
			return

func connectNode(node):
	print("turret connected to")
	
	var WireScene = load("res://wire.tscn").instantiate()
	WireScene.WiredFrom = self
	WireScene.WiredTo = node
	get_parent().add_child(WireScene)
	
	ConnectedNodes[ConnectedNodes.size()] = node
	
	print(ConnectedNodes)

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)


func _on_power_timer_timeout():
	getPower()

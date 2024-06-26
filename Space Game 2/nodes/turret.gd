extends BasicNode

var StoredPower = 5
var StoredPowerThreshold = 5
var PoweredThreshold = 1
var Powered = 0

@export var PowerFrequency : float = 1

var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

func _ready():
	
	$PowerTimer.wait_time = PowerFrequency
	
	Utils.Demanders.append(self)

func _physics_process(delta):
	$Label.text = str(StoredPower)
	
	if StoredPower >= PoweredThreshold:
		Powered = 1
	else:
		Powered = 0
	
	if Powered:
		$Pivot/barrel.color.b += 1
		$Pivot.rotation_degrees += 1.5

func getPower():
	RequestForm.Couriers.clear()
	if StoredPower > 0:
		StoredPower -= 1
	if StoredPower < StoredPowerThreshold:
		requestPower()
	

func receive(data):
	
	StoredPower += data.Power

func requestPower():
	
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("relay") or ConnectedNodes[i].is_in_group("power"):
				var SendingForm = RequestForm.duplicate(false)
				ConnectedNodes[i].call_deferred("send", RequestForm)
				

func deadEnd(from):
	print(RequestForm.PowerParent, from)
	
	if RequestForm.PowerParent == from:
		
		RequestForm.PowerParent = null
		
	elif RequestForm.ParentGateway != null:
		if RequestForm.ParentGateway.has(from):
			
			RequestForm.PowerParent = null

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)


func _on_power_timer_timeout():
	getPower()

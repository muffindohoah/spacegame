extends BasicNode

var PowerFrequency = 0.75
var StoredPower = 5

var BlankReturnForm = {
	"To":0, #Requestee
	"Power":0 #Requested Amount
	
}

var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

func _ready():
	$Connector/CollisionShape2D.shape.radius = Utils.NodeDB.Battery.ConnectionRange
	$powertimer.wait_time = PowerFrequency
	Utils.Demanders.append(self)
	Utils.WebChanged.connect(updateDistances)
	Utils.Suppliers.append(self)
	updateDistances()


func _physics_process(delta):
	$Label.text = str(StoredPower)
	

func getPower():
	RequestForm.Couriers.clear()
	
	requestPower()

func receive(data):
	StoredPower += data.Power

func requestPower():
	
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null:
			if ConnectedNodes[i].is_in_group("relay") or ConnectedNodes[i].is_in_group("power"):
				ConnectedNodes[i].call_deferred("send", RequestForm)

func deadEnd(from):
	print(RequestForm.PowerParent, from)
	
	if RequestForm.PowerParent == from:
		
		RequestForm.PowerParent = null
		
	elif RequestForm.ParentGateway != null:
		if RequestForm.ParentGateway.has(from):
			
			RequestForm.PowerParent = null


func _on_power_timer_timeout():
	getPower()

func send(data):
	returnRequest(data)

func returnRequest(data):
	if self != data.PowerParent && data.PowerParent != null:
		return
	else:
		
		data.PowerParent = self
		data.ParentGateway = ConnectedNodes.duplicate(false)
	
	var ReturnForm = BlankReturnForm
	ReturnForm.To = data.From
	
	if StoredPower >= data.Power:
		StoredPower -= data.Power
		ReturnForm.Power = data.Power
	else:
		return
	
	data.From.receive(ReturnForm)

func updateDistances():
	for i in ConnectedNodes.size():
		if ConnectedNodes[i] != null && ConnectedNodes[i].has_method("setDistanceFrom"):
			ConnectedNodes[i].setDistanceFrom([self], 0)

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)
		updateDistances()

func _on_powertimer_timeout():
	getPower()

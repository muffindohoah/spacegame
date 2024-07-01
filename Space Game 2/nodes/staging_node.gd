extends BasicNode

var matureNode = null

var StoredPower = 0
var PowerGoal = 15
var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

@onready var progressbar = $ColorRect/ProgressBar

func _ready():
	
	progressbar.max_value = PowerGoal

func _process(delta):
	pass


func getPower():
	RequestForm.Couriers.clear()
	
	if StoredPower < PowerGoal:
		requestPower()
	else:
		completeNode()
	

func requestPower():
	
	for i in ConnectedNodes.size():
		if ConnectedNodes[i].is_in_group("relay"):
			print("SOS buildstuff",RequestForm.Couriers)
			var SendingForm = RequestForm.duplicate(false)
			ConnectedNodes[i].send(SendingForm)

func receive(data):
	print("Received Buildstuff" + str(data.Power))
	StoredPower += data.Power
	progressbar.value = StoredPower
	

func deadEnd(from):
	if RequestForm.ParentGateway:
		if RequestForm.ParentGateway.has(from):
			print("cant find builddad")
			RequestForm.PowerParent = null

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)

func completeNode():
	print("completion")

func _on_timer_timeout():
	print("need buildstuff")
	getPower()

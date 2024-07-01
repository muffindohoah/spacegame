extends BasicNode

var matureSelf = "Generator"


var isSelectingLocation = false
var StoredPower = 0
var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

@onready var PowerGoal = Utils.NodeDB[matureSelf].PowerToBuild
@onready var progressbar = $ColorRect/ProgressBar
@onready var timer = $Timer
@onready var connector = $Connector

func _ready():
	modulate.a = 100
	progressbar.max_value = PowerGoal

func _process(delta):
	if isSelectingLocation:
		global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("LMB"):
			isSelectingLocation = false
			groundSelf()

func groundSelf():
	modulate.a = 255
	connector.monitorable = true
	connector.monitoring = true
	timer.start()

func getPower():
	RequestForm.Couriers.clear()
	
	if StoredPower < PowerGoal:
		requestPower()
	else:
		completeNode()
	

func requestPower():
	
	for i in ConnectedNodes.size():
		if ConnectedNodes[i].is_in_group("relay") or ConnectedNodes[i].is_in_group("power"):
			
			var SendingForm = RequestForm.duplicate(false)
			ConnectedNodes[i].send(SendingForm)

func receive(data):
	
	StoredPower += data.Power
	progressbar.value = StoredPower
	

func deadEnd(from):
	if RequestForm.ParentGateway:
		if RequestForm.ParentGateway.has(from):
			
			RequestForm.PowerParent = null

func _on_connector_area_entered(area):
	var prospectiveNode = area.get_parent()
	if area.is_in_group("collider") && area.get_parent() != self:
		connectNode(prospectiveNode)

func completeNode():
	
	var butterfly = Utils.NodeDB[matureSelf].PackedScene.instantiate()
	get_parent().add_child(butterfly)
	
	for i in ConnectedNodes:
		butterfly.connectNode(i)
	butterfly.global_position = self.global_position
	queue_free()
	
	Utils.WebChanged.emit()

func _on_timer_timeout():
	
	getPower()

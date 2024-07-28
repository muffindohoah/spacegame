extends BasicNode

var matureSelf = "Generator"


var isSelectingLocation = false
var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

@onready var PowerGoal = Utils.NodeDB[matureSelf].PowerToBuild
@onready var ConnectionRange = Utils.NodeDB[matureSelf].ConnectionRange
@onready var progressbar = $ColorRect/ProgressBar
@onready var timer = $Timer
@onready var connector = $Connector
@onready var connectorshape = $Connector/CollisionShape2D

func _ready():
	modulate.a = 100
	progressbar.max_value = PowerGoal
	connectorshape.shape.radius = ConnectionRange

func _process(delta):
	if isSelectingLocation:
		_staging_process()

func _staging_process():
	global_position = get_global_mouse_position()
	queue_redraw()
	if Input.is_action_just_pressed("LMB"):
		isSelectingLocation = false
		groundSelf()

func _draw():
	if isSelectingLocation:
		draw_circle(get_local_mouse_position(), ConnectionRange, Color.STEEL_BLUE)

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

extends BasicNode

var matureSelf = "Generator"
@onready var matureNodeData = Utils.getNodeTypeData(matureSelf)

var isSelectingLocation = false
var RequestForm = {
	"From":self,
	"To":"Power",
	"Power":1,
	"PowerParent":null,
	"ParentGateway":null,
	"Couriers":[]
	}

@onready var PowerGoal = matureNodeData.PowerToBuild
@onready var ConnectionRange = matureNodeData.ConnectionRange
@onready var progressbar = $ColorRect/ProgressBar
@onready var timer = $Timer
@onready var collision = $Collision
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
	collision.monitorable = true
	collision.monitoring = true
	timer.start()

func getPower():
	RequestForm.Couriers.clear()
	
	if StoredPower < PowerGoal:
		requestPower()
	else:
		completeNode()
	

func requestPower():
	
	for i in ConnectedNodes.size():
		if !ConnectedNodes[i] == null:
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
	if area.is_in_group("collider") && prospectiveNode != self:
		
		if !prospectiveNode.is_in_group("asteroid"):
			connectNode(prospectiveNode)
		
		if (prospectiveNode.is_in_group("asteroid")) && (matureNodeData.nodeName == "Miner"):
			connectNode(prospectiveNode)

func completeNode():
	
	var butterfly = matureNodeData.packedScene.instantiate()
	get_parent().add_child(butterfly)
	
	for i in ConnectedNodes:
		butterfly.connectNode(i)
	butterfly.global_position = self.global_position
	queue_free()
	
	Utils.WebChanged.emit()

func _on_timer_timeout():
	
	getPower()

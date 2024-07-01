extends CanvasLayer

@onready var menuButton = $Root/PopupButton
@onready var selectableNodesContainer = $Root/selectPanel/selectableNodes
@onready var AnimPlayer = $AnimationPlayer
@onready var scoreLabel = $Label

var isPanel = false : set = panelSet

func _ready():
	AnimPlayer.play("RESET")
	spawnNodeUI()

func spawnNodeUI():
	for i in Utils.NodeDB.keys():
		var nodeUIelement = load("res://ui/nodeUIelement.tscn").instantiate()
		nodeUIelement.focusNode = i
		nodeUIelement.nodeSelected.connect(nodeUIselected)
		selectableNodesContainer.add_child(nodeUIelement)

func nodeUIselected(node):
	Utils.SelectedNode = node
	Utils.NodeSelected.emit(node, true)
	print("nodeUIselected")
	togglePanel()

func panelSet(value):
	if value:
		AnimPlayer.play("slidingUp")
	else:
		AnimPlayer.play("slidingDown")
	isPanel = value

func togglePanel():
	isPanel = !isPanel

func _on_popup_button_pressed():
	togglePanel()


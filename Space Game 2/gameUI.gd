extends CanvasLayer

@onready var menuButton = $Root/PopupButton
@onready var selectableNodesContainer = $Root/selectPanel/selectableNodes
@onready var AnimPlayer = $AnimationPlayer
@onready var scoreLabel = $Label

var isPanel = false : set = panelSet, get = panelGet

func _ready():
	AnimPlayer.play("RESET")
	spawnNodeUI()

func _process(delta):
	pass

func spawnNodeUI():
	for i in Utils.NodeDB.keys():
		var NodeUIElement = load("res://nodeUIelement.tscn").instantiate()
		NodeUIElement.focusNode = i
		
		selectableNodesContainer.add_child(NodeUIElement)
		

func panelSet(value):
	if value:
		AnimPlayer.play("slidingUp")
	else:
		AnimPlayer.play("slidingDown")
	isPanel = value

func panelGet():
	return isPanel

func _on_popup_button_pressed():
	
	isPanel = !isPanel
	

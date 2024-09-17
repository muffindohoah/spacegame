extends Button

var focusNode : set = setFocusNode
var nodeData

@onready var NameLabel = $VBoxContainer/NameLabel
@onready var PriceLabel = $VBoxContainer/PriceLabel
@onready var PreviewTextureRect = $VBoxContainer/PreviewTextureRect

signal nodeSelected(node)

func setFocusNode(value):
	focusNode = value
	nodeData = Utils.getNodeTypeData(focusNode)
	print(focusNode + str(nodeData))

func _ready():
	updateUI()

func updateUI():
	
	if focusNode:
		print(nodeData)
		PriceLabel.text = str(nodeData.Price)
		NameLabel.text = nodeData.nodeName

func _on_pressed():
	print("buttonpressed")
	Utils.SpaceRocks -= nodeData.Price
	nodeSelected.emit(focusNode)

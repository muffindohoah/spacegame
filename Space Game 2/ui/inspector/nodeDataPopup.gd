extends Window

var focusNode
@onready var focusNodeData = Utils.getNodeTypeData(focusNode.name.rstrip("0123456789"))
@onready var popupHbox = preload("res://ui/inspector/popupHbox.tscn")

@onready var VBox = $Panel/VBoxContainer

func _ready():
	print(focusNode)
	if !focusNodeData == null:
		self.title = focusNodeData.nodeName
		createValues()
	else:
		_on_close_requested()

func createValues():
	print(focusNodeData.displayedValues.keys())
	for i in focusNodeData.displayedValues.keys():
		
		var valueHbox = popupHbox.instantiate()
		
		valueHbox.node = focusNode
		valueHbox.property = i
		valueHbox.editable = focusNodeData.displayedValues[i]
		
		VBox.add_child(valueHbox)


func _on_close_requested():
	queue_free()

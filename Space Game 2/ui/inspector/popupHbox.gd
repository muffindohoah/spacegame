extends HBoxContainer

var node
var property
var editable: bool

@onready var propertyLabel = $Label
var valueInput

func _ready():
	
	propertyLabel.text = property
	
	createValueInput()
	
	if editable:
		valueInput.editable = true
	else:
		valueInput.editable = false

func createValueInput():
	var boolInput = CheckButton.new()
	var intInput = SpinBox.new()
	var strInput = TextEdit.new()
	var colInput = ColorPickerButton.new()
	var objInput = Button.new()
	
	var type
	
	print(property, node.get(property))
	
	match typeof(node.get(property)):
		1: #bool
			type = "bool"
		2: #int
			type = "int"
			
		3: #string
			type = "str"
		14: #color
			type = "color"
		17: #object
			type = "obj"
	
	add_child(self.get("%sInput" % type))
	valueInput = get_child(get_child_count()-1)
	valueInput.step = 0.25
	if node.get(property):
		valueInput.value = node.get(property)
	
	valueInput.value_changed.connect(setNodeProperty)

func setNodeProperty(to):
	print("changed", to)
	node.set(property, to)

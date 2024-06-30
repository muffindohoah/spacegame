extends PanelContainer

var focusNode : set = setFocusNode

@onready var NameLabel = $VBoxContainer/NameLabel
@onready var PriceLabel = $VBoxContainer/PriceLabel
@onready var PreviewTextureRect = $VBoxContainer/PreviewTextureRect

func setFocusNode(value):
	focusNode = value


func _ready():
	updateUI()

func updateUI():
	print(Utils.NodeDB[focusNode].Price)
	PriceLabel.text = str(Utils.NodeDB[focusNode].Price)
	NameLabel.text = focusNode


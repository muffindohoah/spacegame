extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.NodeSelected.connect(nodeSelected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func nodeSelected(node, isStaging):
	if isStaging:
		var stagingNode = load("res://nodes/staging node/staging_node.tscn").instantiate()
		
		stagingNode.isSelectingLocation = true
		stagingNode.matureSelf = node
		add_child(stagingNode)


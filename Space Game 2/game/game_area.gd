extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.NodeSelected.connect(nodeSelected)
	for i in 20:
		var asteroid = load("res://nodes/asteroid/asteroid.tscn").instantiate()
		asteroid.position = Vector2(position.x + (randi()%2000 - randi()%2000), position.y + (randi()%2000 - randi()%2000))
		add_child(asteroid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("Escape"):
		
		get_tree().reload_current_scene()

func nodeSelected(node, isStaging):
	if isStaging:
		var stagingNode = load("res://nodes/staging node/staging_node.tscn").instantiate()
		stagingNode.isSelectingLocation = true
		stagingNode.matureSelf = node
		add_child(stagingNode)

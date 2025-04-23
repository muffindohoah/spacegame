extends Node2D

@onready var dataPopupScene = preload("res://ui/inspector/nodeDataPopup.tscn")

var focusNode


func _unhandled_input(event):
	
	if Input.is_action_just_pressed("LMB"):
		print("goober")
		self.visible = false
		killBounds()
		position = get_global_mouse_position()

func _on_connector_area_entered(area):
	
	
	var prospectiveNode = area.get_parent()
	
	if !area.is_in_group("collider") or !prospectiveNode.is_in_group("node"):
		return
	
	killBounds()
	focusNode = prospectiveNode
	
	position = focusNode.position
	self.visible = true
	
	createBounds(focusNode)
	showDataUI(focusNode)

func killBounds():
	for n in self.get_children():
		if n.is_in_group("bound"):
			remove_child(n)
			n.queue_free()

func createBounds(aroundnode):
	var inspectorBound = load("res://ui/inspector/inspectorBounds.tscn")
	
	for i in 4:
		var tempInspectorBound = inspectorBound.instantiate()
		print("spawnbounds")
		tempInspectorBound.nodeToBound = aroundnode
		tempInspectorBound.duckling = i
		self.add_child(tempInspectorBound)

func showDataUI(forNode):
	var dataPopup = dataPopupScene.instantiate()
	dataPopup.focusNode = forNode
	
	var canvas_position = forNode.get_canvas_transform().origin
	dataPopup.position = Vector2(forNode.get_global_transform_with_canvas().origin.x + 34, forNode.get_global_transform_with_canvas().origin.y - 30)
	add_child(dataPopup)

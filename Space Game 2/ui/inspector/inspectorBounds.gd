extends Node2D

var duckling
var nodeToBound

const animWeight = 0.3

func _ready():
	
	print(nodeToBound, nodeToBound.find_child("Collision").get_child(0).shape.size)

func _physics_process(delta):
	
	if nodeToBound == null:
		return
	match duckling:
		0:
			rotation_degrees = lerp(rotation_degrees, float(-90), animWeight) 
			global_position = lerp(global_position, nodeToBound.position + Vector2(nodeToBound.find_child("Collision").get_child(0).shape.size.x / 2, nodeToBound.find_child("Collision").get_child(0).shape.size.y / 2), animWeight)
		1:
			rotation_degrees = lerp(rotation_degrees, float(0), animWeight) 
			global_position = lerp(global_position, nodeToBound.position + Vector2(-nodeToBound.find_child("Collision").get_child(0).shape.size.x/2, nodeToBound.find_child("Collision").get_child(0).shape.size.y/2), animWeight)
		2:
			rotation_degrees = lerp(rotation_degrees, float(-180), animWeight) 
			global_position = lerp(global_position, nodeToBound.position + Vector2(nodeToBound.find_child("Collision").get_child(0).shape.size.x/2, -nodeToBound.find_child("Collision").get_child(0).shape.size.y/2), animWeight)
		3:
			rotation_degrees = lerp(rotation_degrees, float(90), animWeight) 
			global_position = lerp(global_position, nodeToBound.position + Vector2(-nodeToBound.find_child("Collision").get_child(0).shape.size.x/2, -nodeToBound.find_child("Collision").get_child(0).shape.size.y/2), animWeight)
	
#that long thing finds the collision shape of the requested node (which is always a rectangle) 
#then the match finds which corner it should go to
 

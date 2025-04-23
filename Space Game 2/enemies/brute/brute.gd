extends CharacterBody2D

const HEALTH = 5
const SPEED = 90.0
var health = HEALTH
var current_target: set = set_current_target
var targets = []
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var hitbox = $Area2D2

func _ready() -> void:
	_on_timer_timeout()

func _physics_process(delta: float) -> void:
	
	
	var target_direction = (nav_agent.get_next_path_position() - global_position).angle()

	$RemoteTransform2D.global_rotation = lerp_angle($RemoteTransform2D.global_rotation, target_direction, .05)
	
	var new_velocity = global_position.direction_to(nav_agent.get_next_path_position()) * SPEED
	#print(new_velocity)
	nav_agent.velocity = new_velocity
	
	move_and_slide()

func set_current_target(new_target):
	current_target = new_target

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#print(safe_velocity, "SAFE")
	velocity += safe_velocity * 0.5
	velocity *= 0.8


func generate_path(global_vec2):
	
	nav_agent.target_position = global_vec2
	
	#print(nav_agent.target_position, nav_agent.get_final_position(), nav_agent.get_next_path_position())

func hit(damage):
	health -= damage
	if health <= 0:
		death()

func death():
	queue_free()

func get_target_position():
	if current_target:
		return current_target.global_position
	else:
		return Vector2(0,0)

func _on_timer_timeout() -> void:
	if current_target == null:
		if targets.size() > 0:
			current_target = targets[0]
	generate_path(get_target_position())

func _on_area_2d_area_entered(area: Area2D) -> void:
	var potential_target = area.get_parent()
	if potential_target.is_in_group("node"):
		targets.append(potential_target)

func _on_area_2d_area_exited(area: Area2D) -> void:
	var potential_target = area.get_parent()
	if targets.has(potential_target):
		targets.erase(potential_target)

func _on_navigation_agent_2d_target_reached() -> void:
	pass # Replace with function body.


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("collider"):
		var knockback = self.velocity.normalized()
		knockback = -knockback *1000
		velocity += knockback
		print("happeningsss")
		area.get_parent().hit()
	

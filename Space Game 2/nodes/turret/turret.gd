extends TakerNode

var spinSpeed = 1.5
var targets = []
var shotCooldown = 1 : set = set_shot_cooldown
var damage = 1

func set_shot_cooldown(new):
	shotCooldown = new
	$ShotCooldown.wait_time = new


func _physics_process(delta):
	$Label.text = str(StoredPower)
	
	if StoredPower >= PoweredThreshold:
		Powered = 1
	else:
		Powered = 0
	
	if Powered:
		if !targets.is_empty():
			print(targets[0])
			if targets[0] == null:
				targets.pop_front()
				return
			var target = targets[0]
			var target_direction = (target.global_position - global_position).angle()
			$Pivot.global_rotation = lerp_angle($Pivot.global_rotation, target_direction, .05)
			if $ShotCooldown.time_left == 0:
				$ShotCooldown.start()
				$AnimationPlayer.play("shoot")
				hit_target(targets[0])

func hit_target(target):
	target.hit(damage)

func _on_power_timer_timeout():
	getPower()

func _on_detection_area_area_entered(area: Area2D) -> void:
	var potential_target = area.get_parent()
	if potential_target.is_in_group("enemy"):
		targets.append(area.get_parent())

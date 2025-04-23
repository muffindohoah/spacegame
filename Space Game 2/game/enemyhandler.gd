extends Node2D

@onready var waittimer = $Timer
const RANGE = 500

func _ready() -> void:
	position = Vector2(randi()%RANGE, randi()%RANGE)
	startwavetimer()

func _process(delta: float) -> void:
	$Label.text = "INBOUND:"+str(waittimer.time_left)

func startwavetimer():
	waittimer.start()


func _on_timer_timeout() -> void:
	
	for i in Utils.Wave:
		var enemy = load("res://enemies/brute/brute.tscn").instantiate()
		enemy.position = Vector2(position.x + randi()%20, position.y + randi()%20)
		get_parent().add_child(enemy)
	
	$Area2D.monitoring = true
	Utils.WaveTimerStart.emit(waittimer, waittimer.wait_time)
	Utils.Wave += 1
	waittimer.wait_time *= 1.35
	position = Vector2(randi()%RANGE, randi()%RANGE)


func _on_area_2d_area_entered(area: Area2D) -> void:
	position = Vector2(randi()%RANGE, randi()%RANGE)

extends Line2D

var WiredFrom
var WiredTo
var WireColor = Color(0,25,200)

func _ready():
	default_color = WireColor
	add_point(WiredFrom.global_position)
	add_point(WiredTo.global_position)

func pulse():
	$AnimationPlayer.play("pulse")

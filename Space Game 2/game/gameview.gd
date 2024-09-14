extends Camera2D

var zoomSpeed

var targetZoom = Vector2(1, 1)
const MIN_ZOOM = 0.1
const MAX_ZOOM = 2
const ZOOM_INC = 0.1

func _ready():
	Input.use_accumulated_input = false
	pass

func _physics_process(delta):
	zoom = lerp(zoom, targetZoom * Vector2.ONE, ZOOM_INC)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()
	
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("MMB"):
			self.offset -= event.relative * self.zoom
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_in()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_out()

func zoom_in():
	targetZoom += Vector2(0.1, 0.1)

func zoom_out():
	targetZoom -= Vector2(0.1, 0.1)

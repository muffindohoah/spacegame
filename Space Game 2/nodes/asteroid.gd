extends BasicNode

@onready var ResourceLabel = $ResourceLabel

const MaxRocks = 1000 

var Rocks = 0: 
	set(value):
		ResourceLabel.text = str(value)
		Rocks = value
		
		if Rocks == 0:
			kill()

func _ready():
	Rocks += MaxRocks

func kill():
	print("kill asteroid")
	queue_free()

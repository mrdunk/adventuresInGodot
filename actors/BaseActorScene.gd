extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(_name: String):
	name = _name
	
func point(_name: String, heading: Vector2):
	rotation = heading.angle()

func move(_name: String, _position: Vector2):
	position = _position

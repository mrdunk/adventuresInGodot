# Display an icon at the squad's target point for debug purposes.
extends Area2D

var BaseActorScene = preload("res://actors/BaseActorScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var squad_data = common_data.squads[name]
	for actor_data in squad_data.members.values():
		var actor_scene = BaseActorScene.instance()
		actor_scene.initialize(actor_data.name)
		actor_data.connect("changed_heading", actor_scene, "point")
		actor_data.connect("changed_position", actor_scene, "move")
		self.get_parent().add_child(actor_scene)
	
func initialize(_name: String):
	name = _name

func move(name: String, _position: Vector2):
	position = _position
extends Control

var BaseActor = preload("res://actors/BaseActor.tscn")
var SquadHint = preload("res://actors/SquadHint.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#common_data.add_squad(2)
	#common_data.add_squad(5)
	common_data.add_squad(30)
	#common_data.add_squad(1)

	for squad in common_data.squads.values():
		squad.scene = SquadHint.instance()
		add_child(squad.scene)
		for actor in squad.members.values():
			actor.scene = BaseActor.instance()
			add_child(actor.scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	for squad in common_data.squads.values():
		squad.move(delta)

func _on_Stage_resized():
	common_data.window_size = get_viewport_rect().size
	print(common_data.window_size)

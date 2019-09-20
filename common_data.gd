extends Node

#export(Resource) var actor = load("res://actor.gd")

export(Dictionary) var actors
export(Dictionary) var squads
export var window_size := Vector2()

func add_squad(count := 1):
	var squad_number = squads.size()
	var squad_name = "squad_%s" % squad_number
	var squad = Squad.new(squad_name)
	for i in range(count):
		var actor_name = "actor_%s_%s" % [squad_number, i]
		var actor_instance = Actor.new(actor_name, 100)
		actors[actor_name] = actor_instance
		squad.members[actor_name] = actor_instance
	squads[squad_name] = squad
	squad.update_members()
	
	print("---")
	print(actors)
	print(squads)
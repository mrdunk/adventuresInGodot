extends Node

var actors := {}
var squads := {}
export var window_size := Vector2()

func add_squad(count := 1):
	var squad_number = squads.size()
	var squad = Squad.new(count)
	
	print("%s: %s %s" % [squads.size(), squad.name, squad.members.size()])
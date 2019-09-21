extends Node

var actors := {}
var squads := {}
export var window_size := Vector2()

func add_squad(member_count := 1):
	var squad = Squad.new(member_count)
	print("%s: %s %s" % [squads.size(), squad.name, squad.members.size()])
	return squad
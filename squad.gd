# A squad is a collection of actors which will operate together as a unit.
extends Resource
class_name Squad

# Will be raised whenever the squad's target position changes.
signal changed_position

var name := ""
var position := Vector2()
var heading := Vector2(1, 1).normalized()
var speed := 100
var members := {}

# Variables that affect how the squad's Actors move.
var config := {
	"neighbour_dist": 200,		# Actor attracted to neighbours within this distance.
	"desired_seperation": 150,	# Actor repelled from any neighbour closer than this.
	"seperation": 20,			# How strongly repelled from neighbours.
	"cohesion": 0.1,			# How strongly attracted to neighbours.
	"heading": 1,				# TODO
	"fade": 1,
	"target": 0.4,				# How strongly attracted to Squad's tartget point.
	"random": 1,				# How much random jitter to apply.
	"edge_avoid": 0.5			# How strongly to be repelled from window edges.
}

func _init(count: int):
	name = "squad_%s" % common_data.squads.size()
	position.x = rand_range(0, common_data.window_size.x)
	position.y = rand_range(0, common_data.window_size.y)
	
	for i in range(count):
		_add_member()
		
	common_data.squads[name] = self

func _add_member():
	var actor_name = "actor_%s_%s" % [common_data.squads.size(), members.size()]
	var actor_instance = Actor.new(actor_name, config, 100)
	common_data.actors[actor_name] = actor_instance
	members[actor_name] = actor_instance

# Called once per frame to update squad.
# Updates position as well as calculating neighbours of individual actors.
func update(delta: float):
	position += heading * speed * delta
	emit_signal("changed_position", name, position)
	
	if(position.x <= 0 or position.x >= common_data.window_size.x):
		position.x = clamp(position.x, 0, common_data.window_size.x)
		heading += Vector2(rand_range(-0.1, 0.1), rand_range(-0.1, 0.1))
		heading = heading.normalized()
		heading = heading.reflect(Vector2(0, 1))
	if(position.y <= 0 or position.y >= common_data.window_size.y):
		position.y = clamp(position.y, 0, common_data.window_size.y)
		heading += Vector2(rand_range(-0.1, 0.1), rand_range(-0.1, 0.1))
		heading = heading.normalized()
		heading = heading.reflect(Vector2(1, 0))
	
	_update_members(delta)
	_update_neighbours()

func _update_members(delta: float):
	for member in members.values():
		member.update(delta, position)

func _update_neighbours():
	var neighbour_dist_squared = config.neighbour_dist * config.neighbour_dist
	var members_array = members.values()
	var neighbours = members_array.duplicate()
	for member in members_array:
		member.neighbours.clear()
	for member in members_array:
		neighbours.pop_front()
		for neighbour in neighbours:
			if member.position.distance_squared_to(neighbour.position) < neighbour_dist_squared:
				#if member.neighbours.size() < 2:
					member.neighbours[neighbour.name] = neighbour
				#if neighbour.neighbours.size() < 5:
					neighbour.neighbours[member.name] = member
			
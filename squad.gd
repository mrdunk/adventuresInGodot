extends Resource

class_name Squad

export(String) var name := ""
export(Vector2) var position := Vector2()
export(Vector2) var heading := Vector2(1, 1).normalized()
export(int) var speed := 100
var members := {}
export(Resource) var scene = null

var config := {
	"neighbour_dist": 200,
	"desired_seperation": 100,
	"seperation": 10,
	"cohesion": 0.2,
	"heading": 1,
	"fade": 5,
	"target": 0.4,
	"random": 1,
	"edge_avoid": 0.5
}

func _init(count: int):
	name = "squad_%s" % common_data.squads.size()
	position.x = rand_range(0, common_data.window_size.x)
	position.y = rand_range(0, common_data.window_size.y)
	
	for i in range(count):
		var actor_name = "actor_%s_%s" % [common_data.squads.size(), i]
		var actor_instance = Actor.new(actor_name, config, 100)
		common_data.actors[actor_name] = actor_instance
		members[actor_name] = actor_instance
		
	common_data.squads[name] = self
	update_members(1)

func add_member(member: Actor):
	members[member.name] = member

func update(delta: float):
	position += heading * speed * delta
	
	if(position.x <= 0 or position.x >= common_data.window_size.x):
		position.x = clamp(position.x, 0, common_data.window_size.x)
		heading = heading.reflect(Vector2(0, 1))
	if(position.y <= 0 or position.y >= common_data.window_size.y):
		position.y = clamp(position.y, 0, common_data.window_size.y)
		heading = heading.reflect(Vector2(1, 0))
		
	if(!scene):
		return
	scene.position = position
	
	update_members(delta)
	update_neighbours()

func update_members(delta: float):
	for member in members.values():
		member.update(delta, position)

func update_neighbours():
	var neighbour_dist_squared = config.neighbour_dist * config.neighbour_dist
	var members_array = members.values()
	var neighbours = members_array.duplicate()
	for member in members_array:
		member.neighbours.clear()
	for member in members_array:
		neighbours.pop_front()
		for neighbour in neighbours:
			if member.position.distance_squared_to(neighbour.position) < neighbour_dist_squared:
				member.neighbours[neighbour.name] = neighbour
				neighbour.neighbours[member.name] = member
			
			
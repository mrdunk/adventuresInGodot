extends Resource

class_name Squad

export(String) var name := ""
export(Vector2) var position := Vector2()
export(Vector2) var heading := Vector2(1, 1).normalized()
export(int) var speed := 100
export(Dictionary) var members
export(Resource) var scene = null

var neighbour_dist := 200

func _init(_name: String):
	name = _name
	
func add_member(member: Actor):
	members[member.name] = member

func move(delta: float):
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
	
	update_members()
	update_neighbours()

func update_members():
	for member in members.values():
		member.update(position)

func update_neighbours():
	var members_array = members.values()
	var neighbours = members_array.duplicate()
	for member in members_array:
		member.neighbours.clear()
	for member in members_array:
		neighbours.pop_front()
		for neighbour in neighbours:
			if(member.position.distance_squared_to(neighbour.position) <
					neighbour_dist * neighbour_dist):
				member.neighbours[neighbour.name] = neighbour
				neighbour.neighbours[member.name] = member
			
			
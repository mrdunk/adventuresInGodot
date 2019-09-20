extends Resource

class_name Actor

signal changed_position
signal changed_heading

export(Vector2) var position := Vector2(10, 10) setget set_position
export(Vector2) var heading := Vector2(1, 1) setget set_heading
export(String) var name := ""
export(int) var speed := 0
export(int) var agility := 0
export(int) var stamina := 0
export(Resource) var scene = null

var neighbours := {}
var desired_seperation = 100

func _init(_name: String, _speed := 0, _agility := 0, _stamina := 1):
	name = _name
	speed = _speed
	agility = _agility
	stamina = _stamina
	
func update(target: Vector2):
	#print("update %s %s" % [target, seperation()])
	seperation()
	self.heading = (
	                heading * 5
	                + (target - self.position).normalized() * 0.05
					#+ Vector2(rand_range(-0.05, 0.05), rand_range(-0.05, 0.05))
					+ seperation() * 2
					+ coheasion() * 0.01
					).normalized()
	if(position.x <= 0 or position.x >= common_data.window_size.x):
		position.x = clamp(position.x, 0, common_data.window_size.x)
		heading = heading.reflect(Vector2(0, 1))
	if(position.y <= 0 or position.y >= common_data.window_size.y):
		position.y = clamp(position.y, 0, common_data.window_size.y)
		heading = heading.reflect(Vector2(1, 0))
		
	self.position += self.heading
	
func coheasion():
	if neighbours.size() == 0:
		return heading
	var count = 0
	var sum = Vector2(0, 0)
	for neighbour in neighbours.values():
		var dist = position.distance_to(neighbour.position)
		if dist > desired_seperation:
			sum += neighbour.position * dist
			count += 1
	if count > 0:
		sum /= count
		return (sum - position).normalized()
	return heading

func seperation():
	var count = 0
	var mean_heading = Vector2(0, 0)
	for neighbour in neighbours.values():
		var dist = position.distance_to(neighbour.position)
		if dist == 0:
			return Vector2(rand_range(-1, 1), rand_range(-1, 1))
		if dist < desired_seperation:
			mean_heading += (position - neighbour.position).normalized() / dist
			count += 1
	if count:
		mean_heading /= count
	return mean_heading
	
func set_position(new_position: Vector2):
	#print("set_position %s %s" % [new_position, position])
	position = new_position
	emit_signal("changed_position")
	if(!scene):
		return
	scene.position = position

func set_heading(new_heading: Vector2):
	heading = new_heading
	emit_signal("changed_heading")
	if(!scene):
		return
	scene.rotation = heading.angle()
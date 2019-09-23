extends Resource

class_name Actor

signal changed_position
signal changed_heading

var squad_name := ""
var position := Vector2(
  rand_range(0, common_data.window_size.x),
  rand_range(0, common_data.window_size.y)) setget set_position
var heading := Vector2(1, 1) setget set_heading
var name := ""
var speed := 0
var agility := 0
var stamina := 0
var config: Dictionary
var neighbours := {}

func _init(_name: String, _squad_name: String, _config: Dictionary, _speed := 0, _agility := 0, _stamina := 1):
  name = _name
  squad_name = _squad_name
  config = _config
  speed = _speed #* rand_range(0.5, 1)
  agility = _agility
  stamina = _stamina
  
func update(delta: float, target: Vector2):
  #print("update %s %s" % [target, seperation()])
  #print("%s %s" % [config.desired_seperation, config.neighbour_dist])
  self.heading = (
                  heading
                  + (target - self.position).normalized() * config.target / 100
                  + Vector2(rand_range(-1, 1), rand_range(-1, 1)) * config.random / 100
                  + seperation() * config.seperation
                  + cohesion() * config.cohesion
                  + follow() * config.follow
                  + edge_avoid() * config.edge_avoid
                 ).normalized()
  if(position.x <= 0 or position.x >= common_data.window_size.x):
    position.x = clamp(position.x, 0, common_data.window_size.x)
    heading = heading.reflect(Vector2(0, 1))
  if(position.y <= 0 or position.y >= common_data.window_size.y):
    position.y = clamp(position.y, 0, common_data.window_size.y)
    heading = heading.reflect(Vector2(1, 0))
  
  #var distance = position.distance_to(common_data.squads[squad_name].position)
  #var calculated_speed = clamp(distance - 100, 0, speed)
  #self.position += self.heading * delta * calculated_speed
  self.position += self.heading * delta * speed
  
func edge_avoid():
  var return_val = Vector2(0, 0)
  if position.x <= 100:
    return_val = Vector2((100 - position.x) / 5000, 0)
  elif position.x >= common_data.window_size.x - 100:
    return_val = Vector2(-(100 + position.x - common_data.window_size.x) / 5000, 0)
  
  if position.y <= 100:
    return_val += Vector2(0, (100 - position.y) / 10000)
  elif position.y >= common_data.window_size.y - 100:
    return_val += Vector2(0, -(100 + position.y - common_data.window_size.y) / 5000)
    
  return return_val

func follow():
  if neighbours.size() == 0:
    return heading
  var sum = Vector2(0, 0)
  for neighbour in neighbours.values():
    sum += neighbour.heading
  return sum.normalized()
  
func cohesion():
  if neighbours.size() == 0:
    return heading
  var sum = Vector2(0, 0)
  for neighbour in neighbours.values():
    var dist = position.distance_to(neighbour.position)
    #sum += neighbour.position.normalized() * dist
    sum += (neighbour.position - position).normalized() * dist
  sum /= neighbours.size()
  #return (sum - position).normalized()
  return sum.normalized() / 32

func seperation():
  var count = 0
  var mean_heading = Vector2(0, 0)
  for neighbour in neighbours.values():
    var dist = position.distance_to(neighbour.position)
    if dist == 0:
      return Vector2(rand_range(-1, 1), rand_range(-1, 1))
    if dist < config.desired_seperation:
      mean_heading += (position - neighbour.position).normalized() / dist
      count += 1
  if count:
    mean_heading /= count
  return mean_heading
  
func set_position(new_position: Vector2):
  #print("set_position %s %s" % [new_position, position])
  position = new_position
  emit_signal("changed_position", name, position)

func set_heading(new_heading: Vector2):
  heading = new_heading
  emit_signal("changed_heading", name, heading)

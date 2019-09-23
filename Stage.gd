# Root godot node.
# Think "Stage" as the stage in a theater here Actors perform.

extends Control

var SquadScene = preload("res://actors/SquadScene.tscn")

# Store reference to all child godot scenes.
var scenes := { "squads": {},
                "actors": {} }

# Add a squad of actors.
# Args:
#   count: Number of actors in squad.
# Returns:
#   [squad_data, squad_scene]:
#      squad_data: Non-display related data about the squad.
#      squad_scene: Godot node displaying the squad's position.
func add_squad(count: int):
  var squad_data = common_data.add_squad(count)
  
  var squad_scene = SquadScene.instance()
  squad_scene.initialize(squad_data.name)
  scenes.squads[squad_data.name] = squad_scene
  squad_data.connect("changed_position", squad_scene, "move")
  add_child(squad_scene)
  
  return [squad_data, squad_scene]

# Called when the node enters the scene tree for the first time.
func _ready():
  add_squad(50)
  #add_squad(75)
  #add_squad(100)
  #add_squad(25)
  $SuqadConfig._ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
  for squad in common_data.squads.values():
    squad.update(delta)

# Called every time the window is resized.
func _on_Stage_resized():
  common_data.window_size = get_viewport_rect().size
  print(common_data.window_size)


extends Control

var squad_names := []
var active_squad_name := ""
var active_squad_id := -1
var active_squad : Squad

var properties := {
  "neighbour_dist":
    { "value": 0,		# Actor attracted to neighbours within this distance.
      "units": "px"},
  "desired_seperation":
    { "value": 0,	# Actor repelled from any neighbour closer than this.
      "units": "px"},
  "seperation":
    { "value": 0,			# How strongly repelled from neighbours.
      "units": "%"},
  "cohesion":
    { "value": 0,			# How strongly attracted to neighbours.
      "units": "%"},
  "follow":
    { "value": 0,				# TODO
      "units": "%"},
  "target":
    { "value": 0,				# How strongly attracted to Squad's tartget point.
      "units": "%"},
  "random":
    { "value": 0,				# How much random jitter to apply.
      "units": "%"},
  "edge_avoid":
    { "value": 0,			# How strongly to be repelled from window edges.
      "units": "%"},
  "speed":
    { "value": 0,     # Squad target speed
      "units": "px"}
}

# Called when the node enters the scene tree for the first time.
func _ready():
  if common_data.squads.size() == 0:
    # $Stage has not populated common_data yet.
    return

  for sn in common_data.squads:
    if active_squad_id < 0:
      active_squad_name = sn
      active_squad_id = 0
    squad_names.push_back(sn)
  _update_active_squad()
  
  var children = $MenuPopup/MarginContainer/VBoxContainer/Sliders.get_children()
  for child_node in children:
    _update_slider(child_node, true)
    
func _update_slider(container : Node, reverse=false):
  var label = container.get_node("LabelContainer/Label")
  var slider = container.get_node("SliderContainer/HSlider")
  var value = container.get_node("ValueContainer/Value")
  
  label.text = container.name
  
  for key in properties:
    var property = properties[key]
    var property_name = key.replace("_", "").to_lower()
    if property_name == container.name.to_lower():
      if reverse:
        property.value = common_data.squads[active_squad_name].config[key]
      else:
        common_data.squads[active_squad_name].config[key] = property.value
      
      slider.value = property.value
      value.text = "%s%s" % [property.value, property.units]
      if property.units == "px":
        slider.max_value = 500      

func _on_DesiredSeperation_HSlider_value_changed(value):
  properties["desired_seperation"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/DesiredSeperation)

func _on_NeighbourDist_HSlider_value_changed(value):
  properties["neighbour_dist"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/NeighbourDist)

func _on_Seperation_HSlider_value_changed(value):
  properties["seperation"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Seperation)

func _on_Cohesion_HSlider_value_changed(value):
  properties["cohesion"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Cohesion)
  
func _on_Follow_HSlider_value_changed(value):
  properties["follow"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Follow)

func _on_Target_HSlider_value_changed(value):
  properties["target"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Target)

func _on_Random_HSlider_value_changed(value):
  properties["random"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Random)

func _on_EdgeAvoid_HSlider_value_changed(value):
  properties["edge_avoid"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/EdgeAvoid)

func _on_Speed_HSlider_value_changed(value):
  properties["speed"].value = value
  _update_slider($MenuPopup/MarginContainer/VBoxContainer/Sliders/Speed)

func _on_ButtonMenuPopupEnable_pressed():
  $MenuPopup.popup()

func _on_ButtonMenuPopupDisable_pressed():
  $MenuPopup.hide()

func _update_active_squad():
    active_squad_name = squad_names[active_squad_id]
    active_squad = common_data.squads[active_squad_name]
    
    $MenuPopup/MarginContainer/VBoxContainer/SquadPicker/Label.text = active_squad.name
    $MenuPopup/MarginContainer/VBoxContainer/SquadPicker/SquadPrevious.disabled = false
    $MenuPopup/MarginContainer/VBoxContainer/SquadPicker/SquadNext.disabled = false
    if active_squad_id <= 0:
      $MenuPopup/MarginContainer/VBoxContainer/SquadPicker/SquadPrevious.disabled = true
    elif active_squad_id >= common_data.squads.size() -1:
      $MenuPopup/MarginContainer/VBoxContainer/SquadPicker/SquadNext.disabled = true

func _on_SquadPrevious_pressed():
  if active_squad_id > 0:
    active_squad_id -= 1
    _update_active_squad()

func _on_SquadNext_pressed():
  if active_squad_id < squad_names.size() -1:
    active_squad_id += 1
    _update_active_squad()

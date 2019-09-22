extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_MenuPopupEnable_pressed():
	$MenuPopup.popup()

func _on_MenuPopupDisable_pressed():
	$MenuPopup.hide()

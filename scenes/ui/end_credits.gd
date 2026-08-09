extends Control

@onready var credits_label: Label = $MarginContainer/VBoxContainer/CreditsText
@onready var return_button: Button = $MarginContainer/VBoxContainer/ReturnButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if return_button:
		return_button.hide()
		
	# Start scrolling animation
	var tween = create_tween()
	tween.tween_property(credits_label, "position:y", -200.0, 12.0).from(400.0)
	tween.finished.connect(_on_scroll_finished)

func _on_scroll_finished() -> void:
	if return_button:
		return_button.show()

func _on_return_button_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	if SceneTransition:
		SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

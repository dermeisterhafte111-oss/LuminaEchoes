extends CanvasLayer
class_name PauseMenu

@onready var panel: PanelContainer = $Control/PanelContainer

var is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if panel:
		panel.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_just_pressed("ui_cancel"): # ESC key
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	
	if is_paused:
		if panel: panel.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		if panel: panel.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	toggle_pause()

func _on_main_menu_pressed() -> void:
	if SoundManager: SoundManager.play_sfx_type("ui_click")
	get_tree().paused = false
	if SceneTransition:
		SceneTransition.change_scene("res://scenes/ui/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

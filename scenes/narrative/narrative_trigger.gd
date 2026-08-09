extends Area3D
class_name NarrativeTrigger

signal triggered(trigger_id: String)

@export var trigger_id: String = "event_01"
@export var trigger_once: bool = true
@export var speaker_name: String = "Lumina Echo"
@export_multiline var dialogue_text: String = "Willkommen in der Resonanz-Sternwarte... Das Licht schwindet."

var has_triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if has_triggered and trigger_once:
		return
		
	if body is PlayerController:
		has_triggered = true
		triggered.emit(trigger_id)
		
		# Interface with Dialogue UI if available
		var dialogue_ui = get_tree().root.find_child("DialogueBox", true, false)
		if dialogue_ui and dialogue_ui.has_method("show_line"):
			dialogue_ui.call("show_line", speaker_name, dialogue_text)

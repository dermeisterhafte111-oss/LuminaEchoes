extends Node3D
class_name MainLevel

@onready var player: PlayerController = $Player
@onready var dialogue_box: DialogueBox = $DialogueBox
@onready var perspective_puzzle: PerspectivePuzzle = $PerspectivePuzzle
@onready var hud: HUD = $HUD

func _ready() -> void:
	print("Lumina Echoes - Polished Level Loop Initialized.")
	
	if hud:
		hud.set_objective_text("Richte den Fluchtpunkt des Relikts mit der Kamera aus")
	
	if perspective_puzzle:
		perspective_puzzle.alignment_completed.connect(_on_puzzle_solved)

func _on_puzzle_solved() -> void:
	if SoundManager:
		SoundManager.play_sfx_type("puzzle_solved")
		
	if dialogue_box:
		dialogue_box.show_line(
			"Lumina Echo", 
			"Das Fragment ist ausgerichtet! Das Licht des Sterns kehrt vollständig zurück."
		)
		
	if hud:
		hud.set_objective_text("Sternen-Synthese abgeschlossen! Der Kern erwacht...")

	# Wait 3.5 seconds then transition to End Credits
	await get_tree().create_timer(3.5).timeout
	if SceneTransition:
		SceneTransition.change_scene("res://scenes/ui/end_credits.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/end_credits.tscn")

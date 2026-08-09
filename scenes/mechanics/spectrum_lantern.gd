extends Node3D
class_name SpectrumLantern

enum Spectrum { SPECTRUM_A, SPECTRUM_B }

signal spectrum_changed(current_spectrum: Spectrum)

@export var current_spectrum: Spectrum = Spectrum.SPECTRUM_A
@export var color_a: Color = Color(0.15, 0.65, 0.95, 1.0) # Cyan / Indigo (Present)
@export var color_b: Color = Color(0.95, 0.70, 0.25, 1.0) # Warm Amber / Gold (Echo)

@onready var light_node: OmniLight3D = $OmniLight3D

func _ready() -> void:
	# Register to lantern group
	add_to_group("spectrum_lanterns")
	_apply_spectrum_visuals()

func toggle_spectrum() -> void:
	if current_spectrum == Spectrum.SPECTRUM_A:
		current_spectrum = Spectrum.SPECTRUM_B
	else:
		current_spectrum = Spectrum.SPECTRUM_A
		
	_apply_spectrum_visuals()
	spectrum_changed.emit(current_spectrum)
	
	# Global event dispatch to all PhaseObjects in scene
	get_tree().call_group("phase_objects", "on_spectrum_changed", current_spectrum)

func _apply_spectrum_visuals() -> void:
	if light_node:
		var target_color = color_a if current_spectrum == Spectrum.SPECTRUM_A else color_b
		var tween = create_tween()
		tween.tween_property(light_node, "light_color", target_color, 0.3)

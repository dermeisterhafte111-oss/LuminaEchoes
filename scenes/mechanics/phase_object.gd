extends StaticBody3D
class_name PhaseObject

## Defines which spectrum state this object is active in
@export var active_spectrum: SpectrumLantern.Spectrum = SpectrumLantern.Spectrum.SPECTRUM_A
## If true, object is inverted (active when NOT in active_spectrum)
@export var invert_phase: bool = false
## Opacity when inactive (0.0 = completely invisible & non-collidable)
@export var inactive_alpha: float = 0.1

@onready var mesh_node: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var is_active: bool = true

func _ready() -> void:
	add_to_group("phase_objects")
	# Initialize state
	on_spectrum_changed(SpectrumLantern.Spectrum.SPECTRUM_A)

func on_spectrum_changed(new_spectrum: SpectrumLantern.Spectrum) -> void:
	var matches = (new_spectrum == active_spectrum)
	is_active = !matches if invert_phase else matches
	
	_update_state()

func _update_state() -> void:
	# Update collision
	if collision_shape:
		collision_shape.disabled = !is_active
		
	# Update visuals & materials
	if mesh_node:
		var tween = create_tween().set_parallel(true)
		var target_transparency = 0.0 if is_active else (1.0 - inactive_alpha)
		tween.tween_property(mesh_node, "transparency", target_transparency, 0.4)

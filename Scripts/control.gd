extends Spatial

var cast_ray : bool = false
var shiftHeld : bool = false
var rightClick : bool = false

var clickPosition : Vector2 = Vector2()
var ray_length : int = 1000


var m = SpatialMaterial.new()

# I want to click

func _ready() -> void:
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white

func _input(event: InputEvent) -> void:
	if event is InputEventMouse and Input.is_action_just_pressed("clickSelect"):
		clickPosition = event.position
		cast_ray = true
	
	if event is InputEventMouse and Input.is_action_just_pressed("rightClick"):
		rightClick = true
		cast_ray = true
	
	if Input.is_action_pressed("shift"):
		shiftHeld = true
	else:
		shiftHeld = false



func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("clickSelect") and not shiftHeld:
		for selected in get_tree().get_nodes_in_group("Selected"):
			selected.deselect()

func _physics_process(_delta: float) -> void:
	if cast_ray:
		var outcome = _cast_check_ray()
		if !rightClick:
			_check_selection(outcome)
		else:
			for selected in get_tree().get_nodes_in_group("Selected"):
				if selected.has_method("rightClick"):
					selected.rightClick(outcome.position)


# Cast a ray into 3D space
func _cast_check_ray() -> Dictionary:
	var camera = get_parent().get_node("cameraBall/Camera")
	var from = camera.project_ray_origin(clickPosition)
	var to = from + camera.project_ray_normal(clickPosition) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [self], 1)
	if result:
		draw_path([from, result.position])
	cast_ray = false
	return result

func _check_selection(result) -> void:
	if result:
		if result.collider.get_parent().has_method("select"):
			result.collider.get_parent().select()
		if result.collider.has_method("select"):
			result.collider.select()


func draw_path(path_array):
	var im = get_node("Draw")
	im.set_material_override(m)
	im.clear()
	im.begin(Mesh.PRIMITIVE_POINTS, null)
	im.add_vertex(path_array[0])
	im.add_vertex(path_array[path_array.size() - 1])
	im.end()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path_array:
		im.add_vertex(x)
	im.end()

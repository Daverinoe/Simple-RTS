extends KinematicBody

export(int, 0, 100) var scrollSpeed : int = 100 
export(int, 0, 100) var panSpeed : int = 100

var scrollDirection : Vector2 = Vector2()
var mouseScroll : Vector2 = Vector2()
var originalMousePosition : Vector2 = Vector2()
var originalCameraPosition : Vector3 = Vector3()
var mouseCameraMove : bool = false

export(float, 0, 500) var heightAboveTerrain : float = 50.0
export(float, 0, 10) var zoomSpeed : float = 1.0
var heightMax : float = 100.0
var heightMin : float = 10.0



func _physics_process(_delta: float) -> void:
	_get_scroll_direction()
	# We don't want to move on the y-axis with scroll movement.
	# Instead y-position will be handle by a raycast, so that the camera
	# follows topology.
	_set_height()
	
	# Do middle-mouse button movement first, for reasons?
	# This happens once 'move_map' is pressed
	# Middle mouse movement is broken until I can test for collisions through code
	if Input.is_action_just_pressed("scrollMouseMiddleButton"):
		var ref = get_viewport().get_mouse_position()
		originalMousePosition = ref
		originalCameraPosition = transform.origin
		mouseCameraMove = true
	elif Input.is_action_just_released("scrollMouseMiddleButton"):
		mouseCameraMove = false
	# This happens while 'move_map' is pressed
	if Input.is_action_pressed("scrollMouseMiddleButton"):
		_do_mouse_movement()
	
	if Input.is_action_just_released("mouseScrollDown"):
		_set_zoom(false)
	elif Input.is_action_just_released("mouseScrollUp"):
		_set_zoom(true)
	
	var linear_velocity = Vector3(scrollDirection.x, 0, scrollDirection.y) * scrollSpeed
	if !mouseCameraMove:
		linear_velocity = move_and_slide(linear_velocity, Vector3( 0, 1, 0 ), true, 1, 0.5, true)


func _set_zoom(zoomDirection: bool) -> void:
	if zoomDirection:
		#zoomIn
		var newHeight = heightAboveTerrain - zoomSpeed
		heightAboveTerrain = clamp(newHeight, heightMin, heightMax)
	else:
		#zoomOut
		var newHeight = heightAboveTerrain + zoomSpeed
		heightAboveTerrain = clamp(newHeight, heightMin, heightMax)


func _do_mouse_movement() -> void:
	var ref = get_viewport().get_mouse_position()
	transform.origin.x = originalCameraPosition.x + (originalMousePosition.x - ref.x)/80 * panSpeed
	transform.origin.z = originalCameraPosition.z + (originalMousePosition.y - ref.y)/80 * panSpeed


func _get_scroll_direction() -> void:
	# From the arrow keys, or whatever other keys they're attached to
	var LRStrength = Input.get_axis("scrollLeft", "scrollRight")
	var UDStrength = Input.get_axis("scrollUp", "scrollDown")
	scrollDirection = Vector2(LRStrength, UDStrength)
	# Since I'm overwriting scrollDirection every frame, I need to take into
	# account the mouse scrolling.
	scrollDirection += mouseScroll
	scrollDirection = scrollDirection.normalized()


func _set_height() -> void:
	# Probably don't need to force update, since we're checking before moving.
#	$RayCast.force_raycast_update()
	var rayCollisionPoint = $RayCast.get_collision_point()
	self.transform.origin.y = rayCollisionPoint.y + heightAboveTerrain


func _on_minimap_minimap_clicked(clickPosition) -> void:
	transform.origin.x = clickPosition.x
	transform.origin.z = clickPosition.y


# Should probably replace this with just a check through code, but this came
# to mind first.
func _on_top_mouse_entered() -> void:
	mouseScroll.y -= 1


func _on_top_mouse_exited() -> void:
	mouseScroll.y += 1


func _on_left_mouse_entered() -> void:
	mouseScroll.x -= 1


func _on_left_mouse_exited() -> void:
	mouseScroll.x += 1


func _on_bottom_mouse_entered() -> void:
	mouseScroll.y += 1


func _on_bottom_mouse_exited() -> void:
	mouseScroll.y -= 1


func _on_right_mouse_entered() -> void:
	mouseScroll.x += 1


func _on_right_mouse_exited() -> void:
	mouseScroll.x -= 1


func _on_topLeft_mouse_entered() -> void:
	mouseScroll += Vector2(-1, -1)


func _on_topLeft_mouse_exited() -> void:
	mouseScroll -= Vector2(-1, -1)


func _on_topRight_mouse_entered() -> void:
	mouseScroll += Vector2(1, -1)


func _on_topRight_mouse_exited() -> void:
	mouseScroll -= Vector2(1, -1)


func _on_bottomLeft_mouse_entered() -> void:
	mouseScroll += Vector2(1, 1)


func _on_bottomLeft_mouse_exited() -> void:
	mouseScroll -= Vector2(1, 1)


func _on_bottomRight_mouse_entered() -> void:
	mouseScroll += Vector2(-1, 1)


func _on_bottomRight_mouse_exited() -> void:
	mouseScroll -= Vector2(-1, 1)



extends KinematicBody2D

#vec2 of mouse position (assigned at handle_attack_rotation())
var mouseGlobalPosition

#Vector of input direction
var moveDir = Vector2()
#Current speed vector
var currentSpeed = Vector2()

#max speed player can reach
export var moveSpeed = 250
#acceleration of moving speed
export var acceleration = 100

#DEBUG STUFF=========================================================
func _ready():
	# Center window on screen
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
#====================================================================

func _physics_process(delta):
	handle_input()
	moving(delta)
	handle_attack()


func _on_damageZone_body_entered(body):
	print("PASS")

func handle_attack():
	mouseGlobalPosition = get_global_mouse_position()
	$damageZone.look_at(mouseGlobalPosition)
	if Input.is_action_just_pressed("attack_key"):
		$damageZone/attackAnim.show()
		$damageZone/attackAnim.playing = true
		
	
	
#basically creates vec2 of moving direction
func handle_input():
	moveDir = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		moveDir.y -= 1
	if Input.is_action_pressed("move_down"):
		moveDir.y += 1
	if Input.is_action_pressed("move_left"):
		moveDir.x -= 1
	if Input.is_action_pressed("move_right"):
		moveDir.x += 1

#moving the player
func moving(time):
	currentSpeed.x = lerp(currentSpeed.x, moveSpeed * moveDir.x, acceleration * time)
	currentSpeed.y = lerp(currentSpeed.y, moveSpeed * moveDir.y, acceleration * time)
	
	currentSpeed = move_and_slide(currentSpeed,Vector2(0,-1))



func _on_attackAnim_animation_finished():
	$damageZone/attackAnim.playing = false
	$damageZone/attackAnim.hide()

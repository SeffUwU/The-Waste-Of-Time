extends KinematicBody2D


#Vector of input direction
var moveDir = Vector2()
#Current speed vector
var currentSpeed = Vector2()

#max speed player can reach
export var moveSpeed = 350
#acceleration of moving speed
export var acceleration = 100

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


func _physics_process(delta):
	handle_input()
	moving(delta)

extends KinematicBody2D

#vec2 of mouse position ( assigned at handle_attack_rotation() )
var mouseGlobalPosition

#Vector of input direction
var moveDir = Vector2()
#Current speed vector
var currentSpeed = Vector2()
#Remaining time (AKA Health.) in seconds
var chrono = 120
var canDisplayChrono = true
#is the player dead?
var isDead = false
#max speed player can reach
export var moveSpeed = 300
#acceleration of moving speed
export var acceleration = 20



func _ready():
	$Timers/timeDepleting.start(1)
	
#DEBUG STUFF====================================================================
	# Center window on screen
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
#===============================================================================



#ATTACK ANIMATION ==============================================================
func handle_attack_rotation():
	if isDead == false:
		mouseGlobalPosition = get_global_mouse_position()
		$damageZone.look_at(mouseGlobalPosition)
		if Input.is_action_just_pressed("attack_key"):
			$damageZone/attackAnim.show()
			$damageZone/attackAnim.playing = true
# hide attack animation if the animation is finished
func _on_attackAnim_animation_finished():
		$damageZone/attackAnim.hide()
#===============================================================================
	
# vec2 of moving direction
func handle_input():
	moveDir = Vector2.ZERO
	if isDead == false:
		if Input.is_action_pressed("move_up"):
			moveDir.y -= 1
		if Input.is_action_pressed("move_down"):
			moveDir.y += 1
		if Input.is_action_pressed("move_left"):
			moveDir.x -= 1
		if Input.is_action_pressed("move_right"):
			moveDir.x += 1

# rotates sprite in a moving direction
func handle_animations():
	if moveDir.y < 0:
		$AnimatedSprite.set_rotation_degrees(0)
	if moveDir.y > 0:
		$AnimatedSprite.set_rotation_degrees(-180)
	if moveDir.x < 0:
		$AnimatedSprite.set_rotation_degrees(270)
	if moveDir.x > 0:
		$AnimatedSprite.set_rotation_degrees(-270)
	if moveDir.y < 0 and moveDir.x < 0:
		$AnimatedSprite.set_rotation_degrees(-45)
	if moveDir.y < 0 and moveDir.x > 0:
		$AnimatedSprite.set_rotation_degrees(45)
	if moveDir.y > 0 and moveDir.x < 0:
		$AnimatedSprite.set_rotation_degrees(-135)
	if moveDir.y > 0 and moveDir.x > 0:
		$AnimatedSprite.set_rotation_degrees(135)

# moving the player
func moving(time):
	currentSpeed.x = lerp(currentSpeed.x, moveSpeed * moveDir.x, acceleration * time)
	currentSpeed.y = lerp(currentSpeed.y, moveSpeed * moveDir.y, acceleration * time)
	
	currentSpeed = move_and_slide(currentSpeed,Vector2(0,-1))


# handle Chrono (health) and death  ==============================================
func manageChrono(amount):
	chrono += amount
	
	canDisplayChrono = false
	if amount < 0:
		$UI/RichTextLabel.bbcode_text = "[center] [shake rate=14 level=12]" + "[color=#F71414]" + $UI/RichTextLabel.text + "[/color]" + "[/shake] [/center]"
	else:
		$UI/RichTextLabel.bbcode_text = "[center] [shake rate=8 level=12]" + "[color=#81FD77]" + $UI/RichTextLabel.text + "[/color]" + "[/shake] [/center]"
	yield(get_tree().create_timer(0.2), "timeout")
	canDisplayChrono = true
	$UI/RichTextLabel.bbcode_text = ""
	
	
	
func displayChrono():
	if canDisplayChrono == true:
		var minutes
		var seconds
		minutes = chrono / 60
		seconds = chrono - (60 * minutes)
		if seconds == 0:
			$UI/RichTextLabel.bbcode_text = "[center]" + "0" + minutes as String + ":00" + "[/center]"
		elif seconds < 10:
			$UI/RichTextLabel.bbcode_text = "[center]" + "0" + minutes as String + ":0" + seconds as String + "[/center]"
		else:
			$UI/RichTextLabel.bbcode_text = "[center]" + "0" + minutes as String + ":" + seconds as String + "[/center]"
		if minutes > 9:
			$UI/RichTextLabel.bbcode_text[8] = ""
		if minutes < 0 or seconds < 0:
			$UI/RichTextLabel.bbcode_text = "[center] [color=#F71414] TIME OUT [/color] [/center]"  
			
		if minutes > 59:
			$UI/RichTextLabel.bbcode_text = "[center] [shake rate=10 level=12] TOO MUCH [/shake] [/center]"
func _on_timeDepleting_timeout():
	chrono -= 1


	

func handlePlayerDead():
	if chrono <= 0:
		isDead = true
		$AnimatedSprite.stop()
		$AnimatedSprite2.stop()
# ==============================================================================

# main func ####################################################################
func _process(delta):
	handle_input()
	moving(delta)
	handle_attack_rotation()
	handle_animations()
	displayChrono()
	handlePlayerDead()
################################################################################




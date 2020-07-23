extends KinematicBody2D

#player node variable
onready var Player = get_tree().get_nodes_in_group("Player")[0]
#direction to player or target
var targetDir = Vector2()

#is this enemy too close to player?
var imTooClose = false
#is player in my radius?
var canSeePlayer = false
#am in range of player's attack?a
var canBeHurt = false
#my current health
var health = 3
#am i dead?
var isDead = false
#my maximum moving speed
export var moveSpeed = 140
#my current speed vector
var currentSpeed = Vector2()



#main func everythins is being processed here ##################################
func _physics_process(delta):
	#moving
	if Player != null and imTooClose == false and canSeePlayer == true and isDead == false:
		targetDir.x = Player.position.x - self.position.x
		targetDir.y = Player.position.y - self.position.y
		currentSpeed = move_and_slide(moveSpeed * targetDir * delta,Vector2(0,-1))
	
	handleBeingHurt(delta)
################################################################################

#handles damage and death (sets it queue free on death)
func handleBeingHurt(time):
	#decrease health by 1 each time player attacks
	if canBeHurt == true and Input.is_action_just_pressed("attack_key") and isDead == false and Player.isDead == false:
		health -= 1
		#set the color of this enemy red if being hit
		$Sprite.modulate = Color8(120,0,0)
		#wait
		yield(get_tree().create_timer(0.08), "timeout")
		#set the color back
		$Sprite.modulate = Color8(255,255,255)
		#emit dmg particles
		$dmgParticles.set_emitting(true)
		
		#change animated sprite frame to display health
		$AnimatedSprite.set_frame(health)
		
	#queue free this node if health <= 0
	if health <= 0:
		isDead = true
		$Sprite.rotate(deg2rad(900) * time)
		$Sprite.modulate = Color8(120,0,0,120)
		deleteThisInstance(0.45)
		
func deleteThisInstance(waitTime):
	var timer = Timer.new()
	timer.connect("timeout", self, "deathTimerTimeout")
	timer.set_wait_time(waitTime)
	self.add_child(timer)
	timer.start()
func deathTimerTimeout():
	Player.manageChrono(30)
	queue_free()
	
#Node signals below ############################################################

func _on_TargetZone_body_entered(body):
	if body.name == "Player":
		canSeePlayer = true


func _on_TargetZone_body_exited(body):
	if body.name == "Player":
		canSeePlayer = false
		$tooClose/AttackTimer.stop()

#Handling attacking the player
func _on_tooClose_body_entered(body):
	var counter = 0
	if body.name == "Player":
		imTooClose = true
		$tooClose/AttackTimer.start(0.5)
		$ChargeAttackSprite.show()
		$ChargeAttackSprite.playing = true

func _on_ChargeAttackSprite_animation_finished():
	if imTooClose == true and Player.isDead == false:
		$ChargeAttackSprite.set_frame(0)
		$ChargeAttackSprite.play("default")
	
func _on_AttackTimer_timeout():
	if Player.chrono > 0:
		Player.manageChrono(-30)
	
	


func _on_tooClose_body_exited(body):
	if body.name == "Player":
		imTooClose = false
	$ChargeAttackSprite.hide()
	$ChargeAttackSprite.playing = false
	$ChargeAttackSprite.set_frame(0)
	$tooClose/AttackTimer.stop()

func _on_hitBoxArea_area_entered(area):
	if area.name == "damageZone":
		canBeHurt = true
func _on_hitBoxArea_area_exited(area):
	if area.name == "damageZone":
		canBeHurt = false

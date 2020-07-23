extends Control

var paused = false
#Pause Menu=====================================================================
func _input(event):
	if event.is_action_pressed("ui_cancel") and get_tree().paused == false:
		get_tree().paused = true
		paused = true
		$PauseUI.show()
	elif event.is_action_pressed("ui_cancel") and get_tree().paused == true:
		get_tree().paused = false
		paused = false
		$PauseUI.hide()
func _on_Button_pressed():
	get_tree().paused = false
	paused = false
	$PauseUI.hide()
#===============================================================================




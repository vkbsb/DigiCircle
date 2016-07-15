
extends CanvasLayer

signal new_game_clicked
signal restart_game_clicked
# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func show_game_over(score):
	get_node("Panel/GameOver/score").set_text(str(score))
	get_node("Panel/MainMenu").hide()
	get_node("Panel").show()
	get_node("Panel/GameOver").show()
	pass
	
func hide_menu():
	get_node("Panel").hide()
	pass
	
func _on_TextureButton_pressed():
	emit_signal("new_game_clicked")
	pass # replace with function body
	

func _on_TextureButton1_pressed():
	emit_signal("restart_game_clicked")
	pass # replace with function body

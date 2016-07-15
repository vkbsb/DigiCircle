
extends Sprite

# member variables here, example:
# var a=2
# var b="textvar"
export(int) var num = 1
export(ColorArray) var colors
var col = Color(1, 0, 0, 1)
signal move_completed
var numNode;
var starNode;
var tween;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	numNode = get_node("./number")
	starNode = get_node("./star")
	tween = get_node("Tween")
	set_number(3)
	
func set_number(number):
	num = number
	if(num >= 10):
		numNode.hide()
		starNode.show()
		starNode.set_scale(Vector2(0, 0))
		appear_anim(starNode)
	numNode.set_text(str(number))
	set_modulate(colors[number % colors.size()])
	#TODO: write code for changing the color based on number set.
	
func appear_anim(obj = null):
	var target = self
	if obj:
		target = obj
	tween.interpolate_property(target, "transform/scale", Vector2(0, 0), Vector2(1, 1), 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	
func move_to(target_pos, duration=0.5, delay=0):
	tween.interpolate_property(self, "transform/pos", get_pos(), target_pos, duration, Tween.TRANS_EXPO, Tween.EASE_IN_OUT, delay)
	tween.start()

func _on_Tween_tween_complete( object, key ):
	if key == "transform/scale":
		return
	emit_signal("move_completed", object)
	pass # replace with function body

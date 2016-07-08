
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var nodes = Array()
var connected
var numbers = IntArray()
var moving_nodes = Array()
var active_node
var active_node_scene
var active_circle
var disable_input = false

export(int) var BallImgSize = 256
var radius

func _ready():
	var size = get_viewport_rect().size
	set_pos(Vector2(size.width/2, size.height/2))
	# Called every time the node is added to the scene.
	# Initialization here
	active_node_scene = load("res://ball/scene.tscn")
	active_circle = get_node("./activeCircle")
	_add_active_node()
	
	for i in range(0,16):
		nodes.push_back(get_node("activeCircle/" + str(i+1)))
		numbers.push_back(0)
		moving_nodes.push_back(null)
	
	print(nodes.size())
	set_process_input(true)
	
	radius = 256 * nodes[0].get_scale().x * 0.5
	
	#add a new node once the merges are done.
	#connect("merges_done", self, "_add_active_node")
	
func _add_active_node():
	randomize()
	active_node = active_node_scene.instance()
	active_node.set_pos(Vector2(0, 0))
	active_node.set_scale(Vector2(0, 0))
	active_circle.add_child(active_node)
	active_node.set_number(1+randi() % 5)
	active_node.appear_anim()
	active_node.connect("move_completed", self, "user_move_done")

func _handle_merges(cur_index):
	#merge the nodes that can be combined.
	connected = IntArray()
	connected.push_back(cur_index)
	
	var left = cur_index-1
	var right = cur_index+1
	
	#move the left pointer till we find a miss match.
	while (true):
		if(left < 0):
			left = numbers.size()-1
		if(numbers[left] == numbers[cur_index]):
			connected.push_back(left)
			left -= 1
		else:
			break
	#move the right pointer till we find a missmatch.
	while(true):
		right %= numbers.size()			
		if( numbers[right] == numbers[cur_index] ):
			connected.push_back(right)
			right += 1
		else:
			break
	
	print(connected)
	print(numbers)
	
func merge_done(node):
	if node:
		node.disconnect("move_completed", self, "merge_done")
		node.set_number(node.num + 1)
	_add_active_node()
	disable_input = false
	
func user_move_done(node):
	print("user_move_done")
	#disconnect the movement callback on this node.
	node.disconnect("move_completed", self, "user_move_done")
	var loc = nodes[connected[0]].get_pos()
	#there is only one node.. just add a new node.
	if connected.size() == 1:
		merge_done(null)
		return
	#call animation for the merging.
	for i in range(0, connected.size()):
		var node = moving_nodes[connected[i]]
		var indx = connected[i]
		if i == 0:
			print("Connecting for merge_done")
			node.connect("move_completed", self, "merge_done")
			numbers[indx] = node.num + 1
		else:
			numbers[indx] = 0
			node.connect("move_completed", active_circle, "remove_child")
		node.move_to(loc, 0.25)
	print(numbers)
	
func _check_node_move():
	for i in range(0, 16):
		var node = nodes[i]
		var localPos = node.get_local_mouse_pos()
		if(localPos.length() < radius):
			if numbers[i] == 0: #the clicked node is empty.
				disable_input = true
				#move active ball to target location.
				active_node.move_to(node.get_pos())
				numbers[i] = active_node.num
				moving_nodes[i] = active_node
				print(i, numbers[i], active_node.num)
				#Check if there are any merges possible.
				_handle_merges(i)
	
func _input(event):
	if not(disable_input) and event.is_action_released("ui_accept"):
		_check_node_move()
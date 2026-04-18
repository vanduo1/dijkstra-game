extends Node2D

@onready var tilemap: TileMap = $map
@onready var line2D: Line2D = $Line2D
@onready var player: CharacterBody2D = $Player
@onready var game_timer: Timer = $GameTimer/Timer
@onready var start_sprite: AnimatedSprite2D = $Start
@onready var end_sprite: AnimatedSprite2D = $End
@onready var timer_light: Timer = $LightTimer/TimerLight
@onready var number4: AnimatedSprite2D = $TrafficLightCost/number4
@onready var number7: AnimatedSprite2D = $TrafficLightCost/number7
@onready var number2: AnimatedSprite2D = $TrafficLightCost/number2
@onready var number0: AnimatedSprite2D = $TrafficLightCost/number0
@onready var winEffect = $"Win/Cute-level-up-3-189853"
@onready var ticktock = $"LightTimer/Mixkit-tick-tock-clock-timer-1045"



var arr_movable: Array
var oo = INF
var path: Array
var parent_child: Array
var start_arr:Array
var end_arr:Array
var traffic_light_cost = [2, 4, 7]
var total_time = 0.0
var light_wait: Array
var end_idx
var traffic_lights_labels: Array


#----------------------#
#        ready         #
#______________________#
func _ready() -> void:
	#-------------not paused by default------------#
	get_tree().paused = true
	
	#-------------initialize------------#
	find_start_arr()
	find_end_arr()
	print(end_arr)
	traffic_lights_labels = get_tree().get_nodes_in_group("Traffic Lights")
	
	var start = find_start_position()
	var end = find_end_position()
	end_idx = end_arr.find(end)
	player.position = tilemap.map_to_local(start)
	find_movable_node(start, end)
	find_shortest_path(start, end)
	
	
	##_________set start sprite_________#
	#start_sprite.position = tilemap.map_to_local(start + Vector2(0,-6))
	
	#----------set end sprite----------#
	end_sprite.position = tilemap.map_to_local(end + Vector2i(0,-4))
	
	
	#-------------path------------#
	path.append(end)
	var node = end
	var flat = true
	while flat:
		var parent_idx = find_parent_of_node(parent_child,node) 
		var parent = parent_child[parent_idx][0]
		if parent == Vector2(-1,-1):
			flat = false
			continue
		path.append(parent)
		node = parent
	
	path.reverse()
	print(path)	
	
	var end_idx = find_node(arr_movable,end)
	print("---END------", arr_movable[end_idx], "---------")
	
	#-------------total time------------#
	var index_end = find_node(arr_movable, end)
	#0_node, 1_pi, 2_visited
	total_time = arr_movable[index_end][1] 
	
	print("Total time: ", total_time, "s")
	
	game_timer.wait_time = ceil(total_time + 5)
	
	game_timer.start()
	
	print(ceil(total_time + 5))
	
	#-------------add labels-------------#
	add_labels_to_lights()



#-----------------------#
#        process        #
#_______________________#
var enable = true
func _process(delta: float) -> void:
	
	var player_pos = Vector2(tilemap.local_to_map(player.position))
	
	#----------win game------------#
	if player_pos == Vector2(end_arr[end_idx]):
		winEffect.play()
		$Win.show()
		get_tree().paused = true
		$Win.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	#-------check player reaches traffic light-------#
	if timer_light.time_left < 1:
		ticktock.stop()
		timer_light.stop()
		get_node("LightTimer").call("hide_timer", false)
		get_node("Player").call("move", true)
		enable = true
			
			
	if(enable):
		var is_traffic_light = false
		var idx = find_light_must_wait(player_pos)
		if idx != -1:
			is_traffic_light = true
			timer_light.wait_time = light_wait[idx][1]

		if is_traffic_light:
			get_node("LightTimer").call("show_timer", true)
			timer_light.start()
			

		if  timer_light.time_left < timer_light.wait_time && timer_light.time_left >= 1:
			get_node("Player").call("move", false)
			enable = false	
			ticktock.play()
	else:
		pass


#--------------------------#
#       draw hint line     #
#__________________________#
func _input(event: InputEvent) -> void:
	#----------show help----------#
	if event.is_action_pressed("Help"):
		var tile_pos = tilemap.local_to_map(get_global_mouse_position())
		var pixel_points = []	
		for point in path:	
			pixel_points.append(tilemap.map_to_local(point))
		line2D.points = pixel_points


#-------------------------------#
#  add labels to traffic lights #
#_______________________________#
func add_labels_to_lights():
	for light in light_wait:
		var light_label: AnimatedSprite2D
		match light[1]:
			4:
				light_label = number4.duplicate()	
			7:
				light_label = number7.duplicate()
			2:
				light_label = number2.duplicate()
			0.2: 
				light_label = number0.duplicate()
		add_child(light_label)
		light_label.position = Vector2i(tilemap.map_to_local(light[0] + Vector2(-1, -2)))

#---------------------------------------#
#  find position of traffic light labels #
#_______________________________________#
#func find_traffic_light_labels():
	#var labels = get_tree().get_nodes_in_group("Traffic Lights")
	#
	#for label in labels:
		#var label_pos = label.position
		#traffic_lights_labels.append(label_pos)


#---------------------------------------#
#  get parent of a node in parent_child #
#_______________________________________#
func find_parent_of_node(parent_child: Array, node: Vector2):
	for e in parent_child:
		if e[1] == node:
			return parent_child.find(e)
	return -1;



#-----------------------------------#
#  get positions of all start nodes #
#___________________________________#
func find_start_arr():
	for x in range(tilemap.get_used_rect().size.x):
		for y in range(tilemap.get_used_rect().size.y):
			var tile_pos = Vector2(x, y)
			#print(tile_pos)
			var tile_data = tilemap.get_cell_tile_data(0, tile_pos)
			#print(tile_data)
			var data = tile_data.get_custom_data("start_end")
			#print("Vị trí bắt đầu: ", data)
			if data == "start":
				start_arr.append(tile_pos)	


#---------------------------------#
#  get positions of all end nodes #
#_________________________________#
func find_end_arr():
	var customers = get_tree().get_nodes_in_group("Customers")
	#var map = get_node("map")
	#var child_node_arr = map.get_children()	
	print(customers)
	for cus in customers:
		var customer_pos = tilemap.local_to_map(cus.position)	
		end_arr.append(customer_pos)



#-----------------------------------------#
#  get a random start node from start_arr #
#_________________________________________#
func find_start_position():
	var start_pos
	start_pos = start_arr[randi() % start_arr.size()]
	print("Start: ", start_pos)
	return start_pos


#-------------------------------------#
#  get a random end node from end_arr #
#_____________________________________#
func find_end_position():
	var end_pos
	end_pos = end_arr[randi() % end_arr.size()]
	print("End: ", end_pos)
	return end_pos


#---------------------------------------#
#  get all of movable nodes in the map  #
#_______________________________________#
func find_movable_node(start: Vector2, end: Vector2):
	# array = { (node, pi, visited), (), ... }
	
	for y in range(tilemap.get_used_rect().size.y):
		for x in range(tilemap.get_used_rect().size.x):
			var tile_pos = Vector2(x, y)
			#print(tile_pos)
			var tile_data = tilemap.get_cell_tile_data(0, tile_pos)
			#print(tile_data)
			var data = tile_data.get_custom_data("movable")
			var data1 = tile_data.get_custom_data("start_end")
			if data == "road" || data == "traffic_light" || data1 == "start":
				#print("movable: ", tile_pos)
				#node
				var node_pi_visited: Array
				node_pi_visited.append(tile_pos)
				#pi
				node_pi_visited.append(oo)
				#visited
				node_pi_visited.append(0)
				
				arr_movable.append(node_pi_visited)
	
	#for e in arr_movable:
		#print(e)			
	
	
#---------------------------#
#  get neighbours of a node #
#___________________________#	
func find_neighbours(vertical: Vector2) -> Array:
	var neighbours = []
	# Up, Down, Right, Left (x,y)
	var directions = [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)] 
	for d in directions:
		var neighbour_pos = vertical + d
		var tile_data = tilemap.get_cell_tile_data(0, neighbour_pos)
		var data = tile_data.get_custom_data("movable")
		var data1 = tile_data.get_custom_data("start_end")
		if data == "road" || data == "traffic_light" || data1 == "start" || data1 == "end":
			neighbours.push_back(neighbour_pos)
	return neighbours
	
	
#---------------------------------------------#
#  get index of the array containing the node #
#_____________________________________________#	
func find_node(matrix: Array, node: Vector2) -> int:
	for row in range(matrix.size()):
		var arr: Array = matrix[row] 
		# array = { (node, pi, visited), (), ... }
		var n:Vector2 = arr[0]
		if n == node:
			#index
			return row  
	return -1
	
	
#--------------------------------------------#
#  find index of traffic light in light_wait #
#____________________________________________#
func find_light_must_wait(light):
	for l in range(light_wait.size()):
		if light == light_wait[l][0]:
			return l
	return -1
	

#-------------------------#
#  find the shortest path #
#_________________________#
func find_shortest_path(start: Vector2, end: Vector2):
	#find index of array of 'start' in array 'arr_movable'
	var index_start = find_node(arr_movable, start)
	#array = {(node, pi, visited)}
	#pi=0
	arr_movable[index_start][1] = 0

	#parent_child = {(start,-1)}
	var par_ch_temp: Array
	par_ch_temp.append(Vector2(-1,-1))
	par_ch_temp.append(start)
	parent_child.append(par_ch_temp)
	
	var u = Vector2.ZERO
	var temp_node: Array
	
	for e in range(arr_movable.size()-1):
		#var st = e[0]
		#if st == start:
			#continue
		var min_pi = INF
		
		
		#find min_pi
		for e1 in arr_movable:
			var node = e1[0]
			var pi = e1[1]
			var visited = e1[2]
			if min_pi > pi && visited == 0:
				min_pi = pi
				u = node
				temp_node = e1
		#node of min_pi
		#var index = find_node(arr_movable,u)
		#print(index)
		
		
		
		#var min_pi_node = temp_node[0]
		var index = arr_movable.find(temp_node)
		
		#visited min_pi_node
		arr_movable[index][2] = 1;
		
		#visit neighbours of min_pi node
		var neighbours = find_neighbours(u)
		
		for nei in neighbours:
			var idx = find_node(arr_movable, nei)			
			var pi = arr_movable[idx][1]
			var visited = arr_movable[idx][2]
			
			#velocity = 320px/s  , 1 tile = 16px
			#cost = time per tile
			var cost = 0.2
			
			#check traffic_light
			var tile_data = tilemap.get_cell_tile_data(0, nei)
			var data = tile_data.get_custom_data("movable")
			if data == "traffic_light":
				var light_idx = find_light_must_wait(nei) 
				if light_idx == -1: 
					var wait = randi_range(1,4)
					print(wait)
					if wait != 1:
						cost = traffic_light_cost[randi() % traffic_light_cost.size()]
						print(nei, cost)					
					else:
						cost = 0.2
					var l_w: Array
					l_w.append(nei) #position
					l_w.append(cost)
					light_wait.append(l_w)	
				else:
					cost = light_wait[light_idx][1]
					print("stored_light_cost", cost)
			if visited == 0:
				if min_pi + cost < pi:
					arr_movable[idx][1] = min_pi + cost;
					#--------update parent------#
					var idx_child = find_parent_of_node(parent_child,nei)
					var p_ch: Array
					p_ch.append(u)
					p_ch.append(nei)
					if(idx_child != -1):
						parent_child[idx_child] = p_ch
					else: 
						parent_child.append(p_ch)

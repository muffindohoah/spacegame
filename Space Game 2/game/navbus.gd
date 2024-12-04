extends Node

var astar = AStar2D.new()
var point_directory = {}

func add_node_to_nav(node: Node2D):
	var id = point_directory.size()
	point_directory[id] = node
	astar.add_point(id, node.global_position, 1)

func remove_node(node):
	astar.remove_point(get_id_from_node(node))

func disconnect_nodes(nodea, nodeb):
	astar.disconnect_points(get_id_from_node(nodea), get_id_from_node(nodeb))

func connect_nodes(nodea, nodeb):
	
	is_in_nav(nodea)
	is_in_nav(nodeb)
	
	astar.connect_points(get_id_from_node(nodea), get_id_from_node(nodeb))

func get_givers():
	var givers = []
	for i in point_directory.values():
		if i.is_in_group("giver"):
			givers.append(i)
	return givers

func get_takers():
	var takers = []
	for i in point_directory.values():
		if point_directory[i].is_in_group("taker"):
			takers.append(point_directory[i])
	return takers

func get_node_path(nodefrom, nodeto):
	var node_path = ids_to_nodes(astar.get_id_path(get_id_from_node(nodefrom), get_id_from_node(nodeto)))
	return node_path

func get_closest_node(nodefrom, nodearray):
	var fit_node = nodearray[0]
	
	for i in nodearray.size():
		var node = nodearray[i]
		
		if !can_node_reach(nodefrom, node):
			continue
		
		if get_cost_of_path(get_id_from_node(nodefrom), get_id_from_node(fit_node)) < get_cost_of_path(get_id_from_node(nodefrom), get_id_from_node(node)):
			fit_node = node
	
	return fit_node

func get_cost_of_path(idfrom, idto):
	
	is_in_nav(point_directory[idfrom])
	is_in_nav(point_directory[idto])
	
	
	var path = astar.get_id_path(idfrom, idto)
	var path_cost = 0
	
	for i in path.size():
		path_cost += astar.get_point_weight_scale(path[i])
	
	return path_cost

func can_node_reach(nodefrom, nodeto):
	var result: bool
	if get_node_path(nodefrom, nodeto) == []:
		result = false
	else:
		result = true
	print(nodefrom, nodeto, result, get_node_path(nodefrom, nodeto))
	return result

func get_id_from_node(node):
	
	var id = point_directory.find_key(node)
	return id

func ids_to_nodes(idarray):
	var node_array = []
	for i in idarray.size():
		node_array.append(point_directory[idarray[i]])
	return node_array

func is_in_nav(node):
	if get_id_from_node(node) == null:
		print(node)
		add_node_to_nav(node)

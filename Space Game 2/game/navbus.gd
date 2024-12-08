extends Node

var astar = AStar2D.new()
var point_directory = {}


func add_node_to_nav(node: Node2D):
	
	if point_directory.values().has(node):
		return
	
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

	var connections = astar.get_point_connections(get_id_from_node(nodea))
	if connections.size() > 0:
		pass
	else:
		print("No connections found for", nodea)


func get_givers():
	var givers = []
	for i in point_directory.values():
		if i == null:
			continue
		
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
	
	if nodefrom == null:
		return
	if nodeto == null:
		return

	var node_path = ids_to_nodes(astar.get_id_path(get_id_from_node(nodefrom), get_id_from_node(nodeto)))
	return node_path

func get_closest_node(nodefrom, nodearray):
	var fit_node = nodearray[0]
	var reachable_nodes = {}
	
	for i in range(nodearray.size()):
		var node = nodearray[i]
		
		if !can_node_reach(nodefrom, node):
			print(nodefrom, "cantreach", node)
			continue
		else:
			reachable_nodes[node] = get_cost_of_path(get_id_from_node(nodefrom), get_id_from_node(node))
		
	
	for i in range(reachable_nodes.size()):
		var node = reachable_nodes.keys()[i]
		fit_node = reachable_nodes.find_key(reachable_nodes.values().min())
	
	return fit_node

func get_cost_of_path(idfrom, idto):

	var path = astar.get_id_path(idfrom, idto)
	var path_cost = 0
	for i in range(path.size()):
		path_cost += astar.get_point_weight_scale(path[i])
	return path_cost

func can_node_reach(nodefrom, nodeto):
	var result = false
	var path = []
	
	if nodefrom != null and nodeto != null:
		
		path = get_node_path(nodefrom, nodeto)
		if path.size() > 0:
			result = true
	else:
		print(nodefrom, "cantreach",nodeto)
	return result

func get_nav_connections(node):
	var id = get_id_from_node(node)
	var connections = ids_to_nodes(astar.get_point_connections(id))
	return connections

func get_id_from_point(point:Vector2):
	return astar.get_closest_point(point)

func get_id_from_node(node):
	is_in_nav(node)
	var id = point_directory.values().find(node)
	if id == -1:
		print("Node not found in navigation:", node)
	return id

func ids_to_nodes(idarray):
	var node_array = []
	for i in range(idarray.size()):
		node_array.append(point_directory[idarray[i]])
	return node_array

func is_in_nav(node):
	var pnode = node
	if typeof(pnode) == TYPE_INT:
		pnode = point_directory.values()[pnode]
	if !point_directory.values().has(pnode):
		add_node_to_nav(pnode)
		return true
	else:
		return false

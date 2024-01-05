class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum: int = 0

func add_item(item, weight: int):
	assert(weight > 0)
	items.append({"item": item, "weight": weight})
	weight_sum += weight
	
func pick_item():
	var chosen_weight = randi_range(1, weight_sum)
	var sum = 0
	for item in items:
		sum += item["weight"]
		if chosen_weight <= sum:
			return item["item"]

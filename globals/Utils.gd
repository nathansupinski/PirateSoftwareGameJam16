extends Node
#Loaded globally in project settings->globals
#util functions go here


func in_range(value : float,pivot : float, tolerance : float) -> bool:
	return value <= pivot+tolerance and value >= pivot-tolerance

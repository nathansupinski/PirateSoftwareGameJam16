extends Node
#Loaded globally in project settings->globals
#util functions go here


func in_range(value : float,pivot : float, tolerance : float) -> bool:
	return value <= pivot+tolerance and value >= pivot-tolerance


func vec_angle_correct(radians : float) -> float:
	if radians < 0:
		radians = -(radians)
	elif radians > 0:
		radians = abs(PI-radians)+PI
	return radians

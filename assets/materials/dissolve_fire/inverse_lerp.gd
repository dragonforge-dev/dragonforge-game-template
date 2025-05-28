# inverse_lerp.gd
@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeInverseLerp


func _get_name():
	return "InverseLerp"


func _get_category():
	return "MyShaderNodes"


func _get_description():
	return "Inverse Lerp Node for dissolve shader."


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "a"
		1:
			return "b"
		2:
			return "v"


func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR


func _get_output_port_count():
	return 1


func _get_output_port_name(_port):
	return "result"


func _get_output_port_type(_port):
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_code(input_vars, output_vars, _mode, _type):
	return output_vars[0] + " = (%s - %s) / (%s - %s);" % [input_vars[2], input_vars[0], input_vars[1], input_vars[0]]

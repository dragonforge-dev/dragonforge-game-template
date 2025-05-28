# dissolve_direction.gd
@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeDissolveDirection


func _get_name():
	return "DissolveDirection"


func _get_category():
	return "MyShaderNodes"


func _get_description():
	return "Takes an Int, and two vectors, and outputs a value to determine the direction of a wipe."


func _get_return_icon_type():
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_input_port_count():
	return 3


func _get_input_port_name(port):
	match port:
		0:
			return "uv"
		1:
			return "x_direction"
		2:
			return "y_direction"

func _get_input_port_type(port):
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_VECTOR_2D
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR_INT
		2:
			return VisualShaderNode.PORT_TYPE_SCALAR_INT


func _get_input_port_default_value(port):
	match port:
		#0:
			#return "uv"
		1:
			return 0
		2:
			return 0


func _get_output_port_count():
	return 1


func _get_output_port_name(_port):
	return "direction"


func _get_output_port_type(_port):
	return VisualShaderNode.PORT_TYPE_SCALAR


func _get_global_code(_mode):
	return """
	float dissolve_dir(vec2 uv, int x_direction, int y_direction) {
		float return_value = 1.0;
		float x = 0.0;
		float y = 0.0;
		if (x_direction > 0) {
			x = uv.x;
			return_value = x;
		}
		else if (x_direction < 0) {
			x = 1.0 - uv.x;
			return_value = x;
		}
		if (y_direction > 0) {
			y = uv.y;
			return_value = y;
		}
		else if (y_direction < 0) {
			y = 1.0 - uv.y;
			return_value = y;
		}
		
		if (x != 0.0 && y != 0.0) {
			return_value = x * y;
		}
		
		return return_value;
	}
	"""

func _get_code(input_vars, output_vars, _mode, _type):
	return output_vars[0] + " = dissolve_dir(%s, %s, %s);" % [input_vars[0], input_vars[1], input_vars[2]]

shader_type spatial;
render_mode unshaded, depth_test_disabled;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float color;
	int index = int(FRAGCOORD.x) % 8;
	ALBEDO = vec3(0.1, 0.1, 0.1);
	// Called for every pixel the material is visible on.
}

void light() {
	discard;
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}

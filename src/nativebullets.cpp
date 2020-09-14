#include "nativebullets.h"

using namespace godot;

struct product {
    String name;
    Vector2 position;
};

void NativeBullets::_register_methods() {
    register_method("_draw", &NativeBullets::_draw);
    register_method("update_bullets", &NativeBullets::update_bullets);

    register_property<NativeBullets, float>("outer", &NativeBullets::outer, 10.0);
    register_property<NativeBullets, float>("inner", &NativeBullets::inner, 7.0);
}

NativeBullets::NativeBullets() {
}

NativeBullets::~NativeBullets() {
}

void NativeBullets::_init() {
    // Godot::print("Initialized NativeBullets!");
    outer = 10.0;
    inner = 7.0;
}

void NativeBullets::_draw() {
	for(int i = 0; i < points.size(); i++) {
        Vector2 screen = Vector2(1024.0, 600.0);
        Vector2 pos = points[i] / 5 + 0.5 * screen + offset;

        if (pos.x < 0 || pos.y < 0 || pos.x > screen.x || pos.y > screen.x)
			continue;

        Color c = colors[i];

        if (c.a < 0.5) {
            draw_circle(pos, outer, Color(c.r, c.g, c.b, 1.0));
        }
        
        draw_circle(pos, inner, Color(1.0, 1.0, 1.0, 1.0));
    }
}

void NativeBullets::update_bullets(PoolVector2Array pos, PoolColorArray col, Vector2 off) {
    points = pos;
    colors = col;
    offset = off;
    update();
}
#ifndef NATIVEBULLETS_H
#define NATIVEBULLETS_H

#include <Godot.hpp>
#include <CanvasItem.hpp>

namespace godot {

class NativeBullets : public CanvasItem {
    GODOT_CLASS(NativeBullets, CanvasItem)

	private:
		PoolVector2Array points;
		PoolColorArray colors;
		Vector2 offset;
		String demo;
		float outer;
		float inner;

	public:
	    static void _register_methods();

	    NativeBullets();
	    ~NativeBullets();

	    void _init(); // our initializer called by Godot

		void _draw();
	    void _process(float delta);

		void update_bullets(PoolVector2Array pos, PoolColorArray col, Vector2 off);
	};
}

#endif
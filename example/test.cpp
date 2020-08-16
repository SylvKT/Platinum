#include <Platinum/lib.h>
#include <iostream>
using namespace Platinum;

int main() {
	Renderer renderer;
	Window* window = new Window(new Vector2(640, 480), "Example");
	window->currentContext();
	return EXIT_SUCCESS;
}

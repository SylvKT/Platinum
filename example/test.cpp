#include <Platinum/lib.h>
#include <iostream>
using namespace std;
using namespace Platinum;

int main() {
	cout << "Starting...\n";

	platinumInit();

	cout << "platinumInit() run\n";

	Window* mainWindow = new Window(new Vector2(640, 480), "Example");
	mainWindow->setContext();

	cout << "Window created\n";

	Viewport* viewport = new Viewport();
	mainWindow->setViewport(viewport);

	cout << "Viewport created\n";

	return EXIT_SUCCESS;
}

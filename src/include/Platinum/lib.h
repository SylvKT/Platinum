#ifndef platinum_h__
#define platinum_h__

// i hate apple
#ifdef __APPLE__
#define GL_SILENCE_DEPRECATION
#endif

#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>
#include <exception>
using namespace std;

namespace Platinum {
	class Vector2 {
	public:
		int x, y;
		Vector2(int x, int y);
	};
	class Vector3 {
	public:
		int x, y, z;
		Vector3(int x, int y, int z);
	};
	class Window {
	public:
		Window(Vector2* resolution, const char* name);
		void currentContext();
		void close();
	private:
		GLFWwindow* window;
	};
	class Renderer {
	public:
		Renderer();
		~Renderer();
		void destroyWindows();
	};
}

#endif

#include "lib.h"
#include "err.h"
#include <GLFW/glfw3.h>
#include <iostream>
using namespace std;

namespace Platinum {
	Vector2::Vector2(int x, int y) {
		this->x = x;
		this->y = y;
	}
	Vector3::Vector3(int x, int y, int z) {
		this->x = x;
		this->y = y;
		this->z = z;
	}
	Renderer::Renderer() {
		if (!glfwInit())
			throw RenderFailed;
		// opengl minimum version
		// osx forward compatibility nonsense
		#ifdef __APPLE__
		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
		glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE);
		glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
		#endif
	}
	Renderer::~Renderer() {
		this->destroyWindows();
	}
	void Renderer::destroyWindows() {
		glfwTerminate();
	}
	Window::Window(Vector2* resolution, const char* name) {
		this->window = glfwCreateWindow(resolution->x, resolution->y, name, NULL, NULL);
		if (!this->window)
			throw WindowFailed;
		while (!glfwWindowShouldClose(this->window)) {
			glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
			glfwSwapBuffers(this->window);
			glfwPollEvents();
			// TODO: invoke render callback
		}
		glfwDestroyWindow(this->window);
	}
	void Window::currentContext() {
		glfwMakeContextCurrent(this->window);
	}
	void Window::close() {
		glfwDestroyWindow(this->window);
	}
}

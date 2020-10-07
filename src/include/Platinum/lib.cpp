#include "lib.h"
#include "err.h"
#include <GLFW/glfw3.h>
#include <iostream>
#include <thread>
#include <functional>
#include <vector>
using namespace std;

namespace Platinum {
	// open windows
	int windows = 0;
	void framebufferSizeCallback(GLFWwindow* window, int width, int height) {
		// create gl viewport
		glViewport(0, 0, width, height);
	}
	void processInput(Window* window) {
		if (window->getKey(KEY_ESCAPE) == KEY_PRESS)
			window->close();
	}
	void platinumInit() {
		// if initialisation failed, throw exception
		if (!glfwInit())
			throw RenderFailed;
		// opengl minimum version
		// osx forward compatibility nonsense
		#ifdef __APPLE__
		// set gl version
		glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
		glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
		// set gl profile and enable forward compatibility
		glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GLFW_TRUE);
		glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
		#endif
	}
	void platinumTerminate() {
		// if there is no context, terminate
		if (!glfwGetCurrentContext()) {
			glfwTerminate();
		}
	}
	Vector2::Vector2(int x, int y) {
		this->x = x;
		this->y = y;
	}
	Vector3::Vector3(int x, int y, int z) {
		this->x = x;
		this->y = y;
		this->z = z;
	}
	Color3::Color3(int red, int green, int blue) {
		this->red = red;
		this->green = green;
		this->blue = blue;
	}
	Color4::Color4(int red, int green, int blue, float alpha) {
		this->red = red;
		this->green = green;
		this->blue = blue;
		this->alpha = alpha;
	}
	void Viewport::render() {
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	}
	Window::Window(Vector2* resolution, const char* name) {
		// increment window count
		windows++;
		// create window
		this->window = glfwCreateWindow(resolution->x, resolution->y, name, NULL, NULL);

		// if window creation failed, throw exception
		if (!this->window)
			throw WindowFailed;

		// render until window should close
		while (!glfwWindowShouldClose(this->window)) {
			// if viewport exists, invoke render callback
			if (this->viewport)
				this->viewport->render();

			// poll events
			glfwPollEvents();
			// swap buffers
			glfwSwapBuffers(this->window);
		}
		// destroy window
		glfwDestroyWindow(this->window);
	}
	void Window::setContext() {
		// make window current context
		glfwMakeContextCurrent(this->window);
		context = this;
	}
	void Window::close() {
		// set window should close
		glfwSetWindowShouldClose(this->window, true);
		// this is current context, clear context
		if (context == this)
			context = NULL;
		// decrement window count
		windows--;
	}
	void Window::setViewport(Viewport* viewport) {
		// set viewport
		this->viewport = viewport;
	}
	KeyState Window::getKey(Key key) {
		// return key state
		return (KeyState)glfwGetKey(this->window, (int)key);
	}
	vector<weak_ptr<Node>> Node::getChildren() {
		// return children
		vector<weak_ptr<Node>> ptrs;
		for (auto& p : children) {
			ptrs.push_back(make_shared<Node>(p));
		}
		return ptrs;
	}
	weak_ptr<Node> Node::getParent() {
		return parent;
	}
	void Node::addChild(Node* node) {
		children.push_back(node);
	}
	void Node::notify(Notification notif) {
		// invoke listeners of notification
		if (events.count(notif)) {
			for (auto& cb : events[notif]) {
				cb();
			}
		}
	}
	void Node::on(Notification notif, function<void()> cb) {
		// bind event listener
		if (!events.count(notif)) {
			vector<function<void()>> v;
			v.push_back(cb);
			events.insert(pair<Notification, vector<function<void()>>(notif, v));
		} else {
			events[notif].push_back(cb);
		}
	}
	Node::~Node() {
		// iterate through children nodes and destroy them
		for (auto& n : children) {
			n.reset();
		}
		// clean memory
		delete listeners;
	}
}

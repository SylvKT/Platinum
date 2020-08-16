#include "lib.h"
#include <exception>

namespace Platinum {
	class RenderFailedException: public exception {
		virtual const char* what() const throw() {
			return "Failed to initialize Platinum renderer!";
		}
	} RenderFailed;
	class WindowFailedException: public exception {
		virtual const char* what() const throw() {
			return "Failed to initialize window!";
		}
	} WindowFailed;
}

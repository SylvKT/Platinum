# TODO: add cygwin/mingw support
# TODO: add cross compiling linux to mac support

unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)		env=Linux;;
	Darwin*)	env=Mac;;
	CYGWIN*)	env=Cygwin;;
	MINGW*)		env=MinGw;;
	*)			env=Unknown;;
esac

echo "Creating directories..."
mkdir .include
mkdir .include/win
mkdir .include/osx
#mkdir .include/linux
mkdir .include/win/Platinum
mkdir .include/win/GLFW
mkdir .include/win/glad
mkdir .include/win/KHR
mkdir .include/osx/Platinum
mkdir .include/osx/GLFW
mkdir .include/osx/glad
mkdir .include/osx/KHR
#mkdir .include/linux/Platinum
#mkdir .include/linux/GLFW
#mkdir .include/linux/glad
#mkdir .include/linux/KHR

echo "Copying GLFW files..."
cp lib/win/include/GLFW/glfw3.h .include/win/GLFW/glfw3.h
cp lib/win/include/GLFW/glfw3.h .include/win/GLFW/glfw3native.h
cp lib/osx/include/GLFW/glfw3.h .include/osx/GLFW/glfw3.h
cp lib/osx/include/GLFW/glfw3.h .include/osx/GLFW/glfw3native.h
#cp lib/linux/include/GLFW/glfw3.h .include/linux/GLFW/glfw3.h
#cp lib/linux/include/GLFW/glfw3.h .include/linux/GLFW/glfw3native.h

echo "Copying GLAD files..."
#cp lib/win/include/glad/glad.h .include/win/glad/glad.h
#cp lib/win/include/KHR/khrplatform.h .include/win/KHR/khrplatform.h
#cp lib/win/libglad.a .include/win/libglad.a
cp lib/osx/include/glad/glad.h .include/osx/glad/glad.h
#cp lib/osx/include/KHR/khrplatform.h .include/osx/KHR/khrplatform.h
cp lib/osx/libglad.a .include/osx/libglad.a
#cp lib/linux/include/glad/glad.h .include/linux/glad/glad.h
#cp lib/linux/include/KHR/khrplatform.h .include/linux/KHR/khrplatform.h
#cp lib/linux/libglad.a .include/linux/libglad.a
# TODO: compile linux/windows glad binary

echo "Installing compilers..."
if [ $env == "Mac" ]; then
	echo "Mac OS X detected"
	ver="$(sw_vers -productVersion)"
	IFS='.' read -r -a os_ver <<< "$ver"
	if [[ "${os_ver[1]}" -ge 13 ]]; then
		cp lib/win/libglfw3.a .include/win/libglfw3.a
		cp lib/osx/libglfw3.a .include/osx/libglfw3.a
		#cp lib/linux/libglfw3.a .include/linux/libglfw3.a
		# TODO: Add pre-compiled libglfw3.a linux binary
		if [ ! "$(command -v brew)" ]; then
			curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
		fi
		if [ ! "$(command -v g++)" ]; then
			brew install g++
		fi
		if [ ! "$(command -v x86_64-linux-musl-g++)" ]; then
			brew install FiloSottile/musl-cross/musl-cross
		fi
		if [ ! "$(command -v x86_64-w64-mingw32-g++)" ]; then
			brew install mingw-w64
		fi
		brew install glfw3
	else
		echo "Your version of Mac OS X ($ver) is not supported!"
		echo "The minimum version is Mac OS X High Sierra (10.13)"
	fi
elif [ $env == "Linux" ]; then
	echo "Linux detected"
	cp lib/win/libglfw3.a build/libglfw3.a
	cp lib/osx/libglfw3.a .include/osx/libglfw3.a
	if [ ! "$(command -v apt-get)" ]; then
		wget http://security.ubuntu.com/ubuntu/pool/main/a/apt/apt_1.0.1ubuntu2.17_amd64.deb -O apt.deb
		sudo dpkg -i apt.deb
	fi
	if [ ! "$(command -v g++)" ]; then
		echo "g++ not installed. Installing..."
		sudo apt install g++
	fi
	if [ ! "$(command -v x86_64-w64-mingw32-g++)" ]; then
		sudo apt-get install mingw-w64
	fi
	if [ ! "$(command -v o64-g++)" ]; then
		sudo apt-get install gcc g++ zlib1g-dev libmpc-dev libmpfr-dev libgmp-dev
		./osxcross.sh
	fi
elif [ ! $env == "Unknown" ]; then
	echo "Unsupported OS"
else
	echo "Unknown OS"
fi

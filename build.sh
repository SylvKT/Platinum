# TODO: add mingw/cygwin support
# NOTE: i haven't tested it yet, but i think this will still work on linux

# check if folders exist
# if not, create them
folders=( "build" "build/win" "build/osx" "build/linux" )
for i in "${folders[@]}"
do
	if [ ! -d "$i" ]
	then
		mkdir "$i"
	fi
done

echo "Building static library..."
# build static library
g++ -std=c++17 -c src/include/Platinum/lib.cpp -o build/libplatinum.o
ar rvs build/libplatinum.a build/libplatinum.o

# build shared library
# TODO: create shared library

# get platform
unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)		env=linux;;
	Darwin*)	env=osx;;
	CYGWIN*)	env=win;;
	MINGW*)		env=win;;
	*)			env=unknown;;
esac

# build test
if [ ! $env == "unknown" ]; then
	ext=""
	glinclude=""
	glver=""
	if [ $env == "win" ]; then
		ext=".exe"
		glinclude="-lglfw3"
		glver="3"
	elif [ $env == "osx" ]; then
		glinclude="-lglfw -framework OpenGL"
	elif [ $env == "linux" ]; then
		glinclude="-lglfw -lGL"
	fi
	echo "Copying files..."
	cp build/libplatinum.a .include/win/libplatinum.a
	cp build/libplatinum.a .include/osx/libplatinum.a
	#cp build/libplatinum.a .include/linux/libplatinum.a
	cp src/include/Platinum/lib.h .include/win/Platinum/lib.h
	cp src/include/Platinum/lib.cpp .include/win/Platinum/lib.cpp
	cp src/include/Platinum/lib.h .include/osx/Platinum/lib.h
	cp src/include/Platinum/lib.cpp .include/osx/Platinum/lib.cpp
	#cp src/include/Platinum/lib.h .include/linux/Platinum/lib.h
	#cp src/include/Platinum/lib.cpp .include/linux/Platinum/lib.cpp
	if [ ! $env == "win" ]; then
		echo "Building examples for current platform..."
		g++ -std=c++17 example/test.cpp -o "build/$env/test$ext" -I.include/$env -Lbuild -lplatinum $glinclude
		if [ $env == "osx" ]; then
			# TODO: Fix mingw compiler
			echo "Building Windows examples..."
			#x86_64-w64-mingw32-g++ -std=c++17 example/test.cpp -o "build/win/test.exe" -I.include/win -L.include/win -lplatinum -lglfw3
			#x86_64-linux-musl-g++ -std=c++17 example/test.cpp -o "build/linux/test" -I.include/linux -L.include/linux -lplatinum -lGL
			# TODO: Add pre-compled libglfw3.a linux binary
		elif [ $env == "linux" ]; then
			echo "Building Windows examples..."
			x86_64-w64-mingw32-g++ -std=c++17 example/test.cpp -o "build/win/test.exe" -I.include/win -L.include/win -lplatinum -lglfw3
			echo "Building OS X examples..."
			o64-g++ -std=c++17 example/test.cpp -o "build/osx/test" -I.include/osx -L.include/osx -lplatinum -lglfw3
		fi

	fi
fi

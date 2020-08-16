# TODO: add linux support
# NOTE: i haven't tested it yet, but i think this will still work on linux since it doesn't reqiure any platform-specific frameworks/libraries

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

# build static library
g++ -std=c++98 -c src/include/Platinum/lib.cpp -o build/libplatinum.o
ar rvs build/libplatinum.a build/libplatinum.o

# build shared library

# build test
g++ -std=c++98 example/test.cpp -o build/osx/test -Isrc/include -Lbuild -lplatinum -lglfw -framework OpenGL

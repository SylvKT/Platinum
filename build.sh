# build static library
g++ -c -o build/platinum.o src/include/platinum.cpp
ar rvs build/platinum.a build/platinum.o

# build shared library

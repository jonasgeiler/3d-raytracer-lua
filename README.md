# raytracer.lua (WIP)

A simple 3D raytracer written in Lua


## About

I followed these two books by Peter Shirley and translated the C++ code from the books into Lua:
- [_Ray Tracing in One Weekend_](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
- [_Ray Tracing: The Next Week_](https://raytracing.github.io/books/RayTracingTheNextWeek.html)

All the code is written by me, but I added a MIT license so feel free to use it.

> **Note**  
> I am currently _**still reading the second book**_, therefore this repository is work-in-progress (WIP).  
> If you want to try out the finished raytracer after the first book, checkout the tag [`end-of-book-1`](https://github.com/skayo/raytracer.lua/tree/end-of-book-1).


## Results

![Render 1](https://github.com/skayo/raytracer.lua/assets/10259118/58deb0ce-4c8a-4bc3-8b18-023624e41758)
![Render 2](https://user-images.githubusercontent.com/10259118/231303100-ee609722-1898-4eb9-b79e-6f63029c1b22.png)


## How to use

Just download the repository and then run `raytracer.lua` using LuaJIT:
```shell
$ luajit ./raytracer.lua
```
> You can also use standard Lua 5.1, but I _**highly recommend**_ using LuaJIT instead.
> Also, to use standard Lua you have to install the [Lua BitOp extension](https://bitop.luajit.org/), which is included in LuaJIT.

After the rendering is finished, you can find the PPM file in `renders/`.  
To convert the PPM file to a PNG file, I recommend using [GIMP](https://www.gimp.org/).


## To Do

- [X] Book 1 (Ray Tracing in One Weekend)
	- [X] Output an Image
	- [X] The vec3 Class
	- [X] Rays, a Simple Camera, and Background
	- [X] Adding a Sphere
	- [X] Surface Normals and Multiple Objects
	- [X] Antialiasing
	- [X] Diffuse Materials
	- [X] Metal
	- [X] Dielectrics
	- [X] Positionable Camera
	- [X] Defocus Blur
	- [X] A Final Render
- [X] Book 2 (Ray Tracing: The Next Week)
	- [X] Motion Blur
	- [X] Bounding Volume Hierachies
	- [X] Solid Textures
	- [X] Perlin Noise
	- [X] Image Texture Mapping
	- [X] Rectangles and Lights
	- [X] Instances
	- [X] Volumes
	- [X] A Scene Testing All New Features

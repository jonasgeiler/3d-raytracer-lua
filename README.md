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


## Examples

![Render](https://user-images.githubusercontent.com/10259118/231303100-ee609722-1898-4eb9-b79e-6f63029c1b22.png)


## How to use

Just download the repository and then run `raytracer.lua`:
```shell
$ lua ./raytracer.lua
```

> To save time, I _**highly recommend**_ using LuaJIT instead:
> ```shell
> $ luajit ./raytracer.lua
> ```

After the rendering is finished, you can find the PPM file in `renders/`.  
To convert the PPM file to a PNG file, I recommend using [GIMP](https://www.gimp.org/).

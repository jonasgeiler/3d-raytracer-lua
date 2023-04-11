# raytracer.lua

A simple 3D raytracer written in Lua

I followed this book by Peter Shirley and translated it to Lua: [_Ray Tracing in One Weekend_](https://raytracing.github.io/books/RayTracingInOneWeekend.html)

![Render](https://user-images.githubusercontent.com/10259118/231303100-ee609722-1898-4eb9-b79e-6f63029c1b22.png)


## How to use

Just download the repository and then run `raytracer.lua`:
```shell
$ lua ./raytracer.lua
```

> To save time, I **highly recommend** using LuaJIT instead:
> ```shell
> $ luajit ./raytracer.lua
> ```

After the rendering is finished, you can find the PPM file in `renders/`.  
To convert the PPM file to a PNG file, I recommend using [GIMP](https://www.gimp.org/).

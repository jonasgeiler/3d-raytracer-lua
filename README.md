# 3d-raytracer-lua

> A simple 3D raytracer written in Lua over a couple of weekends.

Some time ago I wanted to learn more about 3D raytracers, so I read these two
books by Peter Shirley and then translated the C++ code from the books into Lua:
- [_Ray Tracing in One Weekend_](https://raytracing.github.io/v3/books/RayTracingInOneWeekend.html)
- [_Ray Tracing: The Next Week_](https://raytracing.github.io/v3/books/RayTracingTheNextWeek.html)

> **ℹ️ Note:** I have read version 3 of the books. There are newer versions now.

This raytracer is obviously not production-ready or really anything to be taken
seriously, but I had a lot of fun writing it!  
I decided to use Lua because it's a very minimal and limited language, which
makes it even more fun, but it's obviously not the fastest language out there
so if you want to try it you'll have to clear your schedule. 😅  
The final render seen below took almost a week to render...
Don't ask.
Sorry Planet Earth!

All the code is written by me, but I added a [MIT license](./LICENSE.md) so feel free to use it
however you like.

## Results

![Result - Final](./results/final-full.jpg)
![Result - Random](./results/random-full.png)
![Result - Cornell Box Smoke](./results/cornell_box_smoke.png)
![Result - Simple Light](./results/simple_light.png)
![Result - Three Spheres](./results/three_spheres.png)

## Requirements

- [LuaJIT 2.1](https://luajit.org/) (_**highly recommended**_) or [Lua 5.1](https://www.lua.org/) (newer Lua versions might work but not tested)
  > **💡 Tip:** On Arch Linux, you can easily install both with `pacman -S luajit lua51`.
- If you are using standard Lua 5.1, you will also need the [Lua BitOp extension](https://bitop.luajit.org/), which is already included in LuaJIT 2.1
  > **💡 Tip:** On Arch Linux, you can easily install it with `pacman -S lua51-bitop`.

## How to try

Download the repository and then run any of the scenes using LuaJIT:
```shell
$ luajit ./scenes/<scene>.lua
```

For example, [`random.lua`](./scenes/random.lua) is reasonably fast and showcases many of the
features:

```
$ luajit ./scenes/random.lua
```

After the rendering is finished, you can find the resulting PPM file in
[`./results/`](./results).  
To convert the PPM file to a PNG/JPEG file, I recommend using
[GIMP](https://www.gimp.org/) or [ImageMagick](https://imagemagick.org/).

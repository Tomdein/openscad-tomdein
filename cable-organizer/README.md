# Cable organizer
I downloaded a [nice models](https://www.printables.com/model/1111926-cable-organizer-cable-clip-clip-rj45-usb-o3mm-usb/files) of a cable organizers, but I needed to change the number of cable holders... So I had to make my own... And while at it, why not make it parametric?

**Welcome to my weekend excursion into [OpenSCAD](https://openscad.org/)!!!**

## The bait
![showcase](./img/showcase.png)

## Features
 - Generate single/multiple cable holders
 - Mirror & join multiple cable holders
 - Have as many cable positions as you want in individual sizes you want
 - Change wall thickness & remove back/front part
 - Change entry hole size
 - Have them all share the same width or not

## Advanced features
 - Custom lenghts for individual cable positions (**overrides `uniform_width`**)
 - Custom hole sizes for individual cable positions
 - Create spacings between cable positions:
   - No wall
   - Back wall
   - Full wall
   - Webbing

## Defaults
 - `height`: `8mm`
 - `wall_thickness`: `1.2mm`
 - `default_entry_percentage`: `0.8` (80% of cable dia is cut out)
 - `center`: `true`
 - `mirror_x`: `false`
 - `uniform_width`: `true` (needs `flat_front=true` for given cable position)
 - `flat_back`: `true`
 - `flat_front`: `true`
 - `union`: `true` (nice for second cable organizer with mirror_x = true)

## How to use
### Generate connector from CMD/sh:
Run:

```
"C:\Program Files\OpenSCAD\openscad.exe" -o utp-cable-organizer.stl -D "settings_cables_dia=[[3,5,5,3],[2,5]];" -D "settings_mirror_x=[false,true]" utp-cable-organizer.scad
```

And wait for a few seconds (this one took me ~30s to generate)

### Edit the commented settings_* variables in `utp-cable-organizer.scad`

### Import `utp-cable-organizer.scad` - Look into examples folder for:
#### Single
![single.png](./img/single.png)
#### Single Non-Uniform
![single-non-uniform.png](./img/single-non-uniform.png)
#### Single Non-Uniform Non-Flat
![single-non-uniform-non-flat.png](./img/single-non-uniform-non-flat.png)
#### Double
![double.png](./img/double.png)
#### Double Non-Uniform
![double-non-uniform.png](./img/double-non-uniform.png)
#### Double Non-Uniform Non-Flat
![double-non-uniform-non-flat.png](./img/double-non-uniform-non-flat.png)
#### Double Non-Uniform Non-Flat Individual
![double-non-uniform-non-flat-infividual.png](./img/double-non-uniform-non-flat-infividual.png)
#### Offset
![offset.png](./img/offset.png)
#### Advanced
![advanced.png](./img/advanced.png)
#### Advanced 2
![advanced2.png](./img/advanced2.png)
#### Advanced 3
![advanced3.png](./img/advanced3.png)
#### Advanced 4
![advanced4.png](./img/advanced4.png)
#### Advanced 5
![advanced5.png](./img/advanced5.png)
#### Advanced 6
![advanced6.png](./img/advanced6.png)
#### Multiple
![multiple.png](./img/multiple.png)

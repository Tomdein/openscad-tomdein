# Cable organizer
I downloaded a [nice models](https://www.printables.com/model/1111926-cable-organizer-cable-clip-clip-rj45-usb-o3mm-usb/files) of a cable organizers, but I needed to change the number of cable holders... So I had to make my own... And while at it, why not make it parametric?

**Welcome to my weekend excursion into [OpenSCAD](https://openscad.org/)!!!**

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

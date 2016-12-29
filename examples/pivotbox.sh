#!/bin/sh

OS=$( uname )
if [ "$OS" = "Darwin" ]; then
        alias openscad='/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
fi

# Render assembled boxes as PNG
openscad -o pivotbox_bottom.png -D assemble=true pivotbox_bottom.scad
openscad -o pivotbox_middle.png -D assemble=true pivotbox_middle.scad
openscad -o pivotbox_top.png -D assemble=true pivotbox_top.scad
openscad -o pivotbox_rods.png pivotbox_rods.scad

# Render unassembled boxes as SVG
openscad -o pivotbox_bottom.svg -D assemble=false pivotbox_bottom.scad
openscad -o pivotbox_middle.svg -D assemble=false pivotbox_middle.scad
openscad -o pivotbox_top.svg -D assemble=false pivotbox_top.scad
openscad -o pivotbox_rods.svg pivotbox_rods.scad

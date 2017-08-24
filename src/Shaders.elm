module Shaders exposing (shaders)

import Types exposing (ShaderObject)
import Shader.Day1 as Day1
import Shader.Day2 as Day2
import Shader.Day3 as Day3
import Shader.Day4 as Day4
import Shader.Day5 as Day5
import Shader.Day6 as Day6
import Shader.Day7 as Day7
import Shader.Day8 as Day8
import Shader.Day9 as Day9
import Shader.Day10 as Day10
import Shader.Day11 as Day11
import Shader.Day12 as Day12
import Shader.Day13 as Day13
import Shader.Day14 as Day14
import Shader.Day15 as Day15
import Shader.Day16 as Day16
import Shader.Day17 as Day17
import Shader.Day18 as Day18
import Shader.Day19 as Day19
import Shader.Day20 as Day20
import Shader.Day21 as Day21
import Shader.Day22 as Day22
import Shader.Day23 as Day23
import Shader.Day24 as Day24


shaders : List ShaderObject
shaders =
    [ ShaderObject 1 "Circles" "01/08/2017" Day1.shader
    , ShaderObject 2 "Composition with color fields by Piet Mondrian" "02/08/2017" Day2.shader
    , ShaderObject 3 "Another Mondrian inspired composition" "03/08/2017" Day3.shader
    , ShaderObject 4 "Animated gradient" "04/08/2017" Day4.shader
    , ShaderObject 5 "Rotating pyramids" "05/08/2017" Day5.shader
    , ShaderObject 6 "Horizontal line noise" "06/08/2017" Day6.shader
    , ShaderObject 7 "Black and white line waves" "07/08/2017" Day7.shader
    , ShaderObject 8 "Circlular distance fields" "08/08/2017" Day8.shader
    , ShaderObject 9 "Radial plasma" "09/08/2017" Day9.shader
    , ShaderObject 10 "2 circles" "10/08/2017" Day10.shader
    , ShaderObject 11 "Follow mouse" "11/08/2017" Day11.shader
    , ShaderObject 12 "Day 12" "12/08/2017" Day12.shader
    , ShaderObject 13 "Day 13" "13/08/2017" Day13.shader
    , ShaderObject 14 "Distorted circle" "14/08/2017" Day14.shader
    , ShaderObject 15 "Rotating polygons" "15/08/2017" Day15.shader
    , ShaderObject 16 "Hypnodiscs" "16/08/2017" Day16.shader
    , ShaderObject 17 "Diamonds morphing into lines" "17/08/2017" Day17.shader
    , ShaderObject 18 "Neon heart" "18/08/2017" Day18.shader
    , ShaderObject 19 "Black/White grid" "19/08/2017" Day19.shader
    , ShaderObject 20 "Life line" "20/08/2017" Day20.shader
    , ShaderObject 21 "Ray tracing pt1" "21/08/2017" Day21.shader
    , ShaderObject 22 "Ray tracing pt2" "22/08/2017" Day22.shader
    , ShaderObject 23 "Random lights" "23/08/2017" Day23.shader
    , ShaderObject 24 "Ray tracing pt3" "24/08/2017" Day24.shader
    ]

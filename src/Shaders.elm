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
    ]

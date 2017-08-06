module Shaders exposing (shaders)

import Types exposing (ShaderObject)
import Shader.Day1 as Day1
import Shader.Day2 as Day2
import Shader.Day3 as Day3
import Shader.Day4 as Day4
import Shader.Day5 as Day5
import Shader.Day6 as Day6


shaders : List ShaderObject
shaders =
    [ ShaderObject 1 "Circles" "01/08/2017" Day1.shader
    , ShaderObject 2 "Composition with color fields by Piet Mondrian" "02/08/2017" Day2.shader
    , ShaderObject 3 "Another Mondrian inspired composition" "03/08/2017" Day3.shader
    , ShaderObject 4 "Animated gradient" "04/08/2017" Day4.shader
    , ShaderObject 5 "Rotating pyramids" "05/08/2017" Day5.shader
    , ShaderObject 6 "Horizontal lines" "06/08/2017" Day6.shader
    ]

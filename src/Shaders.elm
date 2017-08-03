module Shaders exposing (shaders)

import Types exposing (ShaderObject)
import Shader.Day1 as Day1
import Shader.Day2 as Day2
import Shader.Day3 as Day3


shaders : List ShaderObject
shaders =
    [ ShaderObject 1 "Circles" "01/08/2017" Day1.shader
    , ShaderObject 2 "Composition with color fields by Piet Mondrian" "02/08/2017" Day2.shader
    , ShaderObject 3 "Another Mondrian inspired composition" "03/08/2017" Day3.shader
    ]

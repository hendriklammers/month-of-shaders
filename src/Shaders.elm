module Shaders exposing (shaders)

import Types exposing (ShaderObject)
import Shader.Day1 as Day1
import Shader.Day2 as Day2


shaders : List ShaderObject
shaders =
    [ ShaderObject 0 "Day 1" "17/06/2017" Day1.shader
    , ShaderObject 1 "Testing title" "18/06/2017" Day2.shader
    ]

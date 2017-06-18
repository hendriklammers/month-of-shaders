module Types exposing (..)

import Math.Vector2 exposing (Vec2, vec2)
import WebGL exposing (Mesh, Shader, entity, toHtml)


type alias Vertex =
    { position : Vec2
    }


type alias Uniforms =
    { u_resolution : Vec2
    , u_time : Float
    , u_mouse : Vec2
    }


type alias Varying =
    {}


type alias FragmentShader =
    Shader {} Uniforms Varying


type alias VertexShader =
    Shader Vertex Uniforms Varying


type alias ShaderObject =
    { title : String
    , date : String
    , fragment : FragmentShader
    }

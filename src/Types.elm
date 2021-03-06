module Types exposing (..)

import Math.Vector2 exposing (Vec2, vec2)
import WebGL exposing (Mesh, Shader, entity, toHtml)
import Time exposing (Time)
import Window exposing (Size)
import Mouse exposing (Position)
import Http


type Msg
    = WindowResize Size
    | TimeUpdate Time
    | ChangeShader Int
    | KeyPress Int
    | MouseMove Position
    | PauseClick
    | LoadInfo (Result Http.Error String)
    | NoOp


type alias Model =
    { size : Size
    , time : Time
    , activeShader : Int
    , shaders : List ShaderObject
    , paused : Bool
    , mouse : Position
    , info : Maybe String
    }


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
    { id : Int
    , title : String
    , date : String
    , fragment : FragmentShader
    }

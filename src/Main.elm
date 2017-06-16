module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, width, height, style)
import Math.Vector2 exposing (Vec2, vec2)
import WebGL exposing (entity, triangles, toHtml, Mesh)
import Window exposing (Size)
import Task
import AnimationFrame
import Time exposing (Time)
import Shader.Day1 as Day1
import Shader.Day2 as Day2
import Shader.Vertex exposing (vertexShader)
import Types exposing (..)


-- MODEL


type alias Model =
    { size : Size
    , time : Time
    , activeShader : ShaderObject
    , shaders : List ShaderObject
    }


initialModel : Model
initialModel =
    { size = Size 0 0
    , time = 0
    , activeShader = ShaderObject "Day 1" Day1.shader
    , shaders = []
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Task.perform WindowResize Window.size )


shaders : List ShaderObject
shaders =
    [ ShaderObject "Day 1" Day1.shader
    , ShaderObject "Testing title" Day2.shader
    ]



-- UPDATE


type Msg
    = WindowResize Size
    | TimeUpdate Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize size ->
            ( { model | size = size }, Cmd.none )

        TimeUpdate time ->
            ( { model | time = model.time + time }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Window.resizes WindowResize

        -- , AnimationFrame.diffs TimeUpdate
        ]



-- MESH


mesh : Mesh Vertex
mesh =
    triangles
        [ ( (Vertex (vec2 -1 1))
          , (Vertex (vec2 1 1))
          , (Vertex (vec2 -1 -1))
          )
        , ( (Vertex (vec2 -1 -1))
          , (Vertex (vec2 1 -1))
          , (Vertex (vec2 1 1))
          )
        ]



-- VIEW


viewCanvas : Model -> Html Msg
viewCanvas { size, time, activeShader } =
    toHtml
        [ id "canvas"
        , width size.width
        , height size.height
        , style (canvasStyle size.width size.height)
        ]
        [ entity
            vertexShader
            activeShader.fragment
            mesh
            { u_resolution = vec2 (toFloat size.width) (toFloat size.height)
            , u_time = time / 1000
            }
        ]


canvasStyle : Int -> Int -> List ( String, String )
canvasStyle width height =
    [ ( "display", "block" )
    , ( "width", toString width ++ "px" )
    , ( "height", toString height ++ "px" )
    , ( "background", "#000" )
    ]


viewLog : Model -> Html Msg
viewLog model =
    div
        [ style logStyle ]
        [ toString model.time |> text ]


logStyle : List ( String, String )
logStyle =
    [ ( "position", "fixed" )
    , ( "left", "0" )
    , ( "top", "0" )
    , ( "padding", "5px 10px" )
    , ( "font", "14px Helvetica, sans-serif" )
    , ( "background", "#fff" )
    ]


view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ viewCanvas model

        -- , viewLog model
        ]



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

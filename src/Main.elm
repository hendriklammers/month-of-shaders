module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, width, height, style)
import Math.Vector2 exposing (Vec2, vec2)
import Math.Vector3 exposing (Vec3, vec3)
import WebGL exposing (triangles, Mesh, Shader, Entity, entity, toHtml)
import Window exposing (Size)
import Task
import AnimationFrame
import Time exposing (Time)


-- MODEL


type alias Model =
    { size : Size
    , time : Time
    }


init : ( Model, Cmd Msg )
init =
    ( { size = Size 0 0, time = 0 }, Task.perform WindowResize Window.size )



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



-- SHADERS


type alias Uniforms =
    { u_resolution : Vec2
    , u_time : Float
    }


type alias Varying =
    { v_fragCoord : Vec2 }



-- MESH


type alias Vertex =
    { position : Vec2
    }


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



-- SHADERS


vertexShader : Shader Vertex Uniforms Varying
vertexShader =
    [glsl|

    precision mediump float;

    attribute vec2 position;
    uniform vec2 u_resolution;
    uniform float u_time;
    varying vec2 v_fragCoord; // Not used, can use gl_FragCoord instead?

    void main () {
        gl_Position = vec4(position, 0.0, 1.0);
        v_fragCoord = (position + 1.0) / 2.0 * u_resolution;
    }

    |]


fragmentShader : Shader {} Uniforms Varying
fragmentShader =
    [glsl|

    precision mediump float;

    uniform vec2 u_resolution;
    uniform float u_time;
    varying vec2 v_fragCoord;

    void main () {
        gl_FragColor = vec4(0.7, 0.7, 0.7, 1.0);
    }

|]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Window.resizes WindowResize
        , AnimationFrame.diffs TimeUpdate
        ]



-- VIEW


viewCanvas : Model -> Html Msg
viewCanvas { size, time } =
    toHtml
        [ id "canvas"
        , width size.width
        , height size.height
        , style (canvasStyle size.width size.height)
        ]
        [ entity
            vertexShader
            fragmentShader
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

module Main exposing (..)

import AnimationFrame
import Html exposing (..)
import Html.Attributes exposing (id, width, height, style, href, class)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode as Decode
import Math.Vector2 exposing (Vec2, vec2)
import Shader.Vertex exposing (vertexShader)
import Task
import Time exposing (Time)
import Types exposing (..)
import WebGL exposing (entity, triangles, toHtml, Mesh)
import Window exposing (Size)
import Shader.Day1 as Day1
import Shader.Day2 as Day2
import Shader.Tutorial as Tutorial
import Keyboard


-- MODEL


type alias Model =
    { size : Size
    , time : Time
    , activeShader : Maybe ShaderObject
    , shaders : List ShaderObject
    , animating : Bool
    }


initialModel : Model
initialModel =
    { size = Size 0 0
    , time = 0
    , activeShader = List.head shaders
    , shaders = shaders
    , animating = False
    }


shaders : List ShaderObject
shaders =
    [ ShaderObject "Tutorial" "17/06/2017" Tutorial.shader
    , ShaderObject "Day 1" "17/06/2017" Day1.shader
    , ShaderObject "Testing title" "18/06/2017" Day2.shader
    ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Task.perform WindowResize Window.size )



-- UPDATE


type Msg
    = WindowResize Size
    | TimeUpdate Time
    | ChangeShader Int
    | KeyPress Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowResize size ->
            ( { model | size = size }, Cmd.none )

        TimeUpdate time ->
            ( { model | time = model.time + time }, Cmd.none )

        ChangeShader index ->
            let
                active =
                    selectShader index model.shaders
            in
                ( { model | activeShader = active }, Cmd.none )

        KeyPress char ->
            if char == 32 then
                ( { model | animating = not model.animating }, Cmd.none )
            else
                model ! []


selectShader : Int -> List ShaderObject -> Maybe ShaderObject
selectShader n shaders =
    List.head (List.drop n shaders)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes WindowResize
        , animationSubscription model.animating
        , Keyboard.presses (\keycode -> KeyPress keycode)
        ]


animationSubscription : Bool -> Sub Msg
animationSubscription animating =
    if animating then
        AnimationFrame.diffs TimeUpdate
    else
        Sub.none



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


view : Model -> Html Msg
view model =
    div
        [ id "container" ]
        [ viewCanvas model
        , viewNavigation model.shaders
        ]


viewNavigation : List ShaderObject -> Html Msg
viewNavigation shaders =
    nav [ class "navigation" ]
        [ ul []
            (List.indexedMap viewLink shaders)
        ]


onLinkClick : Msg -> Attribute Msg
onLinkClick msg =
    onWithOptions
        "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Decode.succeed msg)


viewLink : Int -> ShaderObject -> Html Msg
viewLink n shader =
    li []
        [ a
            [ href "#"
            , onLinkClick (ChangeShader n)
            , class "navigation__link"
            ]
            [ text (toString <| n + 1) ]
        ]


viewCanvas : Model -> Html Msg
viewCanvas { size, time, activeShader } =
    case activeShader of
        Nothing ->
            text "No shader available"

        Just shader ->
            toHtml
                [ id "canvas"
                , width size.width
                , height size.height
                , style (canvasStyle size.width size.height)
                ]
                [ entity
                    vertexShader
                    shader.fragment
                    mesh
                    { u_resolution =
                        vec2
                            (toFloat size.width)
                            (toFloat size.height)
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



-- MAIN


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

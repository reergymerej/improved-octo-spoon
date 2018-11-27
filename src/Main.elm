module Main exposing (main)

import Browser
import Html exposing (..)


type alias Model =
    { num : Int }


type Msg
    = Hello


init : () -> ( Model, Cmd Msg )
init _ =
    ( { num = 99 }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Hello!"
    , body =
        [ div [] [ text "Hello, everyone." ]
        , div [] [ text (String.fromInt model.num) ]
        ]
    }


main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }

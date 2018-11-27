module Main exposing (main)

import Browser
import Browser.Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Url
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s, string)


type Route
    = Topic String
    | Blog Int
    | User String
    | Comment String Int



-- Parser is a type from Url.Parser.
-- type Parser a b
-- It takes a thing and returns a different thing.
-- string, int, and s are parsers.


routeParser : Parser (Route -> a) a
routeParser =
    -- Tries a bunch of parsers.
    -- oneOf : List (Parser a b) -> Parser a b
    oneOf
        [ -- map : a -> Parser a b -> Parser (b -> c) c
          {-
             map
                 arg1   a
                        Topic
                        Topic : String -> Topic String

                 arg2   Parser a b
                        (
                        s
                        s: String -> Parser a a

                        arg1    "topic"

                        arg2    </>
                                </> : Parser a b -> Parser b c -> Parser a c

                        string
                        string : Parser (String -> a) a
                        )

                 return Parser (b -> c) c



          -}
          map Topic (s "topic" </> string)
        ]


type alias Model =
    { key : Browser.Navigation.Key
    , message : String
    }


type Msg
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key
      , message = ""
      }
    , Cmd.none
    )


onUrlChange : Url.Url -> Msg
onUrlChange url =
    UrlChanged url



{-
   type UrlRequest
     = Internal Url.Url
     | External String
-}


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest req =
    LinkClicked req


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked req ->
            case req of
                Browser.Internal url ->
                    ( model
                    , Browser.Navigation.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Browser.Navigation.load url )

        UrlChanged url ->
            ( { model | message = Url.toString url }, Cmd.none )


viewLink : String -> Html Msg
viewLink path =
    div []
        [ a [ href path ] [ text path ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = model.message
    , body =
        [ div [] [ text model.message ]
        , viewLink "#home"
        , viewLink "#home/gingo"
        , viewLink "https://google.com"
        ]
    }


main =
    Browser.application
        { init = init
        , onUrlChange = onUrlChange
        , onUrlRequest = onUrlRequest
        , subscriptions = subscriptions
        , update = update
        , view = view
        }

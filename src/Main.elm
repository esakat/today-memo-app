module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)

main : Program () Model Msg
main =
  Browser.sandbox
  { init = init
  , update = update
  , view = view
  }

-- MODEL

type Msg = Add

type alias Memo =
    { title : String
    , content : String
    , publishDate : String
    }

type alias Model = { memos : List Memo }

init : Model
init = { memos =
            [ Memo "yeterday goood" "i have .." "2019/04/08"
            , Memo "We are happy" "I think so" "2019/03/05"
            , Memo "たまには日本語もいいだろ" "日本語チェックだよ" "2018/02/05"
            ]
       }


-- UPDATE


update : Msg -> Model -> Model
update msg model =
  case msg of
    Add ->
      { model | memos = ( Memo "Todoタイトル" "Todo詳細" "hoge" ) :: model.memos }

-- VIEW

view : Model -> Html Msg
view model =
  div []
      [ viewTable model.memos
      , button [ onClick Add ] [ text "Add" ]
      ]

viewTable : List Memo -> Html Msg
viewTable memos =
  table []
        [ thead []
              [ th [] [ text "Title" ]
              , th [] [ text "Content" ]
              , th [] [ text "PublishDate" ]
              ]
        , tbody [] ( List.map viewTr memos )
        ]

viewTr : Memo -> Html Msg
viewTr memo =
  tr []
    [ td [] [ text memo.title ]
    , td [] [ text memo.content ]
    , td [] [ text memo.publishDate ]
    ]
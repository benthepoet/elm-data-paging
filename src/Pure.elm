module Pure exposing (..)

import Html
import Html.Attributes

button attrs children =
    let
        pureClass = Html.Attributes.class "pure-button"
    in
        Html.button (pureClass :: attrs) children
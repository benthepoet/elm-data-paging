import Html exposing (div, text, table, tr, td, br)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Pure

main = 
    beginnerProgram 
        { model = model
        , update = update
        , view = view 
        }
    
type alias Model = 
    { limit: Int
    , offset: Int
    , count: Int
    , data: List String
    }

model : Model
model = 
    { limit = 5
    , offset = 0
    , count = 0
    , data = 
        [ "A"
        , "B"
        , "C"
        , "D"
        , "E"
        , "F"
        , "G"
        , "H"
        , "I"
        , "J"]
    }
    
pageData model = 
    model.data
        |> List.drop model.offset
        |> List.take model.limit
    
type Msg = Previous | Next
    
update msg model =
    case msg of
        Previous ->
            { model | offset = model.offset - model.limit }
        Next ->
            { model | offset = model.offset + model.limit }

renderButtons model = 
    let
        previous = Pure.button [onClick Previous] [text "Previous"]
        next = Pure.button [onClick Next] [text "Next"]
        dataLength = List.length model.data
        upperBound = model.offset + model.limit
    in
        List.concat
            [ if model.offset > 0 then [previous] else []
            , if upperBound < dataLength then [next] else []
            ]
        
renderListItem item = 
    tr [] [ 
        td [] [text item]
        ]
    
view model = 
    div []
        [ table [class "pure-table pure-table-striped"] (List.map renderListItem (pageData model))
        , div [] (renderButtons model)
        , div [] 
            [ text ("Offset: " ++ (toString model.offset))
            , br [] []
            , text ("Limit: " ++ (toString model.limit))
            ]
        ]
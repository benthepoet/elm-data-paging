import Html
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
        previous = Html.button 
            [ Html.Attributes.class Pure.button
            , onClick Previous
            ] [Html.text "Previous"]
        next = Html.button 
            [ Html.Attributes.class Pure.button
            , onClick Next
            ] [ Html.text "Next"]
        dataLength = List.length model.data
        upperBound = model.offset + model.limit
    in
        List.concat
            [ if model.offset > 0 then [previous] else []
            , if upperBound < dataLength then [next] else []
            ]
        
renderListItem item = 
    Html.tr [] [ 
        Html.td [] [Html.text item]
        ]

renderListItems model = 
    List.map renderListItem (pageData model)
    
view model = 
    Html.div []
        [ Html.table 
            [ Html.Attributes.classList 
                [ (Pure.table, True)
                , (Pure.tableStriped, True)
                ]
            ] 
            (renderListItems model)
        , Html.div [] (renderButtons model)
        , Html.form [Html.Attributes.class Pure.form] 
            [ Html.input [Html.Attributes.type' "text"] []
            ]
        ]
module Route exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Route"
        [ test "should parse URL" <|
            \_ ->
                Url.fromString "http://example.com/"
                    |> Maybe.andThen Route.parse
                    |> Expect.equal (Just Route.Top)
        ]

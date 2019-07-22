module Main

import iTasks


main =
  withShared 0 (\l ->
    t1 l -&&- t2 l
  )
  where
    t1 l =
      set 2 l >>|
      viewSharedInformation "Number" [] l >>*
        [ OnValue (ifValue (\x -> x > 2) (\_ -> viewInformation "Done" [] ())) ]
    t2 l =
      set 3 l >>|
      set 1 l >>|
      viewInformation "Done" [] ()

Start :: *World -> *World
Start world = startEngine main world

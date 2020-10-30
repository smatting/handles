module Toy.Types where

import RIO

data HttpPool = HttpPool

data User = User {name :: Text, id :: Int}
  deriving (Show)

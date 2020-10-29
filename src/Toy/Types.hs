module Toy.Types where

import RIO

data PostgresConn = PostgresConn

data User = User {name :: Text, id :: Int}
  deriving (Show)

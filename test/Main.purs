module Test.Main where

import Prelude
import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE,log)
import Data.Set
import Data.Set (empty) as Set
import Test.Unit (suite,test,timeout)
import Test.Unit.Main (runTest)
import Test.Unit.Assert as Assert
import Test.Unit.Console

main :: forall a eff. Eff ("console" :: CONSOLE, "testOutput" :: TESTOUTPUT, "avar" :: AVAR | eff) Unit
main = runTest do
  suite "Basic set functions" do
    test "equals" do
      Assert.assert      "Should be equal"      $ eq (Set [1,1,1])   (Set [1])
      Assert.assert      "Should be equal"      $ eq (Set [5,4,3]) (Set [3,5,4])
      Assert.assertFalse "Should not be equal " $ eq (Set [5,4])    (Set [3,5,4])

    test "contains" do
      Assert.assert      "Should contain 5"     $ contains 5 (Set [1,2,4,5])
      Assert.assertFalse "Should not contain 5" $ contains 5 (Set [1,2,4])

    test "subset" do
      Assert.assert      "Should be a subset"            $ subset (Set [1,2,3]) (Set [1,3,4,2,5])
      Assert.assert      "Equal sets should be a subset" $ subset (Set [1,2,3]) (Set [3,2,1])
      Assert.assertFalse "Should not be a subset"        $ subset (Set [3,4])   (Set [1,2,4])

    test "proper" do
      Assert.assert      "Should be a subset"                   $ proper (Set [1,2,3]) (Set [1,2,3,4,5])
      Assert.assertFalse "Equal sets should be a proper subset" $ proper (Set [1,2,3]) (Set [1,2,3])
      Assert.assertFalse "Should not be a subset"               $ proper (Set [3,4])   (Set [1,2,4])

    test "union" do
      Assert.assert "Union of {1,2,3} & {3,4,5} should be {1,2,3,4,5}" $ eq (Set [1,2,3,4,5]) (union [Set [1,2,3], Set [3,4,5]])
      Assert.assert "Union of {3,1,2} & {4,4,4} should be {1,2,3,4}"   $ eq (Set [1,2,3,4])   (union [Set [1,2,3], Set [4,4,4]])

    test "intersection" do
      Assert.assert "Intersection of {1,2,3} & {3,4,5} should be {3}"   $ eq (Set [3])   (intersection (Set [1,2,3]) (Set [3,4,5]))
      Assert.assert "intersection of {1,2,3} & {1,2,4} should be {1,2}" $ eq (Set [1,2]) (intersection (Set [1,2,3]) (Set [1,2,4]))
      Assert.assert "intersection of {2,2,2} & {3,3,3} should be {}"    $ eq (Set.empty) (intersection (Set [2,2,2]) (Set [3,3,3]))

    test "disjoint" do
      Assert.assert      "{1,2,3} & {4,5,6} should be disjoint"     $ disjoint (Set [1,2,3]) (Set [4,5,6])
      Assert.assertFalse "{1,2} & {1,2,4} should not be disjoint"   $ disjoint (Set [1,2])   (Set [1,2,4])
      Assert.assertFalse "{3,2,1} & {1,2,3} should not be disjoint" $ disjoint (Set [3,2,1]) (Set [1,2,3])

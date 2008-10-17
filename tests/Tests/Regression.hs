-- File created: 2008-10-15 20:21:41

module Tests.Regression (tests) where

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.HUnit.Base

import System.FilePath.Glob.Compile
import System.FilePath.Glob.Match

tests =
   [ testGroup "Regression" $
        flip map testCases $ \t@(b,p,s) ->
            testCase (nameTest t) . assertBool "failed" $
               match (compile p) s == b
   ]

nameTest (True ,p,s) = show p ++ " matches " ++ show s
nameTest (False,p,s) = show p ++ " doesn't match " ++ show s

testCases =
   [ (True , "*"          , "")
   , (True , "**"         , "")
   , (True , "asdf"       , "asdf")
   , (True , "a*f"        , "asdf")
   , (True , "a??f"       , "asdf")
   , (True , "*"          , "asdf")
   , (True , "a*bc"       , "aXbaXbc")
   , (True , "a**bc"      , "aXbaXbc")
   , (True , "foo/bar.*"  , "foo/bar.baz")
   , (True , "foo/*.baz"  , "foo/bar.baz")
   , (False, "*bar.*"     , "foo/bar.baz")
   , (False, "*.baz"      , "foo/bar.baz")
   , (False, "foo*"       , "foo/bar.baz")
   , (False, "foo?bar.baz", "foo/bar.baz")
   , (True , "**/*.baz"   , "foo/bar.baz")
   , (True , "**/*"       , "foo/bar.baz")
   , (True , "**/*"       , "foo/bar/baz")
   , (True , "*/*.baz"    , "foo/bar.baz")
   , (True , "*/*"        , "foo/bar.baz")
   , (False, "*/*"        , "foo/bar/baz")
   , (False, "*.foo"      , ".bar.foo")
   , (False, "*.bar.foo"  , ".bar.foo")
   , (False, "?bar.foo"   , ".bar.foo")
   , (True , ".*.foo"     , ".bar.foo")
   , (True , ".*bar.foo"  , ".bar.foo")
   , (False, "foo.[ch]"   , "foo.a")
   , (True , "foo.[ch]"   , "foo.c")
   , (True , "foo.[ch]"   , "foo.h")
   , (False, "foo.[ch]"   , "foo.d")
   , (False, "foo.[c-h]"  , "foo.b")
   , (True , "foo.[c-h]"  , "foo.c")
   , (True , "foo.[c-h]"  , "foo.e")
   , (True , "foo.[c-h]"  , "foo.f")
   , (True , "foo.[c-h]"  , "foo.h")
   , (False, "foo.[c-h]"  , "foo.i")
   , (True , "<->3foo"    , "123foo")
   , (True , "<10-15>3foo", "123foo")
   , (True , "<0-5>23foo" , "123foo")
   , (True , "<94-200>foo", "123foo")
   , (False, "[.]x"       , ".x")
   , (False, "foo[/]bar"  , "foo/bar")
   , (False, "foo[,-0]bar", "foo/bar")
   , (True , "foo[,-0]bar", "foo.bar")
   , (True , "[]x]"       , "]")
   , (True , "[]x]"       , "x")
   , (False, "[b-a]"      , "a")
   , (False, "<4-3>"      , "3")
   , (True , "[]-b]"      , "]")
   , (True , "[]-b]"      , "-")
   , (True , "[]-b]"      , "b")
   , (False, "[]-b]"      , "a")
   , (False, "[^x]"       , "/")
   , (False, "[/]"        , "/")
   , (True , "a[^x]"      , "a.")
   , (True , "a[.]"       , "a.")
   ]

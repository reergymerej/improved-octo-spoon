
https://guide.elm-lang.org/webapps/


https://package.elm-lang.org/packages/elm/browser/latest/Browser#document

You don't have to install elm/browser.  elm init adds it for you.

## Build

```
elm make src/Main.elm --debug
```

If you just want to see the errors without a real build...
```
elm make src/Main.elm --output=/dev/null
```


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

Change from document to application.

Url is needed, but not installed.

Once we start using application, we need to use a real server.

## Serve

```
python -m SimpleHTTPServer
```

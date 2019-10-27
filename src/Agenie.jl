module Agenie

import Genie

export newSection, launchUrl, launchPage, start

################################################################

"""
    start(appname)

Loads the app, starts up the webserver, and it opens the mainpage in the browser

# Examples
```julia
loadapp("myapp")
```
"""
function start(appName::String)

    Genie.loadapp(appName) # Loading New app

    Genie.startup() # Starting up the webserver

    launchPage("") # launches http://127.0.0.1:8000/

end
################################################################

"""
    newSection(name)

Creates a file for new section and opens it for editing

# Examples
```julia
newSection("sectionName")
```
"""
function newSection(sectionName::String)

    Genie.newcontroller(sectionName, pluralize = false)

    sectionFile = joinpath(
        "app",
        "resources",
        "$(lowercase(sectionName))s",
        "$(sectionName)Controller.jl",
    )
    if !isdefined(Main, :Atom)
        Atom.edit(sectionFile)
    end
end
################################################################

"""
    launchUrl(url)

opens a url in the browser

Source code from Blink.jl

# Examples
```julia
launch("wwww.google.com")
```
"""
function launchUrl(x)

    @static if Sys.isapple()
        launchUrl(x) = run(`open $x`)
    elseif Sys.islinux()
        launchUrl(x) = run(`xdg-open $x`)
    elseif Sys.iswindows()
        launchUrl(x) = run(`cmd /C start $x`)
    end

end
################################################################

"""
    lanchPage(p)

opens a page of your website in the browser

# Examples
```julia
launchPage("mycontroller")
```
"""
function launchPage(p)

    launchUrl("http://127.0.0.1:8000/$(p)")

end

################################################################

################################################################
# Conditional REQUIRE - https://github.com/MikeInnes/Requires.jl
using Requires
function __init__()
    # edit() in Atm
    @require Atom = "c52e3926-4ff0-5f6e-af25-54175e0327b1" import .Atom:edit
end
################################################################
end

module Agenie

import Genie

export newSection, launchUrl, launchPage, start, newDestination, render, renderStatic

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

"""
    newDestination(name, type)

Create new destination file
* as a html file
* by printing a template function

So type can be :file or :function

# Examples
```julia
examples
```
"""
function newDestination(name, type::Symbol=:file)

    if type == :file

    try
        mkdir(joinpath("app", "destination"))
    catch e

    end
    filePath=joinpath("app", "destination", "$(name).html")
    touch(filePath)

    if !isdefined(Main, :Atom)
        Atom.edit(filePath)
    end

    elseif type ==:function

    # todo: append this to controller file
    println("""

    function $(name)()

    # use your any julia code here to control the outputed html string.

    \"\"\"
    # enter your html code here
    # use \$() to evaluate julia variables or code
    \"\"\"

    end
    """)

    end

end
################################################################

"""
    render(destination, type, var...)

renders variables passed as an input to the destination file, string, or a function that returns string.

You should put \$(var) in the destination file/string so var is evaluated there. Pass the variables as keyword arguments with the same name you used in the html string/file. Variables should be string,

# Examples
```julia
render("destinationName",:function, var1 = value1, var2= value2)
```
"""
function render(destination, type::Symbol = :file; var::String...)

    if type == :file

        # reading string from html file
        try
            filePath = joinpath("app", "destination", "$(destination).html")
            file = open(filePath, "r")
            println("destination file not in destination folder")
        catch e
            try
                filePath = destination
                file = open(filePath, "r")
            catch e2
                println("destination file address is not correct")
            end
        end


        destinationString = read(file, String)
        close(file)

    elseif type == :string

        destinationString=destination

    elseif type == :function

        # assumes funciton with no input, if it has inputs just call it before passing to renderFile
        destinationString = destination()

    end

    try
        s = '"' * '"' * '"' * destinationString * '"' * '"' * '"'
    catch e
        s = destinationString
    end

    # evaluate $() values in the string
    out = eval(Meta.parse(s))

    return out
end
################################################################

"""
    renderStatic(destination, var...)

renders variables passed as an input to the destination file statically. Useful if you don't want a dynamic website.

You should put \$(var) in the destination file/string so var is evaluated there. Pass the variables as keyword arguments with the same name you used in the html string/file. Variables should be string,


# Examples
```julia
renderStatic("destinationFile", var1 = value1, var2 = value2)
```
"""
function renderStatic(destination; var::String...)

    try
        filePath = joinpath("app", "destination", "$(destination).html")
        file = open(filePath, "w")
        println("destination file not in destination folder")
    catch e
        try
            filePath = destination
            file = open(filePath, "w")
        catch e2
            println("destination file address is not correct")
        end
    end

    try
        s = '"' * '"' * '"' * destinationString * '"' * '"' * '"'
    catch e
        s = destinationString
    end

    # evaluate $() values in the string
    out = eval(Meta.parse(s))

    print(file, out)
    close(file)

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

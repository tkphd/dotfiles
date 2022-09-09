# Julia startup config

atreplinit() do repl
    # Display more float digits
    repl.options.iocontext[:compact] = false

    # Make it pretty
    try
        @eval using OhMyREPL
        @eval enable_highlight_markdown(true)
        @eval colorscheme!("Monokai24bit")
        @eval enable_pass!("RainbowBrackets", true)
    catch e
        @warn "error while importing OhMyREPL" e
    end
end

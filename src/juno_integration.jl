######################################################################
#
#     Juno Integration
#
######################################################################

@require Juno begin  # only if/when Juno is loaded

  import Juno

  function Juno.render(i::Juno.Inline, v::VegaLiteVis)
    tmppath = string(tempname(), ".vegalite.html")
    open(tmppath, "w") do io
      writehtml(io, v)
    end

    # Open the browser
    @static if VERSION < v"0.5.0-"
        @osx_only run(`open $tmppath`)
        @windows_only run(`cmd /c start $tmppath`)
        @linux_only   run(`xdg-open $tmppath`)
    else
        if is_apple()
            run(`open $tmppath`)
        elseif is_windows()
            run(`cmd /c start $tmppath`)
        elseif is_linux()
            run(`xdg-open $tmppath`)
        end
    end

    Juno.render(i, nothing) # print nothing in the editor pane
  end

end

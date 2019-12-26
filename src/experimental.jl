function interactive()
    i -> begin
        getparams(i)["selection"] = Dict{String,Any}()
        getparams(i)["selection"]["selector001"] = Dict{String,Any}()
        getparams(i)["selection"]["selector001"]["type"] = "interval"
        getparams(i)["selection"]["selector001"]["bind"] = "scales"
        getparams(i)["selection"]["selector001"]["encodings"] = ["x", "y"]
        getparams(i)["selection"]["selector001"]["on"] = "[mousedown, window:mouseup] > window:mousemove!"
        getparams(i)["selection"]["selector001"]["translate"] = "[mousedown, window:mouseup] > window:mousemove!"
        getparams(i)["selection"]["selector001"]["zoom"] = "wheel!"
        getparams(i)["selection"]["selector001"]["mark"] = Dict("fill"=>"#333", "fillOpacity"=>0.125, "stroke"=>"white")
        getparams(i)["selection"]["selector001"]["resolve"] = "global"
        return i
    end
end

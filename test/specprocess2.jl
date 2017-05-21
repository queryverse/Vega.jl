
module A
end


include("setup.jl")

#################################################################

#####  ExtendedScheme  #####
  - name : String
  - count : Number
  - extent : Array{Any,1}

type VLSpec{T}
  json::String
end

VLSpec{Int64}("abcd")
VLSpec{:yo}("abcd")
VLSpec{"yo"}("abcd")

typeof(JSON.json(Dict(:cdf=>"yo")))

defs["DateTime"].props

wrapper(defs["DateTime"], 12, 20)
wrapper(defs["DateTime"], 12, 20, 10, 10, 10, 10, 10)
wrapper(defs["DateTime"], milliseconds=12)
wrapper(defs["DateTime"], "Monday")
wrapper(defs["DateTime"], day="Monday")
wrapper(defs["DateTime"], day="Monday", "abcd")

wrapper(defs["Axis"], values=[1.2, 3.5])
wrapper(defs["Axis"], values=[])

# TODO : conversion of datetime etc...

################## check of symbols ##############

function juliaTypeof(n::String)
  nn = lowercase(n[1:1]) * n[2:end]
  return match(r"[a-zA-Z]*", nn).match
end

###################################################

using DataFrames

res = DataFrame(on=String[], nn=String[], used=Bool[], typ=DataType[])
for (k,v) in defs
  nk = juliaTypeof(k)
  s = isdefined(Symbol(nk))
  push!(res, (k, nk, s, typeof(v)))
end

show(res)
res[res[:used] ,:]

res[res[:typ] .== StringDef, :]

for p in filter(p -> p.second > 1, collect(countmap(res[:nn])))
  p.second <= 1 && continue
  println(res[res[:nn] .== p.first,:])
end


##############################################################


:( ($k)(args) = $(Expr(:curly, :VLSpec, QuoteNode(k)))(10) )

juliaTypeof("AAAghj")

k, v = "DateTime", defs["DateTime"]

for (k,v) in defs
  println("defining $k")
  sk = Symbol(juliaTypeof(k))
  if isdefined(sk)
    println("   importing $sk ")
    eval( Expr(:import, :Base, sk) )
  end

  @eval( function ($sk)(args...;kwargs...)
            $(Expr(:curly, :VLSpec, QuoteNode(sk)))(
                wrapper(defs[$k], args...;kwargs...))
        end )
  end
end

dateTime(day="Monday", month=14)


########################################

vls =
"""
  {
    "data": {
      "values": [
        {"a": "C", "b": 2}, {"a": "C", "b": 7}, {"a": "C", "b": 4},
        {"a": "D", "b": 1}, {"a": "D", "b": 2}, {"a": "D", "b": 6},
        {"a": "E", "b": 8}, {"a": "E", "b": 4}, {"a": "E", "b": 7}
      ]
    },
    "mark": "point",
    "encoding": {
      "x": {"field": "a", "type": "nominal"}
    }
  }
"""

JSON.parse(vls)

include("render.jl")

po = VLSpec{:plot}(vls) ;
show(po)


JSON.json(Dict("abcd" => VLSpec{:test}("abcs")))

schs = """{
  "\$schema": "https://vega.github.io/schema/vega-lite/v2.json",
  "data": {"url": "data/seattle-temps.csv"},
  "mark": "bar",
  "encoding": {
    "x": {
      "timeUnit": "month",
      "field": "date",
      "type": "temporal"
    },
    "y": {
      "aggregate": "mean",
      "field": "temp",
      "type": "quantitative"
    }
  }
}
"""

plot(data= Url("data/seattle-temps.csv"),
     mark = "bar",
     encoding=encoding(x = fielddef(timeUnit="month",
                                  field="date",
                                  :type="temporal" ),  # pb with 'type' field name
                       y = fielddef(aggregate = "mean",
                                    field="temp",
                                    type = "quantitative" ))
    )

tst(;kwargs...) = println(kwargs)
tst(a=465, :type="bar")

#### tuples of pairs  ########

plot(:data => ("data/seattle-temps.csv"),
     :mark => "bar",
     :encoding => (:x => (:timeUnit => "month",
                          :field => "date",
                          :type => "temporal" ),  # pb with 'type' field name
                   :y => (:aggregate => "mean",
                          :field => "temp",
                          :type => "quantitative" ))
    )




############################################

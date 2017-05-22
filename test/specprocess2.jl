
module A
end



include("setup.jl")

keys(spc)

defs["root"] = toDef(spc)


##############################################################

using DataFrames

ns = DataFrame(pos=String[], nn=String[],
               def=SpecDef[], typ=DataType[],
               nf=Bool[])

function needsfunction(s::SpecDef)
  typeof(s) in [IntDef, NumberDef, BoolDef, StringDef,
                ArrayDef, VoidDef] && return false
  typeof(s) in [ObjDef, RefDef] && return true
  if isa(s, UnionDef)
    return any(needsfunction, s.items)
  else
    error("unknown type $(typeof(s))")
  end
end

lookinto!(s::SpecDef, pos) = nothing

function lookinto!(s::ObjDef,  pos)
  for (k,v) in s.props
    push!(ns, (pos, k, v, typeof(v), needsfunction(v)))
    lookinto!(v, "$pos-$k")
  end
end

function lookinto!(s::UnionDef,  pos)
  for v in s.items
    push!(ns, (pos, "*", v, typeof(v), needsfunction(v)))
    lookinto!(v, "$pos-*")
  end
end

for (k,v) in defs
  lookinto!(v, k)
end
ns


tf(;kwargs...) = println(kwargs)
tf(on=456)
tf(as=456)

unique(ns[:typ])

filt = (ns[:typ] .== UnionDef) & ns[:nf]
ns[ filt, :]
ns[(ns[:typ] .== UnionDef) & ! ns[:nf],:]

######### field names qui sont courts
filt = (length.(Array(ns[:nn])) .<= 3) &
       (ns[:nn] .!= "*") & ns[:nf] &
       ( (ns[:typ] .== ObjDef) | (ns[:typ] .== RefDef) | (ns[:typ] .== UnionDef) )

unique(ns[filt, :nn ])

######### fonctions à créer
filt = (ns[:nn] .!= "*") & ns[:nf] &
       ( (ns[:typ] .== ObjDef) | (ns[:typ] .== RefDef) | (ns[:typ] .== UnionDef) )

unique(ns[filt,:nn])

######### field names sur fontions existantes
filt = (ns[:nn] .!= "*") & ns[:nf] &
       ( (ns[:typ] .== ObjDef) | (ns[:typ] .== RefDef) | (ns[:typ] .== UnionDef) )

unique(ns[filt,:nn])

######### fonctions à créer déjà définies
filt = [ isdefined(Symbol(n)) for n in Array(ns[:nn])] &
       (ns[:nn] .!= "*") & ns[:nf] &
       ( (ns[:typ] .== ObjDef) | (ns[:typ] .== RefDef) | (ns[:typ] .== UnionDef) )

unique(ns[filt, :nn ])

######### fonctions à créer
filt = (ns[:nn] .!= "*") &
       ( (ns[:typ] .== ObjDef) | (ns[:typ] .== RefDef) | (ns[:typ] .== UnionDef) )

ns[filt, : ]
unique(ns[filt, :nn])
countmap(ns[filt, :nn])

unique(typeof.(Array(ns[:nn])))

sort(ns, by= n->length(n))



s = first(defs).second

map(k -> println(k), keys(s.props))

for (k,v) in defs
  if



###################################################################



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

plot(data(url("data/seattle-temps.csv")),
     mark("bar"),
     encoding(x(timeUnit="month", field="date", type="temporal"),
              y(agregate="mean", field="temp", type="quantitative")))

plot(data(url("data/seattle-temps.csv")),
     mark("bar"),
     encoding(x = spec(timeUnit="month", field="date", type="temporal"),
              y = spec(agregate="mean", field="temp", type="quantitative"))


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

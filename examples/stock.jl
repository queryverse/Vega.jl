using DataFrames

using Quandl
df = quandlget("YAHOO/YHOO")

fn = "c:/users/frtestar/downloads/yahoo-scglf.csv"
df = readtable(fn)

data_values(df) +
  encoding_x_temp(:Date,
                  axis  = axis(ticks=10, labelAngle=-45,
                               subdivide=3, labelAlign="right" )) +
  encoding_y_quant(:Close) +
  mark_line() +
  config_cell(width=800) +
  config(timeFormat="%Y")

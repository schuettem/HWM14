using HWM14
using Dates

date = DateTime(2020,8,29, 12, 0, 0) # year, month, day, hour, minute, second

alt = 300.0 # altitude in km
glat = 45.0 # geodedic latitude in degrees
glon = -120.0 # geodedic longitude in degrees
stl = 12.0 # not used
f107a = 150.0 # not used
f107 = 150.0 # not used
ap = Float64[4.0, 4.0] # ap[1]: not used, ap[2]: 3hr ap index

w = HWM14.hwm14(date, alt, glat, glon, stl, f107a, f107, ap)
println(w)
using HWM14

iyd = Int32(100)
sec = Float32(43200.0)
alt = Float32(300.0)
glat = Float32(45.0)
glon = Float32(-120.0)
stl = Float32(12.0)
f107a = Float32(150.0)
f107 = Float32(150.0)
ap = Float32[4.0, 4.0]
w = Float32[0.0, 0.0]

HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap, w)
println(w)
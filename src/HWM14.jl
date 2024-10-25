module HWM14

using Libdl
using Dates

# Load the shared library
const libhwm14_path = joinpath(@__DIR__, "hwm14_fortran", "libhwm14.so")

# Get total winds:
function hwm14(date::DateTime, alt::Float64, glat::Float64, glon::Float64, stl::Float64, f107a::Float64, f107::Float64, ap::Array{Float64,1})
    # date: Date and time in UTC
    # alt: Altitude in km
    # glat: Geodedic latitude in degrees
    # glon: Geodedic longitude in degrees
    # stl: not used
    # f107a: not used
    # f107: not used
    # ap: ap[1]: not used, ap[2]: 3hr ap index
    # Output: w[1]: meridional wind (m/s + northward), w[2]: zonal wind (m/s + eastward)
    libhwm14 = dlopen(libhwm14_path)
    hwm14_sym = Libdl.dlsym(libhwm14, :hwm14_)

    year = Dates.year(date) % 100 # Get the year as yy
    doy = Dates.dayofyear(date) # Get the day of the year
    iyd = year * 1000 + doy # Convert the date to year and day

    # Calculate the time in seconds since midnight UT
    hour = Dates.hour(date)
    min = Dates.minute(date)
    sec = Dates.second(date)
    sec = sec + min*60.0 + hour*3600.0

    ap = [Float32(ap[1]), Float32(ap[2])]
    w = Float32[0.0, 0.0] # Initialize the output array

    ccall(hwm14_sym, Cvoid,
          (Ref{Int32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
          iyd, sec, alt, glat, glon, stl, f107a, f107, ap, w)
    return w
end

# Get quiet time winds: HWM14 with a negative value for ap[2]

# Get disturbance winds in geographic coordinates:
function dwm07(date::DateTime, alt::Float32, glat::Float32, glon::Float32, ap::Array{Float32,1})
    # date: Date and time in UTC
    # alt: Altitude in km
    # glat: Geodedic latitude in degrees
    # glon: Geodedic longitude in degrees
    # ap: ap[1]: not used, ap[2]: 3hr ap index
    # Output: dw[1]: meridional wind (m/s + geo. northward), dw[2]: zonal wind (m/s + geo. eastward)
    libhwm14 = dlopen(libhwm14_path)
    dwm07_sym = Libdl.dlsym(libhwm14, :dwm07_)

    year = Dates.year(date) % 100 # Get the year as yy
    doy = Dates.dayofyear(date) # Get the day of the year
    iyd = year * 1000 + doy # Convert the date to year and day

    # Calculate the time in seconds since midnight UT
    hour = Dates.hour(date)
    min = Dates.minute(date)
    sec = Dates.second(date)
    sec = sec + min*60.0 + hour*3600.0

    dw = Float32[0.0, 0.0] # Initialize the output array
    ccall(dwm07_sym, Cvoid,
          (Ref{Int32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
            iyd, sec, alt, glat, glon, ap, dw)
    return dw
end

# Get disturbance winds in magnetic coordinates:
function dwm07b(mlt::Float32, mlat::Float32, kp::Float32)
    # mlt: Magnetic local time in hours
    # mlat: Magnetic latitude in degrees
    # kp: current 3hr KP index
    # Output: mmpwind: meridional wind (m/s + mag. northward), mzpwind: zonal wind (m/s + mag. eastward)
    libhwm14 = dlopen(libhwm14_path)
    dwm07b_sym = Libdl.dlsym(libhwm14, :dwm07b_)

    mmpwind = Float32(0.0) # Initialize the Output
    mzpwind = Float32(0.0) # Initialize the Output
    ccall(dwm07b_sym, Cvoid,
          (Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
          mlt, mlat, kp, mmpwind, mzpwind)
    return [mmpwind, mzpwind]
end

end # module HWM14

module HWM14

using Libdl
using Dates

const libhwm14_path = joinpath(@__DIR__, "hwm14_fortran", "libhwm14.so")

# Get total winds:
function hwm14(iyd::Int64, sec::Float64, alt::Float64, glat::Float64, glon::Float64, stl::Float64, f107a::Float64, f107::Float64, ap::Array{Float64,1})
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

    ap = [Float32(ap[1]), Float32(ap[2])]
    w = Float32[0.0, 0.0] # Initialize the output array

    ccall(hwm14_sym, Cvoid,
          (Ref{Int32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
          iyd, sec, alt, glat, glon, stl, f107a, f107, ap, w)
    return w
end

# Get quiet time winds: HWM14 with a negative value for ap[2]

# Get disturbance winds in geographic coordinates:
function dwm07(iyd::Int64, sec::Float64, alt::Float64, glat::Float64, glon::Float64, ap::Array{Float64,1})
    # date: Date and time in UTC
    # alt: Altitude in km
    # glat: Geodedic latitude in degrees
    # glon: Geodedic longitude in degrees
    # ap: ap[1]: not used, ap[2]: 3hr ap index
    # Output: dw[1]: meridional wind (m/s + geo. northward), dw[2]: zonal wind (m/s + geo. eastward)
    libhwm14 = dlopen(libhwm14_path)
    dwm07_sym = Libdl.dlsym(libhwm14, :dwm07_)

    ap = [Float32(ap[1]), Float32(ap[2])]
    dw = Float32[0.0, 0.0] # Initialize the output array
    ccall(dwm07_sym, Cvoid,
          (Ref{Int32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
            iyd, sec, alt, glat, glon, ap, dw)
    return dw
end

# Get disturbance winds in magnetic coordinates:
function dwm07b(mlt::Float64, mlat::Float64, kp::Float64)
    # mlt: Magnetic local time in hours
    # mlat: Magnetic latitude in degrees
    # kp: current 3hr KP index
    # Output: mmpwind: meridional wind (m/s + mag. northward), mzpwind: zonal wind (m/s + mag. eastward)
    libhwm14 = dlopen(libhwm14_path)
    dwm07b_sym = Libdl.dlsym(libhwm14, :dwm07b_)

    mmpwind = Ref{Float32}(1.0) # Initialize the Output
    mzpwind = Ref{Float32}(1.0) # Initialize the Output
    ccall(dwm07b_sym, Cvoid,
          (Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
          mlt, mlat, kp, mmpwind, mzpwind)
    return [mmpwind[], mzpwind[]]
end

function iydsec2datetime(iyd::Int64, sec::Float64)
    # Calculate the year
    yy = div(iyd, 1000)
    yyyy_now = Dates.year(now())
    if yy > yyyy_now % 100 # Check if yy is in the 20th or 21st century
        yyyy = 1900 + yy
    else
        yyyy = 2000 + yy
    end

    # Calculate the month and day
    doy = iyd % 1000
    yyyy_mm_dd = Date(yyyy, 1, 1) + Day(doy - 1)

    # Calculate the time in UTC
    hour = div(sec, 3600)
    sec = sec - hour*3600
    minute = div(sec, 60)
    sec = sec - minute*60

    # Create the date and time as a DateTime object
    date = DateTime(yyyy_mm_dd) + Hour(hour) + Minute(minute) + Second(sec)
    return date
end

function datetime2iydsec(date::DateTime)
    # Calculate the year and day of the year
    yyyy = Dates.year(date)
    doy = Dates.dayofyear(date)
    iyd = (yyyy % 100) * 1000 + doy

    # Calculate the time in seconds since midnight UT
    hour = Dates.hour(date)
    minute = Dates.minute(date)
    sec = Dates.second(date)
    sec = sec + minute*60.0 + hour*3600.0
    return iyd, sec
end

end # module HWM14
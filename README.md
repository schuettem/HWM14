# HWM14
This package provides a Julia interface to the Horizontal Wind Model 2014 (HWM14), making it usable within the Julia programming environment. The HWM14 model is an empirical model of the Earth's horizontal wind fields. It was developed by a team of researchers led by Douglas Drob at the Naval Research Laboratory (NRL). The model was further supported and hosted by Jia Yue and Yuta Hozumi at the Community Coordinated Modeling Center (CCMC) at NASA's Goddard Space Flight Center. For more information about the HWM14 model, visit the [CCMC HWM14 page](https://ccmc.gsfc.nasa.gov/models/HWM14~2014/).

Note: This project is not affiliated with NASA, NRL or CCMC in any way.

## Functions
### `hwm14`
Calculates the total wind.
#### Arguments
 - `iyd::Int64`: Date in yyddd format (year and day of the year)
 - `sec::Float64`: Seconds since midnight UT
 - `alt::Float64`: Altitude in km
 - `glat::Float64`: Geodedic latitude in degrees
 - `glon::Float64`: Geodedic longitude in degrees
 - `stl::Float64`: Not used
 - `f107a::Float64`: Not used
 - `f107::Float64`: Not used
 - `ap::Array{Float64,1}`: `ap[1]`: not used, `ap[2]`: 3hr ap index

#### Output
 - `w[1]`: Meridional wind (m/s, positive northward)
 - `w[2]`: Zonal wind (m/s, positive eastward)

#### Example Usage
```julia
using HWM14

# Define input parameters
iyd = 23001  # Date in yyddd format (year and day of the year)
sec = 36000.0  # Seconds since midnight UT
alt = 300.0    # Altitude in km
glat = 45.0    # Geodedic latitude in degrees
glon = -75.0   # Geodedic longitude in degrees
stl = 0.0      # Not used
f107a = 0.0    # Not used
f107 = 0.0     # Not used
ap = [0.0, 4.0]  # ap[1]: not used, ap[2]: 3hr ap index

# Calculate the total wind
w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)

# Output the results
println("Meridional wind (m/s): ", w_total[1])
println("Zonal wind (m/s): ", w_total[2])
```

### `hwm14` quiet time wind
Calculates the quiet time wind. Use the `hwm14` function with a negative value for `ap[2]`.

### `dwm07`
Calculate the disturbance wind in geographic coordinates
#### Arguments
 - `iyd::Int64`: Date in yyddd format (year and day of the year)
 - `sec::Float64`: Seconds since midnight UT
 - `alt::Float64`: Altitude in km
 - `glat::Float64`: Geodedic latitude in degrees
 - `glon::Float64`: Geodedic longitude in degrees
 - `ap::Array{Float64,1}`: `ap[1]`: not used, `ap[2]`: 3hr ap index

#### Output
 - `dw[1]`: Meridional disturbance wind (m/s, positive northward)
 - `dw[2]`: Zonal disturbance wind (m/s, positive eastward)

### `dwm07b`
Calculates the disturbance wind in magnetic coordinates.

#### Arguments
 - `mlt::Float64`: Magnetic local time in hours
 - `mlat::Float64`: Magnetic latitude in degrees
 - `kp::Float64`: Current 3hr Kp index

#### Output
 - `mmpwind`: Meridional disturbance wind (m/s, positive northward)
 - `mzpwind`: Zonal disturbance wind (m/s, positive eastward)

### `iydsec2datetime`
Converts a date in yyddd format and seconds since midnight to a `DateTime` object.

#### Arguments
 - `iyd::Int64`: Date in yyddd format (year and day of the year)
 - `sec::Float64`: Seconds since midnight UT

#### Output
 - `DateTime`: A `DateTime` object representing the date and time in UTC.

### `datetime2iydsec`
Converts a `DateTime` object to a date in yyddd format and seconds since midnight.

#### Arguments
 - `datetime::DateTime`: A `DateTime` object representing the date and time in UTC.

#### Output
 - `iyd::Int64`: Date in yyddd format (year and day of the year)
 - `sec::Float64`: Seconds since midnight UT


## License
This package is licensed under the MIT License.

## References
 - Drob, D. P., et al. (2015), An Update to the Horizontal Wind Model (HWM): The Quiet Time Thermosphere, Earth and Space Science, submitted.
 - Drob, D. P., et al. (2008), An Empirical Model of the Earth's Horizontal Wind Fields: HWM07, J. Geophys Res., 113, doi:10.1029/2008JA013668.
 - Emmert, J. T., et al. (2008), DWM07 global empirical model of upper thermospheric storm-induced disturbance winds, J. Geophys Res., 113, doi:10.1029/2008JA013541.

For more information, visit the [CCMC HWM14 page](https://ccmc.gsfc.nasa.gov/models/HWM14~2014/).

## Acknowledgements
We acknowledge the Community Coordinated Modeling Center (CCMC) at Goddard Space Flight Center for the use of the [horizontal wind model 2014 (HWM14)](https://ccmc.gsfc.nasa.gov/models/HWM14~2014/).

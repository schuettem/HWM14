using HWM14
using Dates
using CairoMakie

date = DateTime(1993,11,19, 12, 0, 0) # year, month, day, hour, minute, second

iyd = 93323
sec = 12.0 * 3600.0

alt = 130.0 # altitude in km
glongitude = LinRange(-180, 180, 20) # geodedic latitude in degrees
glatitude = LinRange(-90, 90, 20) # geodedic longitude in degrees
stl = 12.0 # not used
f107a = 150.0 # not used
f107 = 150.0 # not used
ap = Float64[-1, 35.0] # ap[1]: not used, ap[2]: 3hr ap index

w_zonal = zeros(length(glongitude), length(glatitude))
w_meridional = zeros(length(glongitude), length(glatitude))
for (i, glon) in enumerate(glongitude)
    for (j, glat) in enumerate(glatitude)
        w = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
        w_zonal[i, j] = w[2]
        w_meridional[i, j] = w[1]
    end
end
strength = sqrt.(w_zonal.^2 + w_meridional.^2)

# Plot the zonal wind as a function of longitude and latitude as a contour plot
fig = Figure(size = (800, 800))
ax1 = Axis(fig[1, 1], xlabel = "Longitude", ylabel = "Latitude")
co1 = contourf!(ax1, glongitude, glatitude, w_zonal, colormap = Reverse(:RdBu))
Colorbar(fig[1, 2], co1, label = "Zonal wind (m/s)")

ax2 = Axis(fig[2, 1], xlabel = "Longitude", ylabel = "Latitude")
co2 = contourf!(ax2, glongitude, glatitude, w_meridional, colormap = Reverse(:RdBu))
Colorbar(fig[2, 2], co2, label = "Meridional wind (m/s)")

# ax3 = Axis(fig[3, 1], xlabel = "Longitude", ylabel = "Latitude")
# arrows!(ax3, glongitude, glatitude, w_zonal, w_meridional, arrowsize = 8, lengthscale = 0.1, linecolor = strength)
fig
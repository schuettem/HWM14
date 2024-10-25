module HWM14

using Libdl

# Load the shared library
const libhwm14_path = joinpath(@__DIR__, "hwm14_fortran", "libhwm14.so")


# Define the function signature
function hwm14(iyd::Int32, sec::Float32, alt::Float32, glat::Float32, glon::Float32, stl::Float32, f107a::Float32, f107::Float32, ap::Array{Float32,1}, w::Array{Float32,1})
    libhwm14 = dlopen(libhwm14_path)
    hwm14_sym = Libdl.dlsym(libhwm14, :hwm14_)

    ccall(hwm14_sym, Cvoid,
          (Ref{Int32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}, Ref{Float32}),
          iyd, sec, alt, glat, glon, stl, f107a, f107, ap, w)
end

end # module HWM14

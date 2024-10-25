# Handles the compilation of the Fortran code

# Define the paths
src_dir = joinpath(@__DIR__, "src/", "hwm14_fortran")
lib_path = joinpath(src_dir, "libhwm14.so")
fortran_source = joinpath(src_dir, "hwm14.f90")

# Checl if the library exists
if !isfile(lib_path)
    println("Compiling Fortran code ...")

    # Determine the compiler
    FC = get(ENV, "FC", "gfortran")

    # Compile the Fortran code
    cd(src_dir) do
        run(`$FC -shared -fPIC -o $lib_path $fortran_source`)
    end

    println("Fortran code compiled")
else
    println("Fortran library already exists")
end

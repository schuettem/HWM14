# Handles the compilation of the Fortran code

# Define the paths
dir = @__DIR__
dir = split(dir, "/")
dir = joinpath(dir[1:end-1]...)
src_dir = joinpath(dir, "src", "hwm14_fortran")
library = "libhwm14.so"
fortran_source = "hwm14.f90"

# Check if the library exists
current_dir = pwd()
cd("..")
cd("src/hwm14_fortran")
if !isfile(library)
    @info "Compiling Fortran code ..."

    # Determine the compiler
    FC = get(ENV, "FC", "gfortran")
    @info "Fortran compiler: $FC"

    write(log, "Compiling Fortran code...\n")
    # Compile the Fortran code with the SOURCE_DIR preprocessor directive
    run(`$FC -cpp -shared -fPIC -DSOURCE_DIR=\"$src_dir\" -o $library $fortran_source`)
    write(log, "Compilation complete.\n")

    @info "Fortran code compiled"
else
    write(log, "Source directory already exists. Skipping compilation.\n")
    @info "Source directory already exists. Skipping compilation."
end

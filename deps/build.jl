# Handles the compilation of the Fortran code

# Define the paths
dir = @__DIR__
dir = split(dir, "/")
dir = "/" * joinpath(dir[1:end-1]...)
src_dir = joinpath(dir, "src", "hwm14_fortran")
library = "libhwm14.so"
fortran_source = "hwm14.f90"


# Check if gfortran is installed on Linux and macOS
function check_gfortran_unix()
    try
        run(`which gfortran`)
        return true
    catch
        return false
    end
end

# Check if gfortran is installed on Windows
function check_gfortran_windows()
    try
        run(`where gfortran`)
        return true
    catch
        return false
    end
end

# Install gfortran on Linux
function install_gfortran_linux()
    @info "gfortran not found. Installing on Linux..."
    run(`sudo apt-get update`)
    run(`sudo apt-get install -y gfortran`)
end

# Install gfortran on macOS
function install_gfortran_macos()
    @info "gfortran not found. Installing on macOS..."
    run(`brew install gfortran`)
end

# Install gfortran on Windows
function install_gfortran_windows()
    @info "gfortran not found. Installing on Windows..."
    run(`choco install mingw`)
end

# Install gfortran based on the operating system
function install_gfortran()
    if Sys.islinux()
        install_gfortran_linux()
    elseif Sys.isapple()
        install_gfortran_macos()
    elseif Sys.iswindows()
        install_gfortran_windows()
    else
        error("Unsupported operating system")
    end
end

# Check if gfortran is installed and install if necessary
function ensure_gfortran_installed()
    if Sys.islinux() || Sys.isapple()
        if !check_gfortran_unix()
            install_gfortran()
        end
    elseif Sys.iswindows()
        if !check_gfortran_windows()
            install_gfortran()
        end
    else
        error("Unsupported operating system")
    end
end

# Check if the library exists
current_dir = pwd()
@info "Current directory: $current_dir"
@info "Source directory: $src_dir"
cd("..")
cd("src/hwm14_fortran")
if !isfile(library)
    @info "Compiling Fortran code ..."

    @info "Check if gfortran is installed..."
    ensure_gfortran_installed()

    # Determine the compiler
    FC = "gfortran"
    @info "Fortran compiler: $FC"

    # Compile the Fortran code with the SOURCE_DIR preprocessor directive
    run(`$FC -cpp -shared -fPIC -DSOURCE_DIR=\"$src_dir\" -o $library $fortran_source`)

    @info "Fortran code compiled"
else
    @info "Source directory already exists. Skipping compilation."
end

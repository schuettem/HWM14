using HWM14
using Test
using DataFrames
using Dates
using CSV

@testset "HWM14.jl" begin
    include("test_hwm14.jl")
    include("test_date.jl")
end
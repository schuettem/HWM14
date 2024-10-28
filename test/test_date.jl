@testset "Conversion date time <-> iyd, sec" begin
    @testset "Conversion iyd, sec -> date time" begin
        iyd = 95150 # yyddd
        ut = 12.0
        sec = ut * 3600.0

        # Test conversion from iyd and sec to date and time
        date = HWM14.iydsec2datetime(iyd, sec)
        @test Dates.year(date) == 1995
        @test Dates.month(date) == 5
        @test Dates.day(date) == 30
        @test Dates.hour(date) == 12
        @test Dates.minute(date) == 0
        @test Dates.second(date) == 0
    end

    @testset "Conversion date time -> iyd, sec" begin
        date = DateTime(1995, 5, 30, 12, 0, 0)

        # Test conversion from date and time to iyd and sec
        iyd, sec = HWM14.datetime2iydsec(date)
        @test iyd == 95150
        @test sec == 12 * 3600.0
    end
end

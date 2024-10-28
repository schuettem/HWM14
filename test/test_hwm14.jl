# Reference:
# https://map.nrl.navy.mil/map/pub/nrl/HWM/HWM14/HWM14_ess224-sup-0002-supinfo/checkhwm14.f90

@testset "Test HWM14" begin
    @testset "Height profile" begin # from checkhwm14.f90
        day = 150
        iyd = 95000 + day # yyddd
        ut = 12.0
        sec = ut * 3600.0
        glat = -45.0
        glon = -85.0
        stl = 6.3
        ap = [0, 80.] # ap[1]: not used, ap[2]: 3hr ap index
        apqt = [0, -1.0] # apqt[1]: not used, apqt[2]: quiet time ap index
        f107a = 150.0 # not used
        f107 = 150.0 # not used

        # transform iyd and ut to date DateTime
        # year = div(iyd, 1000) + 1900
        # day = iyd - year*1000
        # date = DateTime(year, 1, 1) + Dates.Day(day-1) + Dates.Hour(ut)

        # load csv file with height profile
        data = CSV.read("data/test_height_profile.csv", DataFrame)
        # alt, mer_q, zon_q, mer_d, zon_d, mer_t, zon_t

        # Test the quiet time, disturbed, and total winds
        for (i, alt) in enumerate(0:25:400)
            alt = Float64(alt)
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Latitude profile" begin # from checkhwm14.f90
        day = 305
        iyd = 95000 + day # yyddd
        ut = 18.0
        sec = ut * 3600.0
        alt = 250.0
        glon = 30.0
        stl = 20.0
        ap = [0.0, 48.0]
        apqt = [0.0, -1.0]
        f107a = 150.0
        f107 = 150.0

        # load csv file with latitude profile
        data = CSV.read("data/test_latitude_profile.csv", DataFrame)

        # Test the quiet time, disturbed, and total winds
        for (i, glat) in enumerate(-90:10:90)
            glat = Float64(glat)
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Local time profile" begin
        day = 75
        iyd = 95000 + day # yyddd
        alt = 125.0
        glat = 45.0
        glon = -70.0
        ap = [0.0, 30.0]
        apqt = [0.0, -1.0]
        f107a = 150.0
        f107 = 150.0

        # load csv file with local time profile
        data = CSV.read("data/test_local_time_profile.csv", DataFrame)

        # Test the quiet time, disturbed, and total winds
        for (i, stl) in enumerate(0:1:16)
            stl = 1.5 * Float64(stl)
            sec = (stl - glon/15.0) * 3600.0
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Longitude profile" begin
        day = 330
        iyd = 95000 + day
        ut = 6.0
        sec = ut * 3600.0
        alt = 40.0
        glat = -5.0
        ap = [0.0, 4.0]
        apqt = [0.0, -1.0]
        f107a = 150.0
        f107 = 150.0
        stl = 0.0

        # load csv file with longitude profile
        data = CSV.read("data/test_longitude_profile.csv", DataFrame)

        # Test the quiet time, disturbed, and total winds
        for (i, glon) in enumerate(-180:20:180)
            glon = Float64(glon)
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Day of year profile" begin
        ut = 21.0
        sec = ut * 3600.0
        alt = 200.0
        glat = -65.0
        glon = -135.0
        stl = 12.0
        ap = [0.0, 15.0]
        apqt = [0.0, -1.0]
        f107a = 150.0
        f107 = 150.0

        # load csv file with day of year profile
        data = CSV.read("data/test_day_of_year_profile.csv", DataFrame)

        # Test the quiet time, disturbed, and total winds
        for (i, day) in enumerate(0:20:360)
            iyd = 95000 + day
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Magnetic acticity profile" begin
        day = 280
        iyd = 95000 + day
        ut = 21.0
        sec = ut * 3600.0
        alt = 350.0
        glat = 38.0
        glon = 125.0
        stl = 5.3
        ap = [0.0, 48.0]
        apqt = [0.0, -1.0]
        f107a = 150.0
        f107 = 150.0

        # load csv file with magnetic activity profile
        data = CSV.read("data/test_magnetic_activity_profile.csv", DataFrame)

        # Test the quiet time, disturbed, and total winds
        for (i, iap) in enumerate(0.:20.:260.)
            ap[2] = iap
            w_quiet = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, apqt)
            @test w_quiet[1] ≈ data[i, 2] atol=0.1 # meridional quiet time wind
            @test w_quiet[2] ≈ data[i, 3] atol=0.1 # zonal quiet time wind
            w_distubed = HWM14.dwm07(iyd, sec, alt, glat, glon, ap)
            @test w_distubed[1] ≈ data[i, 4] atol=0.1 # meridional disturbed wind
            @test w_distubed[2] ≈ data[i, 5] atol=0.1 # zonal disturbed wind
            w_total = HWM14.hwm14(iyd, sec, alt, glat, glon, stl, f107a, f107, ap)
            @test w_total[1] ≈ data[i, 6] atol=0.1 # meridional total wind
            @test w_total[2] ≈ data[i, 7] atol=0.1 # zonal total wind
        end
    end

    @testset "Magnetic latitude profile" begin
        kp = 6.0
        mlt = 3.0

        # load csv file with magnetic latitude profile
        data = CSV.read("data/test_magnetic_latitude_profile.csv", DataFrame)

        for (i, mlat) in enumerate(-90:10:90)
            mlat = Float64(mlat)
            w = HWM14.dwm07b(mlt, mlat, kp)
            @test w[1] ≈ data[i, 2] atol=0.1 # meridional wind
            @test w[2] ≈ data[i, 3] atol=0.1 # zonal wind
        end
    end

    @testset "Magnetic local time profile" begin
        mlat = 45.0
        kp = 6.0

        # load csv file with magnetic local time profile
        data = CSV.read("data/test_magnetic_local_time_profile.csv", DataFrame)

        for (i, imlt) in enumerate(0:1:16)
            mlt = imlt * 1.5
            w = HWM14.dwm07b(mlt, mlat, kp)
            @test w[1] ≈ data[i, 2] atol=0.1 # meridional wind
            @test w[2] ≈ data[i, 3] atol=0.1 # zonal wind
        end
    end

    @testset "Magnetic kp profile" begin
        mlat = -50.0
        mlt = 3.0

        # load csv file with magnetic kp profile
        data = CSV.read("data/test_magnetic_kp_profile.csv", DataFrame)

        for (i, ikp) in enumerate(0:1:18)
            kp = ikp * 0.5
            w = HWM14.dwm07b(mlt, mlat, kp)
            @test w[1] ≈ data[i, 2] atol=0.1 # meridional wind
            @test w[2] ≈ data[i, 3] atol=0.1 # zonal wind
        end
    end
end
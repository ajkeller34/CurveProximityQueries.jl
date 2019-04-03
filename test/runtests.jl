using CurveProximityQueries
using Test
using LinearAlgebra
using StaticArrays
using IntervalArithmetic
using Random: seed!

@testset "CurveProximityQueries" begin
    @testset "Obstacles" begin
        @test typeof(randpoly(rand(2), n=3, scale=rand())) <: ConvexPolygon{2, 3}
        @test typeof(randpoly(rand(2), n=8, scale=π)) <: ConvexPolygon{2, 8}
        @test typeof(randpoly(rand(2), n=15, scale=rand())) <: ConvexPolygon{2, 15}
        @test typeof(@point rand(2)) <: ConvexPolygon{2, 1}
        @test typeof(@point rand(3)) <: ConvexPolygon{3, 1}
        @test typeof(@line rand(2), rand(2)) <: ConvexPolygon{2, 2}
        @test typeof(@line rand(3), rand(3)) <: ConvexPolygon{3, 2}
        @test typeof(@rect rand(2), rand(2)) <: ConvexPolygon{2, 4}
        @test typeof(@rect rand(3), rand(3)) <: ConvexPolygon{3, 8}
        @test typeof(@square rand(2), π) <: ConvexPolygon{2, 4}
        @test typeof(@square rand(3), rand()) <: ConvexPolygon{3, 8}
    end
    @testset "Bernstein Polynomials" begin
        B2 = rand(Bernstein{2,8})
        B3 = rand(Bernstein{3,5})
        @test typeof(B2) <: Bernstein{2,8}
        @test typeof(B3) <: Bernstein{3,5}
        @test sum(norm.((differentiate(integrate(B2.f)) - B2.f).control_points)) ≤ 1e-10
        @test sum(norm.((differentiate(integrate(B3.f)) - B3.f).control_points)) ≤ 1e-10
    end
    @testset "Curve - Polygon" begin
        seed!(1)
        obs = @point zeros(2)
        c = rand(Bernstein{2,7})
        @test abs(minimum_distance(obs, c) - 0.3683522584741768) ≤ 1e-5
        @test tolerance_verification(obs, c, 0.3) == true
        @test tolerance_verification(obs, c, 0.4) == false
        @test collision_detection(obs, c) == false
        @test abs(minimum_distance(c, obs) - 0.3683522584741768) ≤ 1e-5
        @test tolerance_verification(c, obs, 0.3) == true
        @test tolerance_verification(c, obs, 0.4) == false
        @test collision_detection(c, obs) == false

        seed!(1)
        obs = @point zeros(3)
        c = rand(Bernstein{3,11})
        @test abs(minimum_distance(obs, c) - 0.511627527056288) ≤ 1e-5
        @test tolerance_verification(obs, c, 0.5) == true
        @test tolerance_verification(obs, c, 0.6) == false
        @test collision_detection(obs, c) == false
        @test abs(minimum_distance(c, obs) - 0.511627527056288) ≤ 1e-5
        @test tolerance_verification(c, obs, 0.5) == true
        @test tolerance_verification(c, obs, 0.6) == false
        @test collision_detection(c, obs) == false
    end
    @testset "Curve - Curve" begin
        seed!(1)
        c = rand(Bernstein{2,7})
        d = rand(Bernstein{2,3})
        @test abs(minimum_distance(c, d)) ≤ 1e-5
        @test tolerance_verification(c, d, 0.3) == false
        @test collision_detection(c, d) == true

        seed!(1)
        obs = @point zeros(3)
        c = rand(Bernstein{3,11})
        d = rand(Bernstein{3,5})
        @test abs(minimum_distance(c, d) - 0.137873546917387) ≤ 1e-5
        @test tolerance_verification(c, d, 0.1) == true
        @test tolerance_verification(c, d, 0.3) == false
        @test collision_detection(c, d) == false
    end
end

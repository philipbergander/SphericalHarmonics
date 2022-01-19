module SphericalHarmonics_Mod
    using LegendrePolynomials

    export Calc_SphericalHarmonics

    function Calc_SphericalHarmonics(l::Int64,m::Int64,n::Int64 = 50)

        #Create meshgrid
        theta = range(0,pi,length=n)' .* ones(n,1)
        phi = range(0,2*pi,length=n) .* ones(1,n)

        #Calculate spherical harmonics
        Y = harmonicY(l,m,theta,phi,"real")

        # Transform from spherical to cartesian coordinates
        x,y,z = sph2cart(phi, pi/2 .- theta, abs.(Y))

        return x,y,z,Y
    end

    function harmonicY(l::Int64,m::Int64,th::Matrix{Float64},phi::Matrix{Float64},type::String)
        # Calculate the spherical harmonic Ylm
        # Translation of: Javier Montalt Tordera (2022). Spherical Harmonics (https://github.com/jmontalt/harmonicY/releases/tag/v2.0.1), GitHub. Retrieved January 19, 2022. 

        @assert abs(m) <= l "abs(m) > l!"

        isoddm = isodd(m)
        isnegm = m < 0

        # Quantum mechanical norm, se Wiki. 
        # Factorials can overflow Float64 for l > 19, hence "big". 
        C = (-1)^m*sqrt((2*l+1)/(4*pi)*factorial(big(l-m))/factorial(big(l+m)))

        C = Float64(C)

        m = abs(m)
        P = Plm.(cos.(th),l,m)

        if type=="real"
            if isnegm
                E = sin.(m*phi)
            else
                E = cos.(m*phi)
            end
        else
            E = exp.(1im*m*phi)
            if isnegm
                conj!(E)
                if isoddm
                    E = -E
                end
            end
        end

        # Surface spherical harmonics
        Y = C * P .* E

        return Y
    end

    function sph2cart(az::Matrix{Float64},el::Matrix{Float64},r::Matrix{Float64})
        #Spherical to cartesian

        z = r .* sin.(el)
        rcoselev = r .* cos.(el)
        x = rcoselev .* cos.(az)
        y = rcoselev .* sin.(az)

        return x,y,z
    end
end
(@isdefined(SphericalHarmonics_Mod)) ? nothing : include("M:\\Vågutbredning\\Spherical Harmonics\\SphericalHarmonics.jl")
using .SphericalHarmonics_Mod
using Plots

function main()

    pyplot(size=(1080,1080))

    anim = @animate for l in 0:20, m = 0:l

        x,y,z,Y = Calc_SphericalHarmonics(l,m,500)
        if l==0
            surface(x,y,z, legend = nothing, show = false, axis=([], false))
        else
            surface(x,y,z, legend = nothing, fill_z = abs.(Y), show = false, axis=([], false))
        end
        title!(string("l = ", l, ", m = ", m))

    end

    gif(anim,"C:\\Users\\phiber\\Downloads\\anim1.gif",fps=2)
    
    return


end

main()
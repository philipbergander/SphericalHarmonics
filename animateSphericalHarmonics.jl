filePath = @__DIR__
(@isdefined(SphericalHarmonics_Mod)) ? nothing : include(string(filePath,"\\SphericalHarmonics.jl"))
using .SphericalHarmonics_Mod
using Plots

savepath = string(filePath,"\\anim.gif")

function main(savepath)

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

    gif(anim,savepath,fps=2)
    
    return


end

main(savepath)
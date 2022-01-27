filePath = @__DIR__
(@isdefined(SphericalHarmonics_Mod)) ? nothing : include(string(filePath,"\\SphericalHarmonics.jl"))
using .SphericalHarmonics_Mod
using Plots
using Interpolations

savepath = string(filePath,"\\anim.gif")

function main(savepath)

    #pyplot is very slow, use gr for faster (but not as pretty plots)
    pyplot(size=(1080,1080))

    # l-values to be plotted
    lmax = 20 
    sz = sum((lmax:lmax).+1) #Number of m-values

    N = 500; #Meshgrid in plot is NxN

    x = Array{Float64}(undef,N,N,sz)
    y = Array{Float64}(undef,N,N,sz)
    z = Array{Float64}(undef,N,N,sz)
    Ylm = Array{Float64}(undef,N,N,sz)

    println("Calculating Ylm")
    
    idx = 1
    for l in lmax:lmax, m = 0:l
        x[:,:,idx],y[:,:,idx],z[:,:,idx],Ylm[:,:,idx] = Calc_SphericalHarmonics(l,m,N)
        idx += 1
    end

    sz = idx-1
    x = x[:,:,begin:sz]
    y = y[:,:,begin:sz]
    z = z[:,:,begin:sz]
    Ylm = Ylm[:,:,begin:sz]

    interpVals = 49 #Number of values used for interpolation between each m-value. Use 49 to get 1 m-value plotted per 2 seconds in the gif.

    X = Array{Float64}(undef,N,N,sz*interpVals)
    Y = Array{Float64}(undef,N,N,sz*interpVals)
    Z = Array{Float64}(undef,N,N,sz*interpVals)
    YLM = Array{Float64}(undef,N,N,sz*interpVals)

    println("Interpolating")
    for i = 1:N, j = 1:N

        xs = 1:sz
        xintp = range(1,sz,sz*interpVals)

        interp  = LinearInterpolation(xs,x[i,j,:])
        X[i,j,:] .= interp.(xintp) 

        interp  = LinearInterpolation(xs,y[i,j,:])
        Y[i,j,:] .= interp.(xintp) 

        interp  = LinearInterpolation(xs,z[i,j,:])
        Z[i,j,:] .= interp.(xintp) 

        interp  = LinearInterpolation(xs,Ylm[i,j,:])
        YLM[i,j,:] .= interp.(xintp) 

    end


    println("Animating")
    anim = @animate for i = 1:sz*interpVals
        println(i,"/",sz*interpVals)
        
        surface(X[:,:,i],Y[:,:,i],Z[:,:,i], legend = nothing, fill_z = abs.(YLM[:,:,i]), axis=([], false), show = false)

    end

    println("Saving gif")
    gif(anim,savepath,fps=24)
    
    return


end

main(savepath)

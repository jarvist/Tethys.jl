@testset "BareExpansion" begin

MAX_ORDER=2
diag=Tethys.Diag(0,1.0,MAX_ORDER,[0.1,0.2,1.0 , 0.3,0.4,1.0], [0,0,0,0,0,0])

GF=Tethys.BareExpansion(diag)
@test GF ≈ -0.7444 atol=0.1 

println("Splish splash: ",diag," ==♓> ", GF)

GF=Tethys.Monte!(diag)
println("Monte: ", GF)

fout=open("Monte.dat","w")
for i in 1:100
    GF=Tethys.Monte!(diag)
    @printf(fout,"%d %f \n",i,GF)
end
close(fout)

end


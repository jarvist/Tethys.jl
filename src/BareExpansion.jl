# Starting with §3, a minimalist bare expansion for the Green function of the Frohlich polaron
# [1] Greitemann, J.; Pollet, L. Lecture Notes on Diagrammatic Monte Carlo for the Fröhlich Polaron. SciPost Phys. Lect. Notes 2018, 2. https://doi.org/10.21468/SciPostPhysLectNotes.2.

const MAX_ORDER=2
const α=1.5

struct Diag
    p # external momentum
    τ # external time

    O::Int # Order, integer

    phonon::SMatrix{MAX_ORDER, 3, Float64}
end


function BareExpansion(d::Diag)
# See (24) page 12 in [1], Trying to be as close to the maths as possible.
    
    # need to sort these in time in order to be able to calculate electron
    # momentum as phonons are emitted and absorbed
    # Generation of a phonon loses that phonon's momentum from the electron,
    # and vice versa

    # location of every phonon vertex in time, with change in momentum of
    # electron
    deltas=[ [p[1], -p[3], p[2], p[3]] for p in eachrow(d.phonon)]
    
    logG0tot=0
    p=d.p
    t=0
    for d in deltas
        Δτ=d[1]-t
        t=d[1]
        p=p+d[2]
        logG0tot+=logG0(p,Δτ)
    end

    GF=- α^d.O * 
    exp(logG0tot + sum(logD̃.(d.phonon[:,3], d.phonon[:,2] .- d.phonon[:,1])))
	# Is this all there is?
	
end

const μ=0 # chemical potential is the bane of my life
const m=1
function logG0(p,Δτ)
    -(p^2/2m-μ)*Δτ
end

const ωph=1
function logD̃(q,Δτ)
    -ωph * Δτ
end

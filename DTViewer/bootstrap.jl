(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using DTViewer
push!(Base.modules_warned_for, Base.PkgId(DTViewer))
DTViewer.main()

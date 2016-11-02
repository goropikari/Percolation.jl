using Percolation
using Base.Test

# write your own tests here
#@test 1 == 2
site = squarenn(10,10,0.5)
percolation(site)
percolation(site, water=false)
percolation(site, water=false, colorbar=false)
percolation(site, water=false, color="hot")
percolation(site, water=false, fig=false)

site = squarenn(10,10,0.5)
percolationgif(site)


site = squarennn(10,10,0.5)
percolation(site)
percolation(site, water=false)
percolation(site, water=false, colorbar=false)
percolation(site, water=false, color="hot")
percolation(site, water=false, fig=false)

site = squarennn(10,10,0.5)
percolationgif(site)

site = trinn(100,100,0.5)
percolation(site)

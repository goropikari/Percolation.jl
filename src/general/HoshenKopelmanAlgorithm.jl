###############################
# Hoshen Kopelman Algorithm
###############################
function unionHK(i, j, labels)
    labels[findHK(maximum([i,j]), labels)] = findHK(minimum([i,j]), labels)
end

function findHK(x, labels)
    y = x
    while (labels[y] != y)
        y = labels[y]
    end

## このwhile文、不要じゃね？
    while (labels[x] != x) 
        z = labels[x]
        labels[x] = y
        x = z
    end
    
    return y
end

function HK(occupied)
    n_rows, n_columns = size(occupied)
    labels = collect(1:n_rows * n_columns)
    largest_label = 0
    for i in 1:n_rows
        for j in 1:n_columns
            if occupied[i,j] == 1
                if j == 1
                    left = 0
                else
                    left = occupied[i,j-1]
                end
                
                if i == 1
                    above = 0
                else
                    above = occupied[i-1,j]
                end
                
                if left == 0 && above == 0
                    largest_label += 1
                    occupied[i,j] = largest_label
                elseif left != 0 && above == 0
                    occupied[i,j] = findHK(left, labels)
                elseif left == 0 && above != 0
                    occupied[i,j] = findHK(above, labels)
                else
                    unionHK(left, above, labels)
                    occupied[i,j] = findHK(minimum([left, above]), labels)
                end
            end
        end
    end
    return largest_label, labels
end



#########################
# recursive function
#########################
function recursive(occupied)
    (row, column) = size(occupied)
    labelnum = 101
    for i in 1:row, j in 1:column
        if occupied[i,j] == 1
            checkcluster(i, j, labelnum, occupied)
            labelnum += 1
        end
    end
    
    return labelnum - 100
end

# square lattice nearest neighbor
function checkcluster(i::Int, j::Int, labelnum::Int, occupied::Matrix{Int})
    (row,  column) = size(occupied)
    if occupied[i,j] == 1
        occupied[i,j] = labelnum
        if j < column; checkcluster(i, j+1, labelnum, occupied); end
        if 1 < j; checkcluster(i, j-1, labelnum, occupied); end
        if i < row; checkcluster(i+1, j, labelnum, occupied); end
        if 1 < i; checkcluster(i-1, j, labelnum, occupied); end
    end
end




## sample
#N = 7
#occupied = (rand(N, N) .< 0.6) * 1
#occupied = [
#       0  0  0  1  1  0  1
#        1  1  1  1  0  1  1
#        0  0  1  0  1  1  1
#        0  0  1  0  1  1  0
#        1  0  0  0  1  1  1
#        1  0  1  0  0  1  0
#        1  1  1  1  1  1  1]
#HKA = occupied[:,:]; rec = occupied[:,:]
#@time max, label = HK(HKA)
#modHKA = HKA[:,:]
#@time recursive(rec)
#for i in 0:length(label)-1
#   x = length(label)-i
#   while (label[x] != x)
#       x = label[x]
#   end
   
#   label[length(label)-i] = x
#end

#for i in 1:length(modHKA)
#   if modHKA[i] != 0
#       modHKA[i] = label[modHKA[i]]
#   end
#end
#rec .-= 100
#rec[rec .== -100] .= 0
#occupied
#HKA
#modHKA
#rec
#modHKA == rec

## 2つめのwhileをコメントした場合
#julia> HKA
#7×7 Array{Int64,2}:
# 0  0  0  1  1  0  2
# 3  3  3  1  0  4  2
# 0  0  1  0  5  2  2
# 0  0  1  0  2  2  0
# 6  0  0  0  2  2  2
# 6  0  7  0  0  2  0
# 6  6  6  6  6  2  2

#julia> modHKA
#7×7 Array{Int64,2}:
# 0  0  0  1  1  0  2
# 1  1  1  1  0  2  2
# 0  0  1  0  2  2  2
# 0  0  1  0  2  2  0
# 2  0  0  0  2  2  2
# 2  0  6  0  0  2  0
# 2  2  2  2  2  2  2

#julia> rec
#7×7 Array{Int64,2}:
# 0  0  0  1  1  0  2
# 1  1  1  1  0  2  2
# 0  0  1  0  2  2  2
# 0  0  1  0  2  2  0
# 2  0  0  0  2  2  2
# 2  0  2  0  0  2  0
# 2  2  2  2  2  2  2

maps <- LETTERS[1:5]

2^length(maps)


g <- expand.grid(lapply(maps, function(x) c(1,0) ))
names(g) <- maps

g$class <- 31:0

g$probability <- seq(1,0, length.out = nrow(g))


g


# maybe we encode the values as powers of 10
# so the best map is 10^4
# the second best is 10^3
# the third best is 10^2
# the 4th best is 10^1
# the 5th best is 10^0

# so we can then add them up and get a binary encoding
# when all agree it is 11111
# when all but the worst agree it is 11110

# alternatively we really only need a byte to encode it, not sure how this is done best. 

# binary is even better!!!!

g2 <- t(apply(g[,1:length(maps)], 1, function(x) x* 2^(0:(length(maps)-1))  ))
g2 <- cbind(g2, apply(g2,1,sum))

g2[,6]/(2^5 -1)

g3 <- t(apply(g[,1:length(maps)], 1, function(x) x*  1/(2^length(maps) - 1) * 2^(0:(length(maps)-1))  ))
# weights
1/(2^length(maps) - 1) * 2^(0:(length(maps)-1))

g3 <- cbind(g3, apply(g3,1,sum))


g$probability <-  apply(g[,1:5],1, function(x){ round(x %*% c(17.20430, 17.74194, 18.81720, 20.96774, 25.26882)) })

g$class <- rank(g$probability)
g <- g[order(-g$probability),]

g$linprob <- 100*(g$class-1)/31
g

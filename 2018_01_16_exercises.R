# Exercise 1

## * If x is greater than 3 and y is less than or equal to 3 then print "Hello world!"
##  
## * Otherwise if x is greater than 3 print "!dlrow olleH"
## 
## * If x is less than or equal to 3 then print "Something else ..."
##
## * Stop execution if x is odd and y is even and report an error, don't print any of the text strings above.

x = 5
y = 4

if (x %% 2 == 1 & y %% 2 == 0) {
  stop("Error")
}

if (x > 3) {
  if (y <=3)
    "Hello World!"
  else
    "!dlrow olleH"
} else if (x <= 3) {
  "Something else ..."
}




# Loop error

x = integer();5:10
length(x)

for(i in seq_along(x))
{
  cat(i,"")
}



# Lazy evaluation

g = function(x, z = x+y)
{
  y = 2
  z
}

g(1)
g(5)


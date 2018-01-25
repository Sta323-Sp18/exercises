# Exercise 1

levels = c("sun", "partial clouds", "clouds", "rain", "snow")

weather = c(2L, 1L, 2L, 2L, 3L, 1L, 1L, 2L)
attr(weather, "levels") = levels
attr(weather, "class") = "factor"

factor(c("partial clouds", "sun", "partial clouds", "partial clouds", "clouds", "sun", "sun", "partial clouds"))

factor(c("partial clouds", "sun", "partial clouds", "partial clouds", "clouds", "sun", "sun", "partial clouds"), 
      levels = levels)



# Exercise 2

# Skipped


# Exercise 3

x = c(56, 3, 17, 2, 4, 9, 6, 5, 19, 5, 2, 3, 5, 0, 13, 12, 6, 31, 10, 21, 8, 4, 1, 1, 2, 5, 16, 1, 3, 8, 1,
      3, 4, 8, 5, 2, 8, 6, 18, 40, 10, 20, 1, 27, 2, 11, 14, 5, 7, 0, 3, 0, 7, 0, 8, 10, 10, 12, 8, 82,
      21, 3, 34, 55, 18, 2, 9, 29, 1, 4, 7, 14, 7, 1, 2, 7, 4, 74, 5, 0, 3, 13, 2, 8, 1, 6, 13, 7, 1, 10,
      5, 2, 4, 4, 14, 15, 4, 17, 1, 9)

# Select every third value starting at position 2 in x.

x[ seq(2, length(x), by = 3) ]

x[c(FALSE, TRUE, FALSE)]


# Remove all values with an odd index (e.g. 1, 3, etc.)

x[seq_along(x) %% 2 != 1]


# Remove every 4th value, but only if it is odd.

x[!((seq_along(x) %% 4 == 0) & (x %% 2 == 1))]



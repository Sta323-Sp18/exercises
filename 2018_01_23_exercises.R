# Exercise 1

## Part 1

c(1, NA+1L, "C") # Character

c(1L / 0, NA)    # Double

c(1:3, 5)        # Double

c(3L, NaN+1L)    # Double

c(NA, TRUE)      # Logical

## Part 2

# Character > Double > Integer > Logical


# Exercise 2

j = list(
  firstName = "John",
  lastName = "Smith",
  age = 25,
  address = 
  list(
    streetAddress = "21 2nd Street",
    city = "New York",
    state = "NY",
    postalCode = 10021
  ),
  phoneNumber = list(
      list(
        type = "home",
        number = "212 555-1239"
      ),
      list(
        type = "fax",
        number = "646 555-4567"
      )
  )
)

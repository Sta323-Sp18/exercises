library(stringr)


# Example

text = c("apple", "(219) 733-8965", "(329) 293-8753", "(111) 111-1111")

str_detect(text, "\\(\\d\\d\\d\\) \\d\\d\\d-\\d\\d\\d\\d")



str_replace_all(text, "[aeiou]", "&")

# Exercise 1

names = c("Haven Giron", "Newton Domingo", "Kyana Morales", "Andre Brooks", 
          "Jarvez Wilson", "Mario Kessenich", "Sahla al-Radi", "Trong Brown", 
          "Sydney Bauer", "Kaleb Bradley", "Morgan Hansen", "Abigail Cho", 
          "Destiny Stuckey", "Hafsa al-Hashmi", "Condeladio Owens", "Annnees el-Bahri", 
          "Megan La", "Naseema el-Siddiqi", "Luisa Billie", "Anthony Nguyen")

## detects if the person's first name starts with a vowel (a,e,i,o,u)

names[ str_detect(names, "^[AEIOU]") ]
names[ str_detect(tolower(names), "^[aeiou]") ]

## detects if the person's last name starts with a vowel

names[ str_detect(names, " [AEIOUaeiou]") ]
names[ str_detect(tolower(names), " [aeiou]") ]

## detects if either the person's first or last name start with a vowel

names[ str_detect(tolower(names), "(^[aeiou])|( [aeiou])") ]

## detects if neither the person's first nor last name start with a vowel

names[ !str_detect(tolower(names), " [aeiou]") & !str_detect(tolower(names), "^[aeiou]") ]

names[ str_detect(tolower(names), "^[^aeiou].* [^aeiou]") ]


# Exercise 2

text = c("apple", "219 733 8965", "329-293-8753", "Work: (579) 499-7527; Home: (543) 355 3679")

str_match_all(text, "\\(?(\\d{3})\\)?[ -](\\d{3})[ -](\\d{4})")

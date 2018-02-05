library(stringr)
library(purrr)

allowed_files = c("hw2.Rmd",
                  "hw2.Rproj",
                  "hw2_whitelist.R",
                  "README.md",
                  "wercker.yml",
                  "lego_sales.rds",
                  ".gitignore")

files = dir()
disallowed_files = !map_lgl(files, ~ any(str_detect(., allowed_files)))

if (any(disallowed_files))
{
  cat("Disallowed files found:\n")
  cat("  (remove the following files from your repo)\n\n")

  for(file in files[disallowed_files])
    cat("*",file,"\n")

  quit("no",1,FALSE)
}

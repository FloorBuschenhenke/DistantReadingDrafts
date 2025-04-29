## voor python gedoetjes

# Create a new virtualenv called "r-reticulate"
reticulate::virtualenv_create("r-reticulate")

# Install packages into it
reticulate::py_install(
  packages = c("scikit-learn", "transformers", "torch", "pandas", "numpy"),
  envname = "r-reticulate"
)

# Use that environment from now on
reticulate::use_virtualenv("r-reticulate", required = TRUE)

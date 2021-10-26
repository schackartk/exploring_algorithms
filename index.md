# Exploring Algorithms

In an attempt to gain a better understanding of common machine learning algorithms, I am exploring how and why they work.

I will begin with the intuition that I have for how each algorithm works, then refine that until the algorithm is fully realized.

## [Principal Component Analysis](https://schackartk.github.io/exploring_algorithms/PCA/pca_notebook.nb.html)

I begin by considering the redundancy in correlated predictors, then attempt to capture that by projecting to an ordinary least-squares regression line. It quickly becomes evident that when the predictors have different scales it greatly hinders this approach. Once I perform some rescaling, we see that ordinary least-squares projection causes persistent correlation, so I switch to total least-squaresa regression. I then move from geometrical projection to eigen-decomposition, which is qualitatively the same, but gives additional information such as portions of variance in each new axis. I finally compare these approaches to PCA and find that principal axes must pass through the origin, so re-centering is necessary. I finally conclude that PCA, when performed on standardized data, is identical to geometrical projection to a TLS regression line.

## Source Code

Source code for this project is located in the GitHub repository [schackartk/exploring_algorithms](https://github.com/schackartk/exploring_algorithms)

## Authorship

Kenneth Schackart <schackartk1@gmail.com>
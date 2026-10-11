# ==========================================================
# APM1220 FA5 - PCA on World Happiness Report 2021
# Data: Helliwell et al. (2021), World Happiness Report 2021
#       (CSV obtained from a Kaggle mirror: ajaypalsinghlo/world-happiness-report-2021)
# Put world-happiness-report-2021.csv in the working directory.
# ==========================================================
df <- read.csv("world-happiness-report-2021.csv", check.names = FALSE, fileEncoding = "UTF-8-BOM")

vars  <- c("Ladder score", "Logged GDP per capita", "Social support",
           "Healthy life expectancy", "Freedom to make life choices",
           "Generosity", "Perceptions of corruption")
short <- c("Ladder", "LogGDP", "Social", "HLE", "Freedom", "Generosity", "Corruption")
X <- df[, vars]; colnames(X) <- short

# ---------------- PART A ----------------
# A1. Observations and variables
cat("Observations:", nrow(X), "\nVariables:", ncol(X), "\n"); print(colnames(X))
sum(is.na(X))                                   # missing values

# A2. Means and standard deviations
desc <- data.frame(Mean = colMeans(X), SD = apply(X, 2, sd))
print(round(desc, 3))

# A3. Standardization is needed because the variables use different scales
#     (e.g., HLE ~ 65 years vs Social support ~ 0.8), so unscaled PCA would be
#     dominated by the largest-variance variable.
Z <- scale(X)                                   # mean 0, sd 1
round(colMeans(Z), 3); round(apply(Z, 2, sd), 3)

# A4. Correlation matrix
R <- cor(X); print(round(R, 3))
Rl <- R; Rl[lower.tri(Rl, diag = TRUE)] <- NA
top <- na.omit(as.data.frame(as.table(Rl)))
print(head(top[order(-abs(top$Freq)), ], 6))
png("correlation_heatmap.png", 1300, 1100, res = 200)
image(1:7, 1:7, t(R[7:1, ]), col = hcl.colors(21, "RdBu", rev = TRUE), zlim = c(-1, 1),
      axes = FALSE, xlab = "", ylab = "", main = "Correlation Matrix")
axis(1, 1:7, short, las = 2); axis(2, 1:7, rev(short), las = 2)
for (i in 1:7) for (j in 1:7) text(j, 8 - i, sprintf("%.3f", R[i, j]), cex = 0.7)
dev.off()

# ---------------- PART B ----------------
# B1. PCA on the correlation matrix (scale. = TRUE)
pca <- prcomp(X, center = TRUE, scale. = TRUE)
summary(pca)

# B2-B4. Eigenvalues, proportion and cumulative proportion
eig  <- pca$sdev^2
prop <- eig / sum(eig)
tab  <- data.frame(Eigenvalue = eig, Proportion = prop, Cumulative = cumsum(prop),
                   row.names = paste0("PC", 1:7))
print(round(tab, 3))
round(eigen(R)$values, 3)                       # same eigenvalues from the correlation matrix

# B5. Eigenvectors (component coefficients)
# NOTE: the sign of a PC is arbitrary. Flip PC1 so that higher = higher well-being.
if (pca$rotation["Ladder", 1] < 0) { pca$rotation[, 1] <- -pca$rotation[, 1]; pca$x[, 1] <- -pca$x[, 1] }
print(round(pca$rotation, 3))

# B6. Largest absolute coefficients in PC1
print(round(sort(abs(pca$rotation[, 1]), decreasing = TRUE), 3))

# ---------------- PART C ----------------
# C1. Scree plot
png("scree_plot.png", 1300, 850, res = 200)
plot(1:7, eig, type = "b", pch = 19, col = "#1f4e79", xlab = "Principal Component",
     ylab = "Eigenvalue", main = "Scree Plot")
abline(h = 1, lty = 2, col = "red"); text(1:7, eig, sprintf("%.3f", eig), pos = 3, cex = 0.7)
legend("topright", "Kaiser line (eigenvalue = 1)", lty = 2, col = "red", bty = "n")
dev.off()
# C2. Elbow: the sharp drop is from PC1 to PC2; the curve flattens after PC2 (elbow at PC2/PC3).
# C3. Kaiser criterion
which(eig > 1)
# C4. Decision (see report): retain 2 components (eigenvalues > 1; 74.3% cumulative variance)
# C5. Discussion in the report.

# ---------------- PART D ----------------
# D1-D3. Loadings and correlations of variables with PCs
print(round(pca$rotation[, 1:3], 3))
print(round(sweep(pca$rotation[, 1:3], 2, pca$sdev[1:3], "*"), 3))   # variable-PC correlations
scores <- data.frame(Country = df[["Country name"]], round(pca$x[, 1:2], 3))
print(head(scores[order(-scores$PC1), ], 5)); print(head(scores[order(scores$PC1), ], 5))
print(head(scores[order(-scores$PC2), ], 5)); print(head(scores[order(scores$PC2), ], 5))
png("biplot.png", 1300, 1100, res = 200)
biplot(pca, cex = c(0.5, 0.9), main = "PCA Biplot (PC1 vs PC2)")
dev.off()

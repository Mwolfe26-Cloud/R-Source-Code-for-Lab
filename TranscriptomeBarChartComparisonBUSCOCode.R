# Two horizontal-bar figures for the five-species ECU proposal.
# Uses base R only: no install.packages() step is needed.
# In RStudio, open this file and click Source to generate and view both figures.
# In R, run source(file.choose()) and select this file.
# Each figure opens in its own plot window when run in an interactive session.
# PNG and vector SVG files are saved in getwd()/Fish_Figures.
# Source review: 31 October 2026. Proposed BUSCO target: 95-99%.
# Assembly-level labels checked: 30 October 2026. Detailed sources are in README.

#| Color       | Code      | Color     | Code |
| Navy         | `#1F3A5F` | Burgundy  | `#800020` |
| Blue         | `#0072B2` | Red       | `#D62728` |
| Royal blue   | `#4169E1` | Coral     | `#FF7F50` |
| Sky blue     | `#56B4E9` | Orange    | `#E69F00` |
| Turquoise    | `#40B5AD` | Gold      | `#F2CA67` |
| Teal         | `#167D8D` | Mustard   | `#C49A00` |
| Forest green | `#228B22` | Purple    | `#7B2CBF` |
| Emerald      | `#009E73` | Lavender  | `#B39DDB` |
| Olive        | `#808000` | Magenta   | `#CC79A7` |
| Mint         | `#80CDC1` | Charcoal  | `#404040` |

output_dir <- file.path(getwd(), "Fish_Figures")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

# ---------------------- EDITABLE INPUT DATA ----------------------
species <- c("American paddlefish", "Shovelnose sturgeon",
             "Pallid sturgeon", "Flathead catfish", "Arkansas River shiner")
scientific <- c("Polyodon spathula", "Scaphirhynchus platorynchus",
                "Scaphirhynchus albus", "Pylodictis olivaris", "Notropis girardi")

# Genome completeness means complete BUSCOs, C = single-copy + duplicated.
# Paddlefish: 93.7% is the published PRIMARY GENOME assembly result in
# Cheng et al. 2021, doi:10.1093/molbev/msaa326; BUSCO 3.0.2, odb9.
# It is not a new score for the Casey 2026 assembly.
# Flathead: exact counts from the supplied Galaxy genome-mode summary and
# full table: 3,377 complete / 3,640 markers; BUSCO 5.8.0, odb10.
# The reported value is 92.8%; bar length uses the exact fraction.
# NA means no genome score verified in the reviewed sources, NEVER 0%.
# Do not insert the paddlefish protein-mode score (86.6%) in this table.
genome <- data.frame(
  species = species, scientific = scientific,
  current_complete_pct = c(93.7, NA_real_, NA_real_, 100 * 3377 / 3640, NA_real_),
  goal_min_pct = rep(95, 5), goal_max_pct = rep(99, 5),
  current_assembly_level = c("Chromosome-level*", NA, NA, "Scaffold-level", NA),
  current_reference_accession = c("GCF_017654505.1", NA, NA, "GCA_028570965.1", NA),
  current_busco_assessed_stage = c("Published primary assembly before Hi-C",
                                  NA, NA, "Submitted scaffold assembly", NA),
  proposed_assembly_level = rep("Chromosome-level", 5),
  busco_version = c("3.0.2", NA, NA, "5.8.0", NA),
  lineage = c("actinopterygii_odb9", NA, NA, "actinopterygii_odb10", NA),
  missing_label = c(NA, "No genome BUSCO score found [G1]",
                   "No genome BUSCO score found [G2]", NA,
                   "No genome BUSCO score found [G3]"),
  source = c("Cheng et al. 2021; primary genome assembly",
             "No verified genome BUSCO result in sources reviewed",
             "No verified genome BUSCO result in sources reviewed",
             "User-supplied Galaxy summary and full table; GCA_028570965.1",
             "Genome described in Osborne/Caeiro-Dias report; no numeric BUSCO result"),
  stringsAsFactors = FALSE
)

# Figure 2 counts RNA PREPARATIONS supporting protein annotation.
# It is not protein BUSCO completeness, protein count, read count, or fish count.
# Current paddlefish evidence: Casey et al. 2026, Table S4, 60 paired-end
# RNA-seq libraries = 15 tissue types x 4 fish. The 120 FASTQ files are
# the two read files per library, not 120 biological preparations.
# This RNA baseline refers to Casey 2026, not the Cheng 2021 genome run.
# The paper explicitly describes the paddlefish tissue RNA as ADULT.
# Its 60 libraries are a selected annotation study, not all RNA for the species.
# ADD the six stage-46 larval libraries in GSE92470 to the existing-data bar:
# three pooled fin preparations + three pooled opercular preparations.
# The plotted paddlefish baseline is 60 adult + 6 larval = 66 libraries.
# These are separate studies, not a single matched cohort or all public RNA.
# Shovelnose: Amberg et al. 2013, doi:10.1159/000354280, methods p.309:
# two sequenced adult gonad libraries, one ovary and one testis. The larger
# group of 12 fish supplied qPCR material; it was not 12 sequenced libraries.
# SRA, ENA and GEO were searched on 31 October 2026 (see source audit).
# Flathead: six RNA matches under PRJNA833861 were excluded because the linked
# paper identifies hybrid yellow catfish (Tachysurus), not Pylodictis olivaris.
# NA remains unknown / no eligible baseline found; it NEVER means zero samples.
# Proposed counts: the attached five-species project description v73 and
# sample/contact map v2, both dated 23 October 2026.
rna <- data.frame(
  species = species, scientific = scientific,
  current_adult = c(60, 2, NA_real_, NA_real_, NA_real_),
  current_larval = c(6, 0, NA_real_, NA_real_, NA_real_),
  current_juvenile = c(0, 0, NA_real_, NA_real_, NA_real_),
  current_life_stage = c("Adult + stage-46 larvae", "Adult", NA, NA, NA),
  current_source = c("Casey et al. 2026, Table S4; Modrell et al. 2017, GSE92470",
                     "Amberg et al. 2013, methods p.309", NA, NA, NA),
  missing_label = c(NA, NA,
    "No public RNA-seq records found\nNCBI SRA / ENA / GEO",
    "No eligible RNA records after review\n6 SRA / ENA matches excluded; GEO: none",
    "No public RNA-seq records found\nNCBI SRA / ENA / GEO"),
  proposed_adult = rep(18, 5),
  proposed_egg_to_fry = c(60, 60, 60, 0, 0),
  proposed_juvenile = c(12, 12, 12, 0, 0),
  stringsAsFactors = FALSE
)
rna$current_documented_rna <- rowSums(rna[c("current_adult", "current_larval",
                                         "current_juvenile")])
rna$proposed_total <- with(rna, proposed_adult + proposed_egg_to_fry + proposed_juvenile)

# Validation prevents invented zero baselines and inconsistent proposed totals.
stopifnot(identical(genome$species, rna$species),
          all(genome$current_complete_pct >= 0 & genome$current_complete_pct <= 100,
              na.rm = TRUE),
          all(genome$goal_min_pct <= genome$goal_max_pct),
          all(genome$goal_max_pct <= 100),
          rna$current_documented_rna[1] == 66,
          rna$current_documented_rna[2] == 2,
          all(is.na(rna$current_documented_rna[3:5])),
          identical(as.numeric(rna$proposed_total), c(90, 90, 90, 18, 18)),
          sum(rna$proposed_total) == 306)

# ----------------------- SHARED APPEARANCE -----------------------
# Assembly level describes the published/deposited reference. It is not a BUSCO
# percentage. GCF_017654505.1 is chromosome-level. The 93.7% literature score was
# measured on the study's primary assembly before Hi-C; the asterisk preserves
# that distinction instead of implying a new assessment of the final chromosomes.
# All five proposed references are chromosome-scale in project description v73.
colours <- c(current = "#167D8D", goal = "#F2CA67", goal_edge = "#AD7C1E",
             rna_current = "#687985", adult = "#138A86",
             egg_fry = "#397EC0", juvenile = "#8D68AD",
             ink = "#17323D", muted = "#687985", grid = "#E5E9EC")
centres <- c(10, 8, 6, 4, 2)
row_offset <- 0.29
bar_half_height <- 0.23

canvas <- function(title, xlab, bottom_margin = 0.85) {
  # Include the species-label column in the plotting coordinates. A fixed
  # negative x position outside the plot can leave the device when resized.
  # These limits preserve the original geometry in the 13-inch saved figures.
  par(mai = c(bottom_margin, 0.125, 1.05, 0.75), family = "sans", xpd = NA,
      fg = colours["ink"], col.axis = colours["muted"], las = 1)
  plot.new()
  plot.window(xlim = c(-27.5, 110), ylim = c(0.7, 10.85), xaxs = "i", yaxs = "i")
  segments(seq(0, 100, 20), 1.3, seq(0, 100, 20), 10.65,
           col = colours["grid"], lwd = 0.8)
  axis(1, at = seq(0, 100, 20), labels = seq(0, 100, 20),
       col = NA, col.ticks = NA, cex.axis = 0.96, line = -0.25)
  mtext(xlab, side = 1, line = 1.85, at = 50, cex = 1.0, col = colours["ink"])
  text(-27.5, 12.4, title, adj = c(0, 0.5), font = 2, cex = 1.4,
       col = colours["ink"])
  text(-27.5, centres, species, adj = 0, font = 2, cex = 1.0)
}

bar_rectangle <- function(left, right, y, colour, border = NA, ...) {
  rect(left, y - bar_half_height, right, y + bar_half_height,
       col = colour, border = border, ...)
}

# ---------------------- FIGURE 1: GENOMES -----------------------
plot_genome <- function() {
  canvas("Genome BUSCO completeness", "Complete BUSCOs (%)", bottom_margin = 1.45)
  legend(-27.5, 11.78, legend = c("Current reported baseline", "Proposed goal"),
         fill = colours[c("current", "goal")], border = NA,
         ncol = 2, bty = "n", cex = 0.94, x.intersp = 0.6)
  for (i in seq_len(nrow(genome))) {
    y_current <- centres[i] + row_offset
    y_goal <- centres[i] - row_offset
    value <- genome$current_complete_pct[i]
    if (is.na(value)) {
      text(1.5, y_current, genome$missing_label[i], adj = 0,
           cex = 0.88, col = colours["muted"])
    } else {
      bar_rectangle(0, value, y_current, colours["current"])
      text(value / 2, y_current, genome$current_assembly_level[i],
           col = "white", font = 2, cex = 0.98)
      text(value + 1.8, y_current, sprintf("%.1f%%", value),
           adj = 0, font = 2, cex = 0.98)
    }
    # The bar reaches the requested upper target of 99. Its final four
    # percentage points are hatched to indicate the 95-99 target range.
    bar_rectangle(0, genome$goal_min_pct[i], y_goal, colours["goal"])
    bar_rectangle(genome$goal_min_pct[i], genome$goal_max_pct[i], y_goal,
                  "#FFF7DF", border = colours["goal_edge"], lwd = 0.65)
    bar_rectangle(genome$goal_min_pct[i], genome$goal_max_pct[i], y_goal,
                  colours["goal_edge"], border = colours["goal_edge"],
                  density = 18, angle = 45, lwd = 0.65)
    text(genome$goal_min_pct[i] / 2, y_goal, genome$proposed_assembly_level[i],
         col = colours["ink"], font = 2, cex = 0.98)
    text(genome$goal_max_pct[i] + 1.8, y_goal,
         sprintf("%g-%g%%", genome$goal_min_pct[i], genome$goal_max_pct[i]),
         adj = 0, font = 2, cex = 0.94)
  }
  mtext("*Paddlefish reference is chromosome-level; 93.7% was reported for the primary assembly before Hi-C (Cheng et al. 2021).",
        side = 1, line = 3.5, at = -27.5, adj = 0, cex = 0.66, col = colours["muted"])
  mtext("Reported baselines use different BUSCO datasets. The 95-99% range is a proposed target, not a measured or predicted outcome.",
        side = 1, line = 4.3, at = -27.5, adj = 0, cex = 0.66, col = colours["muted"])
  mtext("[G1-G3] No numerical genome BUSCO result found in NCBI Assembly, targeted PubMed searches and the reviewed primary literature (31 Oct 2026).",
        side = 1, line = 5.1, at = -27.5, adj = 0, cex = 0.66, col = colours["muted"])
  mtext("Search scope, queries and results are documented in the accompanying source audit; an unsuccessful search is not proof that no result exists.",
        side = 1, line = 5.9, at = -27.5, adj = 0, cex = 0.66, col = colours["muted"])
}

# ---------------- FIGURE 2: TRANSCRIPTOMIC SAMPLES ----------------
plot_rna <- function() {
  canvas("Transcriptomic sampling by life stage",
         "Sequenced RNA libraries / proposed RNA preparations", bottom_margin = 0.80)
  # Size each entry to its text, with the same small gap between entries.
  legend_labels <- c("Adult", "Larval / egg-to-fry development", "Juvenile development")
  legend_colours <- colours[c("adult", "egg_fry", "juvenile")]
  x_per_inch <- diff(par("usr")[1:2]) / par("pin")[1]
  y_per_inch <- diff(par("usr")[3:4]) / par("pin")[2]
  key_width <- 0.105 * x_per_inch
  key_height <- 0.105 * y_per_inch
  legend_x <- -26
  legend_y <- 11.45
  for (j in seq_along(legend_labels)) {
    rect(legend_x, legend_y - key_height / 2,
         legend_x + key_width, legend_y + key_height / 2,
         col = legend_colours[j], border = NA)
    text_x <- legend_x + key_width + 0.065 * x_per_inch
    text(text_x, legend_y, legend_labels[j], adj = c(0, 0.5), cex = 0.91)
    legend_x <- text_x + strwidth(legend_labels[j], cex = 0.91) + 0.20 * x_per_inch
  }
  for (i in seq_len(nrow(rna))) {
    y_current <- centres[i] + row_offset
    y_plan <- centres[i] - row_offset
    text(-1.5, y_current, "Reported", adj = 1, cex = 0.70, col = colours["muted"])
    text(-1.5, y_plan, "Proposed", adj = 1, cex = 0.70, col = colours["muted"])
    value <- rna$current_documented_rna[i]
    if (is.na(value)) {
      text(1.5, y_current, rna$missing_label[i], adj = c(0, 0.5),
           cex = 0.76, col = colours["muted"])
    } else {
      existing <- c(rna$current_adult[i], rna$current_larval[i], rna$current_juvenile[i])
      segment_colours <- colours[c("adult", "egg_fry", "juvenile")]
      left <- 0
      for (j in seq_along(existing)) {
        if (existing[j] > 0) {
          bar_rectangle(left, left + existing[j], y_current, segment_colours[j],
                        border = "white", lwd = 0.6)
          if (sum(existing > 0) > 1)
            text(left + existing[j] / 2, y_current, existing[j],
                 col = "white", font = 2, cex = 0.96)
        }
        left <- left + existing[j]
      }
      text(value + 1.8, y_current, value, adj = 0, font = 2, cex = 0.98)
    }
    values <- c(rna$proposed_adult[i], rna$proposed_egg_to_fry[i], rna$proposed_juvenile[i])
    segment_colours <- colours[c("adult", "egg_fry", "juvenile")]
    left <- 0
    for (j in seq_along(values)) {
      if (values[j] > 0) {
        bar_rectangle(left, left + values[j], y_plan, segment_colours[j],
                      border = "white", lwd = 0.6)
        # With only one segment, the total at the end already gives its count.
        if (sum(values > 0) > 1)
          text(left + values[j] / 2, y_plan, values[j],
               col = "white", cex = 0.96, font = 2)
      }
      left <- left + values[j]
    }
    text(rna$proposed_total[i] + 1.8, y_plan, rna$proposed_total[i],
         adj = 0, font = 2, cex = 0.98)
  }
}

# ----------------------- SAVE BOTH FIGURES -----------------------
save_figure <- function(stem, draw, height = 8.3) {
  png_path <- file.path(output_dir, paste0(stem, ".png"))
  png(png_path, width = 13, height = height, units = "in", res = 300,
      bg = "white", type = if (capabilities("cairo")) "cairo" else getOption("bitmapType"))
  tryCatch(draw(), finally = dev.off())
  svg_path <- file.path(output_dir, paste0(stem, ".svg"))
  svg(svg_path, width = 13, height = height, bg = "white", family = "sans")
  tryCatch(draw(), finally = dev.off())
  message("Saved: ", normalizePath(png_path, winslash = "/"))
  message("Saved: ", normalizePath(svg_path, winslash = "/"))
}

save_figure("Figure_1_Genome_Completeness", plot_genome)
save_figure("Figure_2_RNA_For_Protein_Annotation", plot_rna, height = 7.4)

# ----------------------- DISPLAY THE FIGURES -----------------------
# Separate windows preserve the figure dimensions even when RStudio's Plots
# pane is too small. Fit mode keeps the layout intact when Windows resizes
# a plot, including automatic resizing to fit the RGui workspace.
show_figure <- function(draw, title, height = 8.3) {
  if (.Platform$OS.type == "windows") {
    grDevices::windows(width = 13, height = height, title = title,
                       rescale = "fit")
  } else {
    grDevices::dev.new(width = 13, height = height, noRStudioGD = TRUE)
  }
  draw()
  invisible(grDevices::dev.cur())
}

# Run show_figures() in the Console to reopen both figures later.
show_figures <- function() {
  show_figure(plot_genome, "Figure 1 - Genome BUSCO completeness")
  show_figure(plot_rna, "Figure 2 - Transcriptomic sampling", height = 7.4)
  invisible(NULL)
}

if (interactive()) {
  tryCatch({
    show_figures()
    message("Both figures are open in separate plot windows.")
  }, error = function(e) {
    message("Could not open a plot window: ", conditionMessage(e))
    message("The PNG and SVG files are still saved in: ",
            normalizePath(output_dir, winslash = "/"))
  })
}

capture.output(list(genome_baselines_and_goals = genome,
                    rna_preparations = rna,
                    r_session = sessionInfo()),
               file = file.path(output_dir, "Figure_Data_and_R_Session.txt"))
message("Finished. No unreported baseline has been replaced by zero.")

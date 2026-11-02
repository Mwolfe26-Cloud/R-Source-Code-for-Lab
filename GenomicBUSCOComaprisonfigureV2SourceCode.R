# Genomic BUSCO completeness: current baselines and proposed 95-99% goals.
# Standalone base-R script; no packages or external data files are required.
# RGui: paste/open this script, press Ctrl+A, then Ctrl+R.
# RStudio: click Source. The figure opens and PNG/SVG copies are saved.
# Baselines reproduce the source review from 31 October 2026.
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
  current_assembly_level = c("Chromosome-level", NA, NA, "Scaffold-level", NA),
  current_bar_label = c("Primary assembly (pre-Hi-C)", NA, NA, "Scaffold-level", NA),
  current_reference_accession = c("GCF_017654505.1", NA, NA, "GCA_028570965.1", NA),
  current_busco_assessed_stage = c("Published primary assembly before Hi-C",
                                  NA, NA, "Submitted scaffold assembly", NA),
  proposed_assembly_level = rep("Chromosome-level", 5),
  busco_version = c("3.0.2", NA, NA, "5.8.0", NA),
  lineage = c("actinopterygii_odb9", NA, NA, "actinopterygii_odb10", NA),
  missing_label = c(NA, "No genome BUSCO score found",
                   "No genome BUSCO score found", NA,
                   "No genome BUSCO score found"),
  source = c("Cheng et al. 2021; primary genome assembly",
             "No verified genome BUSCO result in sources reviewed",
             "No verified genome BUSCO result in sources reviewed",
             "User-supplied Galaxy summary and full table; GCA_028570965.1",
             "Genome described in Osborne/Caeiro-Dias report; no numeric BUSCO result"),
  stringsAsFactors = FALSE
)

stopifnot(
  all(genome$current_complete_pct >= 0 & genome$current_complete_pct <= 100,
      na.rm = TRUE),
  all(genome$goal_min_pct <= genome$goal_max_pct),
  all(genome$goal_max_pct <= 100)
)

# ----------------------- APPEARANCE -----------------------
colours <- c(current = "#167D8D", goal = "#F2CA67", goal_edge = "#AD7C1E",
             ink = "#17323D", muted = "#687985", grid = "#E5E9EC")
centres <- c(10, 8, 6, 4, 2)
row_offset <- 0.29
bar_half_height <- 0.23

canvas <- function(title, xlab, bottom_margin = 0.85,
                   top_margin = 1.05, title_y = 12.4) {
  # Include the species-label column in the plotting coordinates. A fixed
  # negative x position outside the plot can leave the device when resized.
  # These limits preserve the original geometry in the 13-inch saved figures.
  par(mai = c(bottom_margin, 0.125, top_margin, 0.75), family = "sans", xpd = NA,
      fg = colours["ink"], col.axis = colours["muted"], las = 1)
  plot.new()
  plot.window(xlim = c(-27.5, 110), ylim = c(0.7, 10.85), xaxs = "i", yaxs = "i")
  segments(seq(0, 100, 20), 1.3, seq(0, 100, 20), 10.65,
           col = colours["grid"], lwd = 0.8)
  axis(1, at = seq(0, 100, 20), labels = seq(0, 100, 20),
       col = NA, col.ticks = NA, cex.axis = 0.96, line = -0.25)
  mtext(xlab, side = 1, line = 1.85, at = 50, cex = 1.0, col = colours["ink"])
  text(-27.5, title_y, title, adj = c(0, 0.5), font = 2, cex = 1.4,
       col = colours["ink"])
  text(-27.5, centres, species, adj = 0, font = 2, cex = 1.0)
}

bar_rectangle <- function(left, right, y, colour, border = NA, ...) {
  rect(left, y - bar_half_height, right, y + bar_half_height,
       col = colour, border = border, ...)
}

# Assembly levels follow the NCBI Datasets glossary.
# The numbers are an ordinal display key, not a BUSCO score.
# https://www.ncbi.nlm.nih.gov/datasets/docs/v2/glossary/#assembly-level
assembly_ranks <- c("Complete genome" = 1L, "Chromosome-level" = 2L,
                    "Scaffold-level" = 3L, "Contig-level" = 4L)

assembly_display_label <- function(level) {
  rank <- unname(assembly_ranks[level])
  # "Primary assembly (pre-Hi-C)" identifies an assessed stage rather than
  # an established assembly-level category, so no rank is inferred for it.
  ifelse(is.na(rank), level, paste(rank, "|", level))
}

assembly_level_key <- function() {
  rect(-27.5, 11.10, 110, 12.0, col = "#F3F6F8", border = NA)
  text(-26, 11.55, "Assembly level\n(1 = highest)", adj = c(0, 0.5),
       cex = 0.86, font = 2, col = colours["ink"])
  rank_x <- c(4, 27, 53, 82)
  points(rank_x, rep(11.55, 4), pch = 21, cex = 1.85,
         bg = "white", col = "#A6B4BE", lwd = 0.8)
  text(rank_x, 11.55, 4:1, cex = 0.84, font = 2, col = colours["ink"])
  text(rank_x + 2.5, 11.55,
       c("Contig", "Scaffold", "Chromosome", "Complete genome"),
       adj = c(0, 0.5), cex = 0.91, col = colours["ink"])
  arrows(c(18.5, 44.5, 73), 11.55, c(22, 48, 77), 11.55,
         length = 0.06, angle = 25, col = "#8799A6", lwd = 0.8)
}

# ---------------------- FIGURE 1: GENOMES -----------------------
plot_genome <- function() {
  canvas("Genome BUSCO completeness", "Complete BUSCOs (%)",
         bottom_margin = 0.80, top_margin = 1.65, title_y = 13.5)
  legend(-27.5, 12.88, legend = c("Current", "ECU Proposed"),
         fill = colours[c("current", "goal")], border = NA,
         ncol = 2, bty = "n", cex = 0.94, x.intersp = 0.6)
  assembly_level_key()
  for (i in seq_len(nrow(genome))) {
    y_current <- centres[i] + row_offset
    y_goal <- centres[i] - row_offset
    text(-1.5, y_current, "Current", adj = 1, cex = 0.70, col = colours["muted"])
    text(-1.5, y_goal, "ECU Proposed", adj = 1, cex = 0.70, col = colours["muted"])
    value <- genome$current_complete_pct[i]
    if (is.na(value)) {
      text(1.5, y_current, genome$missing_label[i], adj = 0,
           cex = 0.88, col = colours["muted"])
    } else {
      bar_rectangle(0, value, y_current, colours["current"])
      text(value / 2, y_current, assembly_display_label(genome$current_bar_label[i]),
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
    text(genome$goal_min_pct[i] / 2, y_goal, assembly_display_label(genome$proposed_assembly_level[i]),
         col = colours["ink"], font = 2, cex = 0.98)
    text(genome$goal_max_pct[i] + 1.8, y_goal,
         sprintf("%g-%g%%", genome$goal_min_pct[i], genome$goal_max_pct[i]),
         adj = 0, font = 2, cex = 0.94)
  }
}

# ----------------------- SAVE THE FIGURE -----------------------
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

save_figure("Figure_1_Genome_Completeness", plot_genome, height = 8.0)
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

# ----------------------- DISPLAY THE FIGURE -----------------------
if (interactive()) {
  tryCatch({
    show_figure(plot_genome, "Genome BUSCO completeness", height = 8.0)
  }, error = function(e) {
    message("Could not open a plot window: ", conditionMessage(e))
    message("The image files are saved in: ", normalizePath(output_dir))
  })
}

message("Finished. Figure saved in: ", normalizePath(output_dir))

## Load your packages, e.g. library(targets).
source("./packages.R")

## Load your R files
tar_source()

tar_plan(
  tar_terra_rast(
    name = rastex,
    command = rast(data.frame(x = c(1, 2), y = c(3, 4), z = c(100, 200)))
  ),

  tar_target(
    name = rastex_plot,
    command = ggplot() +
      geom_spatraster(data = rastex)
  ),

  tar_target(
    name = plot_rastex_base,
    command = {
      png(tempf <- tempfile(fileext = ".png"))
      plot(rastex)
      dev.off()
      image_ggplot(image_read(tempf))
    }
  ),

  tar_file(
    name = saved_spatraster,
    command = {
      spat_plot <- ggplot() +
      geom_spatraster(data = rastex)
      ggsave(filename = "geom-spatraster.png",
             plot = spat_plot)
      # must return the filename as the output
      "geom-spatraster.png"
    }
  ),

  tar_quarto(index, "doc/index.qmd")

)

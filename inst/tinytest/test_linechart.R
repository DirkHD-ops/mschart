library(mschart)
library(officer)
library(xml2)

source("utils/unpack_chart.R")

dat <- data.frame(
  color=c(rep("green",3), rep("unclear",3), rep("gray",3)),
  musician=c(rep(c("Robert Wyatt", "John Zorn", "Damon Albarn"),3)),
  count = c(120, 101, 131, 200, 154, 187, 122, 197, 159),
  stringsAsFactors=F)


# example areachart -------
chart_01 <- ms_linechart(data = dat, x = "musician", y = "count", group = "color")

settings <- c(green = 1L, unclear = 0L, gray = 0L)
settings <- settings[order(names(settings))]
chart_01 <- chart_data_smooth(chart_01, values = settings )


path <- unpack_chart(chart_01)

chart <- read_xml(attr(path, "chart_xml"))
serie_names <- xml_find_all(chart, "//c:ser/c:tx/c:strRef/c:strCache/c:pt/c:v")
serie_names <- xml_text(serie_names)
smooth_data <- xml_find_all(chart, "//c:smooth")
smooth_data <- as.integer(xml_attr(smooth_data, "val"))
names(smooth_data) <- serie_names
smooth_data <- smooth_data[order(names(smooth_data))]

expect_equivalent(settings, smooth_data)


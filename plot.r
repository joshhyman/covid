filepath = "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
datafiles = list.files(filepath)

la = data.frame()
for (f in datafiles) {
  if (f == "README.md") { next }

  d = read.csv(file.path(filepath, f))
  la = rbind(la, d[d$Province_State == "California" & d$Admin2 == "Los Angeles", c("Confirmed")])
}

la = cbind(la, c(0, diff(la[,])))
names(la) = c("Confirmed", "Diff")

print(la)

png("~/www/no_crawl/covid_plot.png")
plot(la$Confirmed, la$Diff)
dev.off()

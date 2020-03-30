filepath = "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
datafiles = list.files(filepath)

la = data.frame()
sf = data.frame()
for (f in datafiles) {
  if (f == "README.md") { next }

  d = read.csv(file.path(filepath, f))
  la = rbind(la, d[d$Province_State == "California" & d$Admin2 == "Los Angeles", c("Confirmed")])
  sf = rbind(sf, d[d$Province_State == "California" & d$Admin2 == "San Francisco", c("Confirmed")])
}

la = cbind(la, c(0, diff(la[,])))
names(la) = c("Confirmed", "Diff")

sf = cbind(sf, c(0, diff(sf[,])))
names(sf) = c("Confirmed", "Diff")

png("~/www/no_crawl/covid_plot.png")

plot(la$Confirmed, la$Diff,
     type="b",
     xlim=range(100,max(la$Confirmed)),
     ylim=range(10,max(la$Diff)),
     log="xy", xlog=TRUE, ylog=TRUE,
     xlab="Confirmed Cases",
     ylab="Daily Cases")

lines(sf$Confirmed, sf$Diff, type="b", col="blue")

dev.off()

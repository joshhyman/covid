filepath = "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
datafiles = list.files(filepath)

ny = data.frame()
ca = data.frame()
la = data.frame()
sf = data.frame()

for (f in datafiles) {
  if (f == "README.md") { next }

  d = read.csv(file.path(filepath, f))
  ny = rbind(ny, sum(d[d$Province_State == "New York", c("Confirmed")]))
  ca = rbind(ca, sum(d[d$Province_State == "California", c("Confirmed")]))
  la = rbind(la, d[d$Province_State == "California" & d$Admin2 == "Los Angeles", c("Confirmed")])
  sf = rbind(sf, d[d$Province_State == "California" & d$Admin2 == "San Francisco", c("Confirmed")])
}

ny = cbind(ny, c(0, diff(ny[,])))
names(ny) = c("Confirmed", "Diff")

ca = cbind(ca, c(0, diff(ca[,])))
names(ca) = c("Confirmed", "Diff")

la = cbind(la, c(0, diff(la[,])))
names(la) = c("Confirmed", "Diff")

sf = cbind(sf, c(0, diff(sf[,])))
names(sf) = c("Confirmed", "Diff")

png("~/www/no_crawl/covid_plot.png")

plot(ny$Confirmed, ny$Diff,
     type="b",
     xlim=range(100,max(ny$Confirmed)),
     ylim=range(10,max(ny$Diff)),
     log="xy", xlog=TRUE, ylog=TRUE,
     xlab="Confirmed Cases",
     ylab="Daily Cases")

lines(ca$Confirmed, ca$Diff, type="b", col="green")
lines(la$Confirmed, la$Diff, type="b", col="blue")
lines(sf$Confirmed, sf$Diff, type="b", col="red")

legend("topleft", lty=c(1,1), bty="n",
       col=c("black", "green", "blue", "red"),
       legend=c("New York", "California", "Los Angeles", "San Francisco"))

dev.off()

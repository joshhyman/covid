filepath = "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
datafiles = list.files(filepath)

cn = data.frame()
ny = data.frame()
ca = data.frame()
la = data.frame()
sf = data.frame()

for (f in datafiles) {
  if (f == "README.md") { next }

  d = read.csv(file.path(filepath, f))
  cn = rbind(cn, sum(d[c(d$Country_Region == "China",
                         d$Country.Region %in% c("China", "Mainland China")), c("Confirmed")], na.rm=T))
  ny = rbind(ny, sum(d[c(d$Province_State == "New York", d$Province.State == "New York"), c("Confirmed")]))
  ca = rbind(ca, sum(d[c(d$Province_State == "California", d$Province.State == "California"), c("Confirmed")]))
  la = rbind(la, d[d$Province_State == "California" & d$Admin2 == "Los Angeles", c("Confirmed")])
  sf = rbind(sf, d[d$Province_State == "California" & d$Admin2 == "San Francisco", c("Confirmed")])
}

cn = cbind(cn, c(0, diff(cn[,])))
names(cn) = c("Confirmed", "Diff")

ny = cbind(ny, c(0, diff(ny[,])))
names(ny) = c("Confirmed", "Diff")

ca = cbind(ca, c(0, diff(ca[,])))
names(ca) = c("Confirmed", "Diff")

la = cbind(la, c(0, diff(la[,])))
names(la) = c("Confirmed", "Diff")

sf = cbind(sf, c(0, diff(sf[,])))
names(sf) = c("Confirmed", "Diff")

png("covid_plot.png")
options(scipen=999)

plot(cn$Confirmed, cn$Diff,
     type="b",
     xlim=range(100,max(cn$Confirmed)),
     ylim=range(10,max(cn$Diff)),
     log="xy", xlog=TRUE, ylog=TRUE,
     xlab="Confirmed Cases",
     ylab="Daily Cases")

lines(ny$Confirmed, ny$Diff, type="b", col="purple")
lines(ca$Confirmed, ca$Diff, type="b", col="green")
lines(la$Confirmed, la$Diff, type="b", col="red")
lines(sf$Confirmed, sf$Diff, type="b", col="blue")

legend("topleft", lty=c(1,1), bty="n",
       col=c("black", "purple", "green", "red", "blue"),
       legend=c("China", "New York", "California", "Los Angeles", "San Francisco"))

dev.off()

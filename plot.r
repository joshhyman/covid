#-----------------------------
# Read Hopkins Datatset
#-----------------------------
filepath = "COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/"
datafiles = list.files(filepath)

cn = data.frame()

for (f in datafiles) {
  if (f == "README.md") { next }

  d = read.csv(file.path(filepath, f))
  cn = rbind(cn, sum(d[c(d$Country_Region == "China",
                         d$Country.Region %in% c("China", "Mainland China")), c("Confirmed")], na.rm=T))
}

cn = cbind(cn, c(0, diff(cn[,])))
names(cn) = c("Confirmed", "Diff")

#-----------------------------
# Read NYT Datatset
#-----------------------------
series = list()

states = read.csv("covid-19-data/us-states.csv")
series[["ny"]] = data.frame(states[states$state == "New York", c("cases")])
series[["ca"]] = data.frame(states[states$state == "California", c("cases")])

counties = read.csv("covid-19-data/us-counties.csv")
series[["la"]] = data.frame(counties[counties$county == "Los Angeles", c("cases")])
series[["sf"]] = data.frame(counties[counties$county == "San Francisco", c("cases")])

for (i in 1:length(series)) {
  series[[i]] = cbind(series[[i]], c(0, diff(series[[i]][,])))
  names(series[[i]]) = c("Confirmed", "Diff")
}

#-----------------------------
# Plot
#-----------------------------
c = c("#000000", "#E69F00", "#56B4E9", "#009E73",
      "#0072B2", "#D55E00", "#CC79A7")

png("covid_plot.png")
options(scipen=999)

plot(series[[1]]$Confirmed, series[[1]]$Diff,
     type="b", col=c[1],
     xlim=range(1,max(series[[1]]$Confirmed)),
     ylim=range(1,max(series[[1]]$Diff)),
     log="xy", xlog=TRUE, ylog=TRUE,
     xlab="Confirmed Cases",
     ylab="Daily Cases")

for (i in 2:length(series)) {
  lines(series[[i]]$Confirmed, series[[i]]$Diff, type="b", col=c[i])
}

legend("topleft", lty=c(1,1), bty="n", col=c,
       legend=c("New York", "California", "Los Angeles", "San Francisco"))

dev.off()

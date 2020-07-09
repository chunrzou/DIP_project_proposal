Project description
=================================
Covid-19 broke out in 2020 in US. The number of cases increased everyday varied at different counties of different states. The change of number of cases in each county can be seen as a time sequence. Different patterns of case increase should be observed among different counties. The pattern will be associated with different factors such as population density, poverty rate, education level, unemployment rate, temperature and number of travelling each day at each county. My aim is to clustering the patterns of case increasing in each county by employing LSTM (dimension reduction) and K-means method (clustering) and find out the factors that will significantly affect the pattern of increasing cases in each cluster.



Data description
=================================
Education.csv                   -- Education level in each county (refer to https://www.ers.usda.gov/data-products/county-level-data-sets/)<br/>
PopulationEstimates.csv         -- Population estimated in in each county (refer to https://www.ers.usda.gov/data-products/county-level-data-sets/)<br/>
PovertyEstimates.csv            -- Poverty rate in in each county (refer to https://www.ers.usda.gov/data-products/county-level-data-sets/)<br/>
Unemployment.csv                -- Unemployment rate in each county (refer to https://www.ers.usda.gov/data-products/county-level-data-sets/)<br/>
us-counties.csv                 -- Covid-19 daily cases in US (refer to https://github.com/nytimes/covid-19-data)<br/>
StateCode.csv                   -- State code for each county (refer to https://worldpopulationreview.com/states/state-abbreviations/)<br/>

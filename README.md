# Wave Height Direction
 Manipulating data of waves in a large scale

Here we have a dataset of observations of the wave heights, wind direction and other parameters over a period of 23 years. However, we're interested in the dataset of storms. Each storm consists of several observations and we specifically are interested to obtain the wave height(Hs) during the peak of the storm.

The period of time in which the wave height is larger than a threshold is defined as a storm. This analysis is called peak-over-threshold (PoT) method. We're usually interested in the highest value of wave height in each storm (Hss).

As it can be seen in the first plot, the major peaks in the wave height happens at two distinct directions. First at around 90 degrees (East)and second at around 230 degrees (South-West). However, we're interested in the Highest peak, so we filter out data accordingly. in this case we chose data with directions between 150 and 300.

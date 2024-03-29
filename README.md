This is a practice exercise using the dataset https://datadryad.org/stash/dataset/doi:10.5061/dryad.b8gtht7bh where actigraphy data was collected from individuals with chronic insomnia (n=40) and their healthy bed partners (n=40). C1045 and P1045 were used to build the codes and C1057/P1057 and C1182/P1182 were used to test them. The data were collected using Respironics Actiwatch Spectrum Pro and Actiware software (Respironics, Bend, OR, USA), with movement counts sampled in 60-second epochs. In addition to movement, light exposure (on the wrist) was also recorded.

The MPI_BC.m script provides the overall workflow/analysis pipeline. It contains four functions:

1. nocturnal_actigraph.m graphs the nocturnal activity of chronic insomnia and their health bed partners and tests the difference between groups.
2. bin_m calculates and bins the hourly, 30-minute and 1-minute average  activity and light exposure across multiple days of chronic insomnia and their healthy bed partners. 
3. R_acti_wrgb calculates the correlation of the averaged (i.e., binned) hourly activity and light exposure for every type of light - white, red, blue and green.
4. cosinor.m fits a double harmonic regression curve on the raw actigraph data and calculates the tau (i.e., period) for chronic insominia and their healthy bed partners. 

The codes in this repository are all custom-made. Please ask for permission when using them. Thank you!

# vaers
Back of the envelop calculations on expected deaths reported to VAERS

I used the 2021 VAERS data set to determine the average time from vaccine administration to death in all COVID-19 vaccine reported deaths.
I then used the 2020 population and overall death estimates as well as the number of pepole who have received vaccines to calculate the following:

```
PROBABILITY_OF_DEATH_FROM_RANDOM_CHANCE = TOTAL_US_DEATHS_2020 X (AVERAGE_DAYS_BETWEEN_VACCINE_AND_DEATH / 366) / TOTAL_US_POPULATION
EXPECTED_DEATHS_WITHIN_PERIOD = PEOPLE_RECEIVED_AT_LEAST_ONE_DOSE x PROBABILITY_OF_DEATH_FROM_RANDOM_CHANCE
```

All code is in the `vaers.jl` file.

__THESE ARE BACK OF THE ENVELOPE CALCULATIONS.
I DID NOT TAKE INTO ACCOUNT AGE STRATIFICATION OF THE VACCINATED POPULATION AND MANY OTHER RELEVANT FACTORS.
THIS IS SIMPLY MEANT TO ILLUSTRATE THAT ONE WOULD EXPECT A LOT OF DEATHS TO BE REPORTED TO VAERS.__

using DataFrames, CSV, Statistics, Dates

import Dates.Date
Date(::Missing, str::String) = missing
isnotmissing(x) = !ismissing(x)
day_value(x::Day) = x.value
day_value(::Missing) = missing

cd(@__DIR__)

vaers_path = "2021VAERSData" # downloaded on 1/17/2022 from https://vaers.hhs.gov/data.html
vax_path = joinpath(vaers_path, "2021VAERSVAX.csv")
data_path = joinpath(vaers_path, "2021VAERSDATA.csv")

vax_df = CSV.read(vax_path, DataFrame)
data_df = CSV.read(data_path, DataFrame)

df = innerjoin(vax_df, data_df, on=:VAERS_ID)
vax_df = nothing
data_df = nothing

relevant_cols = [:DIED, :VAX_DATE, :DATEDIED]
relevant_rows = findall(x -> !ismissing(x), df.DIED)
relevant_rows2 = findall(x -> x == "COVID19", df.VAX_TYPE)
relevant_rows = intersect(relevant_rows, relevant_rows2)
df = df[relevant_rows, relevant_cols]


ismissing.(df.DATEDIED) .== ismissing.(df.DIED)
x = ismissing.(df.DIED)
y = ismissing.(df.DATEDIED)

died = findall(x -> !x, x)
date = findall(x -> !x, y)
perc_dates = length(intersect(died, date)) / length(died)



df.DATEDIED = Date.(df.DATEDIED, "mm/dd/yyyy")
df.VAX_DATE = Date.(df.VAX_DATE, "mm/dd/yyyy")

min_date = Date("12/01/2020", "mm/dd/yyyy")
max_date = Date("12/31/2021", "mm/dd/yyyy")


#some basic quality control
for i = 1:size(df, 1)
    d = df.DATEDIED[i]
    v = df.VAX_DATE[i]
    if ismissing(d - v)
        continue
    end
    if v > d || !(min_date <= d <= max_date) || !(min_date <= v <= max_date)
        df.DATEDIED[i] = missing
        df.VAX_DATE[i] = missing
    end
end





df.ONSET_DAYS = day_value.(df.DATEDIED - df.VAX_DATE)


average_onset = mean(df.ONSET_DAYS[isnotmissing.(df.ONSET_DAYS)])

n_deaths = count(x -> x == "Y", df.DIED)

deaths_2020_total = 3358814 # https://www.cdc.gov/mmwr/volumes/70/wr/mm7014e1.htm
expected_deaths_per_average_onset = deaths_2020_total / (366 / average_onset) # 2020 was a leap year
expected_deaths_per_person_per_onset = expected_deaths_per_average_onset / 330_000_000 # ~330 million people in US

vax_doses = 526898876 #https://covid.cdc.gov/covid-data-tracker/#vaccinations_vacc-total-admin-rate-total accessed 1/17/2022

expected_deaths_within_average_onset = vax_doses * expected_deaths_per_person_per_onset
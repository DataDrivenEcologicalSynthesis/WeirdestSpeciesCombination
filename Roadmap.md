# Project Roadmap 

## Project Mission and Summary

We're going to determine a) how to define a "weird species combination" and b) where are the weirdest groupings of said combinations.

## Milestones 

1. ~~Figure out a question~~
2. Get some data
3. Attempt to answer question
4. Present project for other groups on June 5
5. The real project was the friendship we made along the way


## Milestone Tasks

1. Determine our research question
   - [x] Brainstorm as a group 
   - [x] Determine question parameters (e.g. what is "weird") 
   - [x] Set a deadline to reach this milestone
   
   - 20-May-20 meeting notes
      - Potential Questions/Approaches
         1. What city in Canada has the weirdest surrounding plant community?
         2. Can we place them along a "Transect of weird"?
         3. Should weirdness be defined as a) a deviation from our expected species composition? b) different from the average in the area? Should we focus only on species identities, or on traits? 
         4. Focus on plant species first, and if the approach work incorporate another taxa (e.g. mammals)
 
Weird definition: Extreme ends of a trait disribution occurring together in one place
Taxa: Vascular plants in Canada
Questions: 
   1. Are the communities closer to a city "weirder" than those further from the city? (i.e. differences within cities)
   2. Is there a gradient of strange from East to West? Will Vancouver be the weirdest? (i.e. differences among cities)
  
2. Find the data
   - As per 20-MAY-20 phone meeting:
      - Interested in plant species across Canada
          - likely this data will be from within 100 km of a city  
      - Generate a data set and begin exploring 
         - Combine data from GBIF and TRY databases pairing species occurances with traits
         
  - [x] Decided on six populous Canadian cities spanning a gradient from West to East
         - Vancouver, Edmonton, Winnipeg, Toronto, Montreal, Halifax
         
  - [x] Create a sampling area for each city
      - 10 x 10 km quadrats, 10 km apart, beginning in the city and moving north
      
  - [x] Gather all species that occur within these quadrats 
        - Use GBIF to gather species occurrences
        
  - [x] Clean species data
         - Remove taxonomists names
         - Change the format?
         
  - [x] Match species in the cities to the species in the TRY database
         - request TRY data using the species codes
         - Common traits: specific leaf area, height, number of flowers, number of seeds
         
   - [x] Merge the species dataset for each city-quadrat with TRY information
  
   
3. Answer the question
   - [ ] Generate histograms
        - [ ] for each quadrat create histograms for the distribution of each trait (4 traits x 5 quadrats a city x 6 cities = 120 histograms?)
   - [ ] Determine the "weird species" within each quadrat (or in the city overall)
   
   Question 1: Differences within cities
   - [ ] Determine the weirdest area of the city (closer to the city center or more northern?)
      - Std. as a response variable and distances as the predictor? So just a simple linear regression?
   
   Question 2: Differences among cities
   - [ ] Use standard deviation of trait dispersal as response variable
      - ANCOVA w/ standard deviation ~ distance * city for each trait
      

4. Share with DDES group
   - [ ] Make some figures
   
   
   

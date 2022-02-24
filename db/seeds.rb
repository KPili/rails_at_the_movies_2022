# Library bundled with rails to parse data from a csv file
require "csv"

# Fresh database to start
Movie.delete_all
ProductionCompany.delete_all
Page.delete_all
Genre.delete_all
MovieGenre.delete_all

# Access the CSV file
filename = Rails.root.join("db/top_movies.csv") # Outputs absolute path of the file name
# puts "Loading Movie the CSV file: #{filename}"

csv_data = File.read(filename) # Return everything from csv and store it

# Parse out data row by row in the csv file
movies = CSV.parse(csv_data, headers: true, encoding: "utf-8")

movies.each do |m|
  # populate database
  # First create a variable that creates production company data for our PK table
  # Note: The example below would violate contraints for uniqueness if there are multiple of the same production companies.
  # production_company = ProductionCompany.create(name: m["production_company"])

  # To get arround the uniqueness constraint, use find_or_create_by
  # This will either return a found production company, or create a new one
  production_company = ProductionCompany.find_or_create_by(name: m["production_company"])

  # Apply safeguards to assure validation of uniqueness is not violated
  # Check if a production_company is created & passes validation before creating movie data
  if production_company && production_company.valid?
    # Create a movie for the production company
    # We will use association to create a movie
    movie = production_company.movies.create(
      title:        m["original_title"],
      year:         m["year"],
      duration:     m["duration"],
      description:  m["description"],
      average_vote: m["avg_vote"]
    )

    unless movie&.valid?
      puts "Invalid movie #{m['original_title']}"
      next
    end

    # Create our genres in this space
    genres = m["genre"].split(",").map(&:strip) # this is short hand. Long Form: collection.map {|collection_item|collection_item.strip}

    genres.each do |genre_name|
      genre = Genre.find_or_create_by(name: genre_name)

      MovieGenre.create(movie: movie, genre: genre)
    end
    # End our genre creations

  else # Provide details on why a failure occurred
    puts "Invalid production company #{m['production_company']} for movie #{m['original_title']}"
  end
end

puts "Created #{ProductionCompany.count} Production Companies"
puts "Created #{Movie.count} Movies"
puts "Created #{Genre.count} Genres"
puts "Created #{MovieGenre.count} Movie Genres"

### Working with Pages Model (note: This method in practice is not recommended unlesss testing)
Page.create(
  title:     "About the Data",
  content:   "The data powering this lovely website was provided by IMDB Kaggle Dataset.",
  permalink: "about"
)
Page.create(
  title:     "Contact Us",
  content:   "If you like this site and want to chat about the project or the data, email me at: obviously_faker@email.com",
  permalink: "contact"
)

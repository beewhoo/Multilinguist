require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://bitmakertranslate.herokuapp.com"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end



class Mathgenius < Multilinguist

  def report_total(problem)
      say_in_local_language("The total is #{problem.sum}")
  end

end

class Quotecollector < Multilinguist

  def initialize
    @favquotes = []
  end


  def all
    @favquotes
  end


  def add(value)
    @favquotes << value
  end

  def random
    say_in_local_language(@favquotes.sample)
  end

end


#quotecollector

quote1 = Quotecollector.new


quote1.add("You know you’re in love when you can’t fall asleep because reality is finally better than your dreams.")
quote1.add("Twenty years from now you will be more disappointed by the things that you didn’t do than by the ones you did do")
quote1.add("Get busy living or get busy dying")

p quote1.all

p quote1.travel_to("Italy")
p quote1.random

# # Math Genius
#
# me = Mathgenius.new
# math_problem = [10,20,30,40,50,60,70,80,90,100]
# # p me.report_total(math_problem)
#
# me.travel_to("Italy")
# p me.report_total(math_problem)
# me.travel_to('India')
# p me.report_total(math_problem)

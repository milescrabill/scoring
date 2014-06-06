require 'net/http'
require 'uri'

def open(url)
  Net::HTTP.get(URI.parse(url))
end

points = 0

answers = File.open("/tmp/answers", "r") { |f| f.read.split("\n") }
scoring_pages = File.open("/tmp/scoring_pages", "r") { |f| f.read.split("\n") }

submitted = []
scoring_pages.each { |s| submitted << open(s) }

answers.each do |answer|
  submitted.each_line do |submitted_line| 
    if answer == submitted_line
      points += 1
  end
end

puts points
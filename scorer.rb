#!/usr/bin/env ruby
require 'daemons'
require 'open-uri'

def open(url)
  URI.parse(url).read
end

answers = File.open("/tmp/scoring/answers", "r") { |f| f.read.split("\n") }
scoring_pages_url = File.open("/tmp/scoring/scoring_pages", "r") { |f| f.read }

# Daemons.run_proc('edurange-scorer', :log_output => true) do
#   loop do
    points = 0
    submitted = []

    scoring_pages = open(scoring_pages_url).split("\n")
    scoring_pages.each { |s| submitted << open(s).split("\n") }
    submitted.flatten!
    submitted.each { |s| s.chomp }

    answers.each do |answer|
      submitted.each do |submitted_line|
        File.open("/tmp/scoring/log", "a+") { |f| f.write("'" + answer + "'" + " : " + "'" + submitted_line + "'" + "\n") }
        if answer == submitted_line
          points += 1
        end
      end
    end

    File.open("/tmp/scoring/points", "w+") { |f| f.write(points.to_s + "\n") }

    sleep(0.5)
#   end
# end
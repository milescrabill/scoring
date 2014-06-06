#!/usr/bin/env ruby
require 'daemons'
require 'net/http'
require 'uri'

def open(url)
  Net::HTTP.get(URI.parse(url))
end

answers = File.open("/tmp/answers", "r") { |f| f.read.split("\n") }
scoring_pages = File.open("/tmp/scoring_pages", "r") { |f| f.read.split("\n") }

Daemons.run_proc('edurange-scorer', :log_output => true) do
  loop do
    points = 0

    submitted = []
    scoring_pages.each { |s| submitted << open(s) }

    answers.each do |answer|
      submitted.each_line do |submitted_line| 
        if answer == submitted_line
          points += 1
      end
    end

    File.open("/tmp/points", "w+") { |f| f.write(points) }

    sleep(0.5)
  end
end
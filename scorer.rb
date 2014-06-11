#!/usr/bin/env ruby
require 'daemons'
require 'open-uri'

def open(url)
  URI.parse(url).read
end

answers = File.open("/tmp/scoring/answers", "r") { |f| f.read.split("\n") }
answers.each do |a|
  a.chomp
  a.strip
end
answers.reject! { |a| a.empty? }
answers.uniq!

scoring_pages_url = File.open("/tmp/scoring/scoring_pages", "r") { |f| f.read }

Daemons.run_proc('edurange-scorer', :log_output => true) do
  loop do
    points = 0
    submitted = []
    loginfo = ""

    scoring_pages = open(scoring_pages_url).split("\n")
    scoring_pages.each { |s| submitted << open(s).split("\n") }
    submitted.flatten!
    submitted.each do |s|
      s.chomp
      s.strip
    end
    submitted.reject! { |s| s.empty? }
    submitted.uniq!

    answers.each do |answer|
      submitted.each do |submitted_line|
        if answer == submitted_line
          loginfo += "'" + answer + "'" + " : " + "'" + submitted_line + "'" + "\n"
          points += 1
        end
      end
    end

    File.open("/tmp/scoring/points", "w+") { |f| f.write(points.to_s + "\n") }
    File.open("/tmp/scoring/log", "a+") { |f| f.write(Time.now.to_s + "\n" + loginfo) }

    sleep(0.5)
  end
end
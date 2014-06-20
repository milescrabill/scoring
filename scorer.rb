#!/usr/bin/env ruby
require 'daemons'
require 'open-uri'

# the url for the list of scoring_pages
scoring_pages_url = File.open("/tmp/scoring/scoring_pages", "r") { |f| URI.parse(f.read) }

Daemons.run_proc('edurange-scorer',
  #:log_output => true) 
) do
    loop do
      submitted = []
      loginfo = ""

      # download and clean up the scenario answers
      # each loop just to check if they were changed
      # this is lazy but it works
      answers = File.open("/tmp/scoring/answers", "r") { |f| f.read.split("\n") }
      answers.each do |a|
        a.chomp
        a.strip
      end
      answers.reject! { |a| a.empty? }
      answers.uniq!

      # get the answers out of each scoring page and score them
      # this happens on a per scorable instance basis
      scoring_pages = scoring_pages_url.read.split("\n")
      scoring_pages.each do |s|
        points = 0
        s = URI.parse(s)

        # read and clean up the submitted answers
        submitted << s.read.split("\n")
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

        filename = "/tmp/scoring/points/" + s.path
        File.open(filename + "-points", "w+") { |f| f.write(points.to_s + "\n") }
        
        # logging is a little tricky because we can't get modification times from AWS
        # so this updates way too often (constantly repeats) and I don't want to bother fixing it
        # File.open(filename + "-log", "a+") { |f| f.write(Time.now.to_s + "\n" + loginfo) }
      end

      sleep(5)
    end
  end
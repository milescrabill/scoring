#!/usr/bin/env ruby
require 'daemons'
require 'digest/md5'
require 'net/http'
require 'logger'

# current directory
# @dir = File.dirname(File.expand_path(__FILE__)) + "/"

@dir = '/tmp/scoring/'
@scorefile = @dir + "answers"
@log = @dir + "log"
@scoring_url = @dir + 'scoring_url'

def upload
  # build a PUT request
  put = Net::HTTP::Put.new(open(@scoring_url).read.chomp, {
    'content-type' => 'text/plain',
  })
  put.body = @contents

  # send the PUT request
  http = Net::HTTP.new('edurange-scoring.s3.amazonaws.com', 80)
  http.set_debug_output(Logger.new($stdout))
  http.start
  resp = http.request(put)
  resp = [resp.code.to_i, resp.to_hash, resp.body]
  http.finish
end

def log
  File.open(@log, 'a') { |log| log.puts(@mtime.to_s + "\n" + @contents + "\n") }
end

@mtime = Time.at(0)
Daemons.run_proc(
  'scorefile-upload',
  log_output: true
) do
  loop do
      File.open(@scorefile, 'r') { |s|
      @contents = s.read
      upload and log if s.mtime > @mtime
      @mtime = s.mtime
    }

    sleep(0.5)
  end
end
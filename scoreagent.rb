#!/usr/bin/env ruby

require "aws"
require "daemons"

@s3 = AWS::S3.new

@pwd = File.dirname(File.expand_path(__FILE__))

@scorefile = @pwd + "/score"
@bucketname = "edurange"
@log = @pwd + "/log"

def upload
  bucket = @s3.buckets[@bucketname]
  @s3.buckets.create(@bucketname) if bucket.nil?
  obj = bucket.objects[@scorefile]
  bucket.objects.create(@scorefile, open(@scorefile))
end

def log
  File.open(@log, 'a') { |log| log.puts(@mtime.to_s + "\n" + @contents + "\n") }
end

@mtime = Time.at(0)
Daemons.run_proc(
  'scorefile-upload',
  :log_output => true
) do
  loop do
    scoreagent = File.open(@scorefile, 'r') { |s|
      @contents = s.read
      upload and log if s.mtime > @mtime
      @mtime = s.mtime
    }

    sleep(0.5)

  end
end


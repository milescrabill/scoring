#!/usr/bin/env ruby

require "aws"
require "daemons"
require 'pry'



@s3 = AWS::S3.new(:access_key_id => 'AKIAIT47ECWW2NUAFKPQ',
:secret_access_key => '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')
@pwd = File.dirname(File.expand_path(__FILE__))
@scorefile = @pwd + "/score"
@objname = "score"
@bucketname = "edurange"
@log = @pwd + "/log"

def upload
  bucket = @s3.buckets[@bucketname]
  @s3.buckets.create(@bucketname) if bucket.nil?
  obj = bucket.objects[@objname]
  obj.write(@contents)
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
      File.open(@scorefile, 'r') { |s|
      @contents = s.read
      upload and log if s.mtime > @mtime
      @mtime = s.mtime
    }

    sleep(0.5)
  end
end

#needs aws credentialse
#get answers >> scorefile

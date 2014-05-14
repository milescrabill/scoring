#!/usr/bin/env ruby

require "aws"
require "daemons"

s3 = AWS::S3.new

scorefile = "score"
bucketname = "edurange"
log = "log"

bucket = s3.buckets[bucketname]

s3.buckets.create(bucketname) if bucket.nil?

scoreagent = File.new(scorefile, 'w') unless File.exists?(scorefile)
scoreagent = File.new(scorefile, 'r')
logfile = File.new(log, 'w') unless File.exists?(log)

mtime = Time.at(0)

Daemons.run_proc(
  'test-shit',
  :log_output => true
) do
  loop do
    if scoreagent.mtime > mtime
      mtime = scoreagent.mtime
      contents = File.read(scorefile)
      obj = bucket.objects[scorefile]
      bucket.objects.create(scorefile, open(scorefile)) unless obj.exists?
      obj.write(contents)
      File.open(log, 'a') { |log| log.puts(mtime.to_s + "\n" + contents + "\n") }
    end
  end
end
require 'aws'

s3 = AWS::S3.new(
  :access_key_id => 'abc',
  :secret_access_key => '123'
)

scorefile = 'score'
bucketname = 'edurange'

unless bucket.exists?
  s3.buckets.create(bucketname)

bucket = s3.buckets[bucketname] 
scoreagent = File.new(scorefile, 'r')
contents = File.read(scorefile)
mtime = scoreagent.mtime

loop do
  if scoreagent.mtime > mtime
    S3Object.store(scorefile, open(scorefile), bucketname)
    log = 'log'
    File.open(log, 'a') { |log| log.puts(mtime.to_s + "\n" + contents + "\n") }
    mtime = scoreagent.mtime
  end
end
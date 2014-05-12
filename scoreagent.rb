# s3 = AWS::S3.new(
#   :access_key_id => 'abc',
#   :secret_access_key => '123'
# )

scorefile = "score"
mode = "r"
bucketname = "recon"

# Bucket.create(bucketname)

scoreagent = File.new(scorefile, mode)
contents = File.read(scorefile)
mtime = scoreagent.mtime

loop do
  if scoreagent.mtime > mtime
    # S3Object.store(scorefile, open(scorefile), bucketname)
    log = "log"
    File.open(log, 'a') { |log| log.puts(mtime.to_s + "\n" + contents + "\n") }
    mtime = scoreagent.mtime
  end
end
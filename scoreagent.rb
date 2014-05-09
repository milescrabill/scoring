AWS::S3::Base.establish_connection!(
  :access_key_id     => 'abc',
  :secret_access_key => '123'
)

scorefile = "scoreagent"
mode = "r"
bucketname = "recon"

Bucket.create(bucketname)

scoreagent = File.new(scorefile, mode)
mtime = scoreagent.mtime

loop do
  if scoreagent.mtime > mtime
    S3Object.store(scorefile, open(scorefile), bucketname)
    log = "log"
    File.open(log, 'w') { |log| log.write(mtime) }
    mtime = scoreagent.mtime
  end
end
require 'aws'

s3 = AWS::S3.new(
  :access_key_id => 'AKIAJJWCYVD6QPYXISGQ',
  :secret_access_key => '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'
)

scorefile = 'score'
bucketname = 'edurange'
log = 'log'

bucket = s3.buckets[bucketname]

s3.buckets.create(bucketname) if bucket.nil?

scorefile = File.new(scorefile, 'w') unless File.exists?(scorefile)

scoreagent = File.new(scorefile, 'r')
mtime = scoreagent.mtime

loop do
  if scoreagent.mtime >= mtime
  	contents = File.read(scorefile)
  	obj = bucket.objects[scorefile]
  	bucket.objects.create(scorefile, open(scorefile)) unless obj.exists?
  	obj.write(contents)
    File.open(log, 'a') { |log| log.puts(mtime.to_s + "\n" + contents + "\n") }
    mtime = scoreagent.mtime
  end
end
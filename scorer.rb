require 'aws-sdk'
require 'string_score/ext/string'

s3 = AWS::S3.new
submitted = bucket.objects[instance.uuid + "-scoring"].read
answers = bucket.objects["answers?"].read

#accessbucket

submitted.each_line { |line| 
	scorekey = StringScore.new(line)
	answers.each_line { |line|
		scorekey.score(line)
  }
}

#save scores
#generate a web ui table
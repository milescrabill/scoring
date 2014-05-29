require 'aws-sdk'
require 'string_score/ext/string'
require 'edurange'

s3 = AWS::S3.new
submitted = bucket.objects[instance.uuid + "-scoring"].read
# answers = bucket.objects["answers?"].read

scenario_name = "recon"
YmlRecord.load_yml(scenario_name)

#accessbucket
points = 0

submitted.each_line do |submitted_line| 
	scorekey = StringScore.new(submitted_line)
	answers.each_line do |answers_line|
    if scorekey.score(answers_line) == 1
      points += 1
  end
end

#save scores
#generate a web ui table
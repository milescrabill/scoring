require 'aws-sdk'
require 'string_score/ext/string'
require 'edurange'

s3 = AWS::S3.new
submitted = bucket.objects[instance.uuid + "-scoring"].read
# answers = bucket.objects["answers?"].read

scenario_name = "recon"

answers = yml["Answers"]

#accessbucket
points = 0

answers.each do |answer|
  scorekey = StringScore.new(answer)

  submitted.each_line do |submitted_line| 
    if scorekey.score(submitted_line) == 1
      points += 1
  end
end

puts points

#save scores
#generate a web ui table
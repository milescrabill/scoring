filename = ARGV.first

if filename.nil?
	@answers_doc = []
	prompt = "Enter Answers (one per line), when done type: 'done'"
	puts prompt
	loop do
		answer = gets.chomp
		if answer == "done" 
			break
		end
		@answers_doc << answer 
	end
else
	File.open(filename, 'r') { |file| @answers_doc = file.read }
end

File.open("/tmp/scoring", 'w') { |file| file.write(@answers_doc) }

#make sure output file is answers seperated by \n
#if user submits file without spaces then WRONG

#./answer
#hey enter your answers
#10.1.1.3
#10.5.3.2
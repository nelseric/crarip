require 'rubygems'
require 'mysql'
require 'tba'

tba = TBA.new("e9f1ef17b855b367caac352dcf2bdeeb")
test = tba.get_events(:year=>"2001")
test.each do
	|t|
	puts t.inspect
end
=begin
[{:robotname=>"CRR1", 
 :website=>"http://www.coderedrobotics.com",
 :informalname=>"", 
 :tba_link=>"http://www.thebluealliance.net/tbatv/team.php?team=2771", 
 :teamnumber=>"2771", 
 :city=>"Grandville", 
 :country=>"", 
 :name=>"Huizenga Group / RoMan Manufacturing / GM / PTC / BAE SYSTEMS & Grand River Preparatory High School", 
 :state=>"MI", 
 :rookieyear=>"2009"}]

=end


	
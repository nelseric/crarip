# Written by Alex Kern of FRC Team 1515 (MorTorq) and FTC Team 161 (BHRobotics)
# Do whatever you want with this, though I'd appreciate some sort of credit if used. :)
# This is released AS IS and does not come with any warranty.  Use at your own risk.
# Version 1.1

# TO USE IN RAILS:
# Place this file in lib/ and include it into your Application Controller.  Then create the TBA object as you choose. See the bottom of this document for an example.

require 'open-uri'
require 'rexml/document'

class TBA
	def initialize(api_key)
		# Do not edit this method unless you REALLY need to
		@api_key = api_key
		
		@api_url = "http://thebluealliance.net/tbatv/api.php"
		@version = 1
	end
	
	# Default arguments for the API calls
	# DO NOT EDIT
	def default_arguments
		{
			:version => @version,
			:api_key => @api_key
		}
	end
	
	# Low level API call
	def call_api_method(method, args)
		method = method.to_s
		
		# Assmble the argument list
		arguments = args.merge default_arguments
		arguments = arguments.merge({:method => method})
		argument_string = ""
		
		# Encode the arguments into the URL
		arguments.each do |key, value|
			argument_string += "#{key}=#{value}&"
		end
		argument_string = argument_string[0..-2] # Chop off the last &
		
		# Retrieve the XML
		file = "#{@api_url}?#{argument_string}"
		raise Exception, "No such TBA file could be found." unless response = open(file).read
		raise Exception, "Could not read TBA file." unless doc = REXML::Document.new(response)
		
		# Retrieve the data into a hash
		array = []
		doc.elements.each do |root|
			root.elements.each do |child|
				child_hash = {}
				child.elements.each do |element|
					child_hash = child_hash.merge({element.name.to_sym => element.text.to_s})
				end
				array.push child_hash
			end
		end
	 	if array[0]
			# This means there was an error
			raise Exception, "Error code #{array[0][:code]}: #{array[0][:text]}" if array[0][:code] && array[0][:text]
			raise Exception, "Error code #{array[0][:code]}" if array[0][:code] && !array[0][:text]
		else
			# This means the query was false or returned nothing
			return false
		end
		
		array
	end
	
	# Combines arguments so there are only arguments supported by the method
	def combine_arguments(optional_args, args)
		combined = {}
		optional_args.each do |argument_name|
			combined = combined.merge({argument_name => args[argument_name]}) if args[argument_name]
		end
		
		combined
	end
	
	# Convenience methods
	# See the API documentation for details: http://thebluealliance.net/tbatv/api/apidocs.pdf
	def get_teams(args)
		arguments = combine_arguments [:teamnumber, :state], args
		call_api_method(:get_teams, arguments)
	end
	
	def get_events(args)
		arguments = combine_arguments [:eventid, :year, :week], args
		call_api_method(:get_teams, arguments)
	end
	
	def get_matches(args)
		arguments = combine_arguments [:teamnumber, :eventid, :matchid, :complevel], args
		call_api_method(:get_matches, arguments)
	end
	
	def get_attendance(args)
		arguments = combine_arguments [:eventid, :teamnumber], args
		call_api_method(:get_attendance, arguments)
	end
	
	def get_official_record(args)
		arguments = combine_arguments [:teamnumber, :eventid, :matchid, :complevel], args
		call_api_method(:get_official_record, arguments)
	end
	
	def get_elim_sets(args)
		arguments = combine_arguments [:eventid, :noun], args
		call_api_method(:get_elim_sets, arguments)
	end
end

# Example:
# tba = TBA.new("place_api_key_here")
# p tba.get_teams(:teamnumber => "1515")
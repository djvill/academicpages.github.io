require 'liquid'
require 'uri'

# Replace state name with postal code abbreviation
module Jekyll
  module StateAbbr
		def abbr_replace(string)
			case string
			when "Alabama"
				return "AL"
			when "Alaska"
				return "AK"
			when "Arizona"
				return "AZ"
			when "Arkansas"
				return "AR"
			when "California"
				return "CA"
			when "Colorado"
				return "CO"
			when "Connecticut"
				return "CT"
			when "Delaware"
				return "DE"
			when "Florida"
				return "FL"
			when "Georgia"
				return "GA"
			when "Hawaii"
				return "HI"
			when "Idaho"
				return "ID"
			when "Illinois"
				return "IL"
			when "Indiana"
				return "IN"
			when "Iowa"
				return "IA"
			when "Kansas"
				return "KS"
			when "Kentucky"
				return "KY"
			when "Louisiana"
				return "LA"
			when "Maine"
				return "ME"
			when "Maryland"
				return "MD"
			when "Massachusetts"
				return "MA"
			when "Michigan"
				return "MI"
			when "Minnesota"
				return "MN"
			when "Mississippi"
				return "MS"
			when "Missouri"
				return "MO"
			when "Montana"
				return "MT"
			when "Nebraska"
				return "NE"
			when "Nevada"
				return "NV"
			when "New Hampshire"
				return "NH"
			when "New Jersey"
				return "NJ"
			when "New Mexico"
				return "NM"
			when "New York"
				return "NY"
			when "North Carolina"
				return "NC"
			when "North Dakota"
				return "ND"
			when "Ohio"
				return "OH"
			when "Oklahoma"
				return "OK"
			when "Oregon"
				return "OR"
			when "Pennsylvania"
				return "PA"
			when "Rhode Island"
				return "RI"
			when "South Carolina"
				return "SC"
			when "South Dakota"
				return "SD"
			when "Tennessee"
				return "TN"
			when "Texas"
				return "TX"
			when "Utah"
				return "UT"
			when "Vermont"
				return "VT"
			when "Virginia"
				return "VA"
			when "Washington"
				return "WA"
			when "West Virginia"
				return "WV"
			when "Wisconsin"
				return "WI"
			when "Wyoming"
				return "WY"
			else
				return string
			end
		end
    def state_abbr(loc)
      return loc.split(', ').map{|token| abbr_replace token}.join(', ')
    end
  end
end

Liquid::Template.register_filter(Jekyll::StateAbbr)

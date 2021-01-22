note
	description: "Summary description for {REPRESENTATION_UTILS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REPRESENTATION_UTILS

create
	make

feature -- Initialization
	result_string: STRING

	make
	do
		result_string := ""
	end

feature -- Creates a string representation from a JSON object
	create_json_string(json_object: JSON_OBJECT)
	-- Creates a string representation for `json_object`
	local
		json_keys: ARRAY[JSON_STRING]
		json_val: JSON_VALUE
		formatter: FORMAT_DOUBLE
		current_string: STRING
		value_count: INTEGER
	do
		result_string := ""
		result_string.append("{")
		if attached json_object.current_keys then
			value_count := 1
			-- Get JSON keys
			json_keys := json_object.current_keys
			across json_keys as current_key loop
				-- Append key name
				result_string.append(current_key.item.representation + ": ")
				-- Append value
				if attached json_object.item(current_key.item) as val then
					json_val := val
					-- Format value if number
					if json_val.is_number then
						create formatter.make(10, 2)
						current_string := formatter.formatted(json_val.representation.to_real_64)
						current_string.adjust
						result_string.append(current_string)
					else
						result_string.append(json_val.representation)
					end
					if value_count /= json_object.count then
						result_string.append(", ")
					end
				end
				value_count := value_count + 1
			end
		end
		result_string.append("}")
	end

end

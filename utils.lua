function Check_tables_equal(t1, t2)
	for a, b in pairs(t1) do
		if type(b) == "table" then
			if type(t2[a]) == "table" then
				if Check_tables_equal(b, t2[a]) then
				else
					return false
				end
			else
				return false
			end
		else
			if b == t2[a] then
			else
				return false
			end
		end
	end
	return true
end

function Check_in_table(t1, val)
	for _, b in pairs(t1) do
		if type(val) == "table" then
			if type(b) == "table" then
				if Check_tables_equal(val, b) then
					return true
				end
			end
		elseif b == val then
			return true
		end
	end
	return false
end

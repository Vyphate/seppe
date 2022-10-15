--// Seppe ~ Lightweight project builder by @woebong.
--// Gamecore.

local Seppe = {}
Seppe.__index = Seppe
Seppe.IndexableServices = true
Seppe.CapFailure = false
Seppe.Services = setmetatable({}, {
	__mode = { 'kv' };
})

function Seppe.__initialize__()
	local self = Seppe
	
	self.Project = 'nil'
	return self
end

function Seppe:CreateService(Service)
	assert(not Seppe.Services[Service[1]],
		('%s # This service already exists!')
		:format(self.Project)
	)
	Seppe.Services[Service[1]] = setmetatable({
		__index = Seppe.Services[Service[1]]}, Seppe.Services[Service[1]])
	
	if (Service[2]) then
		Seppe.Services[Service[1]][Service[2]] = false
	end

	return Seppe.Services[Service[1]]
end

function Seppe:GetService(Service)
	if Seppe.Services[Service[1]] then
		return Seppe.Services[Service[1]]
	end
end

function Seppe:catch(rejectable)
	local _, reject = pcall(function()
		for _, serviced in pairs(Seppe.Services) do
			if (serviced._init_) then
				serviced._init_()
			elseif serviced._hasInitialization then else
				warn(
					('%s # %s does not have an initializer and cannot start!')
					:format(self.Project, serviced)
				)
			end
		end
	end)
	
	if (reject) then
		rejectable(self, reject)
	end
	self.Rejected = true
	return self
end

function Seppe:resolve(resolved)
	if (not self.Rejected) then
		resolved(self)
	end
end

return Seppe

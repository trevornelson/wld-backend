module RequestSpecHelper
	def json
		JSON.parse(response.body)
	end

	def authenticate_headers(email, password)
		headers = { 'Authorization' => nil }
		auth = AuthenticateUser.call(email, password)
		if auth.success?
			headers['Authorization'] = auth.result
		end
		headers
	end
end

if @test.errors.any?
  json.status 'error'
  json.code 400
  json.message 'Update operation failed'
  json.errors @test.errors
else
  json.status 200
  json.test do
    json.id @test.id
    json.name @test.name
    json.status @test.status
  end
end

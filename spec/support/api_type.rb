module ApiType
  include Rack::Test::Methods
end

RSpec.configure do |c|
  c.include(
    ApiType,
    type: :api,
    example_group: { file_path: %r(spec/api) }
  )
end

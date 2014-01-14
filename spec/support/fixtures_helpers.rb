module FixturesHelpers

  def xml_fixture_response(file)
    WCC::Arena::Response.new(
      status: 200,
      headers: { 'content-type' => 'application/xml' },
      body: File.open(File.join(FIXTURES_DIR, file)).read
    )
  end

end

module FixturesHelpers

  def xml_fixture_response(file)
    WCC::Arena::Response.new(
      status: 200,
      headers: { 'content-type' => 'application/xml' },
      body: xml_fixture(file)
    )
  end

  def xml_fixture(file)
    File.open(File.join(FIXTURES_DIR, file)) { |f| f.read }
  end

end

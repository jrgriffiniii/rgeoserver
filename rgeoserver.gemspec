require File.join(File.dirname(__FILE__), "lib/rgeoserver/version")
Gem::Specification.new do |s|
  s.name = "rgeoserver"
  s.version = RGeoServer::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = ">=1.9.3"
  s.authors = ["Renzo Sanchez-Silva", "Bess Sadler", "Darren Hardy"]
  s.email = ["renzo.sanchez.silva@gmail.com", "drh@stanford.edu"]
  s.summary = %q{GeoServer REST API Ruby library }
  s.description = %q{GeoServer REST API Ruby library : Requires GeoServer 2.1.3+}
  s.homepage = "http://github.com/rnz0/rgeoserver"
  s.has_rdoc = true
  s.licenses = ['ALv2', 'Stanford University Libraries']
  

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {examples,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rest-client"
  s.add_dependency "nokogiri"
  s.add_dependency "mime-types"
  s.add_dependency "activesupport"
  s.add_dependency "activemodel"
  s.add_dependency "confstruct"
  s.add_dependency "rgeo", ">=0.3.20"
  s.add_dependency "rgeo-shapefile"
  s.add_dependency "rubyzip"

  s.add_development_dependency("rake")
  s.add_development_dependency("shoulda")
  s.add_development_dependency("bundler", ">= 1.0.14")
  s.add_development_dependency("rspec")
  s.add_development_dependency("yard")
  s.add_development_dependency("equivalent-xml")
  s.add_development_dependency("jettywrapper")
  s.add_development_dependency("pry")
  s.add_development_dependency("debugger", ">=1.5")
  s.add_development_dependency("irbtools")
  s.add_development_dependency("awesome_print")
end

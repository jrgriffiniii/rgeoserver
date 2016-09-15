
require 'pathname'

module RGeoServer
  # A coverage store is a source of spatial data that is raster based.
  class CoverageStore < ResourceInfo
    class CoverageStoreAlreadyExists < StandardError
      def initialize(name)
        @name = name
      end

      def message
        "The CoverageStore '#{@name}' already exists and can not be replaced."
      end
    end

    class DataTypeNotExpected < StandardError
      def initialize(data_type)
        @data_type = data_type
      end

      def message
        "The CoverageStore does not not accept the data type '#{@data_type}'."
      end
    end

    OBJ_ATTRIBUTES = {
      :catalog => 'catalog',
      :workspace => 'workspace',
      :url => 'url',
      :data_type => 'type',
      :name => 'name',
      :enabled => 'enabled',
      :description => 'description'
    }
    OBJ_DEFAULT_ATTRIBUTES = {
      :catalog => nil,
      :workspace => nil,
      :url => '',
      :data_type => 'GeoTIFF',
      :name => nil,
      :enabled => 'true',
      :description=>nil
    }
    define_attribute_methods OBJ_ATTRIBUTES.keys
    update_attribute_accessors OBJ_ATTRIBUTES

    @@route = "workspaces/%s/coveragestores"
    @@root = "coverageStores"
    @@resource_name = "coverageStore"

    def self.root
      @@root
    end

    def self.resource_name
      @@resource_name
    end

    def self.root_xpath
      "//#{root}/#{resource_name}"
    end

    def self.member_xpath
      "//#{resource_name}"
    end

    def route
      @@route % @workspace.name
    end

    def update_params name_route = @name
      { :name => name_route, :workspace => @workspace.name }
    end

    def message
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.coverageStore {
          xml.name @name
          xml.workspace {
            xml.name @workspace.name
          }
          xml.enabled @enabled
          xml.type_ @data_type if (data_type_changed? || new?)
          xml.description @description if (description_changed? || new?)
          xml.url @url if (url_changed? || new?) && !@url.nil
        }
      end
      @message = builder.doc.to_xml
    end

    # @param [RGeoServer::Catalog] catalog
    # @param [RGeoServer::Workspace|String] workspace
    # @param [String] name
    def initialize catalog, options
      super(catalog)
      _run_initialize_callbacks do
        workspace = options[:workspace] || 'default'
        if workspace.instance_of? String
          @workspace = @catalog.get_workspace(workspace)
        elsif workspace.instance_of? Workspace
          @workspace = workspace
        else
          raise "Not a valid workspace"
        end
        @name = options[:name].strip
        @route = route
      end
    end

    def coverages &block
      self.class.list Coverage, @catalog, profile['coverages'] || [], {:workspace => @workspace, :coverage_store => self}, true, &block
    end

    # <coverageStore>
    # <name>antietam_1867</name>
    # <description>
    # Map shows the U.S. Civil War battle of Antietam. It indicates fortifications, roads, railroads, houses, names of residents, fences, drainage, vegetation, and relief by hachures.
    # </description>
    # <type>GeoTIFF</type>
    # <enabled>true</enabled>
    # <workspace>
    # <name>druid</name>
    # <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="alternate" href="http://localhost:8080/geoserver/rest/workspaces/druid.xml" type="application/xml"/>
    # </workspace>
    # <__default>false</__default>
    # <url>
    # file:///var/geoserver/current/staging/rumsey/g3881015alpha.tif
    # </url>
    # <coverages>
    # <atom:link xmlns:atom="http://www.w3.org/2005/Atom" rel="alternate" href="http://localhost:8080/geoserver/rest/workspaces/druid/coveragestores/antietam_1867/coverages.xml" type="application/xml"/>
    # </coverages>
    # </coverageStore>
    def profile_xml_to_hash profile_xml
      doc = profile_xml_to_ng profile_xml
      h = {
        'name' => doc.at_xpath('//name').text.strip,
        'description' => doc.at_xpath('//description/text()').to_s,
        'type' => doc.at_xpath('//type/text()').to_s,
        'enabled' => doc.at_xpath('//enabled/text()').to_s,
        'url' => doc.at_xpath('//url/text()').to_s,
        'workspace' => @workspace.name # Assume correct workspace
      }
      doc.xpath('//coverages/atom:link[@rel="alternate"]/@href',
                "xmlns:atom"=>"http://www.w3.org/2005/Atom" ).each{ |l|
        h['coverages'] = begin
          response = @catalog.do_url l.text
          Nokogiri::XML(response).xpath('//name/text()').collect{ |a| a.text.strip }
        rescue RestClient::ResourceNotFound
          []
        end.freeze
      }
      h
    end

    # @param [String] path - location of upload data
    # @param [Symbol] upload_method -- only valid for :file
    # @param [Symbol] data_type -- currently only supported for :geotiff
    def upload path, upload_method = :file, data_type = :geotiff
      raise CoverageStoreAlreadyExists, @name unless new?
      raise DataTypeNotExpected, data_type unless [:geotiff].include? data_type

      case upload_method
      when :file then # local file that we post
        local_file = Pathname.new(File.expand_path(path))
        unless local_file.extname == '.tif' && local_file.exist?
          raise ArgumentError, "GeoTIFF upload must be .tif file: #{local_file}"
        end
        puts "Uploading #{local_file.size} bytes from file #{local_file}..."

        catalog.client["#{route}/#{name}/file.geotiff"].put local_file.read, :content_type => 'image/tiff'
        refresh
      else
        raise NotImplementedError, "Unsupported upload method #{upload_method}"
      end
      self
    end
  end
end

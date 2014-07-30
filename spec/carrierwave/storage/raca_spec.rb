require 'carrierwave-raca'

describe CarrierWave::Storage::Raca do
  let(:username) { "abc"}
  let(:api_key)  { "123"}
  let(:uploader) { double(:uploader, raca_username: username, raca_api_key: api_key) }

  subject(:storage) do
    CarrierWave::Storage::Raca.new(uploader)
  end

  describe '#connection' do
    it 'instantiates a new connection' do
      Raca::Account.should_receive(:new).with(username, api_key)

      storage.connection
    end
  end
end

describe CarrierWave::Storage::Raca::File do
  let(:objects)    { { 'files/1/file.txt' => file } }
  let(:container)  { double(:container, objects: objects) }
  let(:containers)  { double(:containers, get: container) }
  let(:account)    { double(:account, containers: containers) }
  let(:file)       { double(:file, read: '0101010', content_type: 'content/type', path: '/file/path') }
  let(:username) { "abc"}
  let(:api_key)  { "123"}
  let(:container_name) { "foo"}
  let(:uploader) { 
    double(:uploader, raca_username: username,
                      raca_api_key: api_key,
                      raca_container: container_name,
                      raca_region: :ord,
                      asset_host: nil
          )
  }
  let(:path)       { 'files/1/file.txt' }

  subject(:raca_file) do
    CarrierWave::Storage::Raca::File.new(uploader, account, path)
  end

  describe '#attributes' do
    context 'when the file is on cloudfiles' do
      it 'return the content_type' do
        container.stub(object_metadata: {content_type: "text/plain"})

        raca_file.attributes.should == {content_type: "text/plain"}
      end
    end
    context 'when the file is not on cloudfiles' do
    end
  end

  describe '#content_type' do
    context 'when the file is on cloudfiles' do
      it 'return the content_type' do
        container.stub(object_metadata: {content_type: "text/plain"})

        raca_file.content_type.should == "text/plain"
      end
    end
    context 'when the file is not on cloudfiles' do
    end
  end

  describe '#delete' do
    context "when the file exists on cloud files" do
      it "should delegate the deletion to the container" do
        container.should_receive(:delete).with("files/1/file.txt")
        raca_file.delete
      end
    end
    context "when the file doesn't exist on cloud files" do
      it "should return true anyway" do
        container.should_receive(:delete).with("files/1/file.txt").and_raise(::Raca::NotFoundError)
        raca_file.delete.should be true
      end
    end
  end

  describe '#extension' do
    context 'when the path ends in txt' do
      let(:path) { "foo.txt" }
      it 'returns just the extension' do
        raca_file.extension.should == "txt"
      end
    end
  end

  describe '#exists' do
  end

  describe '#filename' do
    context 'when the path has no path separators' do
      let(:path) { "foo.txt" }
      it 'returns the full path' do
        raca_file.filename.should == "foo.txt"
      end
    end

    context 'when the path has one path separator' do
      let(:path) { "foo/bar.txt" }
      it 'returns just th filename' do
        raca_file.filename.should == "bar.txt"
      end
    end
  end

  # TODO work out how to mock Raca::Container#download
  #describe '#read' do
  #  it 'reads from the remote file object' do
  #    aws_file.read.should == '0101010'
  #  end
  #end

  describe '#size' do
    context 'when the file is on cloudfiles' do
      it 'uses the asset_host and file path' do
        container.stub(object_metadata: {bytes: 100})

        raca_file.size.should == 100
      end
    end
    context 'when the file is not on cloudfiles' do
    end
  end

  describe '#store' do
    context 'when the file is already on cloudfiles' do
    end
    context 'when the file is not already on cloudfiles' do
      it 'uploads the provided file to cloudfiles' do
        container.should_receive(:upload).with(path, "io-ish", "Content-Type" => "text/plain")

        raca_file.store(double(:new_file, file: "io-ish", content_type: "text/plain"))
      end
    end
  end

  describe '#url' do
    context 'when the asset_host is set' do
      it 'uses the asset_host and file path' do
        uploader.stub(asset_host: 'http://example.com')

        raca_file.url.should eql 'http://example.com/files/1/file.txt'
      end
    end
    context 'when the asset_host is not set' do
      it 'returns path untouched' do
        uploader.stub(asset_host: nil)


        raca_file.url.should eql 'files/1/file.txt'
      end
    end
  end
end

require 'spec_helper'
require 'helpers/bridge_helpers'

describe BridgeHelpers do

  class DummyInterface

    include BridgeHelpers

  end

  class DummyBridge

    def initialize(config)
      @config = config
    end

    def self.required_args
      [:hash, :array, :string].freeze
    end

  end

  describe 'construct_bridge' do

    before do
      @interface = DummyInterface.new
    end

    it 'will raise an error if game is not specified' do
      expect{@interface.construct_bridge({})}.to \
        raise_exception('You must specify a "game"')
    end

    it 'will raise an error if bridge is not specified' do
      expect{@interface.construct_bridge({:game => 'test'})}.to \
        raise_exception('You must specify a "bridge"')
    end

    it 'will raise an error if bridge-file does not exist' do
      expect{@interface.construct_bridge({:game => 'test', :bridge => 'doesnt_exist'})}.to \
        raise_exception('Bridge: "doesnt_exist" for game: "test" does not exist..')
    end

    it 'will raise an error if the bridge-file cannot be loaded' do
      File.stub(:exists?).and_return(true)
      expect{@interface.construct_bridge({:game => 'test', :bridge => 'cant_load'})}.to \
        raise_exception(LoadError)
    end

    it 'will raise an error if the bridge cannot be instantiated' do
      File.stub(:exists?).and_return(true)
      @interface.stub(:load)
      expect{@interface.construct_bridge({:game => 'test', :bridge => 'cant_instantiate'})}.to \
        raise_exception(NameError)
    end

    it 'will raise an error if there are missing arguments' do
      File.stub(:exists?).and_return(true)
      @interface.stub(:load)
      expect{@interface.construct_bridge({:game => 'test', :bridge => 'dummy'})}.to \
        raise_exception('Bridge: "DummyBridge" is missing one or more required arguments')
    end

    it 'will attempt to load, validate and construct a bridge' do
      File.stub(:exists?).and_return(true)
      @interface.stub(:ensure_required_args!)
      @interface.should_receive(:load).with("#{BRIDGES_DIR}/test/dummy_bridge.rb")
      @interface.construct_bridge({
        :game => 'test',
        :bridge => 'dummy',
        :hash => {},
        :array => [],
        :string => '',
      }).should_not be_nil
    end

  end

end
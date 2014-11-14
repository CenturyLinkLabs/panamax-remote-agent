require 'spec_helper'
require 'stringio'
require 'logger'

describe OrchestrationAdapter::Middleware::Response::DetailLogger do

  let(:app) { double(:app) }
  let(:buffer) { StringIO.new }
  let(:logger) { Logger.new(buffer) }

  subject { described_class.new(app, logger) }

  before do
    logger.level = Logger::DEBUG
    allow(app).to receive(:call).and_return(app)
    allow(app).to receive(:on_complete)
  end

  describe '#call' do

    let(:env) do
      {
        method: 'GET',
        url: 'http://someurl.com/',
        request_headers: [ { 'Content-Type' => 'application/json' } ]
      }
    end

    it 'logs method and url at the info level' do
      subject.call(env)
      expect(buffer.string).to match /INFO.*#{env[:method]} #{env[:url]}/
    end

    it 'logs headers at the debug level' do
      subject.call(env)
      expect(buffer.string).to match /DEBUG.*#{env[:request_headers].first.values.first}/
    end

    context 'when a request body is present' do

      before do
        env[:body] = 'foo'
      end

      it 'logs request body at the debug level' do
        subject.call(env)
        expect(buffer.string).to match /DEBUG.*#{env[:body]}/
      end
    end
  end

  describe '#on_complete' do

    let(:response) { double(:response, body: nil) }

    let(:env) do
      {
        status: 200,
        response_headers: [ { 'Content-Type' => 'application/json' } ],
        response: response
      }
    end

    it 'logs the status at the info level' do
      subject.on_complete(env)
      expect(buffer.string).to match /INFO.*#{env[:status]}/
    end

    it 'logs headers at the debug level' do
      subject.on_complete(env)
      expect(buffer.string).to match /DEBUG.*#{env[:response_headers].first.values.first}/
    end

    context 'when a response body is present' do

      let(:response) { double(:response, body: 'foo') }

      it 'logs headers and request body at the debug level' do
        subject.on_complete(env)
        expect(buffer.string).to match /DEBUG.*#{env[:response].body}/
      end
    end
  end
end

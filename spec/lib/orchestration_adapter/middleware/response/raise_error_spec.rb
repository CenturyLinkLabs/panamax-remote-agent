require 'spec_helper'

describe OrchestrationAdapter::Middleware::Response::RaiseError do
  describe '#on_complete' do

    context 'when HTTP status is 200' do

      let(:env) { { status: 200 } }

      it 'raises no errors' do
        expect { subject.on_complete(env) }.to_not raise_error
      end
    end

    context 'when the HTTP status is a known error (404)' do

      let(:message) { 'not found' }

      let(:env) { { status: 404 } }

      it 'raises a NotFound execption' do
        expect { subject.on_complete(env) }.to raise_error(OrchestrationAdapter::NotFound)
      end

      context 'when the body is not JSON' do

        before do
          env[:body] = message
        end

        it 'sets uses the default message on the exception' do
          begin
            subject.on_complete(env)
            fail 'exception should have been raised'
          rescue OrchestrationAdapter::NotFound => ex
            expect(ex.message).to eq message
          end
        end
      end

      context 'when the error message is in the :message key of the body' do

        before do
          env[:body] = { message: message }.to_json
        end

        it 'sets the message on the exception' do
          begin
            subject.on_complete(env)
            fail 'exception should have been raised'
          rescue OrchestrationAdapter::NotFound => ex
            expect(ex.message).to eq message
          end
        end
      end

      context 'when the error message is in the :error key of the body' do

        before do
          env[:body] = { error: message }.to_json
        end

        it 'sets the message on the exception' do
          begin
            subject.on_complete(env)
            fail 'exception should have been raised'
          rescue OrchestrationAdapter::NotFound => ex
            expect(ex.message).to eq message
          end
        end
      end

      context 'when neither the :message or :error key is present in the body' do

        before do
          env[:body] = { foo: message }.to_json
        end

        it 'sets the message on the exception' do
          begin
            subject.on_complete(env)
            fail 'exception should have been raised'
          rescue OrchestrationAdapter::NotFound => ex
            expect(ex.message).to eq(env[:body])
          end
        end
      end
    end

    context 'when HTTP status is an unknown error' do

      let(:env) { { status: 499 } }

      it 'raises an Error execption' do
        expect { subject.on_complete(env) }.to raise_error(OrchestrationAdapter::Error)
      end
    end

  end
end

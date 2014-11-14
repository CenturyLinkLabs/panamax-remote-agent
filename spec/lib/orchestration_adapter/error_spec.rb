require 'spec_helper'

describe OrchestrationAdapter::Error do

  it 'has a nil error code' do
    expect(subject.error_code).to be_nil
  end

  describe 'HTTP error classes' do
    OrchestrationAdapter::Error::HTTP_CODE_MAP.each do |code, class_name|

      describe "OrchestrationAdapter::#{class_name}" do

        it 'exists' do
          expect { OrchestrationAdapter.const_get(class_name) }.to_not raise_error
        end

        it 'has the appropriate error code' do
          error = OrchestrationAdapter.const_get(class_name).new
          expect(error.error_code).to eq code
        end
      end
    end
  end
end

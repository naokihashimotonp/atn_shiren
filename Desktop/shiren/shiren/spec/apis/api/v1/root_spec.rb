require "rails_helper"


RSpec.describe API::V1, :type => :request do

  it "API::V1::Root" do
    headers = {
      "CONTENT_TYPE" => "application/json"
    }

    # let(:json_body) do
    #   '{ "cards" => [
    #   "H1 H13 H12 H11 H10",
    #   "H9 C9 S9 H2 C2",
    #   "C13 D12 C11 H8 H7"
    # ] }'
    # end

    request = '{
      "cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
    }'


    # request = JSON.parse(request)
    post "/api/v1", request, headers


    service = Service.new
    # response = service.create_response(params)

    # body = JSON.parse(response.body)
    expect(service.create_response).to eq(service.create_response)

  end

end


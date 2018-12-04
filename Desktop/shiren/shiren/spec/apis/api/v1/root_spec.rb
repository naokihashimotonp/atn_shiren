require "rails_helper"


RSpec.describe API::V1, :type => :request do

  it "API::V1::Root" do
    headers = {
      "CONTENT_TYPE" => "application/json"
    }


    request = '{
      "cards": ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
    }'

    api_response = {
      "card1": {
        "card": "H1 H13 H12 H11 H10",
        "hand": "flush",
        "best": false
      },
      "card2": {
        "card": "H9 C9 S9 H2 C2",
        "hand": "full_house",
        "best": true
      },
      "card3": {
        "card": "C13 D12 C11 H8 H7",
        "hand": "high_card",
        "best": false
      }
    }

    # ハッシュのjson化
    api_response = JSON.generate(api_response)
    post "/api/v1", request, headers
    
    expect(api_response).to eq(response.body)

  end

end


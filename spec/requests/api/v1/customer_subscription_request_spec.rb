require "rails_helper"

describe "Customer Subscription API" do
  describe "Happy Path" do
    it "can create a new subscription for a customer" do
      customer = create(:customer)
      subscription = create(:subscription)
      
      subscription_params = {
        subscription_id: subscription.id,
        customer_id: customer.id
      }
      headers = {"CONTENT_TYPE": "application/json"}
      post "/api/v1/customer_subscriptions", headers: headers, params: subscription_params, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(201)

      customer_subscription = CustomerSubscription.last
      data = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(data).to be_a Hash
      expect(data).to have_key(:id)
      expect(data).to have_key(:type)
      expect(data).to have_key(:attributes)
      expect(data).to have_key(:relationships)

      expect(data[:id].to_i).to eq(customer_subscription.id)
      expect(data[:type]).to eq("customer_subscription")
      
      expect(data[:attributes]).to be_a Hash
      expect(data[:attributes]).to have_key(:status)
      expect(data[:attributes][:status]).to eq(customer_subscription.status)
      expect(data[:attributes]).to have_key(:title)
      expect(data[:attributes][:subscription_title]).to eq(subscription.title)
      
      expect(data[:relationships]).to be_a Hash
      expect(data[:relationships]).to have_key(:customer)
      expect(data[:relationships]).to have_key(:subscription)

      expect(data[:relationships][:customer]).to be_a Hash
      expect(data[:relationships][:customer]).to have_key(:data)
      expect(data[:relationships][:customer][:data]).to be_a Hash
      expect(data[:relationships][:customer][:data]).to have_key(:id)
      expect(data[:relationships][:customer][:data][:id].to_i).to eq(customer.id)
      expect(data[:relationships][:customer][:data]).to have_key(:type)
      expect(data[:relationships][:customer][:data][:type]).to eq("customer")

      expect(data[:relationships][:subscription]).to be_a Hash
      expect(data[:relationships][:subscription]).to have_key(:data)
      expect(data[:relationships][:subscription][:data]).to be_a Hash
      expect(data[:relationships][:subscription][:data]).to have_key(:id)
      expect(data[:relationships][:subscription][:data][:id].to_i).to eq(subscription.id)
      expect(data[:relationships][:subscription][:data]).to have_key(:type)
      expect(data[:relationships][:subscription][:data][:type]).to eq("subscription")
    end
  end
end



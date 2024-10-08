require "rails_helper"

describe "Customer Subscription API" do
  describe "Happy Path" do
    before(:each) do
      @customer = Customer.create!(first_name: "LJ", last_name: "Butler", email: "test@test.com", address: "123 test st")
      @subscription = Subscription.create!(title: "10 for 2", price: 10, frequency: 2)
    end

    it "can create a new subscription for a customer" do  
      subscription_params = {
        subscription_id: @subscription.id,
        customer_id: @customer.id
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
      
      expect(data[:relationships]).to be_a Hash
      expect(data[:relationships]).to have_key(:customer)
      expect(data[:relationships]).to have_key(:subscription)

      expect(data[:relationships][:customer]).to be_a Hash
      expect(data[:relationships][:customer]).to have_key(:data)
      expect(data[:relationships][:customer][:data]).to be_a Hash
      expect(data[:relationships][:customer][:data]).to have_key(:id)
      expect(data[:relationships][:customer][:data][:id].to_i).to eq(@customer.id)
      expect(data[:relationships][:customer][:data]).to have_key(:type)
      expect(data[:relationships][:customer][:data][:type]).to eq("customer")

      expect(data[:relationships][:subscription]).to be_a Hash
      expect(data[:relationships][:subscription]).to have_key(:data)
      expect(data[:relationships][:subscription][:data]).to be_a Hash
      expect(data[:relationships][:subscription][:data]).to have_key(:id)
      expect(data[:relationships][:subscription][:data][:id].to_i).to eq(@subscription.id)
      expect(data[:relationships][:subscription][:data]).to have_key(:type)
      expect(data[:relationships][:subscription][:data][:type]).to eq("subscription")
    end

    it "can return all active and cancelled subscriptions of a customer" do
      subscription1 = Subscription.create!(title: "10 for 2", price: 10, frequency: 2)
      subscription2 = Subscription.create!(title: "15 for 5", price: 15, frequency: 1)

      customer_subscription1 = CustomerSubscription.create!(customer_id: @customer.id, subscription_id: subscription1.id, status: "active")
      customer_subscription2 = CustomerSubscription.create!(customer_id: @customer.id, subscription_id: subscription2.id, status: "cancelled")
      customer_subscriptions = @customer.customer_subscriptions

      get "/api/v1/customers/#{@customer.id}/customer_subscriptions"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      data = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(data).to be_an Array
      
      expect(data[0]).to be_a Hash
      expect(data[0]).to have_key(:id)
      expect(data[0][:id].to_i).to eq(customer_subscription1.id)
      expect(data[0]).to have_key(:type)
      expect(data[0][:type]).to eq("customer_subscription")
      
      expect(data[0]).to have_key(:attributes)
      expect(data[0][:attributes]).to be_a Hash

      # Verifys Cancelled and Active Status Appear 
      expect(data[0][:attributes]).to have_key(:status)
      expect(data[0][:attributes][:status]).to eq(customer_subscription1.status)
      expect(data[1][:attributes]).to have_key(:status)
      expect(data[1][:attributes][:status]).to eq(customer_subscription2.status)
      
      expect(data[0]).to have_key(:relationships)
      expect(data[0][:relationships]).to be_a Hash
      
      expect(data[0][:relationships]).to have_key(:customer)
      expect(data[0][:relationships][:customer]).to be_a Hash
      expect(data[0][:relationships][:customer]).to have_key(:data)
      expect(data[0][:relationships][:customer][:data]).to be_a Hash
      expect(data[0][:relationships][:customer][:data]).to have_key(:id)
      expect(data[0][:relationships][:customer][:data][:id].to_i).to eq(@customer.id)
      expect(data[0][:relationships][:customer][:data]).to have_key(:type)
      expect(data[0][:relationships][:customer][:data][:type]).to eq("customer")
      
      expect(data[0][:relationships]).to have_key(:subscription)
      expect(data[0][:relationships][:subscription]).to be_a Hash
      expect(data[0][:relationships][:subscription]).to have_key(:data)
      expect(data[0][:relationships][:subscription][:data]).to be_a Hash
      expect(data[0][:relationships][:subscription][:data]).to have_key(:id)
      expect(data[0][:relationships][:subscription][:data][:id].to_i).to eq(subscription1.id)
      expect(data[0][:relationships][:subscription][:data]).to have_key(:type)
      expect(data[0][:relationships][:subscription][:data][:type]).to eq("subscription")

      expect(customer_subscriptions.count).to eq(2)
    end

    it "Can update a customer subscription's status" do
      customer_sub = CustomerSubscription.create!(customer_id: @customer.id, subscription_id: @subscription.id, status: "cancelled")
      expect(customer_sub.status).to eq("cancelled")

      params = { status: "active" }
      headers = {"CONTENT_TYPE": "application/json"}
      patch "/api/v1/customer_subscriptions/#{customer_sub.id}/cancel", headers: headers, params: params, as: :json
      
      # Reset Variable After Patch
      customer_subscription = @customer.customer_subscriptions.last

      expect(customer_subscription.status).to eq("active")

      expect(response).to be_successful
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_a Hash
      expect(data).to have_key(:id)
      expect(data[:id].to_i).to eq(customer_subscription.id)
      expect(data).to have_key(:type)
      expect(data[:type]).to eq("customer_subscription")
      
      
      expect(data).to have_key(:attributes)
      expect(data[:attributes]).to be_a Hash
      expect(data[:attributes]).to have_key(:status)
      expect(data[:attributes][:status]).to eq("active")
      
      expect(data).to have_key(:relationships)
      expect(data[:relationships]).to be_a Hash

      expect(data[:relationships]).to have_key(:customer)
      expect(data[:relationships][:customer]).to be_a Hash
      expect(data[:relationships][:customer]).to have_key(:data)
      expect(data[:relationships][:customer][:data]).to be_a Hash
      expect(data[:relationships][:customer][:data]).to have_key(:id)
      expect(data[:relationships][:customer][:data][:id].to_i).to eq(@customer.id)
      expect(data[:relationships][:customer][:data]).to have_key(:type)
      expect(data[:relationships][:customer][:data][:type]).to eq("customer")
      
      expect(data[:relationships]).to have_key(:subscription)
      expect(data[:relationships][:subscription]).to be_a Hash
      expect(data[:relationships][:subscription]).to have_key(:data)
      expect(data[:relationships][:subscription][:data]).to be_a Hash
      expect(data[:relationships][:subscription][:data]).to have_key(:id)
      expect(data[:relationships][:subscription][:data][:id].to_i).to eq(@subscription.id)
      expect(data[:relationships][:subscription][:data]).to have_key(:type)
      expect(data[:relationships][:subscription][:data][:type]).to eq("subscription")
    end
  end
end
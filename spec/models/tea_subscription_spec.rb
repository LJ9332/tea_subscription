require 'rails_helper'

RSpec.describe TeaSubscription, type: :model do
  describe "relationships" do
    it { should belong_to(:subscription) }
    it { should belong_to(:tea) }
  end

  describe "validations" do
    it { should validate_presence_of(:subscription_id) }
    it { should validate_presence_of(:tea_id) }
  end
end

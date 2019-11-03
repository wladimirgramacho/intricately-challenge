require 'rails_helper'

RSpec.describe Hostname, type: :model do
  it { should have_and_belong_to_many :dns_records }
  it { should validate_uniqueness_of(:address) }
end

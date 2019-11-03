require 'rails_helper'

RSpec.describe Hostname, type: :model do
  it { should validate_uniqueness_of(:address) }
end

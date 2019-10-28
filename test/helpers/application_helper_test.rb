require "test_helper"

describe ApplicationHelper do
  include ApplicationHelper
  
  describe 'render_date' do
    it "displays a date in a human-readable format" do
      date = Date.parse("october 20 2019")
      
      result = render_date(date)
      
      expect(result).must_equal "Oct 20, 2019"
    end
  end
end
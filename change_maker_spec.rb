require_relative 'change_maker'

describe ChangeMaker do
  describe ".make_change" do
    it "creates change for 1 cent" do
      result = ChangeMaker.make_change(1)
      
      expect(result).to match_array([1])
    end

    it "creates change for 6 cents" do
      result = ChangeMaker.make_change(6)
      expect(result).to match_array([1, 5])
    end

    it "creates change for 37 cents" do
      result = ChangeMaker.make_change(37)
      
      expect(result).to match_array([25, 10, 1, 1])
    end

    it "creates change for 5 cents given different denominations" do
      result = ChangeMaker.make_change(5, [1, 3])
      
      expect(result).to match_array([3, 1, 1])
    end

    it "creates change for 17 cents given different denominations" do
      result = ChangeMaker.make_change(17, [1, 8, 10])
      
      expect(result).to match_array([8, 8, 1])
    end

    it "raises an error if there is no way to make change" do
      expect {
        ChangeMaker.make_change(17, [5, 8, 10])
      }.to raise_error(ChangeError)
    end
  end
end
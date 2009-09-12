describe "Concern" do
  it "loads the correct file" do
    `ruby spec/examples/load.rb`.should == "hello"
  end

  it "can use already present class" do
    `ruby spec/examples/inline.rb`.should == "inline"
  end

  it "can delegate" do
    `ruby spec/examples/delegate.rb`.should == "hello"
  end

  it "can delegate some" do
    `ruby spec/examples/picky_delegate.rb`.should == "hello"
  end
end
describe "Concern" do
  it "loads a simple file" do
    `ruby spec/examples/load.rb`.should == "hello"
  end

  it "requires a complex file" do
    `ruby spec/examples/complex_require.rb`.should == "SUCCESS"
  end

  it "can use already present class" do
    `ruby spec/examples/inline.rb`.should == "inline"
  end

  it "can use complex present class" do
    `ruby spec/examples/complex_inline.rb`.should == "SUCCESS"
  end

  it "can delegate" do
    `ruby spec/examples/delegate.rb`.should == "hello"
  end

  it "can delegate some" do
    `ruby spec/examples/picky_delegate.rb`.should == "hello"
  end

  it "add to parent" do
    `ruby spec/examples/adding.rb`.should == "yepworld"
  end

  it "warns when parent is not Concern" do
    `ruby spec/examples/parent_warning.rb`.should == "SUCCESS"
  end
  
  it "shouldn't pollute the global namespace" do
    `ruby spec/examples/pollution.rb`.should == "SUCCESS"
  end
  
  it "should delegate blocks" do
    `ruby spec/examples/blocks.rb`.should == "SUCCESS"
  end
end
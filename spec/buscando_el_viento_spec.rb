require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  it "exists" do
    BuscandoElViento.class.should == Module
  end

  it "inherits" do
    BuscandoElViento::Migration.new.should be_a(ActiveRecord::Migration)
  end
end
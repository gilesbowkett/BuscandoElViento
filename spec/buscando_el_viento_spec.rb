require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "exists" do
    BuscandoElViento.class.should == Module
  end
  it "inherits" do
    BuscandoMigration.new.should be_a(ActiveRecord::Migration)
  end
end


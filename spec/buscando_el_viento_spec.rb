require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoElViento::Migration
    end
  end

  it "exists" do
    BuscandoElViento.class.should == Module
  end
  it "inherits" do
    BuscandoElViento::Migration.new.should be_a(ActiveRecord::Migration)
  end
end


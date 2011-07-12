require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  it "exists" do
    BuscandoElViento.class.should == Module
  end

  it "inherits" do
    BuscandoElViento::Migration.new.should be_a(ActiveRecord::Migration)
  end

  it "auto-adds search vectors" do
    class SearchMigration < BuscandoElViento::Migration; end

    SearchMigration.should_receive(:add_column).with(:users,
                                                     :username_search_vector,
                                                     "tsvector")
    SearchMigration.add_search_vector :users,
                                      :username,
                                      :fuzzy => true
  end
end

require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "names indexes" do
    index_name = "index_users_on_username_search_vector"
    SearchMigration.index_name(:users, :username).should eq(index_name)
  end
  it "creates indexes"
  it "removes indexes"

  it "names composite indexes for searching multiple attributes"
  it "creates composite indexes for searching multiple attributes"
  it "removes composite indexes for searching multiple attributes"

  it "names multiple indexes for searching distinct attributes"
  it "creates multiple indexes for searching distinct attributes"
  it "removes multiple indexes for searching distinct attributes"
end


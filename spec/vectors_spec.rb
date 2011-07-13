require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    @search_migration = SearchMigration.new
  end

  it "names vectors" do
    @search_migration.vector_name(:username).should eq(:username_search_vector)
  end
  it "creates vector names for multiple combined attributes, as one" do
    attributes = [:title, :description]
    @search_migration.vector_name(attributes).should eq(:title_and_description_search_vector)
  end
  it "auto-adds search vectors" do
    @search_migration.should_receive(:add_column).with(:users,
                                                       :username_search_vector,
                                                       "tsvector")
    @search_migration.add_search_vector :users, :username
  end
  it "removes search vectors" do
    @search_migration.should_receive(:remove_column).with(:users,
                                                          :username_search_vector)
    @search_migration.remove_search_vector :users, :username
  end
end


require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "names vectors" do
    SearchMigration.vector_name(:username).should eq(:username_search_vector)
  end
  it "creates vector names for multiple combined attributes, as one" do
    attributes = [:title, :description]
    SearchMigration.vector_name(attributes).should eq(:title_description_search_vector)
  end
  it "auto-adds search vectors" do
    SearchMigration.should_receive(:add_column).with(:users,
                                                     :username_search_vector,
                                                     "tsvector")
    SearchMigration.add_search_vector :users, :username
  end
  it "removes search vectors" do
    SearchMigration.should_receive(:remove_column).with(:users,
                                                        :username_search_vector)
    SearchMigration.remove_search_vector :users, :username
  end
end


require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    @search_migration = SearchMigration.new
  end

  it "creates a search vector column name" do
    @search_migration.vector_search_column_name_for(:username).should eq(:username_search_vector)
  end
  it "creates a search vector names for multiple combined attributes, as one" do
    attributes = [:title, :description]
    @search_migration.vector_search_column_name_for(attributes).should eq(:title_and_description_search_vector)
  end

  it "creates a column name" do
    @search_migration.column_name_for(:username).should eq(:username)
  end
  it "creates a column name for multiple combined attributes, as one" do
    attributes = [:title, :description]
    @search_migration.vector_search_column_name_for(attributes).should eq(:title_and_description)
  end
end


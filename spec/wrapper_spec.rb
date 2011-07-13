require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    @search_migration = SearchMigration.new
  end

  it "adds search, defaulting to exact search" do
    @search_migration.should_receive(:add_search_vector).with(:users, :username)
    @search_migration.should_receive(:add_trigger).with(:users, :username, {:fuzzy => false})
    @search_migration.should_receive(:add_index).with(:users, :username)

    @search_migration.add_search :users, :username
  end
  it "removes search" do
    @search_migration.should_receive(:remove_search_vector).with(:users, :username)
    @search_migration.should_receive(:remove_trigger).with(:users, :username)
    @search_migration.should_receive(:remove_index).with(:users, :username)

    @search_migration.remove_search :users, :username
  end

  it "supports fuzzy search (stemming)" do
    @search_migration.should_receive(:add_search_vector).with(:users, :username)
    @search_migration.should_receive(:add_trigger).with(:users, :username, :fuzzy => true)
    @search_migration.should_receive(:add_index).with(:users, :username)
    @search_migration.add_search :users, :username, :fuzzy => true
  end

end


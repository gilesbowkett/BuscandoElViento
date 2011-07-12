require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "adds search" do
    SearchMigration.should_receive(:add_search_vector).with(:users, :username)
    SearchMigration.should_receive(:add_trigger).with(:users, :username)
    SearchMigration.should_receive(:add_index).with(:users, :username)
    SearchMigration.add_search :users, :username
  end
  it "removes search" do
    SearchMigration.should_receive(:remove_search_vector).with(:users, :username)
    SearchMigration.should_receive(:remove_trigger).with(:users, :username)
    SearchMigration.should_receive(:remove_index).with(:users, :username)
    SearchMigration.remove_search :users, :username
  end
end


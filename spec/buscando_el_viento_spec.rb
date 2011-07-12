require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoElViento::Migration
    end

    @trigger = <<TRIGGER
CREATE TRIGGER users_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(username_search_vector,
                        'pg_catalog.english',
                        username);
TRIGGER
  end

  it "exists" do
    BuscandoElViento.class.should == Module
  end

  it "inherits" do
    BuscandoElViento::Migration.new.should be_a(ActiveRecord::Migration)
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

  it "creates triggers" do
    SearchMigration.should_receive(:execute).with(@trigger)
    SearchMigration.add_trigger(:users, :username)
  end
end

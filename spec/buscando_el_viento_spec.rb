require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoElViento::Migration
    end

    @add_trigger = <<TRIGGER
CREATE TRIGGER users_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(username_search_vector,
                        'pg_catalog.english',
                        username);
TRIGGER

    @drop_trigger = "DROP TRIGGER IF EXISTS users_search_vector_update on users;"
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

  # TODO: enable creating triggers for more than one attribute!
  it "creates triggers" do
    SearchMigration.should_receive(:execute).with(@add_trigger)
    SearchMigration.add_trigger(:users, :username)
  end
  it "removes triggers" do
    SearchMigration.should_receive(:execute).with(@drop_trigger)
    # SearchMigration.remove_trigger(:users, :username) (uncomment when multiple attribute triggers)
    SearchMigration.remove_trigger(:users)
  end
end

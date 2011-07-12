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
    @add_trigger = <<TRIGGER
CREATE TRIGGER users_username_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(username_search_vector,
                        'pg_catalog.english',
                        username);
TRIGGER
    SearchMigration.should_receive(:execute).with(@add_trigger)
    SearchMigration.add_trigger(:users, :username)
  end

  it "removes triggers" do
    @drop_trigger = "DROP TRIGGER IF EXISTS users_username_search_vector_update on users;"
    SearchMigration.should_receive(:execute).with(@drop_trigger)
    SearchMigration.remove_trigger(:users, :username)
  end

  it "creates triggers for multiple distinct attributes, separately" do
    @add_trigger = <<TRIGGER
CREATE TRIGGER users_username_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(username_search_vector,
                        'pg_catalog.english',
                        username);
TRIGGER
    SearchMigration.should_receive(:execute).with(@add_trigger)
    SearchMigration.add_trigger(:users, :username)
    @add_trigger = <<TRIGGER
CREATE TRIGGER users_email_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(email_search_vector,
                        'pg_catalog.english',
                        email);
TRIGGER
    SearchMigration.should_receive(:execute).with(@add_trigger)
    SearchMigration.add_trigger(:users, :email)
  end
  it "removes triggers for multiple distinct attributes, separately" do
    @username_drop_trigger = "DROP TRIGGER IF EXISTS users_username_search_vector_update on users;"
    @email_drop_trigger = "DROP TRIGGER IF EXISTS users_email_search_vector_update on users;"

    SearchMigration.should_receive(:execute).with(@username_drop_trigger)
    SearchMigration.remove_trigger(:users, :username)

    SearchMigration.should_receive(:execute).with(@email_drop_trigger)
    SearchMigration.remove_trigger(:users, :email)
  end
  it "creates triggers for multiple combined attributes, as one"
end

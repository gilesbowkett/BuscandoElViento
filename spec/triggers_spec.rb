require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "names triggers" do
    SearchMigration.trigger_name(:users, :username).should eq("users_username_search_vector_update")
  end
  it "creates triggers" do
    @add_trigger = <<TRIGGER
CREATE TRIGGER users_username_search_vector_update
BEFORE INSERT OR UPDATE
ON users
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(username_search_vector,
                        'pg_catalog.simple',
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
                        'pg_catalog.simple',
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
                        'pg_catalog.simple',
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

  # multiple combined attributes, as one
  it "names triggers with multiple combined attributes" do
    attributes = [:title, :body]
    trigger_name = "posts_title_and_body_search_vector_update"
    SearchMigration.trigger_name(:posts, attributes).should eq(trigger_name)
  end
  it "creates triggers for multiple combined attributes, as one" do
    # FIXME: join these multi-line heredocs to eliminate indentation
    #        before executing, simply because getting the indentation
    #        right in the specs is an irritating waste of time
    @add_trigger = <<TRIGGER
CREATE TRIGGER posts_title_and_body_search_vector_update
BEFORE INSERT OR UPDATE
ON posts
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(title_and_body_search_vector,
                        'pg_catalog.simple',
                        title, body);
TRIGGER
    SearchMigration.should_receive(:execute).with(@add_trigger)
    SearchMigration.add_trigger(:posts, [:title, :body])
  end
end


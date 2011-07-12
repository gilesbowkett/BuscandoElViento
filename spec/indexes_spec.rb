require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  # FIXME: these specs are sufficiently similar that I should probably be either subclassing
  #        specs, or bunging this before(:each) in the helper
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
  end

  it "names indexes" do
    index_name = "index_users_on_username_search_vector"
    SearchMigration.index_name(:users, :username).should eq(index_name)
  end
  it "creates indexes" do
    create_index = <<-CREATE_INDEX
CREATE INDEX index_users_on_username_search_vector
ON users
USING gin(search_vector);
CREATE_INDEX
    SearchMigration.should_receive(:execute).with(create_index)
    SearchMigration.add_index(:users, :username)
  end
  it "removes indexes"

  it "names composite indexes for searching multiple attributes"
  it "creates composite indexes for searching multiple attributes"
  it "removes composite indexes for searching multiple attributes"

  it "names multiple indexes for searching distinct attributes"
  it "creates multiple indexes for searching distinct attributes" do
    create_username_index = <<-CREATE_INDEX
CREATE INDEX index_users_on_username_search_vector
ON users
USING gin(search_vector);
CREATE_INDEX
    SearchMigration.should_receive(:execute).with(create_username_index)
    SearchMigration.add_index(:users, :username)

    create_email_index = <<-CREATE_INDEX
CREATE INDEX index_users_on_email_search_vector
ON users
USING gin(search_vector);
CREATE_INDEX
    SearchMigration.should_receive(:execute).with(create_email_index)
    SearchMigration.add_index(:users, :email)
  end
  it "removes multiple indexes for searching distinct attributes"
end


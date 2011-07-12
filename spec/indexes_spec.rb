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

  it "names composite indexes for searching multiple attributes" do
    index_name = "index_posts_on_title_and_body_search_vector"
    SearchMigration.index_name(:posts, [:title, :body]).should eq(index_name)

    index_name = "index_posts_on_title_and_body_and_topic_search_vector"
    SearchMigration.index_name(:posts, [:title, :body, :topic]).should eq(index_name)
  end
  it "creates composite indexes for searching multiple attributes" do
    create_index = <<-CREATE_INDEX
CREATE INDEX index_posts_on_title_and_body_search_vector
ON posts
USING gin(search_vector);
CREATE_INDEX
    SearchMigration.should_receive(:execute).with(create_index)
    SearchMigration.add_index(:posts, [:title, :body])
  end
  it "removes composite indexes for searching multiple attributes" do
    vector_name = "title_and_body_search_vector"
    SearchMigration.should_receive(:remove_index).with(:posts, vector_name)
    SearchMigration.remove_composite_index(:posts, [:title, :body])
  end

  # FIXME: spec cleanup...
    # this last spec, and a few others like it, are maybe a little dumb. now that
    # I think of it, I should probably just delete these. to create multiple
    # distinct indices for searching distinct attributes, or to delete same, you
    # just call add_index() or remove_index() as appropriate.

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
end


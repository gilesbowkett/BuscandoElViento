require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    @search_migration = SearchMigration.new
  end

  it "names indexes" do
    # fffffffuuuuuuuuuu http://bit.ly/pDHCNe
    # TODO: FIXME
    index_name = "index_users_on_username"
    @search_migration.index_name(:users, :username).should eq(index_name)
  end
  it "creates indexes" do
    create_index = <<-CREATE_INDEX
CREATE INDEX index_users_username_sv
ON users
USING gin(username_search_vector);
CREATE_INDEX
    @search_migration.should_receive(:execute).with(create_index)
    @search_migration.add_gin_index(:users, :username_search_vector)
  end

  it "names composite indexes for searching multiple attributes" do
    index_name = "index_posts_on_body" #produced by shortening alg
    @search_migration.index_name(:posts, "body").should eq(index_name)

    #test shortening alg
    @search_migration.index_name(:posts, "title_and_body_and_topic_and_comments_search_vector").length.should be < 33
  end

  it "creates composite indexes for searching multiple attributes" do
    create_index = <<-CREATE_INDEX
CREATE INDEX index_posts_on_title_and_body
ON posts
USING gin(title_and_body);
CREATE_INDEX
    @search_migration.should_receive(:execute).with(create_index)
    @search_migration.add_gin_index(:posts, [:title, :body])
  end

  it "removes composite indexes for searching multiple attributes" do
    index_name = "index_posts_on_title_and_body"
    @search_migration.should_receive(:remove_index).with(:posts, :name => index_name)
    @search_migration.remove_gin_index(:posts, [:title, :body])
  end

end


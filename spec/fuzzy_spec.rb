require File.dirname(__FILE__) + '/spec_helper'

describe BuscandoElViento do
  before(:each) do
    class SearchMigration < BuscandoMigration
    end
    @search_migration = SearchMigration.new
  end

  # fuzzy search methods, in practice, only affect the definition of the DB trigger;
  # however, I think requiring the downstream programmer to remember that kind of
  # implementation detail somewhat defeats the purpose of a convenient API in the
  # first place.

  it "enables fuzzy search" do
    fuzzy_trigger = <<TRIGGER
CREATE TRIGGER posts_title_search_vector_update
BEFORE INSERT OR UPDATE
ON posts
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(title_search_vector,
                        'pg_catalog.english',
                        title);
TRIGGER
    @search_migration.should_receive(:execute).with(fuzzy_trigger)
    @search_migration.add_trigger(:posts, :title, :stemming => true)
  end
  it "disables fuzzy search" do
    exact_trigger = <<TRIGGER
CREATE TRIGGER posts_title_search_vector_update
BEFORE INSERT OR UPDATE
ON posts
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(title_search_vector,
                        'pg_catalog.simple',
                        title);
TRIGGER
    @search_migration.should_receive(:execute).with(exact_trigger)
    @search_migration.add_trigger(:posts, :title, :stemming => false)
  end
  it "defaults to exact search" do
    exact_trigger = <<TRIGGER
CREATE TRIGGER posts_title_search_vector_update
BEFORE INSERT OR UPDATE
ON posts
FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(title_search_vector,
                        'pg_catalog.simple',
                        title);
TRIGGER
    @search_migration.should_receive(:execute).with(exact_trigger)
    @search_migration.add_trigger(:posts, :title)
  end
end


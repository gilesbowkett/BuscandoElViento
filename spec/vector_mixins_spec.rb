require File.dirname(__FILE__) + '/spec_helper'

class MyModel
  include VectorMixins
end

describe VectorMixins do
    before do
      MyModel.stub(:column_names).and_return([
        'name','number','state', 'name_search_vector', 'name_and_number_search_vector', 'name_and_number_and_state_search_vector'
      ])
    end

    describe "column_exists?" do
      it "returns true if the column exists" do
        MyModel.column_exists?('name').should be(true)
        MyModel.column_exists?(:name).should be(true)
      end
      it "returns false otherwise" do
        MyModel.column_exists?('bad').should be(false)
      end
    end

    describe "vector_name" do
      it "returns the search vector for a column if it exists" do
        MyModel.vector_name(:name, 'english').should eq("name_search_vector")
        MyModel.vector_name("name", 'english').should eq("name_search_vector")
      end
      it "returns the search vector for multiple columns if it exists" do
        MyModel.vector_name([:name, :number], 'english').should eq("name_and_number_search_vector")
        MyModel.vector_name(["name", "number"], 'english').should eq("name_and_number_search_vector")
      end
      it "returns a ts_vector if the search vector doesnt exist" do
        MyModel.stub(:to_tsvector).and_return("ts_vector")
        MyModel.vector_name([:name, :state], 'english').should eq("ts_vector")
        MyModel.vector_name(["name", "state"], 'english').should eq("ts_vector")
      end
    end

    describe "to_tsvector" do
      it "returns a to_tsvector of coalesced columns columns" do
        MyModel.stub(:coalesce_columns).and_return("stubbed")
        MyModel.to_tsvector([:name,:state], 'english').should eq("to_tsvector('english', stubbed)")
      end
    end

    describe "coalesce_columns" do
      it "returns a coalesce statement for a single column" do
        MyModel.coalesce_columns(["name"]).should eq("coalesce(name, '')")
        MyModel.coalesce_columns([:name]).should eq("coalesce(name, '')")
      end
      it "returns a coalesce statement for multiple columns" do
        MyModel.coalesce_columns(["name", "state"]).should eq("coalesce(name, '') || ' ' || coalesce(state, '')")
        MyModel.coalesce_columns([:name, :state]).should eq("coalesce(name, '') || ' ' || coalesce(state, '')")
      end
    end

    describe "to_pg_query" do
      it "calls sanatize_sql_array on the query" do
        MyModel.should_receive(:sanitize_sql_array)
        MyModel.to_pg_query("query", "english")
      end

      it "returns a to_tsquery statement" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          statement.should eq("to_tsquery('english', ?)")
          query.should eq("query")
        end
        MyModel.to_pg_query("query", "english")
      end

      it "separates all query words with a '|'" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          query.should eq("string | with | words")
        end
        MyModel.to_pg_query("string with words", "english")
      end

      it "substitutes 'or' with '|'" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          query.should eq("string | words")
        end
        MyModel.to_pg_query("string or words", "english")
      end

      it "substitutes 'and' with '&'" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          query.should eq("string & words")
        end
        MyModel.to_pg_query("string and words", "english")
      end

      it "substitutes 'not' with '!'" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          query.should eq("string | !words")
        end
        MyModel.to_pg_query("string not words", "english")
      end

      it "deals with tricky sentences" do
        MyModel.stub(:sanitize_sql_array) do |statement, query|
          query.should eq("StRing | with & s0me | stuff | in | !it")
        end
        MyModel.to_pg_query("StRing      with and s0me, or stuff . -in not it", "english")
      end
    end

    describe "order_by_vector" do
      before(:each) do
        MyModel.stub(:sanitize_sql_array) do |s,q|
          s.gsub(/\?/, "'#{q}'")
        end
      end

      it "orders results by a vector based on a search query" do
        MyModel.should_receive(:order).with("ts_rank_cd(name_search_vector, to_tsquery('english', 'a | query')) DESC")
        MyModel.order_by_vector("a query", "name")
      end
    end


    describe "vector_search" do
      before(:each) do
        MyModel.stub(:sanitize_sql_array) do |s,q|
          s.gsub(/\?/, "'#{q}'")
        end
      end

      it "adds a 'where' condition based on a search query" do
        MyModel.should_receive(:where).with("name_search_vector @@ to_tsquery('english', 'a | query')")
        MyModel.vector_search("a query", "name")
      end
    end
end
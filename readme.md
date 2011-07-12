buscando el viento
==================

buscando el viento is a search gem for PostgreSQL and Rails 3. It enables full-text searching by automating the process of creating appropriate migrations, and is largely based on Xavier Shay's PeepCode video on Postgres.

http://peepcode.com/products/postgresql

usage
-----

Inherit from BuscandoElViento::Migration instead of ActiveRecord::Migration. The BuscandoElViento version includes additional class methods. For example,

    add_search_vector :users, :username, :fuzzy => true

will add a search vector attribute to your users table, and obviously

    add_search_vector :users, :username, :fuzzy => false

will do the same thing, but with stemming turned off. (Stemming enables "fuzzy" search.)

However if you do this

    search :users, :username, :fuzzy => true

you get the search vector along with a database trigger to keep that vector up to date, and an index to make retrieval fast - and you also get both up and down methods, to avoid IrreversibleMigrations.

tests
-----

In order to run your tests, if you use PostgreSQL this way, you'll need to modify how Rails handles schema dumps. See the Postgres PeepCode for more info.

http://peepcode.com/products/postgresql

wtf? is that name spanish?
--------------------------

yes. buscando el viento gets its name from a line in a poem by Pablo Neruda.

    mi voz buscaba el viento para tocar su oido

which means

    my voice sought the wind to touch her hearing

there's a nuance here: where in English, you say a person "plays" a musical instrument, in order to bring forth sound, in Spanish, you say a person "touches" a musical instrument.

authors
-------

Giles Bowkett
Xavier Shay


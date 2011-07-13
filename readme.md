buscando el viento
==================

buscando el viento is a search migrations gem for PostgreSQL and Rails 3. It enables full-text searching by automating the process of creating appropriate migrations, and is largely based on Xavier Shay's PeepCode video on Postgres.

http://peepcode.com/products/postgresql

usage
-----

Inherit from `BuscandoMigration` instead of `ActiveRecord::Migration`. The `BuscandoElViento` version includes additional class methods. For example,

    add_search_vector :users, :username

will add a search vector attribute to your `users` table, tracking the `username` attribute.

However if you do this

    add_search :users, :username, :fuzzy => true

you get the search vector, a database trigger to keep that vector up to date, and an index to make retrieval fast.

Obviously the `:fuzzy` flag represents fuzzy versus exact search; this simply turns stemming on or off, although PostgreSQL supports a lot of additional features and options in its full-text search capacities. Use `remove_search` in the `down` method, to avoid `IrreversibleMigrations`. (Buscando doesn't support the `def change` approach yet, although there's no real reason why not.)

tests and specs
---------------

In order to run your Rails tests, if you use PostgreSQL this way, you'll need to modify how Rails handles schema dumps. See the Postgres PeepCode for more info.

http://peepcode.com/products/postgresql

In terms of the gem's own specs, these could be better. They really just test the implementation, which is to say they verify that calling particular methods on the custom migration invokes particular other methods on the ActiveRecord migration.

This makes the specs fast, and I prefer tests and specs which circumvent the database in most circumstances, but if you're noodling around wondering what kind of patches a project this awesome could possibly need, I'd have a look at verifying that the specs actually result in code which can perform searches properly.

wtf? is that name spanish?
--------------------------

yes. "buscando el viento" means "seeking the wind" and gets its name from a line in a poem by Pablo Neruda.

    mi voz buscaba el viento para tocar su oido

which means

    my voice sought the wind to touch her hearing

(there's a nuance here: where in English, you say a person "plays" a musical instrument, in order to bring forth sound, in Spanish, you say a person "touches" a musical instrument.)

authors
-------

  + Giles Bowkett
  + Xavier Shay

license
-------

MIT License (which document included by reference)

hook a brother up
-----------------

Patches requested:

  + `setweight()` support (*crucial*)
  + Rails 3.1 generator
  + support for `def change` vs `def up` and `def down`
  + better specs

here be dragons
---------------

This gem is still very early days status. May explode unexpectedly. Do not taunt Happy Fun Ball.


class CreateCitextExtension < ActiveRecord::Migration
  def up
    execute 'CREATE EXTENSION IF NOT EXISTS citext'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS citext'
  end
end

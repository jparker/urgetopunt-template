class CreateCitextExtension < ActiveRecord::Migration
  def change
    enable_extension citext
  end
end

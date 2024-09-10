class DropJwtDenylist < ActiveRecord::Migration[6.0]
  def change
    drop_table :jwt_denylists do |t|
      # This block is optional and can be left out if you don't need to specify columns.
    end
  end
end

class ChangeAdressesToAddresses < ActiveRecord::Migration[5.2]
  def change
    rename_table :adresses, :addresses
  end
end

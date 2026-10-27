class RenameValueToVerdictInVotes < ActiveRecord::Migration[8.1]
  def change
    rename_column :votes, :value, :verdict
  end
end

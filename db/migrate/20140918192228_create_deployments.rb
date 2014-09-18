class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments, force: true do |t|
      t.text :service_ids
    end
  end
end

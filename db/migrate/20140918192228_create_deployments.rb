class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments, force: true do |t|
      t.string :name
      t.text :template
      t.text :service_ids
    end
  end
end

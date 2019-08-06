class SetusMmsTables < ActiveRecord::Migration[5.2]
  def change
    unless table_exists? :maintenance_activity_types
      create_table :maintenance_activity_types do |t|
        t.references :maintenance_activity_category_subtype, index: {name: :maintenance_activity_types_category_subtype}
        t.string :name
        t.string :code
        t.string :description
        t.boolean :active
      end
    end

    unless table_exists? :maintenance_repeat_interval_types
      create_table :maintenance_repeat_interval_types do |t|
        t.string :name
        t.string :description
        t.boolean :active
      end
    end

    unless table_exists? :maintenance_service_interval_types
      create_table :maintenance_service_interval_types do |t|
        t.string :name
        t.string :description
        t.boolean :active
      end
    end

    unless table_exists? :maintenance_schedules
      create_table :maintenance_schedules do |t|
        t.string :object_key, limit: 12, null: false, index: true
        t.references :organization
        t.references :asset_subtype
        t.string :name
        t.string :description
        t.boolean :active

        t.timestamps
      end

      add_index :maintenance_schedules, [:organization_id, :asset_subtype_id], name: :maintenance_schedules_organization_id_asset_subtype_id
    end

    unless table_exists? :maintenance_activities
      create_table :maintenance_activities do |t|
        t.string :object_key, limit: 12, null: false, index: true
        t.references :maintenance_schedule
        t.references :maintenance_activity_type
        t.references :maintenance_service_interval_type, index: {name: :maintenance_activities_service_interval_type}
        t.references :maintenance_repeat_interval_type, index: {name: :maintenance_activities_repeat_interval_type}
        t.integer :interval
        t.boolean :required_by_manufacturer
        t.boolean :active

        t.timestamps


      end
    end

    unless table_exists? :maintenance_events
      create_table :maintenance_events do |t|
        t.string :object_key, limit: 12, null: false, index: true
        t.references :transam_asset, index: true
        t.references :mainentance_provider, index: true
        t.references :maintenance_service_order
        t.references :maintenance_activity, index: true
        t.references :maintenance_activity_type, index: true
        t.references
        t.string :name
        t.date :due_date
        t.date :event_date
        t.integer :parts_cost
        t.integer :labor_cost
        t.references :completed_by
        t.integer :miles_as_service

        t.timestamps
      end
    end

    unless table_exists? :assets_maintenance_schedules
      create_table :assets_maintenance_schedules do |t|
        t.references :transam_asset, index: true
        t.references :maintenance_schedule, index: true
      end
    end

    unless table_exists? :maintenance_providers
      create_table :maintenance_providers do |t|
        t.string :object_key, limit: 12, null: false, index: true
        t.references :organization, index: true
        t.string :manager
        t.string :email
        t.string :name
        t.string :address1
        t.string :address2
        t.string :city
        t.string :state, limit: 2
        t.string :zip, limit: 10
        t.string :phone
        t.string :fax
        t.string :url
        t.decimal :latitude, precision: 11, scale: 6
        t.decimal :longitude, precision: 11, scale: 6
        t.boolean :active

        t.timestamps
      end
    end

    unless table_exists? :assets_maintenance_providers
      create_table :assets_maintenance_providers do |t|
        t.references :transam_asset, index: true
        t.references :maintenance_provider, index: true
      end
    end

    unless table_exists? :maintenance_service_orders
      create_table :maintenance_service_orders do |t|
        t.string :object_key, limit: 12, null: false, index: true
        t.string :workorder_number
        t.references :organization, index: true
        t.references :transam_asset, index: true
        t.references :maintenance_provider
        t.references :priority_type
        t.date :order_date
        t.string :state
        t.text :notes

        t.timestamps
      end
    end

    unless table_exists? :maintenance_activity_category_types
      create_table :maintenance_activity_category_types do |t|
        t.string :name
        t.string :description
        t.boolean :active
      end
    end

    unless table_exists? :maintenance_activity_category_subtypes
      create_table :maintenance_activity_category_subtypes do |t|
        t.references :maintenance_activity_category_type, index: {name: :maintenance_activity_category_subtypes_category_type}
        t.string :name
        t.string :description
        t.boolean :active
      end
    end

  end
end

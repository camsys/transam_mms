class SetupMms < ActiveRecord::Migration
  def change
    
    # Lookup Tables
    create_table :maintenance_service_interval_types do |t|
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end
    
    create_table :maintenance_repeat_interval_types do |t|
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end
  
    create_table :maintenance_activity_types do |t|
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end

    # User Tables
    create_table :maintenance_schedules do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :organization,                      :null => :false
      t.references  :asset_subtype,                     :null => :false
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end

    add_index :maintenance_schedules,   :object_key,       :unique => :true,  :name => :maintenance_schedules_idx1
    add_index :maintenance_schedules,   [:organization_id, :asset_subtype_id],      :name => :maintenance_schedules_idx2

    create_join_table :assets, :maintenance_schedules
    
    add_index :assets_maintenance_schedules,   [:asset_id, :maintenance_schedule_id], :name => :assets_maintenance_schedules_idx1

    create_table :maintenance_activities do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :maintenance_schedule,              :null => :false
      t.references  :maintenance_activity_type,         :null => :false
      t.references  :maintenance_service_interval_type,       :null => :false
      t.references  :maintenance_repeat_interval_type,        :null => :false
      t.integer     :interval,                    :null => :false
      t.boolean     :required_by_manufacturer
      t.boolean     :active
    end
    
    add_index :maintenance_activities,   :object_key,                 :unique => :true, :name => :maintenance_activity_details_idx1
    add_index :maintenance_activities,   :maintenance_schedule_id,                      :name => :maintenance_activity_details_idx2
    add_index :maintenance_activities,   :maintenance_activity_type_id,                 :name => :maintenance_activity_details_idx3


    create_table :maintenance_events do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :asset,                             :null => :false
      t.references  :maintenance_activity,              :null => :false
      t.date        :event_date,                        :null => :false
      t.integer     :completed_by_id,                   :null => :false
      t.integer     :miles_at_service,                  :null => :true
    end

    add_index :maintenance_events,   :object_key,                 :unique => :true, :name => :maintenance_event_idx1
    add_index :maintenance_events,   [:asset_id, :event_date],                      :name => :maintenance_event_idx2

  end
end

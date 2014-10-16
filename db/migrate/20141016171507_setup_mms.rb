class SetupMms < ActiveRecord::Migration
  def change
    
    # Lookup Tables
    create_table :service_interval_types do |t|
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end
    
    create_table :repeat_interval_types do |t|
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end
  
    # User Tables

    create_table :maintenance_activities do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end

    add_index :maintenance_activities, :object_key,       :unique => :true, :name => :maintenance_activities_idx1
    add_index :maintenance_activities, :name,             :unique => :true, :name => :maintenance_activities_idx2

    create_table :maintenance_schedules do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :organization,                      :null => :false
      t.references  :asset_subtype,                     :null => :false
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :active
    end

    add_index :maintenance_schedules,   :object_key,       :unique => :true,  :name => :maintenance_schedules_idx1
    add_index :maintenance_schedules,   [:organization, :asset_subtype],      :name => :maintenance_schedules_idx2

    create_table :maintenance_activity_details do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :maintenance_schedule,              :null => :false
      t.references  :maintenance_activity,              :null => :false
      t.string      :name,                :limit => 64, :null => :false
      t.string      :description,         :limit => 254,:null => :false
      t.boolean     :required_by_manufacturer
      t.boolean     :active
    end
    
    add_index :maintenance_activity_details,   :object_key,       :unique => :true,   :name => :maintenance_activity_details_idx1
    add_index :maintenance_activity_details,   :maintenance_schedule,                 :name => :maintenance_activity_details_idx2
    add_index :maintenance_activity_details,   :maintenance_activity,                 :name => :maintenance_activity_details_idx3

    create_table :service_intervals do |t|
      t.string      :object_key,          :limit => 12, :null => :false
      t.references  :maintenance_activity_detail, :null => :false
      t.references  :service_interval_type,       :null => :false
      t.references  :repeat_interval_type,        :null => :false
      t.integer     :interval,                    :null => :false
    end

    add_index :service_intervals,   :object_key,              :unique => :true,   :name => :service_intervals_idx1
    add_index :service_intervals,   :maintenance_activity_detail,                 :name => :service_intervals_idx2

  end
end

#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include? 'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

#------------------------------------------------------------------------------
#
# Lookup Tables
#
# These are the lookup tables for TransAM Maintenance Management
#
#------------------------------------------------------------------------------

puts "======= Processing TransAM MMS Lookup Tables  ======="


maintenance_repeat_interval_types = [
  {:active => 1, :name => 'every',  :description => 'Activity must be performed repeatedly.'},
  {:active => 1, :name => 'at',     :description => 'Activity must be performed at the specified point.'}
]

maintenance_service_interval_types = [
  {:active => 1, :name => 'miles',    :description => 'miles travelled.'},
  {:active => 1, :name => 'hours',    :description => 'hours or operation.'},
  {:active => 1, :name => 'days',     :description => 'days between activities'},
  {:active => 1, :name => 'weeks',    :description => 'weeks between activities.'},
  {:active => 1, :name => 'months',   :description => 'months between activities'},
  {:active => 1, :name => 'years',    :description => 'years between activities'}
]

maintenance_activity_types = [
  {:active => 1, :name => 'Oil Change/Filter/Lube',     :description => 'Oil Change / Filter / Lube'},
  {:active => 1, :name => 'Tire Rotation/Balance',                  :description => 'Rotate and check balance of tires.'},
  {:active => 1, :name => 'Annual Certified Safety Inspection',    :description => 'Annual Certified Safety Inspection'},
  {:active => 1, :name => 'ADA Wheelchair Ramp/Lift Service',    :description => 'ADA Wheelchair Ramp/Lift Service'},
  {:active => 1, :name => 'Standard PM Inspection',    :description => 'Standard PM Inspection'},
  {:active => 1, :name => 'Inspect automatic transmission fluid level',    :description => 'Inspect automatic transmission fluid level'},
  {:active => 1, :name => 'Inspect brake systems',    :description => 'Inspect brake pads/shoes/rotors/drums, brake lines & hoses, & parking brake system'},
  {:active => 1, :name => 'Inspect cooling system and hoses',    :description => 'Inspect cooling system and hoses'},
  {:active => 1, :name => 'Replace fuel filter',    :description => 'Replace fuel filter'},
  {:active => 1, :name => 'Lubrication',    :description => 'Inspect & lubricate all non-sealed steering linkage,ball joints,suspension joints,half and drive-shafts and u-joints'},
  {:active => 1, :name => 'Inspect exhaust system',    :description => 'Inspect complete exhaust system and heat shields'},
  {:active => 1, :name => 'Replace engine air filter',    :description => 'Inspect complete exhaust system and heat shields'},
  {:active => 1, :name => 'Inspect wheel bearings',    :description => 'Inspect 4x2 front wheel bearings; replace grease and grease seals, and adjust bearings'},
  {:active => 1, :name => 'Replace platinum-tipped spark plugs',    :description => 'Replace platinum-tipped spark plugs'},
  {:active => 1, :name => 'Inspect accessory drive belt/s',    :description => 'Inspect accessory drive belt/s'},
  {:active => 1, :name => 'Change Premium Gold engine coolant',    :description => 'Change Premium Gold engine coolant'},
  {:active => 1, :name => 'Replace rear axle lubricant',    :description => 'Replace rear axle lubricant'},
  {:active => 1, :name => 'Replace PCV valve',    :description => 'Replace PCV valve'},
  {:active => 1, :name => 'Replace front wheel bearings',    :description => 'Replace front 4x2 whell bearings & grease seals, lubricate & adjust bearings'},
  {:active => 1, :name => 'Replace accesory drive belts',    :description => 'Replace accesory drive belts (if not replaced within last 100,000)'},
  {:active => 1, :name => 'Inspect/Replace Fire Extinguisher',    :description => 'Inspect/Replace Fire Extinguisher'},
  {:active => 1, :name => 'Inspect/Replace passenger compartment air filter',    :description => 'Inspect and replace passenger compartment air filter'}
]

maintenance_priority_types = [
    {:active => 1, :is_default => 0, :name => 'Low',     :description => 'Lowest priority.'},
    {:active => 1, :is_default => 1, :name => 'Normal',  :description => 'Normal priority.'},
    {:active => 1, :is_default => 0, :name => 'High',    :description => 'Highest priority.'}
]

system_config_extensions = [
    {class_name: 'TransamAsset', extension_name: 'TransamMaintainable', engine_name: 'mms', active: true},
    {class_name: 'Organization', extension_name: 'TransamMaintenanceProvider', engine_name: 'mms', active: true}
]

lookup_tables = %w{ maintenance_repeat_interval_types maintenance_service_interval_types maintenance_activity_types maintenance_priority_types }

lookup_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end

merge_tables = %w{ system_config_extensions }

merge_tables.each do |table_name|
  puts "  Merging #{table_name}"
  data = eval(table_name)
  begin
    klass = table_name.classify.constantize
    data.each do |row|
      x = klass.new(row)
      x.save!
    end
  rescue NameError
  end
end

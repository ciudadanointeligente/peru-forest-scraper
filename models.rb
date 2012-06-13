class Exportation
  include Mongoid::Document

  # Relations
  has_many :batches

  # Fields
  field :num_exportation, :class => String
  field :year, :class => Date
  field :num_cites, :class => Integer
  field :date, :class => Date
  field :exporting_company, :class => String
  field :importing_company, :class => String
  field :destination_country, :class => String
  field :species, :class => String
  field :product_type, :class => String
  field :shipping_volume, :class => Float
  field :batches_ids, :class => Array

  # Indexes
  index :num_exportation, :unique => true
end

class Batch
  include Mongoid::Document

  # Relations
  belongs_to :exportation

  # Fields
  field :id, :class => String
  field :forestal_transport_guide, :class => String
  field :contract_code, :class => String
  field :contract_holder, :class => String
  field :volume, :class => Float
  field :zafra, :class => String
  field :proprietary, :class => String
  field :receiver, :class => String
  field :basin, :class => String
  field :observation, :class => String

  # Indexes
  index :id, :unique => true
end

class SupervisionReport
  include Mongoid::Document

  # Fields
  field :supervision_report_code, :class => String
  field :contract_holder, :class => String
  field :contract_code, :class => String
  field :concession, :class => String
  field :department, :class => String
  field :conclusion, :class => String

  # Indexes
  index :num_supervision_report, :unique => true
end

# record information about every API request
class Hit
  include Mongoid::Document

  index :created_at
  index :method
  index :sections
  index :user_agent
end

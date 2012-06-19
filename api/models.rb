# coding: utf-8
class Exportation
  include Mongoid::Document

  # Field Validation
  validates_presence_of :id
  validates_uniqueness_of :id

  # Fields
  field :id, :class => String ,:meta => ['display_name'=>'Id', 'type'=>'false', 'order'=>0, 'should_be_shown_in_list'=>false]
  field :num_exportation, :class => String ,:meta => ['display_name'=>'Nº', 'type'=>'text', 'order'=>1, 'should_be_shown_in_list'=>true]
  field :year, :class => Date ,:meta => ['display_name'=>'Año', 'type'=>'date', 'order'=>2, 'should_be_shown_in_list'=>true]
  field :num_cites, :class => Integer ,:meta => ['display_name'=>'Número de cites', 'type'=>'text', 'order'=>3, 'should_be_shown_in_list'=>true]
  field :date, :class => Date ,:meta => ['display_name'=>'Fecha', 'type'=>'date', 'order'=>4, 'should_be_shown_in_list'=>true]
  field :exporting_company, :class => String ,:meta => ['display_name'=>'Empresa exportadora', 'type'=>'text', 'order'=>5, 'should_be_shown_in_list'=>true]
  field :importing_company, :class => String ,:meta => ['display_name'=>'Empresa importadora', 'type'=>'text', 'order'=>6, 'should_be_shown_in_list'=>true]
  field :destination_country, :class => String ,:meta => ['display_name'=>'País de destino', 'type'=>'text', 'order'=>7, 'should_be_shown_in_list'=>true]
  field :species, :class => String ,:meta => ['display_name'=>'Especie', 'type'=>'text', 'order'=>8, 'should_be_shown_in_list'=>true]
  field :product_type, :class => String ,:meta => ['display_name'=>'Tipo de producto', 'type'=>'text', 'order'=>9, 'should_be_shown_in_list'=>false]
  field :shipping_volume, :class => Float ,:meta => ['display_name'=>'Volumen total del cargamento (m3)', 'type'=>'text', 'order'=>10, 'should_be_shown_in_list'=>false]
  field :batches_ids, :class => Array ,:meta => ['display_name'=>'Id de lotes', 'type'=>'text', 'order'=>11, 'should_be_shown_in_list'=>false]

  # Indexes
  index :id, :unique => true
  index :num_exportation

  # Relations
  has_many :batches
end

class Batch
  include Mongoid::Document

  #Fields
  field :id, :class => String ,:meta => ['display_name'=>'Id', 'type'=>'text', 'order'=>0, 'should_be_shown_in_list'=>false]
  field :forestal_transport_guide, :class => String ,:meta => ['display_name'=>'GTF', 'type'=>'text', 'order'=>1, 'should_be_shown_in_list'=>true]
  field :contract_code, :class => String ,:meta => ['display_name'=>'Contrato', 'type'=>'text', 'order'=>2, 'should_be_shown_in_list'=>true]
  field :contract_holder, :class => String ,:meta => ['display_name'=>'Titular', 'type'=>'text', 'order'=>3, 'should_be_shown_in_list'=>true]
  field :volume, :class => Float ,:meta => ['display_name'=>'Volumen', 'type'=>'text', 'order'=>4, 'should_be_shown_in_list'=>true]
  field :zafra, :class => String ,:meta => ['display_name'=>'Zafra', 'type'=>'text', 'order'=>5, 'should_be_shown_in_list'=>true]
  field :proprietary, :class => String ,:meta => ['display_name'=>'Propietario', 'type'=>'text', 'order'=>6, 'should_be_shown_in_list'=>true]
  field :receiver, :class => String ,:meta => ['display_name'=>'Destinatario', 'type'=>'text', 'order'=>7, 'should_be_shown_in_list'=>true]
  field :basin, :class => String ,:meta => ['display_name'=>'Cuenca', 'type'=>'text', 'order'=>8, 'should_be_shown_in_list'=>true]
  field :observation, :class => String ,:meta => ['display_name'=>'Observación', 'type'=>'text', 'order'=>9, 'should_be_shown_in_list'=>true]

  # Indexes
  index :id, :unique => true

  # Relations
  belongs_to :exportation
end

class SupervisionReport
  include Mongoid::Document

  # Field Validation
  validates_presence_of :id
  validates_uniqueness_of :id

  # Fields
  field :id, :class => String ,:meta => ['display_name'=>'Id', 'type'=>'text', 'order'=>0, 'should_be_shown_in_list'=>false]
  field :supervision_report_code, :class => String ,:meta => ['display_name'=>'Nº de informe', 'type'=>'text', 'order'=>1, 'should_be_shown_in_list'=>true]
  field :contract_holder, :class => String ,:meta => ['display_name'=>'Titular del contrato', 'type'=>'text', 'order'=>2, 'should_be_shown_in_list'=>true]
  field :contract_code, :class => String ,:meta => ['display_name'=>'Nº de contrato', 'type'=>'text', 'order'=>3, 'should_be_shown_in_list'=>true]
  field :concession, :class => String ,:meta => ['display_name'=>'Tipo de concesión', 'type'=>'text', 'order'=>4, 'should_be_shown_in_list'=>true]
  field :department, :class => String ,:meta => ['display_name'=>'Departamento', 'type'=>'text', 'order'=>5, 'should_be_shown_in_list'=>true]
  field :conclusion, :class => String ,:meta => ['display_name'=>'Conclusión', 'type'=>'text', 'order'=>6, 'should_be_shown_in_list'=>true]
  field :priority, :class => String ,:meta => ['display_name'=>'Prioridad', 'type'=>'text', 'order'=>7, 'should_be_shown_in_list'=>true]

  # Indexes
  index :id, :unique => true
  index :supervision_report_code
end

# record information about every API request
class Hit
  include Mongoid::Document

  index :created_at
  index :method
  index :sections
  index :user_agent
end

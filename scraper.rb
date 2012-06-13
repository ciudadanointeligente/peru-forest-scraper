# coding: utf-8
require 'rubygems'
require 'csv'
require 'rest-client'

class ForestalTableScrapper
	def initialize
		@source_sheet_eia_cites = 'db_sheet1.csv'
		@source_sheet_osinfor_eia = 'db_sheet2.csv'
		@source_sheet_osinfor_conclusions = 'db_sheet3.csv'
		@data = []
		@exportations_url = 'http://api.ciudadanointeligente.cl/forestal/pe/exportations'
		@contracts_url = 'http://api.ciudadanointeligente.cl/forestal/pe/contracts'
		@batches_url = 'http://api.ciudadanointeligente.cl/forestal/pe/batches'
		@supervision_report_url = 'http://api.ciudadanointeligente.cl/forestal/pe/supervision_reports'
	end
	def process_eia_cites
		CSV.foreach(@source_sheet_eia_cites, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
			if !@data[i][2].nil?
				#Si no cuenta con numero de exportation se tratara como un lote
				exportation_data {
				:num_exportation => @data[i][2],
				:year => @data[i][1],
				:num_cites => @data[i][3],
				:date => @data[i][4],
				:exporting_company => @data[i][5],
				:importing_company => @data[i][6],
				:destination_country => @data[i][7],
				:species => @data[i][8],
				:product_type => @data[i][9],
				:shipping_volume => @data[i][10],
				#:batches_ids => @data[i][],
			}
			end
			batch_data {
				:id => i,
				:forestal_transport_guide => @data[i][11],
				:volume => @data[i][14],
				:zafra => @data[i][15],
				:proprietary => @data[i][17],
				:receiver => @data[i][18],
				:basin => @data[i][19],
				:observation => @data[i][20],
				#:contracts_ids => @data[i][],
			}

			RestClient.put @exportations_url, exportation_data, {:content_type => :json}
			RestClient.put @batches_url, batch_data, {:content_type => :json}
		end
	end
	def process_osinfor_eia
		CSV.foreach(@source_sheet_osinfor_eia, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
		end
	end
	def process_osinfor_conclusions
		CSV.foreach(@source_sheet_osinfor_conclusions, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
		end
	end
end
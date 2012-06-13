# coding: utf-8
require 'rubygems'
require 'csv'
require 'rest-client'

class ForestalTableScrapper
	def initialize
		@source_sheet_eia_cites = 'docs/db_sheet1.csv'
		@source_sheet_osinfor_eia = 'docs/db_sheet2.csv'
		@source_sheet_osinfor_conclusions = 'docs/db_sheet3.csv'
		@data = []
		@exportations_url = 'http://api.ciudadanointeligente.cl/forestal/pe/exportations'
		@batches_url = 'http://api.ciudadanointeligente.cl/forestal/pe/batches'
		@supervision_report_url = 'http://api.ciudadanointeligente.cl/forestal/pe/supervision_reports'
	end
	def process_eia_cites
		CSV.foreach(@source_sheet_eia_cites, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
			if !@data[i][2].nil?
				#If you haven't num_exportation it's treated as a batch
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
				:contract_code => @data[i][12],
				:contract_holder => @data[i][13],
				:volume => @data[i][14],
				:zafra => @data[i][15],
				:proprietary => @data[i][17],
				:receiver => @data[i][18],
				:basin => @data[i][19],
				:observation => @data[i][20],
			}

			RestClient.put @exportations_url, exportation_data, {:content_type => :json}
			RestClient.put @batches_url, batch_data, {:content_type => :json}
		end
	end
	def process_reports
		#Sheet with the official reports
		CSV.foreach(@source_sheet_osinfor_eia, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
			supervision_report_data {
				:supervision_report_code => @data[i][0],
				:contract_holder => @data[i][1],
				:contract_code => @data[i][2],
				:concession => @data[i][3],
				:department => @data[i][4],
				:conclusion => @data[i][5], #.gsub(/\n/,''),
			}

			RestClient.put @supervision_report_url, supervision_report_data, {:content_type => :json}
		end
		#Sheet with Julia's annotations
		CSV.foreach(@source_sheet_osinfor_conclusions, :col_sep => "|") do |row|
			@data << row
		end
		for i in 0..@data.length
		end
	end
end
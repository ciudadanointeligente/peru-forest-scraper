# coding: utf-8
require 'rubygems'
require 'csv'
require 'rest-client'

class ForestalTableScrapper
	attr_accessor :source_sheet_eia_cites, :source_sheet_osinfor_eia, :source_sheet_osinfor_conclusions, :data, :current_exportation_id, :current_batches_ids, :exportation_data, :exportations_url, :batches_url, :supervision_report_url

	def initialize
		@source_sheet_eia_cites = 'docs/db_sheet1.csv'
		@source_sheet_osinfor_eia = 'docs/db_sheet2.csv'
		@source_sheet_osinfor_conclusions = 'docs/db_sheet3.csv'
		@data = []
		@current_batches_ids = []
		@current_exportation_id = nil
		@exportation_data = Hash.new
		@exportations_url = 'http://api.ciudadanointeligente.cl/forestal/pe/exportations'
		@batches_url = 'http://api.ciudadanointeligente.cl/forestal/pe/batches'
		@supervision_report_url = 'http://api.ciudadanointeligente.cl/forestal/pe/supervision_reports'
	end
	def process_reports
		#Sheet with the official reports
		@data = []
		CSV.foreach(@source_sheet_osinfor_eia, :col_sep => '|') do |row|
			@data << row
		end
		for i in 1..(@data.length-1)
			supervision_report_data = {
				:id => i,
				:supervision_report_code => @data[i][0],
				:contract_holder => @data[i][1],
				:contract_code => @data[i][2],
				:concession => @data[i][3],
				:department => @data[i][4],
				:conclusion => @data[i][5], #.gsub(/\n/,''), #use the gsub if you want remove the newline character
			}

			RestClient.put @supervision_report_url, supervision_report_data, {:content_type => :json}
		end
	end
	def process_reports_with_annotations
		#Sheet with Julia's annotations
		@data = []
		CSV.foreach(@source_sheet_osinfor_conclusions, :col_sep => '|') do |row|
			@data << row
		end
		puts 'Number of rows to process: '+(@data.length-1).to_s
		for i in 1..(@data.length-1)
			#If exist the report, then adds Julia's annotations
			report = RestClient.get @supervision_report_url, {:params => {:supervision_report_code => @data[i][0]}}
			if !report.scan(/\"id\":\"(\d*)\"/).flatten[0].nil?
				remote_id = report.scan(/\"id\":\"(\d*)\"/).flatten[0]
				puts 'Adds annotations to the supervision report Nº '+@data[i][0]

				RestClient.post @supervision_report_url, {:id => remote_id, :conclusion => @data[i][4], :priority => @data[i][5]}, {:content_type => :json}
			end
		end
	end
	def process_eia_cites
		@data = []
		CSV.foreach(@source_sheet_eia_cites, :col_sep => '|') do |row|
			@data << row
		end
		puts 'Number of rows to process: '+(@data.length-1).to_s
		for i in 1..(@data.length)
			if @data[i].nil? #for the last exportation
				@exportation_data.store('id', @current_exportation_id)
				@exportation_data.store('batches_ids', @current_batches_ids)

				RestClient.put @exportations_url, @exportation_data, {:content_type => :json}
				puts 'Finalizado'
				exit
			end
			if (!@data[i][2].nil?) #for an exportation do
				if !@current_batches_ids.empty? #insert the previous exportation
					@exportation_data.store('id', @current_exportation_id)
					@exportation_data.store('batches_ids', @current_batches_ids)

					RestClient.put @exportations_url, @exportation_data, {:content_type => :json}
					@current_batches_ids = []
					@current_exportation_id = nil
					@exportation_data = {}
				end
				puts 'Process exportation Nº '+@data[i][2]
				if @current_exportation_id.nil?
					@current_exportation_id = i
				end
				@exportation_data = {
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
				}
			end
			@current_batches_ids << i
			batch_data = {
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

			RestClient.put @batches_url, batch_data, {:content_type => :json}
		end
	end
end

if !(defined? Test::Unit::TestCase)
	bot = ForestalTableScrapper.new
	puts '1/3 Processing reports...'
	bot.process_reports
	puts '2/3 Processing reports with comments...'
	bot.process_reports_with_annotations
	puts '3/3 Processing exportations and batches...'
	bot.process_eia_cites
end

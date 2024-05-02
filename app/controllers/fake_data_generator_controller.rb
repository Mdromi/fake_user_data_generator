require "faker"
require "csv"

class FakeDataGeneratorController < ApplicationController
  include FakerHelper
  include FakeDataGeneratorHelper

  def index
    session[:generated_data] = [] 
    @generated_data = generate_fake_data
    @random_seed = 0
  end

  def generate_data
    session[:generated_data] = [] 
    region = params[:region]
    seed = params[:seed]
    error_count = params[:error_count].to_i
    @generated_data = generate_fake_data(region, error_count, seed)

    respond_to do |format|
      format.json { render json: @generated_data }
    end
  end

  def generate_random_seed_data
    session[:generated_data] = [] 
    @random_seed = generate_random_seed
    respond_to do |format|
      format.json { render json: @random_seed }
    end
  end

  def load_more_data
    region = params[:region]
    seed = params[:seed]
    error_count = params[:error_count].to_i
    last_row_count = params[:last_row_count].to_i

    @generated_data = generate_fake_data(region, error_count, seed, last_row_count, load_data = 10)

    respond_to do |format|
      format.json { render json: @generated_data }
    end
  end

  def export_csv
    # Generate CSV data
    csv_data = generate_csv_data(session[:generated_data])

    # Send CSV data as response
    send_data csv_data, filename: "generated_users.csv", type: "text/csv"
  end

  private

  def generate_fake_data(region = "USA", error_count = 0, seed = 0, last_row_count = 0, load_data = 20)
    Faker::Config.locale = Constants::REGION_LANGUAGE_MAP[region]
    faker_instance = Faker::Config.locale
    set_faker_seed(seed)
    generator = Generator.new(region)

    generated_data = (1..load_data).map do |index|
      userData = generate_user_data(region, last_row_count + index)
      generatedData = generator.generate(error_count, { name: userData[:name], address: userData[:address], phone: userData[:phone] })
      {
        **generatedData,
        index: userData[:index],
        identifier: userData[:identifier],
      }
    end

    if session[:generated_data].nil?
      session[:generated_data] = generated_data
    else
      session[:generated_data] += generated_data
    end
    generated_data
  end

  def generate_csv_data(data)
    CSV.generate(headers: true) do |csv|
      csv << data.first.keys # Write headers
      data.each do |item|
        csv << item.values
      end
    end
  end
end

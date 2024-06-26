require "faker"
require "csv"

class FakeDataGeneratorController < ApplicationController
  include FakerHelper
  include FakeDataGeneratorHelper
  @@generated_data = []

  def index
    @@generated_data = []
    @generated_data = generate_fake_data
    @random_seed = 0
  end

  def generate_data
    @@generated_data = []
    region = params[:region]
    seed = params[:seed]
    error_count = params[:error_count].to_i
    @generated_data = generate_fake_data(region, error_count, seed)

    respond_to do |format|
      format.json { render json: @generated_data }
    end
  end

  def generate_random_seed_data
    @@generated_data = []
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
    csv_data = generate_csv_data(@@generated_data)
    send_data csv_data, filename: "generated_users.csv", type: "text/csv"
  end

  private

  def generate_fake_data(region = "USA", error_count = 0, seed = 0, last_row_count = 0, load_data = 20)
    Faker::Config.locale = Constants::REGION_LANGUAGE_MAP[region]
    faker_instance = Faker::Config.locale
    set_faker_seed(seed)
    generator = Generator.new(region)
    # last_row_count = @@generated_data.empty? ? 20 : @@generated_data.length


    generated_data = (1..load_data).map do |index|
      userData = generate_user_data(region, last_row_count + index)
      generatedData = generator.generate(error_count, { name: userData[:name], address: userData[:address], phone: userData[:phone] })
      {
        **generatedData,
        index: userData[:index],
        identifier: userData[:identifier],
      }
    end
    # FakeDataGeneratorWorker.perform_async(region, error_count, last_row_count, load_data)
    # render json: { message: "Data generation job has been enqueued" }

    @@generated_data += generated_data
    generated_data
  end

  def generate_csv_data(data)
    CSV.generate(headers: true) do |csv|
      csv << data.first.keys
      data.each do |item|
        csv << item.values
      end
    end
  end
end

class Devices::ReadingsController < ApplicationController
  def create
    reading_params["readings"].each do |reading|
      Reading.new(reading.to_h).save(reading_params["id"])
    end

    render status: :ok
  end

  private

  def reading_params
    params.permit(
      :id,
      readings: [
        :timestamp,
        :count
      ]
    )
  end
end

class DevicesController < ApplicationController
  before_action :set_device

  def latest_timestamp
    render json: { latest_timestamp: @device.latest_timestamp }
  end

  def cumulative_count
    render json: { cumulative_count: @device.cumulative_count }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.new(params.expect(:id))
    end
end

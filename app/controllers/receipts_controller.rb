class ReceiptsController < ApplicationController
  include ReceiptsHelper
  # route will be orders/:order_id/receipts
  before_action :set_order
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  def index
    @receipts = @order.receipts
  end
  
  def show
    respond_to do |format|
      format.pdf { send_pdf }
    end
  end

  def create
    @receipt = @order.receipts.new(receipt_params)

    if @receipt.amount == 0
      redirect_to orders_path, notice: "No advance payment for order #{@order.id}"
      return
    end

    if (@order.balance < 0)
      flash[:error] = "Receipt amount cannot be greater than the total amount of the order"
      render :new, status: :unprocessable_entity
      return
    end


    respond_to do |format|
      if @receipt.save
        format.html { redirect_to orders_path, notice: 'Receipt was successfully created.' }
        format.json { render :show, status: :created, location: @receipt }
      else
        format.html { render :new }
        format.json { render json: @receipt.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @receipt = @order.receipts.new
    @receipt.amount = 0
  end

  def destroy
    @receipt.destroy
    respond_to do |format|
      format.html { redirect_to order_receipts_path(@order), notice: 'Receipt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def send_pdf
    # Render the PDF in memory and send as the response
    send_data ReceiptsHelper.generate_receipt(@receipt, @order, @order.customer).render,
      filename: "order-#{@order.id}-receipt-#{@receipt.id}.pdf",
      type: "application/pdf",
      disposition: :inline # or :attachment to download
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_receipt
    @receipt = Receipt.find(params[:id])
  end

  def receipt_params
    params.require(:receipt).permit(:amount, :payment_method)
  end
end

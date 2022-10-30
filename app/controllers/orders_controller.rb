class OrdersController < ApplicationController
  
  include ReceiptsHelper
  before_action :set_order, only: %i[ show edit update destroy show_invoice create_bill show_bill ]
  before_action :authenticate_user!

  # GET /orders or /orders.json
  def index
    # if params[:search].present? and value is phone number set posts to customer orders
    if params[:search].present?
      query = params[:search].to_s
      if query.match?(/\A[+-]?\d+?(\.\d+)?\Z/) and query.length == 10
        @orders = Order.where(customer_id: Customer.where(phone: query).pluck(:id)).paginate(page: params[:page], per_page: 10)
      elsif query.match?(/\A[+-]?\d+?(\.\d+)?\Z/) and query.length < 10
        @orders = Order.where(id: query.to_i).paginate(page: params[:page], per_page: 10)
      else
        @orders = Order.where(customer_id: Customer.where("name LIKE ?", "%#{query}%").pluck(:id)).paginate(page: params[:page], per_page: 10)
      end
    else
      @orders = Order.paginate(page: params[:page]).order('created_at DESC')
    end

    if turbo_frame_request?
      render partial: "orders", locals: { orders: @orders }
    else
      render "index"
    end
  end

  def create_bill
    @order.create_bill!
    render partial: "bill", locals: { order: @order }
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  def show_bill
    respond_to do |format|
      format.pdf { send_bill_pdf }
    end
  end

  def show_invoice
    respond_to do |format|
      format.pdf { send_order_pdf }
    end
  end

  # GET /orders/new
  def new
    @order = Order.new
    @order.items.build
    @products = Product.all
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    customer = Customer.find_by(phone: params[:order][:phone])
    params[:order].delete(:phone)
    
    @order = Order.new(order_params)
    @order.customer = customer
    respond_to do |format|
      if @order.save
        format.html { redirect_to new_order_receipt_path(@order), notice: "Order was successfully created. Time for advance payment" }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    params[:order].delete(:phone)
    # if documents are attached, save them else keep the old ones
    if params[:order][:documents].present?
      @order.documents.attach(params[:order][:documents])
      params[:order].delete(:documents)
    end

    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  
  def send_order_pdf
    # Render the PDF in memory and send as the response
    send_data ReceiptsHelper.generate_order(@order, @order.customer).render,
      filename: "order-#{@order.id}.pdf",
      type: "application/pdf",
      disposition: :inline # or :attachment to download
  end

  def send_bill_pdf
    # Render the PDF in memory and send as the response
    send_data ReceiptsHelper.generate_bill(@order, @order.customer).render,
      filename: "bill-#{@order.bill.id}.pdf",
      type: "application/pdf",
      disposition: :inline # or :attachment to download
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:phone, documents: [], items_attributes: [:name, :id, :unit, :quantity, :amount, :_destroy])
    end
end

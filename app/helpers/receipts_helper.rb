module ReceiptsHelper
  def self.generate_order(order, customer)
    r = Receipts::Base.new(
      title: "Order Challan",
      details: [
        ["Order Number", order.id],
        ["Order Date", order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S")],
      ],
      company: {
        name: "Sandhya Rubber Stamp",
        address: "19, Mahavir Bazar, Udhna Teen Rasta, Udhna Surat",
        email: "sandhyarubberstamp@gmail.com",
      },
      recipient: [
        "<b>#{customer.name}</b>",
        customer.address,
        customer.phone
      ],
      line_items: order_line_items(order),
      footer: "Thanks for your business. Please contact us if you have any questions. <b>8866189691</b>"
    )
  end

  def self.generate_bill(order, customer)
    r = Receipts::Base.new(
      title: "Bill",
      details: [
        ["Bill Number", order.bill.id],
        ["Bill Date", order.bill.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S")],
        ["Order Number", order.id],
        ["Order Date", order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S")],
      ],
      company: {
        name: "Sandhya Rubber Stamp",
        address: "19, Mahavir Bazar, Udhna Teen Rasta, Udhna Surat",
        email: "sandhyarubberstamp@gmail.com",
      },
      recipient: [
        "<b>#{customer.name}</b>",
        customer.address,
        customer.phone
      ],
      line_items: order_line_items(order),
      footer: "Thanks for your business. Please contact us if you have any questions. <b>8866189691</b>"
    )
  end

  def self.generate_receipt(receipt, order, customer)
    r = Receipts::Receipt.new(
      details: [
        ["Receipt Number", receipt.id],
        ["Receipt Date", receipt.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S")],
        ["Order Number", order.id],
        ["Order Date", order.created_at.in_time_zone("Asia/Kolkata").strftime("%d/%m/%Y %H:%M:%S")],
        ["Payment method", receipt.payment_method],
      ],
      company: {
        name: "Sandhya Rubber Stamp",
        address: "19, Mahavir Bazar, Udhna Teen Rasta, Udhna Surat",
        email: "sandhyarubberstamp@gmail.com",
      },
      recipient: [
        "<b>#{customer.name}</b>",
        customer.address,
        customer.phone
      ],
      line_items: receipt_line_items(order, receipt),
      footer: "Thanks for your business. Please contact us if you have any questions. <b>8866189691</b>"
    )
  end

  def self.order_line_items(order)
    line_items = [
      ["<b>Item</b>", "<b>Unit</b>", "<b>QTY</b>", "<b>Rate/Unit</b>", "<b>Amount</b>"],
      ["<b>Rubber Stamp</b>", nil, nil, nil, nil]
    ]
    order.items.each do |item|
      line_items << [item.name, item.unit, item.quantity, item.amount / item.quantity, item.amount]
    end
    line_items << [nil, nil, nil,  "<b>Total</b>", order.total_item_amount]
    line_items
  end

  def self.receipt_line_items(order, receipt)
    line_items = [
      ["<b>Received with thanks</b>", nil, nil, "<b>Amount</b>"],
      [nil, nil, "<b>Order Total</b>", order.total_item_amount],
      [nil, nil, "<b>Current Reciept Amount</b>", receipt.amount],
      [nil, nil, "<b>Order Balance</b>", order.balance],
    ]

    if(order.total_item_amount - receipt.amount != order.balance)
      to_add = [nil, nil, "<b>Other Payments</b>", order.total_item_amount - receipt.amount - order.balance]
      # add to_add to 3rd position
      line_items.insert(3, to_add)
    end
    line_items
  end
end

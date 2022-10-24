json.extract! order, :id, :documents, :customer_id, :created_at, :updated_at
json.url order_url(order, format: :json)
json.documents do
  json.array!(order.documents) do |document|
    json.id document.id
    json.url url_for(document)
  end
end

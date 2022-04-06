class Merchant <ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices



  def self.top_merchants_by_revenue(number)
    joins(invoices: {invoice_items: :transactions})
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .group(:id)
    .select('merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .order(revenue: :desc)
    .limit(number)
  end

  def self.top_merchants_by_item_sold(number)
    joins(invoices: {invoice_items: :transactions})
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select('merchants.*, SUM(invoice_items.quantity) as quantity_sold')
    .group(:id)
    .order(quantity_sold: :desc)
    .limit(number)
  end

  def total_revenue
    invoices.joins(invoice_items: :transactions)
    .where(transactions: {result: 'success'}, invoices: {status: 'shipped'})
    .select('invoices.*, SUM(invoice_items.unit_price * invoice_items.quantity)as total_revenue')
    .group(:id)
    .sum(&:total_revenue)
  end
end

# frozen_string_literal: true

class ProductEmail < ActionMailer::Base
  Dir.chdir(File.dirname(__FILE__))
  BODY_TEMPLATE = File.read(File.join(File.dirname(__FILE__), './first_sold.html.erb'))

  default from: 'from@example.com'

  def first_sold_email!(order)
    @product = order.product

    params = {
      sold_date: order.created_at,
      product_code: @product.code,
      order_code: order.code,
      admin_name: @product.user.name
    }

    mail(
      charset:       'utf-8',
      content_type:  'text/html',
      from:          Settings['mailer']['from'],
      subject:       'Primer product vendido',
      to:            @product.user.email,
      cc:            User.all.map(&:email),
      body:          template_from(BODY_TEMPLATE, params)
    )
  end

  def yesterday_report_email!
    mail(
      charset:       'utf-8',
      content_type:  'text/html',
      from:          Settings['mailer']['from'],
      subject:       "Reporte del dia #{Date.yesterday}",
      to:            User.first.email,
      cc:            (User.all - [User.first]).map(&:email).uniq,
      body:          Products::Report.yesterday_sell.to_s
    )
  end

  def template_from(template, params = {})
    binding_params = OpenStruct.new(params).instance_eval { binding }

    ERB.new(template).result(binding_params).squish
  end
  end

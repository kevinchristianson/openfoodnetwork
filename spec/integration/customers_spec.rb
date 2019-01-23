# spec/integration/customers_spec.rb

require 'swagger_helper'

describe 'Customers API', type: :request, swagger_doc: 'v1/swagger.json' do
    let(:api_key) { 'fake_key' }

  path '/customers/{id}/update' do

    parameter name: :id, in: :path, type: :string

    put 'Update customer information' do
      tags 'Customers'
      description 'Update customer information specified by id'
      consumes 'application/json', 'application/xml'
      parameter name: :enterprise_id, :in => :body, :type => :string, required: false
      parameter name: :name, :in => :body, :type => :string, required: false
      parameter name: :code, :in => :body, :type => :integer, required: false
      parameter name: :email, :in => :body, :type => :string, required: false
      parameter name: :allow_charges, :in => :body, :type => :string, required: false


      response '201', 'customer updated' do
        let(:customer) { { name: 'Henry', status: 'available' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:customer) { { name: 'foo' } }
        run_test!
      end
    end
  end

end
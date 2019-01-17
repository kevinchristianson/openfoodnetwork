class Pet < ActiveRecord::Base
  include Swagger::Blocks

  swagger_schema :Pet do
    key :required, [:id, :name]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :tag do
      key :type, :string
    end
  end

  swagger_schema :PetInput do
    allOf do
      schema do
        key :'$ref', :Pet
      end
      schema do
        key :required, [:name]
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end

  # ...
end
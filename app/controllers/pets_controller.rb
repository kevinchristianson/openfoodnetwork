class PetsController < ActionController::Base
  include Swagger::Blocks

  swagger_path '/pets/{id}' do
    operation :get do
      key :summary, 'Find Pet by ID'
      key :description, 'Returns a single pet if the user has access'
      key :operationId, 'findPetById'
      key :tags, [
          'pet'
      ]
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of pet to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      response 200 do
        key :description, 'pet response'
        schema do
          key :'$ref', :Pet
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  swagger_path '/pets' do
    operation :get do
      key :summary, 'All Pets'
      key :description, 'Returns all pets from the system that the user has access to'
      key :operationId, 'findPets'
      key :produces, [
          'application/json',
          'text/html',
      ]
      key :tags, [
          'pet'
      ]
      parameter do
        key :name, :tags
        key :in, :query
        key :description, 'tags to filter by'
        key :required, false
        key :type, :array
        items do
          key :type, :string
        end
        key :collectionFormat, :csv
      end
      parameter do
        key :name, :limit
        key :in, :query
        key :description, 'maximum number of results to return'
        key :required, false
        key :type, :integer
        key :format, :int32
      end
      response 200 do
        key :description, 'pet response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Pet
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
    operation :post do
      key :description, 'Creates a new pet in the store.  Duplicates are allowed'
      key :operationId, 'addPet'
      key :produces, [
          'application/json'
      ]
      key :tags, [
          'pet'
      ]
      parameter do
        key :name, :pet
        key :in, :body
        key :description, 'Pet to add to the store'
        key :required, true
        schema do
          key :'$ref', :PetInput
        end
      end
      response 200 do
        key :description, 'pet response'
        schema do
          key :'$ref', :Pet
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  # ...
end
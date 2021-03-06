module Spree
  module Admin
    ShippingMethodsController.class_eval do
      before_filter :do_not_destroy_referenced_shipping_methods, :only => :destroy
      before_filter :load_hubs, only: [:new, :edit, :create, :update]

      # Sort shipping methods by distributor name
      # ! Code copied from Spree::Admin::ResourceController with two added lines
      def collection
        return parent.public_send(controller_name) if parent_data.present?

        collection = if model_class.respond_to?(:accessible_by) &&
                         !current_ability.has_block?(params[:action], model_class)

                       model_class.accessible_by(current_ability, action)

                     else
                       model_class.scoped
                     end

        collection = collection.managed_by(spree_current_user).by_name # This line added

        # This block added
        if params.key? :enterprise_id
          distributor = Enterprise.find params[:enterprise_id]
          collection = collection.for_distributor(distributor)
        end

        collection
      end

      # Spree allows soft deletes of shipping_methods but our reports are not adapted to that.
      #   So, here we prevent the deletion (even soft) of shipping_methods used in orders.
      def do_not_destroy_referenced_shipping_methods
        order = Order.where(:shipping_method_id => @object).first
        if order
          flash[:error] = I18n.t(:shipping_method_destroy_error, number: order.number)
          redirect_to collection_url and return
        end
      end

      private

      def load_hubs
        @hubs = Enterprise.managed_by(spree_current_user).is_distributor.sort_by!{ |d| [(@shipping_method.has_distributor? d) ? 0 : 1, d.name] }
      end
    end
  end
end

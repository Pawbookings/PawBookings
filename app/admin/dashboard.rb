ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

columns do
column do
  panel "Recent Reservations" do
    table_for Reservation.order(created_at: :desc).limit(10) do
      column("Kennel")   {|res| status_tag(res.kennelID) }
      column("User")   {|res| status_tag(res.userID) }
      column("Customer Email")   {|res| status_tag(res.customer_email) }
      column("Total Price")   {|res| status_tag(res.total_price) }
      # column("Customer"){|order| link_to(order.user.email, admin_customer_path(order.user)) }
      # column("Total")   {|order| number_to_currency order.total_price                       }
    end
  end
end
end
    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       ul do
    #         Post.recent(5).map do |post|
    #           li link_to(post.title, admin_post_path(post))
    #         end
    #       end
    #     end
    #   end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end

- cargar seeds:
 'rake db:test:prepare db:seed'

- Postman: 
  archivo para importar en raiz del proyecto
  
REQUESTS:

- Productos mas vendidos por categoria:
    /api/v1/products/most_sold_products

- Productos que mas recaudaron por categoria:
    /api/v1/products/most_money_products

- Otras rutas:
                  api_v1_categories GET    /api/v1/categories(.:format)                   {:action=>"index", :controller=>"api/v1/categories"}
                                    POST   /api/v1/categories(.:format)                   {:action=>"create", :controller=>"api/v1/categories"}
                    api_v1_category GET    /api/v1/categories/:id(.:format)               {:action=>"show", :controller=>"api/v1/categories"}
                                    PUT    /api/v1/categories/:id(.:format)               {:action=>"update", :controller=>"api/v1/categories"}
                                    DELETE /api/v1/categories/:id(.:format)               {:action=>"destroy", :controller=>"api/v1/categories"}
 most_sold_products_api_v1_products GET    /api/v1/products/most_sold_products(.:format)  {:action=>"most_sold_products", :controller=>"api/v1/products"}
most_money_products_api_v1_products GET    /api/v1/products/most_money_products(.:format) {:action=>"most_money_products", :controller=>"api/v1/products"}
                    api_v1_products GET    /api/v1/products(.:format)                     {:action=>"index", :controller=>"api/v1/products"}
                                    POST   /api/v1/products(.:format)                     {:action=>"create", :controller=>"api/v1/products"}
                     api_v1_product GET    /api/v1/products/:id(.:format)                 {:action=>"show", :controller=>"api/v1/products"}
                                    PUT    /api/v1/products/:id(.:format)                 {:action=>"update", :controller=>"api/v1/products"}
                                    DELETE /api/v1/products/:id(.:format)                 {:action=>"destroy", :controller=>"api/v1/products"}
                     api_v1_clients GET    /api/v1/clients(.:format)                      {:action=>"index", :controller=>"api/v1/clients"}
                                    POST   /api/v1/clients(.:format)                      {:action=>"create", :controller=>"api/v1/clients"}
                      api_v1_client GET    /api/v1/clients/:id(.:format)                  {:action=>"show", :controller=>"api/v1/clients"}
                                    PUT    /api/v1/clients/:id(.:format)                  {:action=>"update", :controller=>"api/v1/clients"}
                                    DELETE /api/v1/clients/:id(.:format)                  {:action=>"destroy", :controller=>"api/v1/clients"}
                      api_v1_orders GET    /api/v1/orders(.:format)                       {:action=>"index", :controller=>"api/v1/orders"}
                                    POST   /api/v1/orders(.:format)                       {:action=>"create", :controller=>"api/v1/orders"}
                       api_v1_order GET    /api/v1/orders/:id(.:format)                   {:action=>"show", :controller=>"api/v1/orders"}
                                    PUT    /api/v1/orders/:id(.:format)                   {:action=>"update", :controller=>"api/v1/orders"}
                                    DELETE /api/v1/orders/:id(.:format)                   {:action=>"destroy", :controller=>"api/v1/orders"}
              api_v1_category_items POST   /api/v1/category_items(.:format)               {:action=>"create", :controller=>"api/v1/category_items"}
               api_v1_category_item DELETE /api/v1/category_items/:id(.:format)           {:action=>"destroy", :controller=>"api/v1/category_items"}
                    me_api_v1_users GET    /api/v1/users/me(.:format)                     {:action=>"me", :controller=>"api/v1/users"}
                       api_v1_users POST   /api/v1/users(.:format)                        {:action=>"create", :controller=>"api/v1/users"}
                        api_v1_user GET    /api/v1/users/:id(.:format)                    {:action=>"show", :controller=>"api/v1/users"}
                                    PUT    /api/v1/users/:id(.:format)                    {:action=>"update", :controller=>"api/v1/users"}
                                    DELETE /api/v1/users/:id(.:format)                    {:action=>"destroy", :controller=>"api/v1/users"}
                  api_v1_auth_login POST   /api/v1/auth/login(.:format)                   {:controller=>"api/v1/auth", :action=>"login"}
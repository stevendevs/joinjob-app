fordward

#FFEB3B

    <%= form_tag(courses_path, method: :get, class: "flex") do %>
      <div class="flex">
        <%= text_field_tag :title, params[:title], autocomplete: 'off', placeholder: "Search", class: 'px-4 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-blue-500' %>
        <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-r-md">
          <i class="fa fa-search" aria-hidden="true"></i>
        </button>
      </div>
    <% end %>

   

 
    


    help
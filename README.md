

    <div class="form-inline my-2 my-lg-0 ">
    <%= form_tag(courses_path, method: :get, class: "input-group flex") do %>
      <%= text_field_tag :title, params[:title], autocomplete: 'off', placeholder: "Search courses", class: 'form-control form-control-sm' %>
      <div class="input-group-append ml-2">
        <button type="submit" class="btn btn-sm btn-primary">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </button>
      </div>
    <% end %>
  </div>
  
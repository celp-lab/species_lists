```{=html}
<div class="list">
<% for (const item of items) { %>
  <div class="species-card" <%= metadataAttrs(item) %>>
    <div class="species-card-image">
      <% if (item.image) { %>
        <img src="<%= item.image %>" alt="<%= item.species %>" />
      <% } else { %>
        <div class="species-card-placeholder">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 80 80" aria-hidden="true">
            <path d="M40 18 C28 18 18 28 18 40 C18 52 28 62 40 62 C52 62 62 52 62 40 C62 28 52 18 40 18Z"
                  fill="none" stroke="currentColor" stroke-width="1.5" stroke-dasharray="4 2" opacity="0.4"/>
            <text x="40" y="44" text-anchor="middle" font-size="10" fill="currentColor" opacity="0.5" font-family="serif" font-style="italic">no image</text>
          </svg>
        </div>
      <% } %>
    </div>
    <div class="species-card-body">
      <h3 class="species-name listing-species"><%= item.species %></h3>
      <div class="species-codes">
        <% if (item.accepted_code) { %>
          <span class="code-badge code-accepted">
            <span class="code-label">Accepted Code</span>
            <strong><%= item.accepted_code %></strong>
            <% if (item.diminutive) { %> Small Code: <strong> <%= item.diminutive %></strong><% } %>
          </span>
        <% } %>
        <% if (item.alternate_codes && item.alternate_codes.length > 0) { %>
          <span class="code-badge code-alternate">
            <span class="code-label">Alt</span>
            <%= item.alternate_codes.join(' · ') %>
            <% if (item.alternate_diminutives && item.alternate_diminutives.length > 0) { %>
              &nbsp;(<%= item.alternate_diminutives.join(' · ') %>)
            <% } %>
          </span>
        <% } %>
      </div>
      <% if (item.description) { %>
        <p class="species-description listing-description"><%= item.description %></p>
      <% } %>
      <% if (item.categories && item.categories.length > 0) { %>
        <div class="species-categories">
          <% item.categories.forEach(function(category) { %>
            <div class="listing-category category-tag" onclick="window.quartoListingCategory('<%= utils.b64encode(category) %>'); return false;">
              <%= category %>
            </div>
          <% }); %>
        </div>
      <% } %>
    </div>
  </div>
<% } %>
</div>
```

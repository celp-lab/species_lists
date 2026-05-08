```{=html}
<%
  const filterFields = [
    { key: 'categories',      label: 'Category' },
<!--    { key: 'mobility',        label: 'Mobility' },    -->
<!--    { key: 'sampling_region', label: 'Region' }, -->

  ];
%>

<div class="species-filter-panel">
<% filterFields.forEach(function(field) {
  const opts = [...new Set(items.flatMap(item => {
    const v = item[field.key];
    if (!v) return [];
    return Array.isArray(v) ? v : [v];
  }))].sort();
  if (opts.length === 0) return;
%>
  <div class="species-filter-group">
    <span class="species-filter-label"><%= field.label %></span>
    <div class="species-filter-bar">
      <button class="species-filter-btn active" data-field="<%= field.key %>" data-value="" onclick="filterSpecies('<%= field.key %>', '', this)">All</button>
      <% opts.forEach(function(val) { %>
        <button class="species-filter-btn" data-field="<%= field.key %>" data-value="<%= val %>" onclick="filterSpecies('<%= field.key %>', '<%= val %>', this)"><%= val %></button>
      <% }); %>
    </div>
  </div>
<% }); %>
</div>

<div class="list">
<% for (const item of items) { %>
  <div class="species-card" <%= metadataAttrs(item) %>
    data-mobility="<%= (Array.isArray(item.mobility) ? item.mobility : (item.mobility ? [item.mobility] : [])).join(',') %>"
    data-sampling_region="<%= (Array.isArray(item.sampling_region) ? item.sampling_region : (item.sampling_region ? [item.sampling_region] : [])).join(',') %>">
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
        <% 
          const altCodes = Array.isArray(item.alternate_codes) ? item.alternate_codes : (item.alternate_codes ? [item.alternate_codes] : []);
          const altDims  = Array.isArray(item.alternate_diminutives) ? item.alternate_diminutives : (item.alternate_diminutives ? [item.alternate_diminutives] : []);
        %>
        <% if (altCodes.length > 0) { %>
          <span class="code-badge code-alternate">
            <span class="code-label">Alt</span>
            <%= altCodes.join(' · ') %>
            <% if (altDims.length > 0) { %>
              &nbsp;(<%= altDims.join(' · ') %>)
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
            <div class="listing-category category-tag" onclick="filterSpecies('categories', '<%= category %>', null); return false;">
              <%= category %>
            </div>
          <% }); %>
        </div>
      <% } %>
    </div>
  </div>
<% } %>
</div>

<script>
(function() {
  // Active filters: one selected value per field, '' means All
  const activeFilters = {
    categories:      '',
    mobility:        '',
    sampling_region: ''
  };

  window.filterSpecies = function(field, value, clickedBtn) {
    // Update active filter for this field
    activeFilters[field] = value;

    // Update button active states for this field's bar only
    document.querySelectorAll('.species-filter-btn[data-field="' + field + '"]').forEach(function(btn) {
      btn.classList.toggle('active', btn.getAttribute('data-value') === value);
    });

    // Apply all active filters combined (AND logic)
    document.querySelectorAll('.species-card').forEach(function(card) {
      const visible = Object.entries(activeFilters).every(function([f, v]) {
        if (v === '') return true; // this filter is set to All — pass

        if (f === 'categories') {
          // categories are base64-encoded in data-categories
          const raw = card.getAttribute('data-categories') || '';
          if (!raw) return false;
          try {
            const decoded = decodeURIComponent(atob(raw));
            return decoded.split(',').map(s => s.trim()).includes(v);
          } catch(e) { return false; }
        } else {
          // other fields are stored as plain comma-separated data-* attributes
          const raw = card.getAttribute('data-' + f) || '';
          return raw.split(',').map(s => s.trim()).includes(v);
        }
      });
      card.style.display = visible ? '' : 'none';
    });

    // Keep Quarto's sidebar category filter in sync for categories
    if (field === 'categories' && window.quartoListingCategory) {
      window.quartoListingCategory(value === '' ? '' : btoa(encodeURIComponent(value)));
    }
  };
})();
</script>
```

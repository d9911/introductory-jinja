# Jinja Learning Project

A comprehensive prototype demonstrating Jinja2 templating capabilities with Flask and modern CSS. This project showcases various Jinja features including template inheritance, filters, conditionals, loops, and data manipulation.

## 🚀 Features

### Jinja2 Features Demonstrated

- **Template Inheritance**: Using `{% extends %}` and `{% block %}` for reusable layouts
- **Variable Output**: Displaying data with `{{ variable }}` and filters
- **Control Structures**: `{% if %}`, `{% for %}`, `{% include %}`
- **Filters & Functions**: `upper`, `lower`, `title`, `length`, `join`, `format`
- **Advanced Filters**: `selectattr`, `map`, `unique`, `groupby`, `sum`
- **Conditional Logic**: Complex if/elif/else statements
- **Data Manipulation**: Working with lists, dictionaries, and nested data

### Pages

- **Home**: User profile, product showcase, Jinja features demo
- **Products**: Product catalog with filtering, statistics, and category breakdown
- **About**: Team information and project overview

### Modern UI/UX

- Responsive design that works on all devices
- Beautiful gradient backgrounds and modern card layouts
- Interactive hover effects and smooth transitions
- Clean typography and spacing
- Professional color scheme

## 🛠️ Technology Stack

- **Backend**: Flask (Python web framework)
- **Templating**: Jinja2
- **Styling**: Modern CSS with Flexbox and Grid
- **Build Tool**: Makefile for easy development workflow

## 📦 Installation & Setup

### Prerequisites

- Python 3.11+
- Make (for using the Makefile)

### Quick Start

1. **Clone or navigate to the project directory**

   ```bash
   cd introductory-jinja
   ```

2. **Create the environment, install dependencies, initialize the database, and run the application**

   ```bash
   make dev
   ```

3. **Open your browser and visit**

```bash
http://localhost:5006
```

## 🔧 Makefile Commands

The project includes a comprehensive Makefile for easy development:

- `make dev` - Prepare and start the local development environment
- `make install` - Create or reuse the virtual environment and install dependencies
- `make run` - Start the Flask development server on port 5006
- `make docker-dev` - Start the application and PostgreSQL with Docker Compose
- `make freeze` - Update requirements.txt with current dependencies
- `make clean` - Remove Python cache files

Local development uses SQLite by default. The Docker workflow uses PostgreSQL
from `docker-compose.yml`.

## 📁 Project Structure

```tree
introductory-jinja/
├── app.py                 # Flask application with routes
├── requirements.txt       # Python dependencies
├── Makefile              # Development commands
├── README.md             # This file
├── static/
│   └── style.css         # Modern CSS styling
└── templates/
    ├── base.html         # Base template with layout
    ├── index.html        # Home page with Jinja features
    ├── about.html        # About page with team info
    ├── products.html     # Product catalog page
    └── partials/
        └── header.html   # Navigation header
```

## 🎯 Learning Objectives

This project is designed to help you learn:

1. **Template Inheritance**: How to create reusable layouts
2. **Data Display**: Various ways to output variables and data
3. **Control Flow**: Using conditionals and loops in templates
4. **Filters**: Transforming data with built-in Jinja filters
5. **Advanced Features**: Working with complex data structures
6. **Best Practices**: Organizing templates and using includes

## 🔍 Key Jinja Features Explained

### Template Inheritance

```jinja
{% extends "base.html" %}
{% block content %}
  <!-- Your content here -->
{% endblock %}
```

### Variable Output with Filters

```jinja
{{ user.name | upper }}
{{ items | length }} items
{{ price | format("%.2f") }}
```

### Conditional Logic

```jinja
{% if user.is_admin %}
  <span class="badge badge-admin">Administrator</span>
{% else %}
  <span class="badge badge-user">Regular User</span>
{% endif %}
```

### Loops

```jinja
{% for product in products %}
  <div class="product-card">
    <h3>{{ product.name }}</h3>
    <p class="price">${{ product.price | format("%.2f") }}</p>
  </div>
{% endfor %}
```

### Advanced Filters

```jinja
{% set in_stock_count = products | selectattr('in_stock', 'equalto', true) | list | length %}
{% set categories = products | map(attribute='category') | unique | list %}
```

## 🎨 Customization

### Adding New Pages

1. Create a new route in `app.py`
2. Create a new template file in `templates/`
3. Extend the base template
4. Add navigation link in `templates/partials/header.html`

### Styling

The CSS is organized into logical sections:

- Base styles and reset
- Header and navigation
- Hero sections
- Cards and content grids
- Components (badges, buttons, etc.)
- Responsive design

### Data Structure

Modify the data in `app.py` routes to experiment with different data structures and see how Jinja handles them.

## 🚀 Next Steps

Once you're comfortable with this project, try:

1. **Adding a database**: Integrate SQLAlchemy or another ORM
2. **User authentication**: Add login/logout functionality
3. **Forms**: Create forms with Flask-WTF
4. **API integration**: Fetch data from external APIs
5. **Advanced Jinja**: Explore macros, custom filters, and template functions

## 📚 Resources

- [Jinja2 Documentation](https://jinja.palletsprojects.com/)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [CSS Grid Guide](https://css-tricks.com/snippets/css/complete-guide-grid/)
- [Flexbox Guide](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

## 🤝 Contributing

Feel free to fork this project and experiment with it! Some ideas:

- Add more Jinja features
- Create new pages
- Enhance the styling
- Add JavaScript interactivity
- Implement a backend database

---

**Happy Learning! 🎉**# introductory-jinja

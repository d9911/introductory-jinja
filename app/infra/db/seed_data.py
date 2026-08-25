# Этот файл содержит функции и данные для начального заполнения базы данных (seed).
# Используется для создания тестовых или стартовых данных при первом запуске приложения.
from datetime import datetime

from app.core.extensions import db
from app.infra.db.models import Category, Product, User


def seed_database():
    """Seed the database with initial data"""

    # Create users
    users = [
        User(
            name="Alice Johnson",
            email="alice@example.com",
            is_admin=True,
            join_date=datetime(2024, 1, 15),
        ),
        User(
            name="Bob Smith",
            email="bob@example.com",
            is_admin=False,
            join_date=datetime(2024, 2, 1),
        ),
        User(
            name="Carol Davis",
            email="carol@example.com",
            is_admin=False,
            join_date=datetime(2024, 3, 10),
        ),
    ]

    for user in users:
        if User.query.filter_by(email=user.email).first() is None:
            db.session.add(user)

    # Create categories
    categories = [
        Category(name="Electronics", description="Electronic devices and gadgets"),
        Category(name="Books", description="Books and literature"),
        Category(name="Kitchen", description="Kitchen appliances and utensils"),
        Category(name="Office", description="Office supplies and equipment"),
        Category(name="Sports", description="Sports equipment and accessories"),
        Category(name="Fashion", description="Clothing and fashion items"),
        Category(
            name="Home & Garden", description="Home improvement and garden supplies"
        ),
        Category(name="Automotive", description="Car parts and accessories"),
        Category(
            name="Health & Beauty", description="Health products and beauty supplies"
        ),
        Category(name="Toys & Games", description="Children's toys and board games"),
        Category(
            name="Music & Instruments",
            description="Musical instruments and audio equipment",
        ),
        Category(name="Art & Crafts", description="Art supplies and craft materials"),
        Category(name="Pet Supplies", description="Pet food and accessories"),
        Category(name="Baby & Kids", description="Baby products and children's items"),
        Category(name="Tools & Hardware", description="Tools and hardware supplies"),
        Category(name="Jewelry & Watches", description="Fine jewelry and timepieces"),
        Category(
            name="Outdoor & Camping", description="Outdoor gear and camping equipment"
        ),
        Category(name="Photography", description="Cameras and photography equipment"),
        Category(
            name="Computers & Software", description="Computer hardware and software"
        ),
        Category(name="Food & Beverages", description="Food products and beverages"),
        Category(name="Furniture", description="Home and office furniture"),
        Category(name="Lighting", description="Lighting fixtures and bulbs"),
        Category(
            name="Storage & Organization",
            description="Storage solutions and organizers",
        ),
        Category(
            name="Bath & Shower", description="Bathroom accessories and shower items"
        ),
        Category(
            name="Bedding & Linens", description="Bed sheets, pillows, and linens"
        ),
        Category(
            name="Wall Art & Decor", description="Wall decorations and home decor"
        ),
        Category(
            name="Kitchen Appliances",
            description="Modern kitchen appliances and gadgets",
        ),
        Category(name="Smart Home", description="Smart home devices and automation"),
        Category(name="Gaming", description="Video games and gaming accessories"),
        Category(
            name="Fitness & Exercise", description="Fitness equipment and workout gear"
        ),
        Category(
            name="Yoga & Meditation",
            description="Yoga mats, meditation cushions, and wellness items",
        ),
        Category(
            name="Travel & Luggage",
            description="Travel bags, suitcases, and travel accessories",
        ),
        Category(
            name="Backpacks & Bags",
            description="Backpacks, handbags, and carrying solutions",
        ),
        Category(
            name="Watches & Clocks",
            description="Wristwatches, wall clocks, and timepieces",
        ),
        Category(
            name="Sunglasses & Eyewear",
            description="Sunglasses, reading glasses, and eyewear",
        ),
        Category(
            name="Hair Care & Styling",
            description="Hair care products and styling tools",
        ),
        Category(
            name="Skincare & Cosmetics", description="Skincare products and makeup"
        ),
        Category(
            name="Fragrances & Perfumes",
            description="Perfumes, colognes, and fragrances",
        ),
        Category(
            name="Dental Care",
            description="Toothbrushes, toothpaste, and dental hygiene",
        ),
        Category(
            name="First Aid & Medical",
            description="First aid kits and medical supplies",
        ),
        Category(
            name="Vitamins & Supplements",
            description="Dietary supplements and vitamins",
        ),
        Category(name="Organic & Natural", description="Organic and natural products"),
        Category(
            name="Vintage & Antiques",
            description="Vintage items and antique collectibles",
        ),
        Category(
            name="DIY & Crafts",
            description="Do-it-yourself supplies and craft materials",
        ),
        Category(
            name="Party & Celebration",
            description="Party supplies and celebration decorations",
        ),
        Category(
            name="Holiday & Seasonal",
            description="Holiday decorations and seasonal items",
        ),
        Category(
            name="Wedding & Events",
            description="Wedding supplies and event planning items",
        ),
        Category(
            name="Educational & Learning",
            description="Educational materials and learning resources",
        ),
        Category(
            name="Professional & Business",
            description="Professional attire and business supplies",
        ),
        Category(
            name="Luxury & Premium", description="Luxury items and premium products"
        ),
        Category(
            name="Budget & Value", description="Affordable and value-priced items"
        ),
        Category(
            name="Eco-Friendly & Sustainable",
            description="Environmentally friendly and sustainable products",
        ),
    ]

    for category in categories:
        if Category.query.filter_by(name=category.name).first() is None:
            db.session.add(category)

    # Commit to get IDs
    db.session.commit()

    # Create products with category relationships
    products = [
        Product(
            name="Laptop",
            price=999.99,
            category="Electronics",
            in_stock=True,
            rating=4.5,
        ),
        Product(name="Book", price=19.99, category="Books", in_stock=True, rating=4.2),
        Product(
            name="Coffee Mug",
            price=12.50,
            category="Kitchen",
            in_stock=False,
            rating=3.8,
        ),
        Product(
            name="Headphones",
            price=89.99,
            category="Electronics",
            in_stock=True,
            rating=4.7,
        ),
        Product(
            name="Notebook", price=5.99, category="Office", in_stock=True, rating=4.0
        ),
        Product(
            name="Smartphone",
            price=699.99,
            category="Electronics",
            in_stock=True,
            rating=4.6,
        ),
        Product(
            name="Running Shoes",
            price=129.99,
            category="Sports",
            in_stock=True,
            rating=4.3,
        ),
        Product(
            name="T-Shirt",
            price=24.99,
            category="Fashion",
            in_stock=True,
            rating=4.1,
        ),
    ]

    for product in products:
        if Product.query.filter_by(name=product.name).first() is None:
            db.session.add(product)

    # Commit to get product IDs
    db.session.commit()

    # Set up many-to-many relationships
    # Get categories by name
    electronics = Category.query.filter_by(name="Electronics").first()
    books = Category.query.filter_by(name="Books").first()
    kitchen = Category.query.filter_by(name="Kitchen").first()
    office = Category.query.filter_by(name="Office").first()
    sports = Category.query.filter_by(name="Sports").first()
    fashion = Category.query.filter_by(name="Fashion").first()

    # Get products by name
    laptop = Product.query.filter_by(name="Laptop").first()
    book = Product.query.filter_by(name="Book").first()
    coffee_mug = Product.query.filter_by(name="Coffee Mug").first()
    headphones = Product.query.filter_by(name="Headphones").first()
    notebook = Product.query.filter_by(name="Notebook").first()
    smartphone = Product.query.filter_by(name="Smartphone").first()
    running_shoes = Product.query.filter_by(name="Running Shoes").first()
    t_shirt = Product.query.filter_by(name="T-Shirt").first()

    # Add missing category relationships without duplicating existing links.
    product_categories = (
        (laptop, electronics),
        (book, books),
        (coffee_mug, kitchen),
        (headphones, electronics),
        (notebook, office),
        (smartphone, electronics),
        (running_shoes, sports),
        (t_shirt, fashion),
    )
    for product, category in product_categories:
        if product and category and category not in product.categories:
            product.categories.append(category)

    # Final commit
    db.session.commit()
    print("Database seeded successfully!")
    print(f"Users available: {User.query.count()}")
    print(f"Categories available: {Category.query.count()}")
    print(f"Products available: {Product.query.count()}")
    print("Product-category relationships are up to date")

import pytest
from app.core import create_app
from app.core.extensions import db
from app.core.config import TestingConfig
from app.infra.db.models import Product, User, Category

@pytest.fixture(scope='session')
def app():
    app = create_app(config_class=TestingConfig)
    with app.app_context():
        db.create_all()
        # Добавьте тестовые данные
        db.session.add(Product(name="Laptop", price=1000, description="Test laptop", category_id=1))
        db.session.add(User(name="Alice", email="alice@example.com", password="testpass"))
        db.session.commit()
        yield app
        db.session.remove()
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()

def test_get_categories(client):
    # Предварительно добавить категорию в БД, если нужно
    from app.infra.db.models import Category
    from app import db

    with client.application.app_context():
        db.session.add(Category(name="Books"))
        db.session.commit()

    response = client.get("/categories")
    assert response.status_code == 200
    assert b"Books" in response.data

def test_create_category(client):
    response = client.post("/categories", data={"name": "NewCategory"})
    assert response.status_code in (200, 302)  # redirect or success

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
        yield app
        db.session.remove()
        db.drop_all()

@pytest.fixture
def client(app):
    return app.test_client()
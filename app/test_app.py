import os
import pytest
from flask import json
from app import app, mysql 

@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    app.config['TESTING'] = True
    app.config["MYSQL_DATABASE_USER"] = "test_user"
    app.config["MYSQL_DATABASE_PASSWORD"] = "test_password"
    app.config["MYSQL_DATABASE_DB"] = "test_db"
    app.config["MYSQL_DATABASE_HOST"] = "test_host"
    
    with app.test_client() as client:
        yield client

def test_index(client):
    """Test the index route."""
    response = client.get("/")
    assert response.data == b"Hello, world!"
    assert response.status_code == 200

def test_create_message(client, monkeypatch):
    """Test the create message endpoint."""
    test_data = {
        'account_id': '123',
        'sender_number': '555-0100',
        'receiver_number': '555-0200'
    }
    
    # Mock database connection
    monkeypatch.setattr(mysql, 'connect', lambda: MagicMock())

    response = client.post('/create', json=test_data)
    assert response.status_code == 201
    assert 'message_id' in response.json

def test_get_messages(client, monkeypatch):
    """Test the get messages by account ID endpoint."""
    # Mock database connection and fetchall
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    monkeypatch.setattr(mysql, 'connect', lambda: mock_conn)
    mock_conn.cursor.return_value = mock_cursor
    mock_cursor.fetchall.return_value = [
        ('123', 'message_id_1', '555-0100', '555-0200'),
        ('123', 'message_id_2', '555-0101', '555-0201')
    ]

    response = client.get('/get/messages/123')
    assert response.status_code == 200
    assert len(response.json) == 2  # Should return 2 messages

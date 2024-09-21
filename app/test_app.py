import os
import pytest
from flask import json
from unittest.mock import MagicMock, patch
from app import app as myapp
from app import mysql

@pytest.fixture
def client():
    """Create a test client for the Flask application."""
    myapp.config['TESTING'] = True
    myapp.config["MYSQL_DATABASE_USER"] = "test_user"
    myapp.config["MYSQL_DATABASE_PASSWORD"] = "test_password"
    myapp.config["MYSQL_DATABASE_DB"] = "test_db"
    myapp.config["MYSQL_DATABASE_HOST"] = "test_host"
    
    with myapp.test_client() as client:
        yield client

def test_index(client):
    """Test the index route."""
    response = client.get("/")
    assert response.data == b"Hello, world!"
    assert response.status_code == 200

def test_create_message(client):
    """Test the create message endpoint."""
    test_data = {
        'account_id': '123',
        'sender_number': '555-0100',
        'receiver_number': '555-0200'
    }

    # Mock the database connection and cursor
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_cursor.execute.return_value = None  # Simulate successful execution
    mock_cursor.fetchall.return_value = []   # Simulate no records returned
    
    with patch('app.mysql.connect', return_value=mock_conn):
        response = client.post('/create', json=test_data)
        assert response.status_code == 201
        assert 'message_id' in response.json

def test_get_messages(client):
    """Test the get messages by account ID endpoint."""
    # Mock the database connection and cursor
    mock_conn = MagicMock()
    mock_cursor = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_cursor.fetchall.return_value = [
        ('123', 'message_id_1', '555-0100', '555-0200'),
        ('123', 'message_id_2', '555-0101', '555-0201')
    ]
    
    with patch('app.mysql.connect', return_value=mock_conn):
        response = client.get('/get/messages/123')
        assert response.status_code == 200
        assert len(response.json) == 2  # Should return 2 messages

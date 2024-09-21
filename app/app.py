from flask import Flask, request, jsonify
import logging
import uuid
from logging_config import setup_logging
from flaskext.mysql import MySQL
import os


# Initialize Flask app
app = Flask(__name__)

setup_logging()

mysql = MySQL()

app.config["MYSQL_DATABASE_USER"] = os.getenv("MYSQL_DATABASE_USER")
app.config["MYSQL_DATABASE_PASSWORD"] = os.getenv("MYSQL_DATABASE_PASSWORD")
app.config["MYSQL_DATABASE_DB"] = os.getenv("MYSQL_DATABASE_DB")
app.config["MYSQL_DATABASE_HOST"] = os.getenv("MYSQL_DATABASE_HOST")

mysql.init_app(app)

def init_db():
    with app.app_context():
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS messages (
            account_id VARCHAR(255) NOT NULL,
            message_id VARCHAR(255) NOT NULL,
            sender_number VARCHAR(255) NOT NULL,
            receiver_number VARCHAR(255) NOT NULL,
            PRIMARY KEY (message_id)
        );
        ''')
        conn.commit()  
        cursor.close()
        conn.close()

@app.route("/")
def index():
    return "Hello, world!"

@app.errorhandler(Exception)
def handle_exception(e):
    logging.error(f"Error occurred: {str(e)}")
    return jsonify({'error': str(e)}), 500

@app.route('/create', methods=['POST'])
def create_message():
    try:
        data = request.json
        account_id = data['account_id']
        sender_number = data['sender_number']
        receiver_number = data['receiver_number']
        message_id = str(uuid.uuid4())

        conn = mysql.connect()
        cursor = conn.cursor()
        query = "INSERT INTO messages (account_id, message_id, sender_number, receiver_number) VALUES (%s, %s, %s, %s)"
        cursor.execute(query, (account_id, message_id, sender_number, receiver_number))
        conn.commit()
        cursor.close()
        conn.close()
        logging.info(f"Message created: {message_id}")
        return jsonify({'message': 'Message created successfully', 'message_id': message_id}), 201

    except Exception as e:
        return handle_exception(e)

# Get messages by account ID
@app.route('/get/messages/<account_id>', methods=['GET'])
def get_messages(account_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        query = "SELECT * FROM messages WHERE account_id=%s"
        cursor.execute(query, (account_id,))
        messages = cursor.fetchall()
        logging.info(f"Fetched messages for account: {account_id}")
        cursor.close()
        conn.close()
        return jsonify(messages), 200

    except Exception as e:
        return handle_exception(e)
# Search
@app.route('/search', methods=['GET'])
def search_messages():
    account_id = request.args.get('account_id')
    message_ids = request.args.get('message_id')
    sender_numbers = request.args.get('sender_number')
    receiver_numbers = request.args.get('receiver_number')

    conn = mysql.connect()
    cursor = conn.cursor()

    search_query = "SELECT * FROM messages WHERE account_id = %s"
    filters = [account_id]
    # Add filters based on query parameters
    if message_ids:
        message_ids = message_ids.split(',')
        global search_query
        global filters
        search_query = search_query + " WHERE message_id IN ({0})" .format(','.join(['%s'] * len(message_ids)))
        logging.info(search_query)
        filters.extend(message_ids)

    if sender_numbers:
        sender_numbers = sender_numbers.split(',')
        #query += " AND sender_number IN (%s)" % ','.join(['%s'] * len(sender_numbers))
        search_query = search_query + " AND sender_number IN ({0})" .format(','.join(['%s'] * len(sender_numbers)))
        filters.extend(sender_numbers)

    if receiver_numbers:
        receiver_numbers = receiver_numbers.split(',')
        #query += " AND receiver_number IN (%s)" % ','.join(['%s'] * len(receiver_numbers))
        search_query = search_query + " AND receiver_number IN ({0})" .format(','.join(['%s'] * len(receiver_numbers)))
        filters.extend(receiver_numbers)
    logging.info(search_query)
    logging.info(filters)
    cursor.execute(search_query, tuple(filters))
    result = cursor.fetchall()

    if not result:
        return jsonify({"message": "No messages found matching the search criteria"}), 404
    
    cursor.close()
    conn.close()
    return jsonify(result), 200

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)

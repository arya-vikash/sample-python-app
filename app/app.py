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

        formated_messages=[]
        for item in messages:
            formated_messages.append({
                "account_id":item[0],
                "message_id":item[1],
                "sender_number":item[2],
                "receiver_number":item[3]
            })
        cursor.close()
        conn.close()
        return jsonify(formated_messages), 200

    except Exception as e:
        return handle_exception(e)
# Search
@app.route('/search', methods=['GET'])
def search_messages():
    try:
        account_id = request.args.get('account_id')
        message_ids = request.args.get('message_id')
        sender_numbers = request.args.get('sender_number')
        receiver_numbers = request.args.get('receiver_number')

        logging.info(f"account_id: {account_id}, message_ids: {message_ids}, sender_numbers: {sender_numbers}, receiver_numbers: {receiver_numbers}")

        conn = mysql.connect()
        cursor = conn.cursor()

        search_query = "SELECT * FROM messages WHERE account_id = %s"
        filters = [account_id]
        filter_conditions = []
        
        if message_ids:
            message_ids = message_ids.split(',')
            filter_conditions.append("message_id IN ({})".format(','.join(['%s'] * len(message_ids))))
            filters.extend(message_ids)

        if sender_numbers:
            sender_numbers = sender_numbers.split(',')
            filter_conditions.append("sender_number IN ({})".format(','.join(['%s'] * len(sender_numbers))))
            filters.extend(sender_numbers)

        if receiver_numbers:
            receiver_numbers = receiver_numbers.split(',')
            filter_conditions.append("receiver_number IN ({})".format(','.join(['%s'] * len(receiver_numbers))))
            filters.extend(receiver_numbers)
        
        if filter_conditions:
            search_query += " AND " + " AND ".join(filter_conditions)

        logging.info(f"Search Query: {search_query}")
        logging.info(f"Filters: {filters}")

        cursor.execute(search_query, tuple(filters))
        result = cursor.fetchall()

        if not result:
            return jsonify({"message": "No messages found matching the search criteria"}), 404
        
        #format result output
        formated_result=[]
        for item in result:
            formated_result.append({
                "account_id":item[0],
                "message_id":item[1],
                "sender_number":item[2],
                "receiver_number":item[3]
            })
        cursor.close()
        conn.close()
        return jsonify(formated_result), 200

    except Exception as e:
        return handle_exception(e)
if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)

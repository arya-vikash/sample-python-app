# import pymysql
# import os

# def get_db_connection():
#     connection = pymysql.connect(
#         host=os.getenv('DB_HOST', 'mysql'),
#         user=os.getenv('DB_USER', 'user'),
#         password=os.getenv('DB_PASSWORD', 'password'),
#         db=os.getenv('DB_NAME', 'messages_db'),
#         charset='utf8mb4',
#         cursorclass=pymysql.cursors.DictCursor
#     )
#     return connection

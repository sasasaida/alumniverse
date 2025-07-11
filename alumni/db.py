import pymysql
from django.db import DatabaseError
from django.db.models.expressions import result
from pymysql.cursors import DictCursor
from contextlib import contextmanager

@contextmanager
def get_db_connection():
    conn = pymysql.connect(
        host='localhost',
        user='root',
        password='root',
        database='alumni',
        port=3306,
        cursorclass=DictCursor
    )
    try:
        yield conn
    finally:
        conn.close()

def execute_query(query, params=None, fetch=False, all=False):
    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()
            if params is None:
                params = ()
            elif not isinstance(params, (tuple, list)):
                params = (params,)
            cursor.execute(query, params or [])
            if fetch:
                if all:
                    #result = cursor.fetchall()
                    columns = [col[0] for col in cursor.description]
                    return [dict(zip(columns, row)) for row in cursor.fetchall()]
                else:
                    #result = cursor.fetchone()
                    columns = [col[0] for col in cursor.description]
                    return [dict(zip(columns, row)) for row in cursor.fetchone()]

            else:
                conn.commit()
                result = cursor.lastrowid
            cursor.close()
            return result
    except DatabaseError as e:
        print(f"Database error: {e}")
        return None


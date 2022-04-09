from flask import Flask, render_template, request
from flask_mysqldb import MySQL
from sqlalchemy import null

app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'comparaja'

mysql = MySQL(app)
global data
@app.route('/form')
def form():
    return render_template('form.html', data=null)


@app.route('/getproviderproducts', methods=['POST', 'GET'])
def get_provider_products():
    if request.method == 'GET':
        return "Give information"

    if request.method == 'POST':
        provider = request.form['provider']

        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT COMPARAJA.PRODUCTS.ID, COMPARAJA.VERTICALS.NAME FROM COMPARAJA.PROVIDERS INNER JOIN
        COMPARAJA.PRODUCTS ON COMPARAJA.PRODUCTS.PROVIDER_ID = COMPARAJA.PROVIDERS.ID
        INNER JOIN COMPARAJA.VERTICALS ON COMPARAJA.VERTICALS.ID = COMPARAJA.PRODUCTS.VERTICAL_ID
        WHERE COMPARAJA.PROVIDERS.NAME = %s''', [provider])
        data = cursor.fetchall()
        mysql.connection.commit()
        cursor.close()
        print(data)
    return render_template('cards.html', data=data)


@app.route('/getproviderproductsinfo', methods=['POST', 'GET'])
def get_provider_products_info():
    if request.method == 'GET':
        return "Give information"

    if request.method == 'POST':
        provider = request.form['provider']
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT comparaja.products.id, comparaja.products.is_sponsored,
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 1), ' ', -1), ':', '-1') as p,
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 2), ' ', -1), ':', '-1') as internet_download_speed_in_mbs, 
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 3), ' ', -1), ':', '-1') as internet_upload_speed_in_mbs, 
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 4), ' ', -1), ':', '-1') as tv_channels, 
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 5), ' ', -1), ':', '-1') as mobile_phone_count, 
            substring_index(substring_index(substring_index (comparaja.products.data, ',', 6), ' ', -1), ':', '-1') as mobile_phone_data_in_gbps, 
            substring_index(replace(substring_index(substring_index (comparaja.products.data, ',', 7), ' ', -1), '\n}', ''), ':', -1) as price
        from comparaja.products inner join comparaja.verticals on comparaja.products.vertical_id = comparaja.verticals.id
        inner join comparaja.providers on comparaja.providers.id = comparaja.products.provider_id
        where comparaja.providers.name = %s and comparaja.providers.is_active = TRUE''', [provider])
        data = cursor.fetchall()
        mysql.connection.commit()
        cursor.close()
        print(data)
    return render_template('cards.html', data=data)


app.run(host='localhost', port=3306)

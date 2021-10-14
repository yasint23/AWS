from flask import Flask, render_template, redirect, url_for

app = Flask (__name__)

@app.route('/')
def home():
    return 'This is home page for no path, <h1> Welcome Home</h1>'

@app.route('/about')
def about():
    return '<h1>This is my about page </h1>' 

@app.route('/error')
def error():
    return '<h1>Either you run into an error or you are not authorized.</h1>'

@app.route('/hello')
def hello():
    return f'<h1>Hello, World! </h1>'

@app.route('/admin')
def admin():
    return redirect (url_for('error'))

@app.route('/<name>')
def greet(name):
    greet_format = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Greeting Page</title>
</head>
<body>
    <h1>Hello, { name }!</h1>
    <h1>Welcome to my Greeting Page</h1>
</body>
</html>
    """
    return greet_format


@app.route('/greet_admin')
def greet_admin():
    return redirect(url_for('greet', name = 'Master Admin!!!'))

@app.route('/<name>')
def greeting(name):
    return render_template('greet.html', name_html = name)

@app.route('/list10')
def list10():
    return render_template('list10.html')


@app.route('/evens')
def evens():
    return render_template('evens.html')



if __name__ == '__main__':
    #app.run(debug=True)
    app.run(host='0.0.0.0', port=80)
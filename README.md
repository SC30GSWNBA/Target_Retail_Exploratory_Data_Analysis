# Target_Retail_Exploratory_Data_Analysis

**Overview of Business Case**

Target is one of the world’s most recognized brands and one of America’s leading retailers. Target makes itself a preferred shopping destination by offering outstanding value, inspiration, innovation and an exceptional guest experience that no other retailer can deliver.

This business case has information of 100k orders from 2016 to 2018 made at Target in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers.

Data is available in 8 csv files (Look for the csv files in the same folder):

1. customers.csv

2. geolocation.csv (Uploaded as 2 separate files - geolocation - 1.csv and geolocation - 1.csv)

3. order_items.csv

4. payments.csv

5. reviews.csv

6. orders.csv

7. products.csv

8. sellers.csv

Each feature or columns of different CSV files are described below:

The **customers.csv** contain following features:

**Features and Description**

customer_id -> Id of the consumer who made the purchase.

customer_unique_id -> Unique Id of the consumer.

customer_zip_code_prefix -> Zip Code of the location of the consumer.

customer_city -> Name of the City from where order is made.

customer_state -> State Code from where order is made(Ex- sao paulo-SP).

The **sellers.csv** contains following features:

**Features and Description**

seller_id -> Unique Id of the seller registered

seller_zip_code_prefix -> Zip Code of the location of the seller.

seller_city -> Name of the City of the seller.

seller_state -> State Code (Ex- sao paulo-SP)

The **order_items.csv** contain following features:

**Features and Description**

order_id -> A unique id of order made by the consumers.

order_item_id -> A Unique id given to each item ordered in the order.

product_id -> A unique id given to each product available on the site.

seller_id -> Unique Id of the seller registered in Target.

shipping_limit_date -> The date before which shipping of the ordered product must be completed.

price -> Actual price of the products ordered .

freight_value -> Price rate at which a product is delivered from one point to another.

The **geolocations.csv** contain following features:

**Features and Description**

geolocation_zip_code_prefix -> first 5 digits of zip code

geolocation_lat -> latitude

geolocation_lng -> longitude

geolocation_city -> city name

geolocation_state -> state

The **payments.csv** contain following features:

**Features and Description**

order_id -> A unique id of order made by the consumers.

payment_sequential -> sequences of the payments made in case of EMI.

payment_type -> mode of payment used.(Ex-Credit Card)

payment_installments -> number of installments in case of EMI purchase.

payment_value -> Total amount paid for the purchase order.

The **orders.csv** contain following features:

Features -> Description

order_id -> A unique id of order made by the consumers.

customer_id -> Id of the consumer who made the purchase.

order_status -> status of the order made i.e delivered, shipped etc.

order_purchase_timestamp -> Timestamp of the purchase.

order_delivered_carrier_date -> delivery date at which carrier made the delivery.

order_delivered_customer_date -> date at which customer got the product.

order_estimated_delivery_date -> estimated delivery date of the products.

The **reviews.csv** contain following features:

**Features and Description**

review_id -> Id of the review given on the product ordered by the order id.

order_id -> A unique id of order made by the consumers.

review_score -> review score given by the customer for each order on the scale of 1–5.

review_comment_title -> Title of the review

review_comment_message -> Review comments posted by the consumer for each order.

review_creation_date -> Timestamp of the review when it is created.

review_answer_timestamp -> Timestamp of the review answered.

The **products.csv** contain following features:

**Features and Description**

product_id -> A unique identifier for the proposed project.

product_category_name -> Name of the product category

product_name_lenght -> length of the string which specifies the name given to the products ordered.

product_description_lenght -> length of the description written for each product ordered on the site.

product_photos_qty -> Number of photos of each product ordered available on the shopping portal.

product_weight_g -> Weight of the products ordered in grams.

product_length_cm -> Length of the products ordered in centimeters.

product_height_cm -> Height of the products ordered in centimeters.

product_width_cm -> width of the product ordered in centimeters.

**Problem Statement:**


Assume you are a data scientist at Target, and are given this data. Your job is to analyze and provide some insights and recommendations from it based on how Target Retail can increase the volume of orders in Brazil.

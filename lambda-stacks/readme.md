
Here are the AWS CLI commands to create the Lambda functions:

1. **Create IAM Role for Lambda (if not already created):**
   ```sh
   aws iam create-role --role-name lambda-execution-role --assume-role-policy-document file://trust-policy.json
   ```

   `trust-policy.json`:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Service": "lambda.amazonaws.com"
         },
         "Action": "sts:AssumeRole"
       }
     ]
   }
   ```

   Attach policy to the role:
   ```sh
   aws iam attach-role-policy --role-name lambda-execution-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
   ```

2. **Create Lambda Functions:**

   **Get Rack Ordering HTML:**
   ```sh
   aws lambda create-function --function-name getRackOrderingHTML \
     --zip-file fileb://function.zip --handler index.handler --runtime nodejs14.x \
     --role arn:aws:iam::123456789012:role/lambda-execution-role
   ```

   **Get Rack Ordering Items JSON:**
   ```sh
   aws lambda create-function --function-name getRackOrderingItemsJSON \
     --zip-file fileb://function.zip --handler index.handler --runtime nodejs14.x \
     --role arn:aws:iam::123456789012:role/lambda-execution-role
   ```

   **Get Badge Authorization Items JSON:**
   ```sh
   aws lambda create-function --function-name getBadgeAuthorizationItemsJSON \
     --zip-file fileb://function.zip --handler index.handler --runtime nodejs14.x \
     --role arn:aws:iam::123456789012:role/lambda-execution-role
   ```

   **Publish RAC Ordering HTML:**
   ```sh
   aws lambda create-function --function-name publishRACOrderingHTML \
     --zip-file fileb://function.zip --handler index.handler --runtime nodejs14.x \
     --role arn:aws:iam::123456789012:role/lambda-execution-role
   ```

   Note: Ensure `function.zip` contains the necessary code and dependencies for each Lambda function.

3. **Sample Code for Each Lambda Function:**

   **Get Rack Ordering HTML (`index.js`):**
   ```javascript
   exports.handler = async (event) => {
       const htmlContent = `
       <!DOCTYPE html>
       <html>
       <head>
           <title>Rack Ordering</title>
       </head>
       <body>
           <h1>Rack Ordering</h1>
           <div id="order-list">
               <ul>
                   <li>Order #1: Product A - Quantity: 100</li>
                   <li>Order #2: Product B - Quantity: 200</li>
                   <li>Order #3: Product C - Quantity: 150</li>
               </ul>
           </div>
       </body>
       </html>`;
       return {
           statusCode: 200,
           headers: {
               'Content-Type': 'text/html',
           },
           body: htmlContent,
       };
   };
   ```

   **Get Rack Ordering Items JSON (`index.js`):**
   ```javascript
   exports.handler = async (event) => {
       const jsonResponse = {
           "orders": [
               {
                   "order_id": "1",
                   "product": "Product A",
                   "quantity": 100
               },
               {
                   "order_id": "2",
                   "product": "Product B",
                   "quantity": 200
               },
               {
                   "order_id": "3",
                   "product": "Product C",
                   "quantity": 150
               }
           ]
       };
       return {
           statusCode: 200,
           body: JSON.stringify(jsonResponse),
       };
   };
   ```

   **Get Badge Authorization Items JSON (`index.js`):**
   ```javascript
   exports.handler = async (event) => {
       const jsonResponse = {
           "authorizations": [
               {
                   "badge_id": "12345",
                   "authorized": true
               },
               {
                   "badge_id": "67890",
                   "authorized": false
               },
               {
                   "badge_id": "54321",
                   "authorized": true
               }
           ]
       };
       return {
           statusCode: 200,
           body: JSON.stringify(jsonResponse),
       };
   };
   ```

   **Publish RAC Ordering HTML (`index.js`):**
   ```javascript
   exports.handler = async (event) => {
       const htmlContent = `
       <!DOCTYPE html>
       <html>
       <head>
           <title>Publish RAC Ordering</title>
       </head>
       <body>
           <h1>Published RAC Ordering</h1>
           <p>The RAC ordering has been published successfully.</p>
       </body>
       </html>`;
       return {
           statusCode: 200,
           headers: {
               'Content-Type': 'text/html',
           },
           body: htmlContent,
       };
   };
   ```

Make sure to zip the appropriate code file and any dependencies into `function.zip` before running the `create-function` commands.
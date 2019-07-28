// Version:        1.0
//Author:         Franklin Correa
//Creation Date:  26/07/2019
//Purpose/Change: AWS Serverless REST API with DynamoDB

import { v4 as uuid } from 'uuid';
import { client } from './db';
import { DocumentClient } from 'aws-sdk/clients/dynamodb';

export const create = (event, _context, callback) => {
  const timestamp = new Date().getTime();
  const data = JSON.parse(event.body);
  if (typeof data.username !== 'string') {
    console.error('Validation Failed');
    callback(null, {
      statusCode: 400,
      headers: { 'Content-Type': 'text/plain' },
      body: 'Couldn\'t create new item.',
    });
    return;
  }

  const url = event.headers["X-Forwarded-Proto"] + "://" + event.headers["Host"] + "/" + event.requestContext["stage"] + event.path

  const params = {
    TableName: process.env.DYNAMODB_TABLE,
    Item: {
      id: uuid.v1(),
      username: data.username,
      endpoint: url,
      createdAt: timestamp
    },
  };

  // write the request to the database
  client.put(params, (error) => {
    // handle potential errors
    if (error) {
      
      console.error(error);
      callback(null, {
        statusCode: error.statusCode || 501,
        headers: { 'Content-Type': 'text/plain' },
        body: 'Couldn\'t create item.',
      });
      return;
    }

    // create a response
    const response = {
      statusCode: 200,
      body: JSON.stringify(params.Item),
    };
    callback(null, response);
  });
};


export const list = (event, _context, callback) => {
    const params: DocumentClient.ScanInput = {
      TableName: process.env.DYNAMODB_TABLE
    };
  
    if (event && event.pathParameters && event.pathParameters.username) {
      params.FilterExpression = 'username = :username';
      params.ExpressionAttributeValues = {':username' : event.pathParameters.username};
    }

    // fetch all todos from the database
    client.scan(params, (error, result) => {
      // handle potential errors
      if (error) {
        console.error(error);
        callback(null, {
          statusCode: error.statusCode || 501,
          headers: { 'Content-Type': 'text/plain' },
          body: 'Couldn\'t fetch items.',
        });
        return;
      }
  
      result.Items.forEach(element => {
        element.createdAt = new Date(element.createdAt);
      });

      // create a response
      const response = {
        statusCode: 200,
        body: JSON.stringify(result.Items),
      };
      callback(null, response);
    });
  };
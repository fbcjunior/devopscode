// Version:        1.0
//Author:         Franklin Correa
//Creation Date:  26/07/2019
//Purpose/Change: Lambda script Installation


import { DynamoDB } from 'aws-sdk';

let options = {};

// connect to local DB if running offline
if (process.env.IS_OFFLINE) {
  options = {
    region: 'localhost',
    endpoint: 'http://localhost:8000',
    accessKeyId: 'DEFAULT_ACCESS_KEY',
    secretAccessKey: 'DEFAULT_SECRET'
  };
}

export const client = new DynamoDB.DocumentClient(options);

#!/bin/bash

rake db:create

rails g model user provider:string uid:string name:string image:string
rails g model project name:string user:references
rails g model endpoint name:string project:references dictionary:references erray:references
rails g model dictionary 
rails g model erray 
rails g model item name:string keytype:string value:string dictionary:references erray:references
rails g model tuple key:string dictionary:references item:references

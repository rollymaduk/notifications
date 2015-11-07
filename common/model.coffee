@models={}
models.Rp_Notification=new SimpleSchema
  title:
    type:String
    optional:true
  description:
    type:String
  audience:
    optional:true
    defaultValue:[]
    type:[String]
  isNew:
    type:Boolean
    defaultValue:true
  docId:
    type:String
  collection:
    type:String
  link:
    type:String
    optional:true
  parent:
    optional:true
    type:String
    autoValue:()->
      if @isInsert
        if not @value or not @isSet
          @field('docId').value
      else if @isUpsert
        if not @value or not @isSet
          {$setOnInsert:@field('docId').value}
      else
        @unset()

@Rp_Notifications=new Meteor.Collection('rp_notifications')

Rp_Notifications.attachSchema(models.Rp_Notification)
Rp_Notifications.attachBehaviour('timestampable')

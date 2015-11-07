class @Rp_Notification_Base
  notificationAdded:(notification)->

  removeNotifications:(parentId,callback)->
    if callback
      Meteor.call 'rp_remove_notification',parentId,(err,res)->
        callback.call(@,err,res)
    else
      Meteor.call 'rp_remove_notification',parentId

  createNewNotification:(notification,callback)->
    if callback
      Meteor.call 'rp_create_notification',notification,(err,res)->
        callback.call(@,err,res)
    else
      Meteor.call 'rp_create_notification',notification

@serverMessages=new ServerMessages()








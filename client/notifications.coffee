class Rp_Notification_Client extends Rp_Notification_Base
  constructor:(limit=20)->
    @Alerts=new Meteor.Collection 'latestNotifications'
    @Activities=new Meteor.Collection 'allNotifications'
    that=@
    Meteor.startup ->
      Meteor.subscribe("rp_all_notifications")
      Meteor.subscribe("rp_latest_notifications")

      serverMessages.listen('server-messages:rp_notify',(notify)->
        that.notificationAdded notify
      )

  getAllNotifications:(qry={},modifier={},limit=limit)->
    @Activities.find(qry,Object.assign(modifier,{limit:limit})).fetch()

  getActiveNotifications:(qry={},modifier={},limit=limit)->
    @Alerts.find(qry,Object.assign(modifier,{limit:limit})).fetch()

  deactivateNotification:(docId,callback)->
    Meteor.call 'rp_update_notification_status',docId,(err,res)->
      callback.call(@,err,res) if callback

  ###syncWithServer:(callback)->
    items=@Alerts.find({isNew:false}).map (doc)->doc._id
    Meteor.call 'rp_update_notification_status',items,(err,res)->
      callback.call(@,err,res) if callback###



Rp_Notification= new Rp_Notification_Client()
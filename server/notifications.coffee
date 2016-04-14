class Rp_Notification_Server extends Rp_Notification_Base
  constructor:(@limit=20)->
    that=@
    Meteor.startup ()->
      Meteor.publishComposite('rp_latest_notifications',(qry={},limit=@limit)->
        collectionName:"latestNotifications"
        find:->
          if @userId
            qry=_.extend(qry,$or:[{audience:$in:[@userId]}],{isNew:true})
            ###Counts.publish @,'latest_notification_count',Rp_Notifications.find(),{noReady:true,fastCount:true}###
            Rp_Notifications.find(qry,{limit:limit,sort:createdAt:-1})

      )

      Meteor.publishComposite('rp_all_notifications',(qry={},limit=@limit)->
        collectionName:"allNotifications"
        find:->
          if @userId
            qry=_.extend(qry,$or:[{audience:$in:[@userId]}])
            ###Counts.publish @,'notification_count',Rp_Notifications.find(),{noReady:true,fastCount:true}###
            Rp_Notifications.find(qry,{limit:limit,sort:createdAt:-1})
      )



      Meteor.methods
        rp_update_notification_status:(items)->
          items=if _.isArray(items) then items else [items]
          try
            check(@userId,String)
            check(items,[String])
            Rp_Notifications.update({_id:$in:items},$set:{isNew:false},{multi:true})
          catch err
            throw new Meteor.Error(5001,err.message)

        rp_create_notification:(notification)->
          try
            check(@userId,String)
            res=Rp_Notifications.insert(notification)
            notify=Rp_Notifications.findOne(res)
            serverMessages.notify('server-messages:rp_notify',notify)
            that.notificationAdded(notify)
          catch err
            throw new Meteor.Error(5002,err.message)

        rp_remove_notification:(parentId)->
          try
            check(@userId,String)
            Rp_Notifications.remove({parent:parentId})
          catch err
            throw new Meteor.Error(5003,err.message)
  getActivities:(qry,modifier)->
    Rp_Notifications.find(qry,modifier)





Rp_Notification= new Rp_Notification_Server()






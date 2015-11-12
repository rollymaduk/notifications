class Rp_Notification_Client extends Rp_Notification_Base
  constructor:(@limit=20)->
    @Alerts=new Meteor.Collection null
    that=@
    Meteor.startup ->
      Tracker.autorun ->
        Meteor.subscribe('rp_alerts',that.getAlertFilter(),that.limit)
        alertFilter=_.extend(that.getAlertFilter(),{isNew:true})
        Rp_Notifications.find(alertFilter).observe
          added:(doc)->
            console.log doc
            that.Alerts.insert(doc)
          removed:(doc)->
            that.Alerts.remove(doc._id)

      serverMessages.listen('server-messages:rp_notify',(notify)->
        that.notificationAdded notify
      )

  _alertfilter=new ReactiveVar({})

  _activityfilter=new ReactiveVar({})

  getActivityFilter:->_activityfilter.get()

  setActivityFilter:(filter)->_activityfilter.set(filter)

  setAlertFilter:(filter)->_alertfilter.set(filter)

  getAlertFilter:()->_alertfilter.get()

  getAlerts:(qry={},modifier={})->
    @Alerts.find(qry,modifier).fetch()


  deactivateAlert:(docId)->
    @Alerts.update(docId,$set:isNew:false)

  syncWithServer:(callback)->
    items=@Alerts.find({isNew:false}).map (doc)->doc._id
    Meteor.call 'rp_update_alert_status',items,(err,res)->
      callback.call(@,err,res) if callback

  getActivities:(limit)->
    Rp_Notifications.find(_activityfilter.get(),{limit:limit}).fetch()

  initActivities:(limit)->
    Meteor.subscribe('rp_activities',_activityfilter.get(),limit)


Rp_Notification= new Rp_Notification_Client()